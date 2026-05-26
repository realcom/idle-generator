using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Commons.Packets;
using Commons.Packets.Updates;
using Commons.Types;
using log4net;
using Server;
using Server.Models;
using Server.Player;

using Commons.Packets.Requests;

namespace WorldServer.Managers;

public static class ChatManager
{
    public static IServer Server = null!;
    private static readonly ILog Logger = LogManager.GetLogger("", System.Reflection.MethodBase.GetCurrentMethod()!.DeclaringType!);
    // 채널 -> (playerId -> IPlayer)
    private static readonly ConcurrentDictionary<string, ConcurrentDictionary<long, IPlayer>> _channels = new();

    // 채널 -> 메시지 풀 (초기화 시 DB에서 로드, 이후 메모리 큐 사용)
    private static readonly ConcurrentDictionary<string, ChannelMessagePool> _messagePool = new();

    // 채널 캐시 상한
    private const int MaxMessagesPerChannel = 1000;
    private const int MaxChatMessageLength = 500;
    public static void Subscribe(string channelKey, IPlayer player)
    {
        var channel = _channels.GetOrAdd(channelKey, _ => new ConcurrentDictionary<long, IPlayer>());
        channel[player.Id] = player; // 덮어쓰기 의도적: 재접속/갱신 허용
    }

    public static void Unsubscribe(string channelKey, IPlayer player)
    {
        if (_channels.TryGetValue(channelKey, out var channel))
        {
            channel.TryRemove(player.Id, out _);
            TryCleanupChannelIfEmpty(channelKey, channel);
        }
    }

    public static void UnsubscribeAll(IPlayer player)
    {
        foreach (var channelKey in _channels.Keys.ToArray()) // 스냅샷
        {
            if (_channels.TryGetValue(channelKey, out var channel))
            {
                Unsubscribe(channelKey, player);
            }
        }
    }

    public static async Task<StatusCode> SendChat(IPlayer player, string channelKey, string language, string message)
    {
        // 입력 검증(예시): 길이 제한
        if (string.IsNullOrWhiteSpace(message) || message.Length > MaxChatMessageLength)
        {
            return StatusCode.BadRequest;
        }
        //TODO: 권한 관리
        Subscribe(channelKey, player);
        var chatModel = new ChatModel
        {
            sender_player_id = player.Id,
            channel_key = channelKey,
            language = language,
            message = message,
        };

        try
        {
            await chatModel.SaveAsync().ConfigureAwait(false);
        }
        catch (Exception ex)
        {
            Logger.Error($"Error saving chat message to DB for channel {channelKey}", ex);
            return StatusCode.BadRequest;
        }

        var chatMessage = chatModel.ToMessage();
        chatMessage.SenderPlayer = player.ToMessage();

        try
        {
            var channelPool = _messagePool.GetOrAdd(channelKey, _ => new ChannelMessagePool(channelKey));
            await channelPool.EnqueueMessage(chatMessage).ConfigureAwait(false);
        }
        catch (Exception ex)
        {
            Logger.Error($"Error enqueuing message to pool for channel {channelKey}", ex);
            return StatusCode.BadRequest;
        }

        Broadcast(channelKey, chatMessage);
        return StatusCode.Ok;
    }

    // afterId(=lastChatId) 이후의 최대 limit개 메시지 반환
    public static async Task<(StatusCode, IReadOnlyList<ChatMessage>)> GetChats(string channelKey, long lastChatId, int limit = 50)
    {
        limit = Math.Clamp(limit, 1, 50);

        try
        {
            var channelPool = _messagePool.GetOrAdd(channelKey, _ => new ChannelMessagePool(channelKey));
            var (statusCode, messages) = await channelPool.GetMessages(lastChatId, limit).ConfigureAwait(false);
            return (statusCode, messages);
        }
        catch (Exception ex)
        {
            Logger.Error($"Error getting chats for channel {channelKey}", ex);
            return (StatusCode.BadRequest, new List<ChatMessage>());
        }
    }

    private static void Broadcast(string channelKey, ChatMessage message)
    {
        if (!_channels.TryGetValue(channelKey, out var channel) || channel.Count == 0)
            return;

        // 스냅샷 뒤 브로드캐스트: 컬렉션 변동과 독립
        var targets = channel.Values.ToArray();
        foreach (var player in targets)
        {
            try
            {
                var packet = new PlayerChatUpdate { Chat = message };
                player.SendPacket(Packet.Pop(player.GetNextPacketKey(), packet));
            }
            catch (System.Exception ex)
            {
                Logger.Error($"Broadcast send failed for player {player.Id}", ex);
            }
        }
    }

    private class ChannelMessagePool
    {
        private static readonly ILog Logger = LogManager.GetLogger(typeof(ChannelMessagePool));
        private readonly ConcurrentQueue<ChatMessage> _queue = new();
        private readonly Task _initializationTask;
        private readonly string _channelKey;

        public ChannelMessagePool(string channelKey)
        {
            _channelKey = channelKey;
            _initializationTask = Initialize();
        }

        private async Task Initialize()
        {
            const int initialSize = MaxMessagesPerChannel;
            try
            {            
                var chatModels = await ChatModel.GetChatsAsync(_channelKey, 0, initialSize).ConfigureAwait(false);

                if (chatModels.Any())
                {
                    var playerIds = chatModels.Select(c => c.sender_player_id).Distinct();
                    var players = (await WorldServer.GetPlayerMessagesByIds(playerIds).ConfigureAwait(false))
                        .ToDictionary(x => x.Id);

                    var messages = chatModels.Select(cm =>
                    {
                        var chat = cm.ToMessage();
                        chat.SenderPlayer = players.GetValueOrDefault(cm.sender_player_id);
                        return chat;
                    }).OrderBy(c => c.Id); // Ensure order

                    foreach (var msg in messages)
                    {
                        _queue.Enqueue(msg);
                    }
                }
            }
            catch (Exception ex)
            {
                Logger.Error($"Error initializing message pool for channel {_channelKey}", ex);
                // Consider setting a status or throwing a specific exception
            }
        }

        public async Task EnqueueMessage(ChatMessage message)
        {
            await _initializationTask; // Ensure initialized before adding
            _queue.Enqueue(message);

            while (_queue.Count > MaxMessagesPerChannel)
            {
                _queue.TryDequeue(out _);
            }
        }

        public async Task<(StatusCode, IReadOnlyList<ChatMessage>)> GetMessages(long lastChatId, int limit)
        {
            try
            {            
                await _initializationTask; // Ensure initialized before getting
                
                IReadOnlyList<ChatMessage> messages;
                if (lastChatId <= 0)
                {
                    messages = _queue.TakeLast(limit).ToList();
                }
                else
                {
                    messages = _queue.Where(c => c.Id > lastChatId).Take(limit).ToList();
                }
                return (StatusCode.Ok, messages);
            }
            catch (Exception ex)
            {
                Logger.Error($"Error getting messages from pool for channel {_channelKey}", ex);
                return (StatusCode.BadRequest, new List<ChatMessage>());
            }
        }
        
        public async Task<int> GetCount()
        {
            await _initializationTask;
            return _queue.Count;
        }
    }

    private static void TryCleanupChannelIfEmpty(string channelKey, ConcurrentDictionary<long, IPlayer> channel)
    {
        if (channel.IsEmpty)
        {
            _channels.TryRemove(channelKey, out _);
            _messagePool.TryRemove(channelKey, out _); // Remove the ChannelMessagePool instance
        }
    }
}
