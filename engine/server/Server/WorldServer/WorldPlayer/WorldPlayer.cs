using System.Data;
using Commons.Game;
using Commons.Packets;
using Commons.Packets.Requests;
using Commons.Resources;
using Commons.Types.Players;
using Server;
using Server.Managers;
using Server.Models;
using Server.Session;
using WorldServer.Managers.AchievementManager;
using WorldServer.Managers.CashItemManager;
using WorldServer.Managers.PlayerLogManager;
using WorldServer.Managers.RankingManager;

namespace WorldServer.WorldPlayer;

public partial class WorldPlayer : Server.Player.Player<WorldServer, WorldPlayer>
{
    public override float TickSeconds => 1f / 10;

    public readonly CashItemManager CashItemManager;
    public readonly AchievementManager AchievementManager;
    public readonly RankingManager RankingManager;
    public sealed override PlayerLogManager PlayerLogManager { get; }
    
    public override PlayerAvatar Avatar => CashItemManager.Avatar;
    public PlayerTelegramModel? Telegram { get; private set; }

    public bool IsSavePending;
    private readonly Queue<Func<IDbConnection, IDbTransaction, Task>> _saveQueue = new();
    
    public WorldPlayer(WorldServer server, Session<WorldServer, WorldPlayer> session, PlayerModel model, AccountModel accountModel)
        : base(server, session, model, accountModel)
    {
        CashItemManager = new CashItemManager(this);
        Subscribe(CashItemManager);
        AchievementManager = new AchievementManager(this);
        Subscribe(AchievementManager);
        RankingManager = new RankingManager(this);
        Subscribe(RankingManager);
        PlayerLogManager = new PlayerLogManager(this);
        Subscribe(PlayerLogManager);
    }

    public override PlayerMessage ToMessage()
    {
        var message = base.ToMessage();
        message.Telegram = Telegram?.ToMessage();
        return message;
    }

    public override async Task Init()
    {
        if (AccountModel.sns_type == AccountModel.SnsType.Telegram && long.TryParse(AccountModel.sns_key, out var telegramUserId))
            Telegram = await PlayerTelegramModel.GetByTelegramUserIdAsync(telegramUserId).ConfigureAwait(false);
        
        await CashItemManager.Init().ConfigureAwait(false);
        await AchievementManager.Init().ConfigureAwait(false);
        
        RecalculatePower();
        Level = CashItemManager.GetItemByDataId(ResourceItem.Global.DataId.PlayerLevel)?.level ?? Level;
        
        await SaveAsync().ConfigureAwait(false);

        await PlayerPushModel.DeleteUnpublishedByPlayerIdAndTypeAsync(Id, PlayerPushModel.PushType.Volatile).ConfigureAwait(false);
    }

    public override void HandleLoginResponse(LoginRequest.Types.Response response)
    {
        response.Items.AddRange(CashItemManager.Items.Select(i => i.ToMessage()));
        response.Avatar = CashItemManager.Avatar;
        response.Achievements.AddRange(AchievementManager.Achievements.Select(a => a.ToMessage()));
    }
    
    public void QueueSave(Func<IDbConnection, IDbTransaction, Task> task)
    {
        _saveQueue.Enqueue(task);
    }

    public override async Task SaveAsync(IDbConnection? db = null, IDbTransaction? transaction = null, bool destroyIfFailed = true)
    {
        try
        {
            if (db == null || transaction == null)
                await DbManager.WithTransactionAsync(SaveInternal).ConfigureAwait(false);
            else
                await SaveInternal(db, transaction).ConfigureAwait(false);
        }
        catch (Exception ex)
        {
            Logger.Error("Failed to save player", ex);
            if (destroyIfFailed)
                await DestroyInternal().ConfigureAwait(false);
        }
        
        await HandleSavePostProcesses().ConfigureAwait(false);
    }

    private async Task SaveInternal(IDbConnection db, IDbTransaction transaction)
    {
        await CashItemManager.Save(db, transaction).ConfigureAwait(false);
        await AchievementManager.Save(db, transaction).ConfigureAwait(false);
        await RankingManager.Save(db, transaction).ConfigureAwait(false);
        await PlayerLogManager.Save(db, transaction).ConfigureAwait(false);
        while (_saveQueue.TryDequeue(out var task))
            await task(db, transaction).ConfigureAwait(false);
        if (Model.Dirty)
            await Model.SaveAsync(db, transaction).ConfigureAwait(false);
    }

    public override PlayerItemModel? GetItemById(long id)
    {
        return CashItemManager.GetItemById(id);
    }
    
    public override PlayerItemModel? GetItemByDataId(int dataId)
    {
        return CashItemManager.GetItemByDataId(dataId);
    }
    
    public override IEnumerable<PlayerItemModel> GetItemsByCategory(ResourceItem.Types.Category category)
    {
        return CashItemManager.GetItemsByCategory(category);
    }
    
    public override IEnumerable<PlayerItemModel> GetItemsByType(ResourceItem.Types.Type type)
    {
        return CashItemManager.GetItemsByType(type);
    }

    public override float MaxStaminaBoostRatio => CashItemManager.MaxStaminaBoostRatio;
    public override float StaminaRegenBoostRatio => CashItemManager.StaminaRegenBoostRatio;

    public override PlayerAchievementModel? GetAchievementByDataId(int dataId)
    {
        return AchievementManager.GetAchievementByDataId(dataId);
    }

    public void SetAvatarCharacter(PlayerItemModel item)
    {
        AvatarCharacterItemDataId = item.item_data_id;
        Avatar.Character = item.ToMessage();
        Avatar.Dirty = true;
    }
}
