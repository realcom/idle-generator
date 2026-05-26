using System.Data;
using Commons.Packets.Updates;
using Commons.Resources;
using Commons.Types;
using Commons.Types.Players;
using Commons.Utility;
using Server.Models;

namespace WorldServer.Managers.CashItemManager;

public partial class CashItemManager
{
    public PlayerAvatar Avatar { get; private set; } = new();

    private async Task InitAvatar()
    {
        var avatarModel = await PlayerAvatarModel.GetByPlayerIdAsync(Player.Id).ConfigureAwait(false);
        Avatar = avatarModel.GetAvatar();
        Avatar.CashItemManager = this;

        Avatar.Units.ResizeAndFillNew(ResourceItem.Global.AvatarConstants.MaxUnitCount);
        
        // var weapons = GetItemsByType(ResourceItem.Types.Type.InventorySkill);
        // Avatar.Weapons.Clear();
        // foreach (var weapon in weapoPns) 
        // {
        //     Avatar.Weapons.Add(GetItemByDataId(weapon.item_data_id)?.ToMessage() ?? new PlayerItemMessage());
        // }
        //
        Avatar.Weapons.ResizeAndFillNew(PlayerAvatar.WeaponSlot.Size);
        Avatar.Equipments.ResizeAndFillNew(PlayerAvatar.EquipmentSlot.Size);
        Avatar.Pets.ResizeAndFillNew(PlayerAvatar.PetSlot.Size);

        if (Avatar.Character != null)
            Player.AvatarCharacterItemDataId = Avatar.Character.ItemDataId;
    }

    private Task SetDefaultAvatar()
    {
        if (Avatar.Character == null)
        {
            var defaultCharacterItem = GetItemByDataId(ResourceItem.Global.DataId.DefaultCharacter)!;
            Player.SetAvatarCharacter(defaultCharacterItem);
        }

        return Task.CompletedTask;
    }

    internal PlayerAvatarUpdate? GetAvatarUpdate()
    {
        if (!Avatar.Dirty)
            return null;
        Avatar.Dirty = false;

        var update = new PlayerAvatarUpdate
        {
            Avatar = Avatar,
        };
        
        RefreshItemStat();
        
        return update;
    }
    
    public void RefreshAvatar(bool save = false)
    {
        var prevAvatar = Avatar.Clone();
        
        // would be deprecated
        Avatar.Traits.Clear();
        Avatar.Weapons.Clear();
        
        // slot root 아이템이 있으면 슬롯 강화 레벨로 덮어씌우기
        for (var i = 0; i < Avatar.Equipments.Count; i++)
        {
            var equipment = Avatar.Equipments[i];
            if (equipment == null || equipment.Id == 0)
                continue;

            equipment = Avatar.Equipments[i] = GetItemById(equipment.Id)!.ToMessage();
            var resEquipment = equipment.GetData();
            if (resEquipment == null)
                continue;
            
            var slotRootItem = GetItemsByCategory(ResourceItem.Types.Category.SlotRoot).FirstOrDefault(e => e.Data.Type == resEquipment.Type);
            if (slotRootItem != null)
                equipment.Level = slotRootItem.level;
        }

        for (var i = 0; i < Avatar.Pets.Count; i++)
        {
            var pet = Avatar.Pets[i];
            if (pet == null || pet.Id == 0)
                continue;

            Avatar.Pets[i] = GetItemById(pet.Id)!.ToMessage();
        }

        if (!prevAvatar.Equals(Avatar))
            Avatar.Dirty = true;
    }
    
    
    private async Task SaveAvatar(IDbConnection db, IDbTransaction transaction)
    {
        await PlayerAvatarModel
            .SaveAsyncWithTransaction(db, transaction, Player.Id, Avatar)
            .ConfigureAwait(false);
    }
}
