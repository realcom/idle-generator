#if !UNITY_WEBGL
using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Sockets;
using System.Threading;
using System.Threading.Tasks;
using Commons;
using Microsoft.IO;
using UnityEngine;
using Commons.Packets;
using Commons.Packets.Requests;
using Commons.Resources;
using Commons.Utility.Protobuf;
using Cysharp.Threading.Tasks;
using Sirenix.Utilities;

public enum ConnectState
{
    Disconnected,
    Init,
    Connecting,
    Connected,
    Loginned
}

public partial class ZClient : EventPublisher
{
    public static readonly RecyclableMemoryStreamManager bufferManager = new RecyclableMemoryStreamManager();

    private const int SEND_COOLDOWN_MILLISECONDS = 30; // 30ms delay between packets

    private struct PacketCallbackInfo
    {
        public readonly float untilAt;
        public readonly PacketCallback callback;
        public readonly PacketFailureCallback failureCallback;

        public PacketCallbackInfo(PacketCallback callback, PacketFailureCallback failureCallback)
        {
            this.callback = callback;
            this.failureCallback = failureCallback;
            untilAt = Time.time + 15f;
        }
    }

    //
    public delegate void PacketCallback(Packet packet);

    public delegate void PacketFailureCallback(StatusCode status);


    const int READ_BUFFER_SIZE = 81920;

    // private TcpClient _client;
    private Socket _client;
    private Stream _stream;
    private byte[] tempBuffer = new byte[READ_BUFFER_SIZE];
    private MemoryStream _receiveBuffer = new MemoryStream();

    private string _host;

    public string Host
    {
        set => _host = value;
        get
        {
            if (!string.IsNullOrEmpty(_host)) return _host;
            var host = Constants.SERVER_HOST;
            if (Application.isEditor || Constants.DEVELOPMENT_MODE || Config.IsDebug)
            {
                if (!string.IsNullOrEmpty(Config.fixHost))
                    host = Config.fixHost;
            }

            return host;
        }
    }

    private readonly BlockingCollection<Packet> _sendPackets = new();

    // private int lastPacketLength = -1;
    private readonly ConcurrentQueue<Packet> packets = new ConcurrentQueue<Packet>();
    private Dictionary<long, PacketCallbackInfo> _callbacks;

    //
    private double _lastPingAt = Utility.GetTime();
    public uint latency;

    //
    private KeyValuePair<double, double> _serverTime = new KeyValuePair<double, double>();
    public double serverTime { private set; get; }
    public int serverOffsetTime { private set; get; }
    public DateTime serverDateTime { private set; get; }

    private int _waitingForConnect;

    // Getters
    public ConnectState State { get; private set; } = ConnectState.Init;
    public bool IsConnected => State is ConnectState.Connected or ConnectState.Loginned;

    public bool logined => State == ConnectState.Loginned;

    protected ZClient()
    {
        _callbacks = new Dictionary<long, PacketCallbackInfo>();
        var t = new Thread(ProcessSendPackets);
        t.Start();
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
    }

    private readonly Queue<long> removableCallbacks = new();

    public virtual void LateUpdate()
    {
        if (_client?.Connected == false)
            State = ConnectState.Disconnected;
        if (_waitingForConnect > 0)
        {
            if (IsConnected)
            {
                _waitingForConnect = 0;
                HandleConnected();
            }

            _waitingForConnect -= 1;
        }

        if (!gatheringPackets)
            ProcessPackets().Forget();

        //
        // Timeout callbacks
        foreach (var c in _callbacks)
        {
            if (c.Value.untilAt < Time.time)
            {
                removableCallbacks.Enqueue(c.Key);
            }
        }

        while (removableCallbacks.TryDequeue(out var id))
        {
            if (!_callbacks.Remove(id, out var c))
                continue;

            try
            {
                c.failureCallback(StatusCode.RequestTimeOut);
            }
            catch (Exception e)
            {
                Debug.LogException(e);
            }
        }

        if (_client != null && _waitingForConnect <= 0 && !_client.Connected)
        {
            Debug.Log("ZClient: Connection lost.");
            Close();
        }

        if (State == ConnectState.Disconnected)
        {
            Close();
        }

        if (_client != null && _client.Connected)
        {
            //로그인 상태에서만 핑체크
            if (NetworkSystem.checkOutPing && MyPlayer.Player.Id != 0 && Utility.GetTime() - _lastPingAt > 20)
            {
                Debug.Log("ZClient: Ping timeout.");
                Close();
            }
        }
    }


    private void SendPacket_Internal(Packet p)
    {
        if (_client == null)
        {
            if (p.PacketType == Packet.Type.None)
                return;

            //
            Debug.LogWarning("Socket not connected.");
            return;
        }

        var key = PacketKey.GetClientKey();
        p.Key = key;
        try
        {
            var stream = _stream;
            if (stream == null)
            {
                Debug.LogWarning("Socket doesn't have stream.");
                return;
            }

            var buf = Utility.SerializePacket(p);

            lock (stream)
            {
                // var lbuf = BitConverter.GetBytes(Utility.convertEndian(buf.Length));
                // stream.Write(lbuf, 0, lbuf.Length);
                stream.Write(buf, 0, buf.Length);
                stream.Flush();
            }

            //			Debug.Log (String.Format("Sent packet type={0}, length={1}", p.type, buf.Length));
        }
        catch (Exception e)
        {
            Debug.LogWarning($"Fail send packet. exception:\n{e}");
            Debug.LogException(e);
        }
        
        p.Dispose();
    }

    private double _blockSendingUntil = 0;

    /// <summary>
    /// 테스트 목적으로 지정된 시간(초) 동안 패킷 전송을 막습니다.
    /// 이 시간 동안 패킷은 큐에 쌓였다가, 시간이 지나면 한꺼번에 전송됩니다.
    /// </summary>
    /// <param name="duration">패킷 전송을 막을 시간(초)</param>
    public void BlockPacketSendingForTest(float duration)
    {
        var blockEndTime = Utility.GetTime() + duration;
        _blockSendingUntil = blockEndTime;
        Debug.LogWarning($"[TEST] Packet sending thread will be blocked for {duration} seconds (until {blockEndTime}). Packets will be queued.");
    }

    public async UniTask<LoginRequest.Types.Response> SendLoginPacket(Packet p)
    {
        var result = await SendPacket<LoginRequest.Types.Response>(p, immediately: true);
        if (result.Status.IsSuccess())
            State = ConnectState.Loginned;

        return result;
    }

    public async UniTask<TPacketResponse> SendPacket<TPacketResponse>(Packet p, CancellationToken cancellationToken = default, bool withLoading = false, bool immediately = false)
        where TPacketResponse : class, IPacketResponse, new()
    {
        var response = await SendPacket(p, cancellationToken: cancellationToken, withLoading: withLoading, immediately: immediately);

        // if failure, return EmptyResponse, after then alloc specific response. response is not allowed null
        if (response is not TPacketResponse TResponse)
        {
            TResponse = new()
            {
                Status = response.Status,
                Message = response.Message,
            };
        }

        return TResponse;
    }

    public UniTask<IPacketResponse> SendPacket(Packet p, CancellationToken cancellationToken = default, bool withLoading = false, bool immediately = false)
    {
        var tsc = new UniTaskCompletionSource<IPacketResponse>();
        var callbackId = 0L;
        p.Request.Id = callbackId = PacketKey.GetCallbackId();

#if UNITY_EDITOR
        switch (p.PacketType)
        {
            case Packet.Type.Request:
            {
                if (p.Request.RequestCase != Request.RequestOneofCase.PingRequest && p.Request.RequestCase != Request.RequestOneofCase.SkipBoardRequest)
                    Debug.Log($"Send packet type={"" + p.PacketType}, {p.Request.RequestCase}");
                break;
            }
            case Packet.Type.Update:
                Debug.Log($"Send packet type={"" + p.PacketType}, {p.Update.UpdateCase}");
                break;
            default:
            {
                if (p.PacketType != Packet.Type.None)
                    Debug.Log($"Got packet type={"" + p.PacketType}, {p}");
                break;
            }
        }
#endif

        switch (p.Request.RequestCase)
        {
            case Request.RequestOneofCase.PingRequest:
            case Request.RequestOneofCase.SkipBoardRequest:
            case Request.RequestOneofCase.None:
                tsc.TrySetResult(new EmptyResponse()
                {
                    Status = StatusCode.Ok
                });
                break;
            default:
            {
                RegisterPacketCallback(callbackId, tsc, withLoading);
                break;
            }
        }
        
        if (!immediately)
            _sendPackets.Add(p, cancellationToken);

        if (State == ConnectState.Disconnected)
        {
            if (_callbacks.Remove(callbackId, out var info))
                info.failureCallback?.Invoke(StatusCode.LostConnection);
            return tsc.Task;
        }

        //
        if (withLoading)
            GameManager.Get().ShowLoading().Forget();

        if (immediately)
            SendPacket_Internal(p);

        //
        return tsc.Task.AttachExternalCancellation(cancellationToken);
    }
    
    private void RegisterPacketCallback(long callbackId, UniTaskCompletionSource<IPacketResponse> taskCompletionSource, bool withLoading)
    {
        _callbacks[callbackId] = new PacketCallbackInfo(
            delegate(Packet packet)
            {
                if (withLoading)
                    GameManager.Get().HideLoading().Forget();
                // if (skipRefreshEdge)
                // 	MyPlayer.Get().skipRefreshEdge = false;

                var response = packet.Request.Response;
                if (response != null)
                {
                    GameManager.HandleCommonStatus(response.Status, response.Message);
                    taskCompletionSource?.TrySetResult(response);
                }
                else
                {
                    GameManager.HandleCommonStatus(StatusCode.BadRequest);
                    taskCompletionSource?.TrySetResult(new EmptyResponse()
                    {
                        Status = StatusCode.BadRequest,
                        Message = ResourceString.Get(StatusCode.BadRequest, ResourceEntity.Language)
                    });
                }
                
            },
            delegate(StatusCode statusCode)
            {
                if (withLoading)
                    GameManager.Get().HideLoading().Forget();
                // if (skipRefreshEdge)
                // 	MyPlayer.Get().skipRefreshEdge = false;

                statusCode.ToToast();

                taskCompletionSource?.TrySetResult(new EmptyResponse()
                {
                    Status = statusCode,
                    Message = ResourceString.Get(statusCode, ResourceEntity.Language)
                });
            }
        );
    }

    // 언제쓰는거지..?
    //public void QueuePacket(Packet p, PacketCallback callback = null, PacketFailureCallback failureCallback = null, bool withLoading = false)
    //{
    //    if (State == ConnectState.Loginned)
    //    {
    //        SendPacket(p, callback, failureCallback, withLoading);
    //        return;
    //    }
    //
    //    var key = PacketKey.GetClientKey();
    //    p.Key = key;
    //    _queuedPackets.Add(p);
    //
    //    if (callback != null)
    //        _callbacks[p.Key] = new PacketCallbackInfo(callback, failureCallback);
    //}

    public void SetReconnectHost(string host)
    {
        _host = host;
    }

    public async Task<bool> ConnectAsync()
    {
        CloseSilently();
        var newSocket = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp);
        try
        {
            var hostAndPort = Host.Split(':');
            var targetAddress = string.Join(":", hostAndPort[..^1]);
            var targetPort = int.Parse(hostAndPort[^1]);

            State = ConnectState.Connecting;
            _waitingForConnect = (int)(1f / Time.deltaTime);

            IPAddress[] targets;
            if (IPAddress.TryParse(targetAddress, out var ip))
            {
                targets = new[] { ip };
            }
            else
            {
                targets = await Dns.GetHostAddressesAsync(targetAddress);
            }

            await newSocket.ConnectAsync(targets, targetPort);

            if (!newSocket.Connected)
                throw new SocketException((int)SocketError.NotConnected);

            _client = newSocket;
            _client.NoDelay = true;

            Clear();

            _stream = new NetworkStream(_client, ownsSocket: true);
            ReadNetworkStream();
            _waitingForConnect = (int)(1f / Time.deltaTime);
            State = ConnectState.Connected;
            return true;
        }
        catch (Exception ex)
        {
            newSocket.Dispose();

            Debug.LogWarning($"Cannot connect to server. (host={Host})");
            Debug.LogWarning(ex);
            HandleConnectFailed();
            return false;
        }
    }


    public void ReadNetworkStream()
    {
        var task = ReadDataAsync();
        task.ContinueWith(t =>
        {
            if (t.IsFaulted)
                Debug.LogError("Error during reading: " + t.Exception?.Message);
        }, TaskContinuationOptions.OnlyOnFaulted);
    }

    private void ClearClient()
    {
        _client = null;
        State = ConnectState.Disconnected;
        _waitingForConnect = 0;
        PacketKey.ResetClientKey();
    }

    public async UniTask<bool> Reconnect()
    {
        return await ConnectAsync();
    }

    public void Close(bool silently = false)
    {
        if (_client != null)
        {
            try
            {
                _client.Close();
            }
            catch (Exception)
            {
            }

            ClearClient();

            if (!silently)
                HandleDisconnected();
        }
    }

    public void CloseSilently()
    {
        Close(silently: true);
    }

    public void ResetLastPingAt()
    {
        _lastPingAt = TimeSystem.time;
    }

    protected virtual void HandleConnected()
    {
        Debug.Log(GetType().Name + ": Connection Succeeded");
        ResetLastPingAt();
    }

    protected virtual void HandleDisconnected()
    {
        State = ConnectState.Disconnected;
        ClearClient();
    }

    protected virtual void HandleConnectFailed()
    {
        ClearClient();
    }

    //
    private static ConcurrentQueue<MemoryStream> _smallPools = new ConcurrentQueue<MemoryStream>();

    //
    // private static MemoryStream PopBuffer()
    // {
    //  if (_smallPools.TryDequeue(out var ms))
    //         return ms;
    //  
    //     return bufferManager.GetStream();
    // }

    // private static void ReturnBuffer(MemoryStream ms)
    // {
    //     if (ms.Length < bufferManager.BlockSize)
    //     {
    //         ms.Position = 0;
    //         ms.SetLength(0);
    //         _smallPools.Enqueue(ms);
    //     }
    //     else
    //         ms.Dispose();
    // }

    private void ProcessSendPackets()
    {
        var wasBlocked = false; // To log only once when unblocked
        while (true)
        {
            try
            {
                // Check for the test block
                if (Utility.GetTime() < _blockSendingUntil)
                {
                    if (!wasBlocked)
                    {
                        wasBlocked = true;
                        Debug.LogWarning($"[TEST] ProcessSendPackets thread is now blocked.");
                    }

                    Thread.Sleep(100);
                    continue;
                }

                if (wasBlocked)
                {
                    wasBlocked = false;
                    Debug.LogWarning($"[TEST] ProcessSendPackets thread is now unblocked. Sending queued packets.");
                }

                //명시적으로 검사
                if (_client is not { Connected: true } || State < ConnectState.Loginned)
                {
                    Thread.Sleep(100);
                    continue;
                }

                if (_sendPackets.TryTake(out var p))
                    SendPacket_Internal(p);
                // Apply cooldown after sending to rate-limit bursts.
                Thread.Sleep(SEND_COOLDOWN_MILLISECONDS);
            }
            catch (Exception ex)
            {
                if (ex is ThreadAbortException)
                    break;
                Debug.LogError(ex);
            }
        }
    }

    private async Task ReadDataAsync()
    {
        while (_client is { Connected: true })
        {
            try
            {
                var bytesRead = await _stream.ReadAsync(tempBuffer, 0, tempBuffer.Length);
                if (bytesRead == 0)
                {
                    Debug.Log("Network Connection closed.");
                    _client.Close();
                    return;
                }

                // method 1. using single buffer for async read (solely relying on length field of packet to determine packet boundaries)
                _receiveBuffer.Seek(0, SeekOrigin.End);
                _receiveBuffer.Write(tempBuffer, 0, bytesRead);
                ProcessReceivedData(_receiveBuffer);
                // {
                //  var readBuffer = PopBuffer();
                //  readBuffer.Seek(0, SeekOrigin.End);
                //  readBuffer.Write(tempBuffer, 0, bytesRead);
                //  readBuffer.Position = 0;
                //  ProcessReceivedData(readBuffer);
                // }

                // method 2. using new buffer for each async read
                // {
                //  var newBuffer = PopBuffer();
                //  if (newBuffer.Length != 0 || newBuffer.Position != 0)
                //   Debug.LogError("Buffer not empty.");
                //  newBuffer.Write(tempBuffer, 0, bytesRead);
                //  newBuffer.Position = 0;
                //
                //  ProcessReceivedData(newBuffer);
                // }
            }
            catch (Exception ex)
            {
                Debug.Log($"Read operation failed: {ex.Message}");
            }
        }
    }

    private void ProcessReceivedData(MemoryStream buffer)
    {
        const int BasicHeaderSize = 2; // Key(1) + Encrypted PacketType(1)
        const int LengthFieldSize = 4;

        buffer.Position = 0;
        var data = buffer.GetBuffer();
        long readPos = 0;
        long totalLen = buffer.Length;

        while (true)
        {
            // (1) 최소한 BasicHeaderSize 가 확보되어야 PacketType 읽기 가능
            if (totalLen - readPos < BasicHeaderSize)
                break;

            // 1‑a) Key, PacketType 읽고 복호화
            byte key = data[readPos + 0];
            byte encPacketType = data[readPos + 1];
            byte packetType = Packet.Xor(encPacketType, key);

            // (2) 길이를 알아야 하는지 여부 판단
            bool hasLengthField = Packet.HasLengthField(packetType);

            // (3) 필요한 헤더 전체 크기 계산
            int headerSize = BasicHeaderSize + (hasLengthField ? LengthFieldSize : 0);

            // (4) 아직 헤더 전체가 수신되지 않았다면 탈출
            if (totalLen - readPos < headerSize)
                break;

            // (5) 본문(body) 길이 계산
            int bodyLength;
            if (hasLengthField)
            {
                bodyLength = Packet.Xor(data[readPos + 2], key) | (Packet.Xor(data[readPos + 3], key) << 8) | (Packet.Xor(data[readPos + 4], key) << 16) | (Packet.Xor(data[readPos + 5], key) << 24);
            }
            else
            {
                bodyLength = Packet.GetFixedDataLength(packetType);
            }

            // (6) 온전한 패킷이 왔는지 확인
            int packetSize = headerSize + bodyLength;
            if (totalLen - readPos < packetSize)
                break;

            // (7) 스트림 포지션을 readPos로 옮겨서 Parse 호출
            buffer.Position = readPos;
            var packet = Packet.PopWithoutInitialize();
            if (!packet.Parse(buffer))
            {
                Debug.LogError("Packet.Parse failed.");
                return;
            }

            HandlePacketWhileReading(packet);

            // (8) 다음 패킷을 위해 readPos를 옮김
            readPos = buffer.Position;
        }

        // (9) 남은 데이터만 버퍼 앞쪽으로 당겨 놓기
        long leftover = totalLen - readPos;
        if (leftover > 0)
        {
            Array.Copy(data, readPos, data, 0, leftover);
        }

        buffer.SetLength(leftover);
        buffer.Position = 0;
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
                _serverTime = new KeyValuePair<double, double>((finalServerTime + time) / 2, TimeSystem.time);

            // TODO: handle latency
            latency = pingRequest.LatencyMilliseconds; // nowhere used yet

            ResetLastPingAt();

            p.Request.PingRequest.Timestamp.Set(DateTime.UtcNow);

            if (!PlatformManager.Get().Paused)
            {
                p.Request.Id = PacketKey.GetCallbackId();
                _sendPackets.Add(p);
            }

            return;
        }

        packets.Enqueue(p);
    }

    protected virtual void Clear(bool clearPackets = false)
    {
        //
        if (clearPackets)
        {
            while (_sendPackets.TryTake(out _)) ;
            while (packets.TryDequeue(out _)) ;
            _callbacks.Clear();
        }

        PacketKey.ResetClientKey();

        // lastPacketLength = -1;
        _serverTime = new KeyValuePair<double, double>();
        State = ConnectState.Init;

        Update();
    }

    //
    [NonSerialized] public bool gatheringPackets;

    private async UniTask ProcessPackets()
    {
        while (packets.TryDequeue(out var p))
        {
            try
            {
                await HandlePacket(p);
                p.Dispose();
            }
            catch (Exception e)
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
        ProcessPackets().Forget();
    }

    public void ClearSendPackets()
    {
        while (_sendPackets.TryTake(out _)) ;
        _callbacks.Clear();
    }

    public void ProcessQueuedPackets()
    {
    }

    // Process the command received from the server, and take appropriate action.
    protected virtual async UniTask HandlePacket(Packet packet)
    {
#if UNITY_EDITOR
        if (packet.PacketType == Packet.Type.Request)
        {
            Debug.Log($"Got packet type={"" + packet.PacketType}, {packet.Request.RequestCase}");
        }
        else if (packet.PacketType != Packet.Type.None)
        {
            Debug.Log($"Got packet type={"" + packet.PacketType}, {packet}");
        }
#endif
        //
        if (packet.PacketType == Packet.Type.Request)
        {
            if (_callbacks.Remove(packet.Request.Id, out var info))
            {
                try
                {
                    info.callback(packet);
                }
                catch (Exception ex)
                {
                    Debug.LogError(ex);
                }
            }
        }
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
        Debug.LogWarning("ResetClientKey");
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