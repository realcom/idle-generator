#if UNITY_WEBGL
using System;
using System.Collections;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.IO;
using System.Net;
using System.Net.Sockets;
using Commons;
// using System.Threading;
// using System.Threading.Tasks;
using Commons.Packets;
using Commons.Packets.Requests;
using Commons.Utility.Protobuf;
using Microsoft.IO;
using NativeWebSocket;
using UnityEngine;

public class ZClient : EventPublisher
{
	public static readonly RecyclableMemoryStreamManager bufferManager = new();

    private class PacketCallbackInfo
    {
		public float untilAt;
		public PacketCallback callback;
		public PacketFailureCallback failureCallback;
		
		public PacketCallbackInfo(PacketCallback callback, PacketFailureCallback failureCallback)
		{
			this.callback = callback;
			this.failureCallback = failureCallback;
			this.untilAt = Time.time + 15f;
		}
	}
	
	//
	public delegate void PacketCallback(Packet packet);
	public delegate void PacketFailureCallback(int status);
	
	const int READ_BUFFER_SIZE = 81920;
	
	private WebSocket _client;
	// private Stream _stream;
	private byte[] tempBuffer = new byte[READ_BUFFER_SIZE];

	public string address { private set; get; }
	public int port { private set; get; }
	private string _reconnectAddress;
	private int _reconnectPort;

	private readonly Queue<Packet> _sendPackets = new();
	private readonly List<Packet> _queuedPackets = new List<Packet>();
	
	// private int lastPacketLength = -1;
	private MemoryStream _readBuffer = new MemoryStream();
	private readonly ConcurrentQueue<Packet> packets = new ConcurrentQueue<Packet>();
	private Dictionary<long, PacketCallbackInfo> _callbacks;
	
	//
	private double _lastPingAt = Utility.GetTime ();
	public uint latency;
	private bool _disconnected;
	public bool disconnected => _disconnected;

	//
	private KeyValuePair<double, double> _serverTime = new KeyValuePair<double, double>();
	public double serverTime { private set; get; }
	public int serverOffsetTime { private set; get; }
	public DateTime serverDateTime { private set; get; }

	private int _waitingForConnect;
	// Getters
	public bool connected => _client?.State == WebSocketState.Open;
	public bool logined;
	
	protected virtual bool CheckPingTimeout => true;

	protected ZClient ()
	{
		_callbacks = new Dictionary<long, PacketCallbackInfo>();
		// var t = new Thread(ProcessSendPackets);
		// t.Start();
		// ProcessSendPackets();
        Clear();
    }
	
	// private double _totalTimeDelta;
	// private DateTime _initialTime = DateTime.UtcNow;

	public virtual void Update()
	{
		// _totalTimeDelta += Time.deltaTime;
		// serverTime = _initialTime.ToSeconds() + _totalTimeDelta;

		serverTime = _serverTime.Key + Utility.GetTime() - _serverTime.Value;
		serverOffsetTime = (int)(_serverTime.Key + Utility.GetOffsetTime() - _serverTime.Value);
		serverDateTime = Utility.FromSeconds(serverTime);

#if !UNITY_WEBGL || UNITY_EDITOR
		_client?.DispatchMessageQueue();
#endif
	}
	
	private List<long> removables = new List<long>();
	public virtual void LateUpdate() 
	{
		if (_waitingForConnect > 0)
		{
			if (connected)
			{
				_waitingForConnect = 0;
				HandleConnected();
			}

			_waitingForConnect -= 1;
		}
		
		if (!gatheringPackets)
			ProcessPackets();

		//
		// Timeout callbacks
		foreach(var c in _callbacks)
		{
			if(!connected || c.Value.untilAt < Time.time)
			{
				removables.Add (c.Key);
			}
		}
		if(removables.Count != 0)
		{
			foreach(var id in removables)
			{
				if (!_callbacks.TryGetValue(id, out var c))
					continue;
				 
				_callbacks.Remove(id);
				try
				{
					c.failureCallback(StatusCode_old.FAILED);
				}
				catch (Exception e)
				{
					Debug.LogException(e);
				}
			}
			removables.Clear();
		}
		
		//if(!connected && _waitingForConnect <= 0)
		//{
		//	Close ();
		//}

		if (_disconnected)
			Close();
		
		if(connected)
		{
			if (CheckPingTimeout && Utility.GetTime() - _lastPingAt > 20) {
				Close();
			}
		}
	}

	private void SendPacket_Internal(Packet p) {
		if(_client == null) {
            if (p.PacketType == Packet.Type.None)
                return;

            //
			Debug.LogWarning("Socket not connected.");
			return;
		}
		
		try
		{
			// var stream = _stream;
			// if (stream == null)
			// {
			// 	Debug.LogWarning("Socket doesn't have stream.");
			// 	return;
			// }
			//
			var buf = Utility.SerializePacket(p);
			//
			// lock(stream)
			// {
			// 	// var lbuf = BitConverter.GetBytes(Utility.convertEndian(buf.Length));
			// 	// stream.Write(lbuf, 0, lbuf.Length);
			// 	stream.Write(buf, 0, buf.Length);
			// 	stream.Flush();
			// }
			//
			_client.Send(buf).Wait();
			p.Dispose();
			
			//			Debug.Log (String.Format("Sent packet type={0}, length={1}", p.type, buf.Length));
		} catch(Exception) {
			Debug.LogWarning("Socket not connected.");
			//Debug.LogException(e);
		}
	}

	public virtual void SendPacket(Packet p, PacketCallback callback = null,
		PacketFailureCallback failureCallback = null, bool withLoading = false)
	{
		var key = PacketKey.GetClientKey(); // TODO: should ensure the packet with this key is sent 
		p.Key = key;
		var callbackId = 0L;
		if (callback != null)
			p.Request.Id = callbackId = PacketKey.GetCallbackId();
		
		// _sendPackets.Enqueue(p);
		SendPacket_Internal(p);

		//
		if (callback == null && !withLoading)
			return;

		//
		if (!connected)
		{
			if (failureCallback != null)
				failureCallback(StatusCode_old.FAILED);
			else
				Toast.Show<Popup_Toast>(StatusCode_old.FAILED.ToString().L());
			return;
		}

		//
		if (withLoading)
			GameManager.Get().ShowLoading();
		// TODO: handle edge refresh if needed when it's added on the server
		// if (skipRefreshEdge)
		// 	MyPlayer.Get().skipRefreshEdge = true;

		//
		_callbacks[callbackId] = new PacketCallbackInfo(
			delegate(Packet packet)
			{
				if (withLoading)
					GameManager.Get().HideLoading().Forget();
				// if (skipRefreshEdge)
				// 	MyPlayer.Get().skipRefreshEdge = false;

				callback?.Invoke(packet);
			},
			delegate(int statusCode)
			{
				if (withLoading)
					GameManager.Get().HideLoading().Forget();
				// if (skipRefreshEdge)
				// 	MyPlayer.Get().skipRefreshEdge = false;

				if (failureCallback != null)
					failureCallback(statusCode);
				else if (callback != null)
					Toast.Show<Popup_Toast>(statusCode.ToString().L());
			}
		);
	}

	public void QueuePacket(Packet p, PacketCallback callback = null, PacketFailureCallback failureCallback = null, bool withLoading = false)
	{
		if (connected && logined)
		{
			SendPacket(p, callback, failureCallback, withLoading);
			return;
		}
		
		var key = PacketKey.GetClientKey();
		p.Key = key;
		_queuedPackets.Add(p);
		
		if(callback != null)
			_callbacks[p.Key] = new PacketCallbackInfo(callback, failureCallback);
	}

	public void SetReconnectHost(string address, int port)
	{
		_reconnectAddress = address;
		_reconnectPort = port;
	}
	
	public void Connect(string address, int port)
	{
		Close ();
		
		try
		{
			this.address = _reconnectAddress = address;
			this.port = _reconnectPort = port;

			_client = new WebSocket($"{address}:{port}");
			_client.OnOpen += () =>
			{
				Debug.Log("Connection open!");
				HandleConnected();
			};

			_client.OnError += (e) =>
			{
				Debug.LogError("WebSocket Error! " + e);
			};

			_client.OnClose += (e) =>
			{
				Debug.Log("Connection closed!");
				Close();
			};

			_client.OnMessage += OnMessageReceived;
			
			_client.Connect();
            Clear();

			_waitingForConnect = (int)(1f / Time.deltaTime);
		}
		catch(Exception ex)
		{
			Debug.LogWarning("Cannot connect to server. (host={0}, port={1})".SFormat(address, port));
			Debug.LogWarning(ex);
			HandleConnectFailed();
		}
	}
	
	private void OnOpen(WebSocket client)
	{
		Debug.Log("WebSocket connected");

	}
	
	private void OnClosed(WebSocket client, ushort code, string message)
	{
		Debug.Log($"WebSocket closed: {code} {message}");
		
	}

	private void ClearClient()
	{
		_client = null;
		logined = false;
		_waitingForConnect = 0;
		PacketKey.ResetClientKey();
	}

	public void Reconnect()
	{
		Connect(_reconnectAddress, _reconnectPort);
	}
	
	public void Close () {
		if(_client != null) {
			try {
				_client.Close ();
			} catch(Exception) {
			}
			HandleDisconnected();
		}
	}
	
	public void CloseSilently() {
		if(_client != null) {
			try {
				_client.Close ();
			} catch(Exception) {
			}
			ClearClient();
		}
	}
	
	public void ResetLastPingAt()
	{
		_lastPingAt = Utility.GetSystemTime();	
	}
	
	protected virtual void HandleConnected() {
		
		Debug.Log (GetType().Name + ": Connection Succeeded");
		ResetLastPingAt();
	}
	
	protected virtual void HandleDisconnected()
	{
		_disconnected = true;
		ClearClient();
	}

	protected virtual void HandleConnectFailed()
	{
		ClearClient();
	}

    //
	private static byte Key = 0x98;
    public static void SetKey(byte k)
    {
        Key = k;
    }

    // moved to packet method: EncryptPacket
	// private byte[] MakeXor(byte[] InputBuffer, int startIndex=0)
	// {
	// 	for(int i = startIndex; i < InputBuffer.Length; i++)
	// 		InputBuffer[i] = (byte)( InputBuffer[i] ^ Key);		
	// 	return InputBuffer;
 //    }

    //
    private static ConcurrentQueue<MemoryStream> _smallPools = new ConcurrentQueue<MemoryStream>();

    //
    public static MemoryStream PopBuffer()
    {
        MemoryStream ms;
        if (_smallPools.TryDequeue(out ms))
            return ms;

        return bufferManager.GetStream();
    }

    public static void ReturnBuffer(MemoryStream ms)
    {
        if (ms.Length < bufferManager.BlockSize)
        {
            ms.Position = 0;
            ms.SetLength(0);
            _smallPools.Enqueue(ms);
        }
        else
            ms.Dispose();
    }

    private void ProcessSendPackets()
    {
	    while (true)
	    {
		    try
		    {
			    if (_sendPackets.TryDequeue(out var p))
				    SendPacket_Internal(p);
			    // var p = _sendPackets.TryDequeue();
		    }
		    catch (Exception ex)
		    {
			    // if (ex is ThreadAbortException)
				   //  break;
			    Debug.LogError(ex);
		    }
	    }
    }
    
    private void OnMessageReceived(byte[] message)
	{
		try
		{
			if (message.Length == 0)
			{
				Debug.Log("Network Connection closed.");
				_client.Close();
				return;
			}

			// method 1. using single buffer for async read (solely relying on length field of packet to determine packet boundaries)
			{
				_readBuffer.Seek(0, SeekOrigin.End);
				_readBuffer.Write(message, 0, message.Length);
				ProcessReceivedData();
			}
		}
		catch (Exception ex)
		{
			Debug.Log($"Read operation failed: {ex.Message}");
		}
	}
    
    private void ProcessReceivedData()
    {
	    _readBuffer.Position = 0;

	    while (_readBuffer.Length - _readBuffer.Position >= 2) // 1 byte key, 1 byte type, 4 byte length
	    {
		    try
		    {
			    var p = Utility.DeserializePacketFromStream(_readBuffer);
			    HandlePacketWhileReading(p);
			    
			    // Update buffer: remove processed bytes
			    var newBuffer = PopBuffer();
			    newBuffer.Write(_readBuffer.GetBuffer(), (int)_readBuffer.Position, (int)(_readBuffer.Length - _readBuffer.Position));
			    ReturnBuffer(_readBuffer);
			    _readBuffer = newBuffer;
			    _readBuffer.Position = 0;
		    }
		    catch (Exception e)
		    {
			   Debug.LogError("Failed to deserialize packet: " + e.Message);
			   break;
		    }
	    }
    }
    
    private void ProcessReceivedData(MemoryStream readBuffer)
    {
	    while (readBuffer.Length - readBuffer.Position >= 2) // 1 byte key, 1 byte type, [4 byte length], [n byte data]
	    {
		    try
		    {
			    var p = Utility.DeserializePacketFromStream(readBuffer);
			    HandlePacketWhileReading(p);

			    // Update buffer: remove processed bytes
			    var newBuffer = PopBuffer();
			    newBuffer.Write(readBuffer.GetBuffer(), (int)readBuffer.Position, (int)(readBuffer.Length - readBuffer.Position));
			    ReturnBuffer(readBuffer);
			    readBuffer = newBuffer;
			    readBuffer.Position = 0;
		    }
		    catch (Exception e)
		    {
			    Debug.LogError("Failed to deserialize packet: " + e.Message);
			    break;
		    }
	    }
	    
	    ReturnBuffer(readBuffer);
    }
    
    private void HandlePacketWhileReading(Packet p)
    {
	    if (p.PacketType == Packet.Type.Request && p.Request.RequestCase == Request.RequestOneofCase.PingRequest)
	    {
		    var pingRequest = p.Request.PingRequest;

		    var finalServerTime = serverTime;
		    var time = pingRequest.Timestamp.Seconds;
		    if (Math.Abs(finalServerTime - time) > 5)
			    _serverTime = new KeyValuePair<double, double>(time, TimeSystem.time); // check if TimeSystem.time is not affect by timeScale
		    else
			    _serverTime = new KeyValuePair<double, double>((finalServerTime + TimeSystem.time) / 2, TimeSystem.time);

		    // TODO: handle latency
		    latency = pingRequest.LatencyMilliseconds; // nowhere used yet

		    ResetLastPingAt();

		    p.Request.PingRequest.Timestamp.Set(DateTime.UtcNow);

		    if (!PlatformManager.Get().Paused)
			    SendPacket(p);
	    
		    return;
	    }
	    packets.Enqueue(p);
    }

 //    private void DoRead(IAsyncResult ar)
	// { 
	// 	if(_client == null)
	// 		return;
	// 	
	// 	int bytesRead;
	// 	try
	// 	{
	// 		// Finish asynchronous read into readBuffer and return number of bytes read.
	// 		bytesRead = _client.GetStream().EndRead(ar);
	// 		if(bytesRead == 0) {
	// 			_client.Close();
	// 			return;
	// 		}
	// 		
	// 		//Debug.Log (String.Format ("Got {0} bytes", bytesRead));
	// 		_readBuffer.Seek (0, SeekOrigin.End);
	// 		_readBuffer.Write(tempBuffer, 0, bytesRead);
	// 		
	// 		
	// 		BinaryReader sr = new BinaryReader(_readBuffer);
	// 		_readBuffer.Position = 0;
	// 		while(lastPacketLength > 0 || _readBuffer.Length-_readBuffer.Position >= 4) {
	// 			
	// 			
	// 			lastPacketLength = (lastPacketLength > 0) ? lastPacketLength : Utility.convertEndian(sr.ReadInt32());
	// 			long leftBytes = _readBuffer.Length-_readBuffer.Position;
	// 			
	// 			if(lastPacketLength > leftBytes)
	// 				break;
	// 			
	// 			try
	// 			{
	// 				// var p = Utility.DeserializePacket(MakeXor(sr.ReadBytes(lastPacketLength)));
	// 				var p = Utility.DeserializePacket(sr.ReadBytes(lastPacketLength));
	// 				
	// 				switch (p.PacketType)
	// 				{
	// 					case Packet.Type.Request:
	// 					{
	// 						Debug.Log("Request packet received.");
	// 						break;
	// 					}
	// 					// case Packet.Type.Ping:
	// 					// {
	// 					// 	var l = p.Get<network.Ping>();
	// 					//
	// 					// 	//
	// 					// 	var finalServerTime = serverTime;
	// 					// 	if (Math.Abs(finalServerTime - l.time) > 5d)
	// 					// 		_serverTime = new KeyValuePair<double, double>(l.time, Utility.GetSystemTime());
	// 					// 	else
	// 					// 		_serverTime = new KeyValuePair<double, double>((finalServerTime + l.time) / 2d, Utility.GetSystemTime());
	// 					//
	// 					// 	//
	// 					// 	latency = l.latency;
	// 					// 	ResetLastPingAt();
	// 					// 	if (!PlatformManager.Get().Paused)
	// 					// 		SendPacket(p);
	// 					// 	break;
	// 					// }
	// 					// case Packet.Type.Disconnected:
	// 					// {
	// 					// 	_disconnected = true;
	// 					// 	break;
	// 					// }
	// 					default:
	// 					{
	// 						packets.Enqueue(p);
	// 						break;
	// 					}
	// 				}
	// 			}
	// 			catch(Exception e)
	// 			{
	// 				Debug.LogWarning("Failed to deserialize packet.");
	// 				Debug.LogException(e);
	// 			}
	// 			
	// 			lastPacketLength = -1;
	// 			
	// 		}
 //
 //            var newBuffer = PopBuffer();
 //            newBuffer.Write(_readBuffer.GetBuffer(), (int)_readBuffer.Position, (int)(_readBuffer.Length - _readBuffer.Position));
 //            ReturnBuffer(_readBuffer);
 //            _readBuffer = newBuffer;
	// 		
	// 		// Start a new asynchronous read into readBuffer.
	// 		_client.GetStream().BeginRead(tempBuffer, 0, READ_BUFFER_SIZE, new AsyncCallback(DoRead), null);
	// 		
	// 	} 
	// 	catch(Exception e)
	// 	{
	// 		Debug.LogWarning(e.Message);
	// 	}
 //    }
    protected virtual void Clear()
    {
	    if (_readBuffer != null)
            ReturnBuffer(_readBuffer);
        _readBuffer = PopBuffer();

        //
        while (packets.TryDequeue(out _));

        _callbacks.Clear();
        // lastPacketLength = -1;
		_serverTime = new KeyValuePair<double, double>();
		_disconnected = false;

		Update();
    }

	//
	[NonSerialized]
	public bool gatheringPackets;

	private void ProcessPackets()
	{
		while (packets.TryDequeue(out var p))
		{
			try
			{
				HandlePacket(p);
				p.Dispose();
			}
			catch(Exception e)
			{
				Debug.LogException(e);
			}

			if (gatheringPackets)
				break;
		}
	}

	public void GatherPackets()
	{
		gatheringPackets = true;
		Debug.Log($"{GetType().Name} : GatherPackets");
	}

	public void ProcessGatheredPackets()
	{
		gatheringPackets = false;
		Debug.Log($"{GetType().Name} : ProcessGatheredPackets: {packets.Count}");
		ProcessPackets();
	}

	public void ProcessQueuedPackets()
	{
		
	}

	// Process the command received from the server, and take appropriate action.
	protected virtual bool HandlePacket(Packet packet)
	{
#if UNITY_EDITOR
        if(packet.PacketType != Packet.Type.None)
            Debug.Log (String.Format("Got packet type={0}, {1}", "" + packet.PacketType, packet));
            
#endif

		if (_queuedPackets.Count > 0 && connected && logined)
		{
			foreach (var p in _queuedPackets)
				SendPacket(p);
			_queuedPackets.Clear();
		}

		//
		if (packet.PacketType == Packet.Type.Request)
		{
			PacketCallbackInfo info;
			if(_callbacks.TryGetValue(packet.Request.Id, out info)) {
				_callbacks.Remove(packet.Request.Id);
				
				try {
					info.callback(packet);
				} catch(Exception ex) {
					Debug.LogError(ex);
				}
			}
		}

		return false;
	}
}

public static class PacketKey
{
	private static uint _clientKey = 1;
	private static uint _callbackId = 1;
	private static readonly object ClientLock = new object();
	private static readonly object CallbackLock = new object();
	
	// private const int CLIENT_MIN = 128;
	// private const int CLIENT_MAX = 255;

	public static byte GetClientKey()
	{
		lock (ClientLock)
		{
			var resKey = _clientKey;
			_clientKey += Packet.MagicNumber;
			// moved to Request.Id processing
			// ZWorldClient.Get().RemoveCallback((byte)_clientKey); // Remove any existing callback with the same key before reusing
			return (byte)resKey;
		}
	}
	
	public static void ResetClientKey()
	{
		lock (ClientLock)
		{
			_clientKey = 1;
		}
	}

	public static long GetCallbackId()
	{
		lock (CallbackLock)
		{
			return _callbackId++;
		}
	}
}
#endif