using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using Commons.Resources;
using Commons.Types.Geometry;
using Commons.Types.Players;
using Cysharp.Text;
using Cysharp.Threading.Tasks;
using UnityEngine;

namespace Commons.Game.Events
{
    public abstract partial class BoardEvent
    {
        public void Run()
        {
            RunInternal();
            GameManager.Get().DispatchEvent(GameEvent.Get(GameEventType.BoardEventDispatched, this), $"{GetType().Name}");
        }

        protected abstract void RunInternal();
    }

    public partial class UnitPlayAnimationEvent
    {
        protected override void RunInternal()
        {
            if (string.IsNullOrEmpty(Animation))
                return;
            
            var resSkill = ResourceSkill.Get(SkillDataId)!;
            if (resSkill.ProjectileType is ResourceSkill.Types.ProjectileType.Straight or ResourceSkill.Types.ProjectileType.Target)
                return;
            var unitObj = GameBoardManager.Get().GetUnitByID(UnitId);
            if (unitObj != null)
            {
                if (Animation.StartsWith("Dead"))
                {
                    unitObj.unitSkin.ClearAnimation();
                    unitObj.unitSkin.SetAnimation(0, Animation, false, false);
                }
                else
                {
                    var trackIndex = 1;
                    // if (Enum.TryParse<PlayAnimationBehaviour.AnimationName>( Animation, out var animationType))
                        // trackIndex = (int)animationType;

                    unitObj.unitSkin.ClearAnimation(trackIndex);
                    unitObj.unitSkin.SetAnimation(trackIndex, Animation, false, true, timeScale: Speed);
                }
            }
        }
    }
    
    public partial class UnitAttackedEvent
    {
        protected override void RunInternal()
        {
            var unitObj = GameBoardManager.Get().GetUnitByID(UnitId);
            if (unitObj != null)
            {
                var coefficient = ResourceUnit.Global.StatConstants.GetDamageCoefficient(ArmorType, DamageType);
                var effectType = (float)coefficient switch
                {
                    < 1f => EffectType.Ineffective,
                    > 1f => EffectType.Effective,
                    _ => EffectType.Default,
                };
                
                unitObj.HandleAttacked(this, effectType);
                
                GameManager.Get().DispatchEvent(GameEventType.UnitAttacked, this);
                GameManager.Get().DispatchEvent(GameEventType.UnitUpdated, this);
            }
        }
    }
    
    public partial class PlayFxEvent
    {
        protected override void RunInternal()
        {
            FxSettings settings;
            // TODO: refactor this
            if (Prefab.Split("'").Length > 1)
                settings = global::Utility.LoadResource<FxSettings>($"Skills/FxSettings/{Prefab.Split("'")[0]}/{Prefab}.asset");
            else
                settings = global::Utility.LoadResource<FxSettings>(Prefab);
            
            if (settings == null)
                return;
                
            var fxUnitObject = GameBoardManager.Get().GetUnitByID(UnitId);
            var fxSkill = GameBoardManager.Get().gameBoard.GetSkillById(SkillId);
            
            settings.Apply(new FxSettings.FxContext(this, fxUnitObject, fxSkill)); 
        }
    }

    public partial class ToastMessageEvent
    {
        protected override void RunInternal()
        {
            var message = ArgumentString;
            if (ArgumentExpressions != null)
            {
                for (var i = 0; i < ArgumentExpressions.Length; i++)
                    message = message.Replace("%" + (i), ArgumentExpressions[i].ToString());
            }

            Toast.Show<Popup_Toast>(message);
        }
    }
    
    public partial class SetUpdateSpeedEvent
    {
        protected override void RunInternal()
        {
            var timeScaleFxSettingsProperties = new TimeScaleFxSettingsProperties(BoardSpeed, EditorSpeed, Duration);
            
            // TODO: should be changed to individual user's own event when multiplayer is taken into account 
            timeScaleFxSettingsProperties.TryApply(new FxSettings.FxContext(null, MyGameUnitObject.Get()));
        }
    }

    public partial class UnitGetDropItemEvent
    {
        protected override void RunInternal()
        {
            GameManager.Get().DispatchEvent(GameEventType.BoardUnitGotDropItem, this);
            
            var dropItemObject = GameBoardManager.Get().GetDropItemByID(DropItemId);
            if (!dropItemObject)
                return;
            
            dropItemObject.HandleGetDropItem(UnitId);
        }
    }

    public partial class EndGameEvent
    {
        protected override void RunInternal()
        {
            GameBoardManager.Get().SendSkipBoard();
            GameBoardManager.Get().BlockBoardPacketSending(true);
            GameManager.Get().DispatchEvent(GameEventType.GameEnded, this);
        }
    }

    public partial class UnitHealedEvent
    {
        protected override void RunInternal()
        {
            var unitObj = GameBoardManager.Get().GetUnitByID(UnitId);
            if (unitObj != null)
            {
                unitObj.HandleHealed(Heal);
                
                GameManager.Get().DispatchEvent(GameEventType.UnitHealed, this);
                GameManager.Get().DispatchEvent(GameEventType.UnitUpdated, this);
            }
        }
    }
    
    public partial class UnitDeathEvent
    {
        protected override void RunInternal()
        {
            var unitObj = GameBoardManager.Get().GetUnitByID(UnitId);
            if (unitObj != null)
            {
                GameManager.Get().DispatchEvent(GameEventType.UnitDied, this);
                GameManager.Get().DispatchEvent(GameEventType.UnitUpdated, this);
            }
        }
    }
    
    public partial class ShowDialogEvent
    {
        protected override void RunInternal()
        {
            return;
        }
    }

    public partial class IncreaseAchievementEvent
    {
        protected override void RunInternal()
        {
            GameManager.Get().DispatchEvent(GameEventType.BoardIncreaseAchievement, this);
        }
    }
    
    public partial class IncreaseMissionEvent
    {
        protected override void RunInternal()
        {
            GameManager.Get().DispatchEvent(GameEventType.BoardIncreaseMission, this);
            GameManager.Get().DispatchEvent(GameEventType.BoardMissionUpdated, this);
        }
    }
    public partial class CompleteMissionEvent
    {
        protected override void RunInternal()
        {
            GameManager.Get().DispatchEvent(GameEventType.BoardCompleteMission, this);
            GameManager.Get().DispatchEvent(GameEventType.BoardMissionUpdated, this);
        }
    }
    

    public partial class PlayerJoinedEvent
    {
        protected override void RunInternal()
        {
            GameManager.Get().DispatchEvent(GameEventType.BoardPlayerJoined, this);
        }
    }

    public partial class PlayerUpdatedEvent
    {
        protected override void RunInternal()
        {
            GameManager.Get().DispatchEvent(GameEventType.BoardPlayerUpdated, this);
        }
    }

    public partial class PlayerLeftEvent
    {
        protected override void RunInternal()
        {
            GameManager.Get().DispatchEvent(GameEventType.BoardPlayerLeft, this);
        }
    }
    
    public partial class TimerUpdatedEvent
    {
        protected override void RunInternal()
        {
            if (StartTimer)
                GameManager.Get().DispatchEvent(GameEventType.TimerStarted, this);
            else if (StopTimer)
                GameManager.Get().DispatchEvent(GameEventType.TimerStopped, this);
            else if (AddTimer)
                GameManager.Get().DispatchEvent(GameEventType.TimerTimeAppended, this);
            else if (PauseTimer)
                GameManager.Get().DispatchEvent(GameEventType.TimerPaused, this);
            else if (ResumeTimer)
                GameManager.Get().DispatchEvent(GameEventType.TimerResumed, this);
            
            GameManager.Get().DispatchEvent(GameEventType.TimerUpdated, this);
        }
    }
    
    public partial class PlayerMoveBoardEvent
    {
        protected override void RunInternal()
        {
            GameManager.Get().DispatchEvent(GameEventType.BoardPlayerMoved, this);
        }
    }

    public partial class InventoryMergeEvent
    {
        // public long PlayerId;
        // public InventoryType SourceType;
        // public int SourceRow;
        // public int SourceIndex;
        // public InventoryType TargetType;
        // public int TargetRow;
        // public int TargetIndex;
        // public int PrevItemDataId;
        // public int NextItemDataId;
        protected override void RunInternal()
        {
            GameManager.Get().DispatchEvent(GameEventType.BoardInventoryMerged, this);
        }
    }

    public partial class InventorySpawnEvent
    {
        // public long PlayerId;
        // public int Row;
        // public int Index;
        // public int ItemDataId;
        protected override void RunInternal()
        {
            GameManager.Get().DispatchEvent(GameEventType.BoardInventorySpawned, this);
        }
    }

    public partial class InventoryMoveEvent
    {
        // public InventoryType SourceType;
        // public int SourceRow;
        // public int SourceIndex;
        // public InventoryType TargetType;
        // public int TargetRow;
        // public int TargetIndex;
        protected override void RunInternal()
        {
            GameManager.Get().DispatchEvent(GameEventType.BoardInventoryMoved, this); 
        }
    }

    public partial class InventoryExpandEvent
    {
        // public long PlayerId;
        // public int Row;
        // public int Index;
        protected override void RunInternal()
        {
            GameManager.Get().DispatchEvent(GameEventType.BoardInventoryExpanded, this); 
        }
    }

    public partial class InventoryResetHoldEvent
    {
        protected override void RunInternal()
        {
            GameManager.Get().DispatchEvent(GameEventType.BoardInventoryResetHold, this); 
        }
    }

    public partial class InventoryRootingEvent
    {
        protected override void RunInternal()
        {
        }
    }

    public partial class SelectTraitEvent
    {
        protected override void RunInternal()
        {
            GameManager.Get().DispatchEvent(GameEventType.BoardSelectTrait, this); 
        }
    }
    
    public partial class CompleteSelectTraitEvent
    {
        protected override void RunInternal()
        {
            // GameManager.Get().DispatchEvent(GameEventType.BoardCo, this); 
        }
    }

    public partial class WaveQueuedEvent
    {
        protected override void RunInternal()
        {
            GameManager.Get().DispatchEvent(GameEventType.BoardWaveQueued, this);
        }
    }

    public partial class WaveStartedEvent
    {
        protected override void RunInternal()
        {
            GameManager.Get().DispatchEvent(GameEventType.BoardWaveStarted, this);
        }
    }

    public partial class ResetMapScrollEvent
    {
        protected override void RunInternal()
        {
            GameManager.Get().DispatchEvent(GameEventType.BoardResetMapScroll, this);
        }
    }
    public partial class ShowPopupEvent
    {
        protected override void RunInternal()
        {
            using var sb = ZString.CreateStringBuilder();
            sb.Append(ArgumentString);
            
            foreach (var expression in ArgumentExpressions)
            {
                var number = (int)expression;
                if (number == 0)
                    continue;
                
                sb.Append(":");
                sb.Append(number);
            }

            GameManager.Get().GetOrShowPopupAsync(sb.ToString()).Forget();
        }
    }
    
    public partial class BoardStateChangedEvent
    {
        protected override void RunInternal()
        {
            
        }
        
    }

    public partial class UseSkillEvent
    {
        protected override void RunInternal()
        {
            
        }
    }
    
}
