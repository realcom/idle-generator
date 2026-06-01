#if UNITY_WEBGL
using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.IO;
using System.Threading;
using System.Threading.Tasks;
using Commons;
using Commons.Packets;
using Commons.Packets.Requests;
using Commons.Resources;
using Commons.Utility.Protobuf;
using Cysharp.Threading.Tasks;
using Microsoft.IO;
using NativeWebSocket;
using UnityEngine;

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
    public static readonly RecyclableMemoryStreamManager bufferManager = new();

    private const int READ_BUFFER_SIZE = 81920;
    private const int SEND_COOLDOWN_MILLISECONDS = 30;

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

    public delegate void PacketCallback(Packet packet);
    public delegate void PacketFailureCallback(StatusCode status);

    private WebSocket _client;
    private MemoryStream _receiveBuffer = new();
    private readonly byte[] tempBuffer = new byte[READ_BUFFER_SIZE];
    private readonly Queue<Packet> _sendPackets = new();
    private readonly ConcurrentQueue<Packet> packets = new();
    private readonly Queue<long> removableCallbacks = new();
    private readonly Dictionary<long, PacketCallbackInfo> _callbacks;

    private string _host;
    private bool _sendingQueuedPacket;
    private double _blockSendingUntil;
    private double _nextSendAt;
    private double _lastPingAt = Utility.GetTime();
    private KeyValuePair<double, double> _serverTime = new();
    private int _waitingForConnect;

    public uint latency;
    public double serverTime { private set; get; }
    public int serverOffsetTime { private set; get; }
    public DateTime serverDateTime { private set; get; }
    public ConnectState State { get; private set; } = ConnectState.Init;
    public bool IsConnected => State is ConnectState.Connected or ConnectState.Loginned;
    public bool logined => State == ConnectState.Loginned;

    // Compatibility for older call sites that compiled only in WebGL.
    public bool connected => IsConnected;
    public bool disconnected => State == ConnectState.Disconnected;

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

    protected ZClient()
    {
        _callbacks = new Dictionary<long, PacketCallbackInfo>();
        Clear();
    }

    public virtual void Update()
    {
        serverTime = _serverTime.Key + Utility.GetTime() - _serverTime.Value;
        serverOffsetTime = (int)(_serverTime.Key + Utility.GetOffsetTime() - _serverTime.Value);
        serverDateTime = Utility.FromSeconds(serverTime);

#if !UNITY_WEBGL || UNITY_EDITOR
        _client?.DispatchMessageQueue();
#endif
    }

    public virtual void LateUpdate()
    {
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

        ProcessSendPackets().Forget();
        ProcessTimedOutCallbacks();

        if (_client != null && _waitingForConnect <= 0 && _client.State == WebSocketState.Closed)
        {
            Debug.Log("ZClient: Connection lost.");
            Close();
        }

        if (State == ConnectState.Disconnected)
            Close();

        if (IsConnected && NetworkSystem.checkOutPing && MyPlayer.Player.Id != 0 && Utility.GetTime() - _lastPingAt > 20)
        {
            Debug.Log("ZClient: Ping timeout.");
            Close();
        }
    }

    private void ProcessTimedOutCallbacks()
    {
        foreach (var callback in _callbacks)
        {
            if (callback.Value.untilAt < Time.time)
                removableCallbacks.Enqueue(callback.Key);
        }

        while (removableCallbacks.TryDequeue(out var id))
        {
            if (!_callbacks.Remove(id, out var info))
                continue;

            try
            {
                info.failureCallback(StatusCode.RequestTimeOut);
            }
            catch (Exception e)
            {
                Debug.LogException(e);
            }
        }
    }

    private async UniTask SendPacket_Internal(Packet p)
    {
        if (_client == null || _client.State != WebSocketState.Open)
        {
            if (p.PacketType != Packet.Type.None)
                Debug.LogWarning("Socket not connected.");
            p.Dispose();
            return;
        }

        var key = PacketKey.GetClientKey();
        p.Key = key;
        try
        {
            var buf = Utility.SerializePacket(p);
            await _client.Send(buf);
        }
        catch (Exception e)
        {
            Debug.LogWarning($"Fail send packet. exception:\n{e}");
            Debug.LogException(e);
        }
        finally
        {
            p.Dispose();
        }
    }

    public void BlockPacketSendingForTest(float duration)
    {
        var blockEndTime = Utility.GetTime() + duration;
        _blockSendingUntil = blockEndTime;
        Debug.LogWarning($"[TEST] Packet sending will be blocked for {duration} seconds (until {blockEndTime}). Packets will be queued.");
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
        if (response is TPacketResponse typedResponse)
            return typedResponse;

        return new TPacketResponse
        {
            Status = response.Status,
            Message = response.Message,
        };
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
                if (p.Request.RequestCase != Request.RequestOneofCase.PingRequest && p.Request.RequestCase != Request.RequestOneofCase.SkipBoardRequest)
                    Debug.Log($"Send packet type={"" + p.PacketType}, {p.Request.RequestCase}");
                break;
            case Packet.Type.Update:
                Debug.Log($"Send packet type={"" + p.PacketType}, {p.Update.UpdateCase}");
                break;
            default:
                if (p.PacketType != Packet.Type.None)
                    Debug.Log($"Got packet type={"" + p.PacketType}, {p}");
                break;
        }
#endif

        switch (p.Request.RequestCase)
        {
            case Request.RequestOneofCase.PingRequest:
            case Request.RequestOneofCase.SkipBoardRequest:
            case Request.RequestOneofCase.None:
                tsc.TrySetResult(new EmptyResponse
                {
                    Status = StatusCode.Ok
                });
                break;
            default:
                RegisterPacketCallback(callbackId, tsc, withLoading);
                break;
        }

        if (State == ConnectState.Disconnected)
        {
            if (_callbacks.Remove(callbackId, out var info))
                info.failureCallback?.Invoke(StatusCode.LostConnection);
            p.Dispose();
            return tsc.Task;
        }

        if (withLoading)
            GameManager.Get().ShowLoading().Forget();

        if (immediately)
            SendPacket_Internal(p).Forget();
        else if (!cancellationToken.IsCancellationRequested)
            _sendPackets.Enqueue(p);
        else
        {
            _callbacks.Remove(callbackId);
            p.Dispose();
        }

        return tsc.Task.AttachExternalCancellation(cancellationToken);
    }

    private void RegisterPacketCallback(long callbackId, UniTaskCompletionSource<IPacketResponse> taskCompletionSource, bool withLoading)
    {
        _callbacks[callbackId] = new PacketCallbackInfo(
            delegate(Packet packet)
            {
                if (withLoading)
                    GameManager.Get().HideLoading().Forget();

                var response = packet.Request.Response;
                if (response != null)
                {
                    GameManager.HandleCommonStatus(response.Status, response.Message);
                    taskCompletionSource?.TrySetResult(response);
                }
                else
                {
                    GameManager.HandleCommonStatus(StatusCode.BadRequest);
                    taskCompletionSource?.TrySetResult(new EmptyResponse
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

                statusCode.ToToast();

                taskCompletionSource?.TrySetResult(new EmptyResponse
                {
                    Status = statusCode,
                    Message = ResourceString.Get(statusCode, ResourceEntity.Language)
                });
            }
        );
    }

    public void SetReconnectHost(string host)
    {
        _host = host;
    }

    public void SetReconnectHost(string address, int port)
    {
        SetReconnectHost($"{address}:{port}");
    }

    public void Connect(string address, int port)
    {
        SetReconnectHost(address, port);
        _ = ConnectAsync();
    }

    public async Task<bool> ConnectAsync()
    {
        CloseSilently();
        try
        {
            Clear();
            State = ConnectState.Connecting;
            _waitingForConnect = (int)(1f / Time.deltaTime);

            var url = BuildWebSocketUrl(Host);
            _client = new WebSocket(url);
            _client.OnOpen += () =>
            {
                Debug.Log("Connection open!");
                State = ConnectState.Connected;
            };
            _client.OnError += e =>
            {
                Debug.LogError("WebSocket Error! " + e);
                if (State == ConnectState.Connecting)
                    HandleConnectFailed();
            };
            _client.OnClose += _ =>
            {
                Debug.Log("Connection closed!");
                if (State != ConnectState.Disconnected)
                    Close();
            };
            _client.OnMessage += OnMessageReceived;

            await _client.Connect();
            if (_client.State == WebSocketState.Open)
            {
                State = ConnectState.Connected;
                return true;
            }

            HandleConnectFailed();
            return false;
        }
        catch (Exception ex)
        {
            Debug.LogWarning($"Cannot connect to server. (host={Host})");
            Debug.LogWarning(ex);
            HandleConnectFailed();
            return false;
        }
    }

    private static string BuildWebSocketUrl(string host)
    {
        if (string.IsNullOrWhiteSpace(host))
            return host;

        var trimmed = host.Trim();
        if (trimmed.StartsWith("ws://", StringComparison.OrdinalIgnoreCase) ||
            trimmed.StartsWith("wss://", StringComparison.OrdinalIgnoreCase))
            return EnsureTrailingSlash(trimmed);

        var scheme = "ws";
        if (!string.IsNullOrEmpty(Application.absoluteURL) &&
            Application.absoluteURL.StartsWith("https", StringComparison.OrdinalIgnoreCase))
            scheme = "wss";

        return EnsureTrailingSlash($"{scheme}://{trimmed}");
    }

    private static string EnsureTrailingSlash(string url)
    {
        return url.EndsWith("/") ? url : url + "/";
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
        if (_client == null)
            return;

        var client = _client;
        ClearClient();
        try
        {
            _ = client.Close();
        }
        catch (Exception)
        {
        }

        if (!silently)
            HandleDisconnected();
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

    private static readonly ConcurrentQueue<MemoryStream> SmallPools = new();

    public static MemoryStream PopBuffer()
    {
        return SmallPools.TryDequeue(out var ms) ? ms : bufferManager.GetStream();
    }

    public static void ReturnBuffer(MemoryStream ms)
    {
        if (ms == null)
            return;

        if (ms.Length < bufferManager.BlockSize)
        {
            ms.Position = 0;
            ms.SetLength(0);
            SmallPools.Enqueue(ms);
        }
        else
        {
            ms.Dispose();
        }
    }

    private async UniTask ProcessSendPackets()
    {
        if (_sendingQueuedPacket)
            return;

        if (Utility.GetTime() < _blockSendingUntil || Utility.GetTime() < _nextSendAt)
            return;

        if (!IsConnected || State < ConnectState.Loginned)
            return;

        if (_sendPackets.Count == 0)
            return;

        var packet = _sendPackets.Dequeue();
        _sendingQueuedPacket = true;
        try
        {
            await SendPacket_Internal(packet);
            _nextSendAt = Utility.GetTime() + SEND_COOLDOWN_MILLISECONDS / 1000d;
        }
        finally
        {
            _sendingQueuedPacket = false;
        }
    }

    private void OnMessageReceived(byte[] message)
    {
        try
        {
            if (message.Length == 0)
            {
                Debug.Log("Network Connection closed.");
                Close();
                return;
            }

            _receiveBuffer.Seek(0, SeekOrigin.End);
            _receiveBuffer.Write(message, 0, message.Length);
            ProcessReceivedData(_receiveBuffer);
        }
        catch (Exception ex)
        {
            Debug.Log($"Read operation failed: {ex.Message}");
        }
    }

    private void ProcessReceivedData(MemoryStream buffer)
    {
        const int basicHeaderSize = 2;
        const int lengthFieldSize = 4;

        buffer.Position = 0;
        var data = buffer.GetBuffer();
        long readPos = 0;
        long totalLen = buffer.Length;

        while (true)
        {
            if (totalLen - readPos < basicHeaderSize)
                break;

            var key = data[readPos];
            var encryptedPacketType = data[readPos + 1];
            var packetType = Packet.Xor(encryptedPacketType, key);
            var hasLengthField = Packet.HasLengthField(packetType);
            var headerSize = basicHeaderSize + (hasLengthField ? lengthFieldSize : 0);

            if (totalLen - readPos < headerSize)
                break;

            int bodyLength;
            if (hasLengthField)
            {
                bodyLength = Packet.Xor(data[readPos + 2], key) |
                             (Packet.Xor(data[readPos + 3], key) << 8) |
                             (Packet.Xor(data[readPos + 4], key) << 16) |
                             (Packet.Xor(data[readPos + 5], key) << 24);
            }
            else
            {
                bodyLength = Packet.GetFixedDataLength(packetType);
            }

            var packetSize = headerSize + bodyLength;
            if (totalLen - readPos < packetSize)
                break;

            buffer.Position = readPos;
            var packet = Packet.PopWithoutInitialize();
            if (!packet.Parse(buffer))
            {
                Debug.LogError("Packet.Parse failed.");
                return;
            }

            HandlePacketWhileReading(packet);
            readPos = buffer.Position;
        }

        var leftover = totalLen - readPos;
        if (leftover > 0)
            Array.Copy(data, readPos, data, 0, leftover);

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
                _serverTime = new KeyValuePair<double, double>(time, TimeSystem.time);
            else
                _serverTime = new KeyValuePair<double, double>((finalServerTime + time) / 2, TimeSystem.time);

            latency = pingRequest.LatencyMilliseconds;
            ResetLastPingAt();

            p.Request.PingRequest.Timestamp.Set(DateTime.UtcNow);

            if (!PlatformManager.Get().Paused)
            {
                p.Request.Id = PacketKey.GetCallbackId();
                _sendPackets.Enqueue(p);
            }
            else
            {
                p.Dispose();
            }

            return;
        }

        packets.Enqueue(p);
    }

    protected virtual void Clear(bool clearPackets = false)
    {
        if (clearPackets)
        {
            _sendPackets.Clear();
            while (packets.TryDequeue(out _)) ;
            _callbacks.Clear();
        }

        _receiveBuffer.SetLength(0);
        _receiveBuffer.Position = 0;
        PacketKey.ResetClientKey();
        _serverTime = new KeyValuePair<double, double>();
        State = ConnectState.Init;
        Update();
    }

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
        _sendPackets.Clear();
        _callbacks.Clear();
    }

    public void ProcessQueuedPackets()
    {
    }

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

        await UniTask.CompletedTask;
    }
}

public static class PacketKey
{
    private static uint _clientKey = 1;
    private static uint _callbackId = 1;
    private static readonly object ClientLock = new();
    private static readonly object CallbackLock = new();

    public static byte GetClientKey()
    {
        lock (ClientLock)
        {
            var resKey = _clientKey;
            _clientKey += Packet.MagicNumber;
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
