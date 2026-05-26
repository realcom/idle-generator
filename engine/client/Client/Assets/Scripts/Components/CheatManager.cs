using Commons;
using Commons.Packets;
using Commons.Packets.Requests;
using Commons.Packets.Updates;
using Commons.Types.Players;
using Commons.Resources;
using Cysharp.Threading.Tasks;
using UnityEngine;

namespace Components
{
    public static class CheatManager
    {
        
        public static async UniTask HandleInputCheat(string input)
        {
    #if !UNITY_EDITOR && !DEVELOPMENT_BUILD
            if (MyPlayer.Player == null || !MyPlayer.Player.IsAdmin)
                return;
    #endif
            
            var commandPacket = Packet.Pop(0, new SendCommandRequest { Command = input });
            ZWorldClient.Get().SendPacket(commandPacket).Forget();

            var args = input.Split(' ');
            switch (args.GetSafe(0))
            {
                case "/popup2":
                {
                    GameManager.Get().GetOrShowPopupAsync(args.GetSafe(1)).Forget();
                    break;
                }
                case "/popup":
                {
                    GameManager.Get().ShowPopupAsync(args.GetSafe(1)).Forget();
                    break;
                }
                case "/achclaim":
                {
                    var achievementDataId = int.Parse(args.GetSafe(1));
                    if (!int.TryParse(args.GetSafe(2), out var count))
                        count = 1;
                        
                    var achievement = MyPlayer.GetAchievementByDataID(achievementDataId);
                    if (achievement is not { State: PlayerAchievementMessage.Types.State.Completed })
                        break;
                    
                    ZWorldClient.Get().SendPacket(Packet.Pop(0, new ClaimAchievementRewardRequest()
                        {
                            AchievementDataId = achievementDataId,
                            Count = count
                        })).Forget();
                    break;
                }
                case "/useItem":
                {
                    var itemDataId = int.Parse(args.GetSafe(1));
                    if (!int.TryParse(args.GetSafe(2), out var count))
                        count = 1;
                    
                    var item = MyPlayer.GetItemByDataID(itemDataId);
                    if (item == null)
                        break;

                    ZWorldClient.Get().SendPacket(Packet.Pop(0, new UseCashItemRequest()
                    {
                        ItemDataId = itemDataId,
                        Count = count
                    })).Forget();
                    break;
                }
                
                case "/buyItem":
                {
                    var itemDataId = int.Parse(args.GetSafe(1));
                    if (!int.TryParse(args.GetSafe(2), out var count))
                        count = 1;
                    
                    ZWorldClient.Get().SendPacket(Packet.Pop(0, new BuyItemRequest()
                    {
                        ProductItemDataId = itemDataId,
                        Count = count
                    })).Forget();
                    break;
                }

                case "/spawn":
                {
                    var unitDataId = int.Parse(args.GetSafe(1));
                    float.TryParse(args.GetSafe(2), out var deltaPosX);
                    float.TryParse(args.GetSafe(3), out var deltaPosY);
                    GameBoardManager.Get().UpdateBoardPlayerRunCheat(MyPlayer.Player.Id, BoardPlayerRunCheatUpdate.Types.CheatType.Spawn, new[] { unitDataId, (int)deltaPosX, (int)deltaPosY });
                    break;
                }

                case "/buff":
                {
                    var buffDataId = int.Parse(args.GetSafe(1));                
                    GameBoardManager.Get().UpdateBoardPlayerRunCheat(MyPlayer.Player.Id, BoardPlayerRunCheatUpdate.Types.CheatType.Buff, new int[] { buffDataId });
                    break;
                }
                
                case "/trait":
                {
                    var traitDataId = int.Parse(args.GetSafe(1));
                    GameBoardManager.Get().UpdateBoardPlayerRunCheat(MyPlayer.Player.Id, BoardPlayerRunCheatUpdate.Types.CheatType.Trait, new int[] { traitDataId });
                    break;
                }
                
                case "/weapon":
                {
                    var weaponDataId = int.Parse(args.GetSafe(1));
                    GameBoardManager.Get().UpdateBoardPlayerRunCheat(MyPlayer.Player.Id, BoardPlayerRunCheatUpdate.Types.CheatType.Weapon, new int[] { weaponDataId });
                    break;
                }
                
                case "/skill":
                {
                    UseSkillEasy(int.Parse(args.GetSafe(1)), ushort.Parse(args.GetSafe(2, "0")));
                    break;
                }
                case "/map":
                {
                    GameBoardManager.Get().GoToMapLocalToNet(int.Parse(args.GetSafe(1))).Forget();
                    break;
                }
                case "/joinmap":
                {
                    
                    break;
                }
                case "/helloworld":
                {
                    Utility.isDebugMode = false;
                    GameManager.Get().scene.GoScene(Constants.LOGIN_SCENE, true);
                    break;
                }

                case "/hellodevworld":
                {
                    Utility.isDebugMode = true;
                    GameManager.Get().scene.GoScene(Constants.LOGIN_SCENE, true);
                    break;
                }
            }
        }

        public static bool UseSkillEasy(int skillId, ushort targetUnitId = 0)
        {
            var resSkill = ResourceSkill.Get(skillId);
            if (resSkill == null || resSkill.Id == default)
            {
                Debug.LogError($"UseSkill: Invalid skill id: {skillId}");
                return false;
            }

            switch (resSkill.ProjectileType)
            {
                case ResourceSkill.Types.ProjectileType.Target:
                    GameBoardManager.Get().UseTargetSkill(skillId, targetUnitId);
                    break;
                default:
                    GameBoardManager.Get().UseSkill(skillId);
                    break;
            }

            return true;
        }
    }
}