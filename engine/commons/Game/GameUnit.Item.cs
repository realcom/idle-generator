using System.Linq;
using Commons.Game.Events;
using Commons.Types;
using Google.Protobuf.Collections;
#if UNITY_5_3_OR_NEWER
using UnityEngine;
#endif

namespace Commons.Game
{
    public partial class GameUnit
    {
        internal void AddItems(RepeatedField<AddItemGroup> addItemGroups, GameUnit? receivingUnit)
        {
            foreach (var addItemGroup in addItemGroups)
            {
                if (addItemGroup.ShouldAddAll)
                {
                    if (!addItemGroup.CanSampleGroup(Board))
                        continue;

                    foreach (var addItem in addItemGroup.AddItems)
                        AddItem(addItem, receivingUnit);
                }
                else
                {
                    var addItem = addItemGroup.Sample(Board);
                    if (addItem != null)
                        AddItem(addItem, receivingUnit);
                }
            }
        }

        internal void AddItem(AddItem addItem, GameUnit? receivingUnit)
        {
            var exp = addItem.GetExp(Board);
            if (exp > 0L)
            {
                if (receivingUnit != null)
                {
                    if (Board.ResMap.EnableUnitExp)
                    {
                        receivingUnit.AddExp(exp);
                    }
                    else
                        Board.QueueEvent(new UnitGetDropItemEvent
                        {
                            UnitId = receivingUnit.Id,
                            PlayerId = receivingUnit.PlayerId,
                            ItemDataId = addItem.ItemDataId,
                            Exp = exp,
                        });
                }

                return;
            }
                
            Board.QueueAddDropItem(addItem, position_, ResUnit.DropDistance, this, receivingUnit);
        }
    }
}
