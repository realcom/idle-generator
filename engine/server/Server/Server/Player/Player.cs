using System.Data;
using Commons;
using Commons.Game;
using Commons.Packets.Requests;
using Commons.Resources;
using Commons.Types;
using Commons.Types.Players;
using Commons.Types.Units;
using Commons.Utility;
using log4net;
using Server.Managers;
using Server.Models;
using Server.Session;
using Enum = System.Enum;

namespace Server.Player;

public abstract partial class Player<TServer, TPlayer>(TServer server, Session<TServer, TPlayer> session, PlayerModel model, AccountModel accountModel) : IPlayer
    where TServer : Server<TServer, TPlayer>
    where TPlayer : Player<TServer, TPlayer>
{
    protected static readonly ILog Logger = LogManager.GetLogger("", typeof(TPlayer));
    
    public const double PingIntervalSeconds = 1;
    public const double DestroyTimeoutSeconds = 30000;

    public abstract float TickSeconds { get; }

    public bool SentLoginResponse { get; set; } = false;
    public readonly TServer Server = server;
    public PlayerModel Model { get; } = model;
    public AccountModel AccountModel { get; } = accountModel;
    public string? SnsId { get; set; }
    public int Level { get => Model.level; set => Model.level = value; }
    public long Power { get => Model.power; set => Model.power = value; }
    public int AvatarCharacterItemDataId { get => Model.avatar_character_item_data_id; set => Model.avatar_character_item_data_id = value; }

    public abstract PlayerAvatar Avatar { get; }
    public UnitStat ItemStat { get; } = new();

    public GameBoard? Board { get; set; }
    public Action<StatusCode>? LeaveBoardCallback { get; set; }
    public readonly Dictionary<int, int> BoardPlayerSkillCount = new();

    public long Id => Model.id;
    public string Name => Model.name;
    public bool IsAdmin => Model.is_admin;

    public ResourceString.Types.Language Language =
        Enum.TryParse<ResourceString.Types.Language>(accountModel.language, true, out var language)
            ? language
            : ResourceString.Types.Language.English;

    public abstract IPlayerLogManager PlayerLogManager { get; }

    public override string ToString()
    {
        return $"{typeof(TPlayer)}[{Id}]({Name})";
    }

    public virtual PlayerMessage ToMessage()
    {
        var message = Model.ToMessage();
        message.BoardId = Board?.Id ?? 0L;
        return message;
    }
    
    public BoardPlayerMessage ToBoardMessage(bool includePlayerTraits = false)
    {
        var playerMessage = new BoardPlayerMessage
        {
            Id = Id,
            BytesName = Name.ToByteString(),
            Level = Level,
        };
        ItemStat.CopyTo(playerMessage.ItemStat);
        
        var inventorySkills = GetItemsByType(ResourceItem.Types.Type.InventorySkill);
        playerMessage.InventorySkills.AddRange(inventorySkills.Select(w => w.ToMessage()));

        var addItems = Avatar.Character.GetData()?.EquipAddItemGroups.GetAddItems();
        if (addItems != null)
            foreach (var addItem in addItems)
            {
                var equipItem = ResourceItem.Get(addItem.ItemDataId);
                if (equipItem != null)
                    playerMessage.InventorySkills.Add(new PlayerItemMessage
                    {
                        Id = Int32.MaxValue,
                        Grade = equipItem.Grade,
                        Count = 1,
                        ItemDataId = equipItem.Id,
                    });
            }

        if (includePlayerTraits)
        {
            var traits = GetItemsByCategory(ResourceItem.Types.Category.Trait);
            foreach (var trait in traits)
            {
                var resItem = trait.Data;
                switch (resItem.Type)
                {
                    case ResourceItem.Types.Type.Passive:
                    {
                        playerMessage.AppliedTraits.Add(trait.ToMessage());
                        break;
                    }
                    case ResourceItem.Types.Type.Learnable:
                    {
                        playerMessage.LearnableTraits.Add(trait.ToMessage());
                        break;
                    }
                }
            }
        }
        return playerMessage;
    }
    
    public string GetString(StatusCode status)
    {
        return ResourceString.Get(status, Language);
    }
    
    public string GetString(StatusCode status, params object[] args)
    {
        return ResourceString.Get(status, Language, args);
    }
    
    public string GetString(string key)
    {
        return ResourceString.Get(key, Language);
    }
    
    public string GetString(string key, params object[] args)
    {
        return ResourceString.Get(key, Language, args);
    }

    public string GetString(ResourceString.Types.Category category, int id, string key)
    {
        return ResourceString.Get(category, id, key, Language);
    }
    
    public void SetSession(Session<TServer, TPlayer>? session)
    {
        lock (this)
        {
            Session?.Close(StatusCode.PlayerDuplicateLogin);
            Session = session;
        }
    }

    public abstract Task Init();

    public abstract PlayerItemModel? GetItemById(long id);
    public abstract PlayerItemModel? GetItemByDataId(int dataId);
    public virtual float MaxStaminaBoostRatio => 1f;
    public virtual float StaminaRegenBoostRatio => 1f;
    public virtual float GameSpeedMultiplier => 1f;
    public abstract PlayerAchievementModel? GetAchievementByDataId(int dataId);

    public abstract Task SaveAsync(IDbConnection? db = null, IDbTransaction? transaction = null, bool destroyIfFailed = true);
}
