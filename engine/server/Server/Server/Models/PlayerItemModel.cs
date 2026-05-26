using System.Data;
using Commons;
using Commons.Resources;
using Commons.Types;
using Commons.Types.Players;
using Dapper;
using Google.Protobuf;
using Google.Protobuf.WellKnownTypes;
using Newtonsoft.Json.Linq;
using Server.Managers;

namespace Server.Models;

[Table("player_items")]
public class PlayerItemModel : Model<PlayerItemModel>, IReadOnlyPlayerItem 
{
    long IReadOnlyPlayerItem.Id => id;
    int IReadOnlyPlayerItem.DataId => item_data_id;
    int IReadOnlyPlayerItem.Level => _level;
    PlayerItemOption? IReadOnlyPlayerItem.PlayerItemOption => DeserializedOption;
    
    
    [IgnoreUpdate]
    public long player_id { get; init; }

    [IgnoreUpdate]
    public int item_data_id { get; init; }
    public ResourceItem Data => ResourceItem.Get(item_data_id)!;

    private long _count;
    public long count
    {
        get => _count;
        set
        {
            Dirty = true;
            _count = value;
        }
    }

    private int _grade = 1;
    public int grade
    {
        get => _grade;
        set
        {
            Dirty = true;
            _grade = value;
        }
    }
    private int _level = 1;
    public int level
    {
        get => _level;
        set
        {
            Dirty = true;
            _level = value;
        }
    }
    private long _exp;
    public long exp
    {
        get => _exp;
        set
        {
            Dirty = true;
            _exp = value;
        }
    }
    
    private uint _state_flag;
    public bool HasFlag(PlayerItemMessage.State flag) => (_state_flag & (uint)flag) != 0;
    public PlayerItemMessage.State AddFlag(PlayerItemMessage.State flag)
    {
        if (HasFlag(flag))
            return (PlayerItemMessage.State)_state_flag;
        
        Dirty = true;
        _state_flag |= (uint)flag;
        return (PlayerItemMessage.State)_state_flag;
    }
    
    public PlayerItemMessage.State RemoveFlag(PlayerItemMessage.State flag)
    {
        if (!HasFlag(flag))
            return (PlayerItemMessage.State)_state_flag;
        
        Dirty = true;
        _state_flag &= ~(uint)flag;
        return (PlayerItemMessage.State)_state_flag;
    }

    private int _param1;
    public int param1
    {
        get => _param1;
        set
        {
            Dirty = true;
            _param1 = value;
        }
    }
    private int _param2;
    public int param2
    {
        get => _param2;
        set
        {
            Dirty = true;
            _param2 = value;
        }
    }
    private int _param3;
    public int param3
    {
        get => _param3;
        set
        {
            Dirty = true;
            _param3 = value;
        }
    }
    private int _param4;
    public int param4
    {
        get => _param4;
        set
        {
            Dirty = true;
            _param4 = value;
        }
    }
    
    private DateTime? _until_at;
    public DateTime? until_at
    {
        get => _until_at;
        set
        {
            Dirty = true;
            _until_at = value;
        }
    }

    private DateTime? _time_expiration_process_at;
    public DateTime? time_expiration_process_at
    {
        get => _time_expiration_process_at;
        set
        {
            Dirty = true;
            _time_expiration_process_at = value;
        }
    }

    private bool _optionDirty;
    [Editable(true)]
    public JObject? option { get; private set; }
    private PlayerItemOption? _deserializedOption;
    
    [NotMapped]
    private PlayerItemOption? DeserializedOption
    {
        get
        {
            if (_deserializedOption != null)
                return _deserializedOption;
            if (option == null)
                return null;
            _deserializedOption = option.ToObject<PlayerItemOption>();
            return _deserializedOption;
        }
    }
    
    public OptionScope GetOptionScope()
    {
        return new OptionScope(this);
    }
    
    public ref struct OptionScope(PlayerItemModel model)
    {
        private PlayerItemOption? _option = model.DeserializedOption;
        private bool _dirty;

        public PlayerItemOption Option
        {
            get
            {
                _dirty = true;
                return _option ??= model._deserializedOption = new();
            }
        }
        
        public void OverrideOption(PlayerItemOption option)
        {
            _dirty = true;
            _option = option;
            model._deserializedOption = option;
            model._optionDirty = true;
            model.Dirty = true;
        }

        public void Dispose()
        {
            if (_dirty)
            {
                model._deserializedOption = _option;
                model._optionDirty = true;
                model.Dirty = true;
            }
        }
        
        public static implicit operator PlayerItemOption(OptionScope scope)
        {
            return scope.Option;
        }
    }

    private bool _deleted;
    public bool deleted
    {
        get => _deleted;
        set
        {
            Dirty = true;
            _deleted = value;
        }
    }

    private bool _dirty;
    [NotMapped]
    public bool Dirty
    {
        get => _dirty;
        set
        {
            _dirty = value;
            if (value)
            {
                Updated = true;
                CashItemManager?.SetDirty();
            }
        }
    }

    public bool Updated;

    public ICashItemManager? CashItemManager;

    private PlayerItemModel()
    {
    }
    
    public PlayerItemModel(long playerId, int itemDataId, long count = 1, int level = 1, DateTime? untilAt = null)
    {
        player_id = playerId;
        item_data_id = itemDataId;
        this.count = count;
        this.level = level;
        until_at = untilAt;
    }
    
    public override PlayerItemModel OnConstructionByDb()
    {
        Dirty = false;
        Updated = false;
        return this;
    }
    
    public override PlayerItemModel BeforeSave()
    {
        if (_optionDirty)
        {
            _optionDirty = false;
            option = _deserializedOption == null ? null : JObject.FromObject(_deserializedOption);
        }
        return this;
    }
    
    public override PlayerItemModel OnSave()
    {
        Dirty = false;
        return this;
    }

    public PlayerItemMessage ToMessage(bool includeOption = true)
    {
        return new PlayerItemMessage
        {
            Id = id,
            ItemDataId = item_data_id,
            
            Count = _count,
            Grade = _grade,
            Level = _level,
            Exp = _exp,
            UntilAt = _until_at?.ToTimestamp(),
            TimeExpirationProcessAt = _time_expiration_process_at?.ToTimestamp(),
            StateFlag = _state_flag,
            
            Param1 = _param1,
            Param2 = _param2,
            Param3 = _param3,
            Param4 = _param4,
            
            Option = includeOption ? DeserializedOption : null,
        };
    }
    
    public static async Task<PlayerItemModel?> GetAsync(long playerId, int itemDataId)
    {
        return (await DbManager.WithSessionAsync(db =>
                db.QueryFirstOrDefaultAsync<PlayerItemModel>(
                    "SELECT * FROM player_items WHERE player_id = @playerId AND item_data_id = @itemDataId AND deleted = false",
                    new { playerId, itemDataId })).ConfigureAwait(false))
            ?.OnConstructionByDb();
    }
    
    public static async Task<IEnumerable<PlayerItemModel>> GetAllByPlayerIdAsync(long playerId)
    {
        return (await DbManager.WithSessionAsync(db =>
                db.GetListAsync<PlayerItemModel>(new { player_id = playerId, deleted = false })).ConfigureAwait(false))
            .Select(item => item.OnConstructionByDb());
    }
    
    public static async Task<IEnumerable<PlayerItemModel>> GetAllByPlayerIdsDataIdAsync(IEnumerable<long> playerIds, int itemDataId)
    {
        return (await DbManager.WithSessionAsync(db =>
                db.GetListAsync<PlayerItemModel>(
                    "WHERE player_id = ANY(@playerIds) AND item_data_id = @itemDataId AND deleted = false",
                    new { playerIds, itemDataId })).ConfigureAwait(false))
            .Select(item => item.OnConstructionByDb());
    }
    
    public static async Task<IEnumerable<PlayerItemModel>> GetAllByPlayerIdDataIdsAsync(long playerId, IList<int> itemDataIds)
    {
        return (await DbManager.WithSessionAsync(db =>
                db.GetListAsync<PlayerItemModel>(
                    "WHERE player_id = @playerId AND item_data_id = ANY(@itemDataIds) AND deleted = false",
                    new { playerId, itemDataIds })).ConfigureAwait(false))
            .Select(item => item.OnConstructionByDb());
    }
    
    public static async Task<IEnumerable<PlayerItemModel>> GetAllByDataIdCountRangeAsync(int itemDataId, long minCount, long maxCount)
    {
        return (await DbManager.WithSessionAsync(db =>
                db.GetListAsync<PlayerItemModel>(
                    "WHERE item_data_id = @itemDataId AND count >= @minCount AND count <= @maxCount AND deleted = false",
                    new { itemDataId, minCount, maxCount })).ConfigureAwait(false))
            .Select(item => item.OnConstructionByDb());
    }
}
