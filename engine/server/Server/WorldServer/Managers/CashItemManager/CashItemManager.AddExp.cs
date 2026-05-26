using Commons.Utility;
using Server.Events;
using Server.Models;

namespace WorldServer.Managers.CashItemManager;

public partial class CashItemManager
{
    private int RefreshItemExp(PlayerItemModel item)
    {
        var resItem = item.Data;
        var levelUp = 0;
        while (true)
        {
            var requiredExp = resItem.RequiredExps.GetSafe(item.level - 1);
            if (requiredExp == 0L || item.exp < requiredExp)
                break;
            item.exp -= requiredExp;
            item.level += 1;
            levelUp += 1;
        }

        return levelUp;
    }
    
    public int AddExp(PlayerItemModel item, long exp)
    {
        item.exp += exp;
        
        var levelUp = RefreshItemExp(item);
        
        Player.PublishEvent(new ItemAddExpEvent
        {
            Item = item,
            Exp = exp,
        });

        if (levelUp > 0)
        {
            Player.PublishEvent(new ItemLevelUpEvent()
            {
                Item = item,
                Count = levelUp,
            });
        }

        return levelUp;
    }
}
