using System.Data;
using Commons.Game;
using Commons.Packets;
using Commons.Packets.Requests;
using Commons.Types;
using Commons.Types.Players;
using Commons.Types.Units;
using Server.Events;
using Server.Managers;
using Server.Models;

namespace Server.Player;

public interface IPlayer : IServerEventPublisher, IServerEventSubscriber
{
    public long Id { get; }
    public PlayerModel Model { get; }
    public string Name { get; }
    public bool IsAdmin { get; }
    public int Level { get; }
    public long Power { get; set; }
    public PlayerAvatar Avatar { get; }
    public UnitStat ItemStat { get; }
    
    public GameBoard? Board { get; set; }
    public Action<StatusCode>? LeaveBoardCallback { get; set; }
    public BoardPlayerMessage? OpponentBoardPlayer { get; }
    public PlayerAvatar? OpponentBoardPlayerAvatar { get; }
    public void ClearBoard();
    public void InitBoard(GameBoard board);
    public void SendGetBoard(long requestId = 0L);

    public SemaphoreSlim Semaphore { get; }

    public PlayerMessage ToMessage();
    public BoardPlayerMessage ToBoardMessage(bool includePlayerTraits = false);

    public IPlayerLogManager PlayerLogManager { get; }

    public byte GetNextPacketKey();
    public void SendUpdate();
    public void SendPacket(Packet packet);

    public PlayerItemModel? GetItemById(long id);
    public PlayerItemModel? GetItemByDataId(int dataId);
    public float MaxStaminaBoostRatio { get; }
    public float StaminaRegenBoostRatio { get; }
    public float GameSpeedMultiplier { get; }
    public PlayerAchievementModel? GetAchievementByDataId(int dataId);

    public Task SaveAsync(IDbConnection? db = null, IDbTransaction? transaction = null, bool destroyIfFailed = true);
}
