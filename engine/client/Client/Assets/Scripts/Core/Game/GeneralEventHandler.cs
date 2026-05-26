using System;
using System.Linq;
using Commons.Game;
using Commons.Packets;
using Commons.Packets.Requests;
using Commons.Packets.Updates;
using Commons.Resources;
using Commons.Types.Players;
using Commons.Utility;
using Cysharp.Threading.Tasks;
using UnityEngine;
using UnityEngine.Pool;
using UnityEngine.SceneManagement;

public class GeneralEventHandler : WrappedEventBehaviour
{
    private static GeneralEventHandler _singleton;

    [RuntimeInitializeOnLoadMethod]
    public static void Initialize()
    {
        if (_singleton == null)
        {
            _singleton = new GameObject("[GeneralEventHandler]").AddComponent<GeneralEventHandler>();
        }
    }

    public override void Awake()
    {
        base.Awake();
        DontDestroyOnLoad(gameObject);
    }

    public override async UniTask HandleEvent(GameEvent e)
    {
        await base.HandleEvent(e);
    }
    
    public override void HandleRequestPacket(Packet p)
    {
        switch (p.Request.RequestCase)
        {
            case Request.RequestOneofCase.SendCommandResponse:
            {
                var commandResponse = p.Request.SendCommandResponse;
                GameManager.HandleCommonStatus(commandResponse.Status, commandResponse.Message, showCenterLabel: true);

                break;
            }
            case Request.RequestOneofCase.GetBoardResponse:
            {
                if (SceneManager.GetActiveScene().name == Constants.LOGIN_SCENE)
                    return;
                var res = p.Request.GetBoardResponse;
                
                if (res.Status.IsSuccess())
                {
                    if (res.BoardHash != default)
                    {
                        MyPlayer.SetGameBoardResponse(res);
                    }
                    else if (res.CompressedBoard != default)
                    {
                        MyPlayer.SetGameBoard(res.CompressedBoard.Decompress<GameBoard>());
                    }
                }

                break;
            }
        }
    }
    
    public override void HandleUpdatePacket(Packet p)
    {
        switch (p.Update.UpdateCase)
        {
            case Update.UpdateOneofCase.PlayerItemUpdate:
            {
                var update = p.Update.PlayerItemUpdate;
                MyPlayer.UpdateItems(update.Items);
                break;
            }
            case Update.UpdateOneofCase.PlayerAvatarUpdate:
            {
                var update = p.Update.PlayerAvatarUpdate;
                MyPlayer.CacheAvatar(update.Avatar);
                break;
            }
            case Update.UpdateOneofCase.PlayerAchievementUpdate:
            {
                var update = p.Update.PlayerAchievementUpdate;
                MyPlayer.UpdateAchievements(update.Achievements);
                break;
            }
            case Update.UpdateOneofCase.PlayerAcquiredItemsUpdate:
            {
                var update = p.Update.PlayerAcquiredItemsUpdate;
                MyPlayer.UpdateItems(update.Items);
                
                // if (update.Type == PlayerAcquiredItemsUpdate.Types.Type.BuyProduct && update.Items.All(x => x.GetData()!.Category != ResourceItem.Types.Category.Skill))
                // {
                //     GameManager.Get().HideLoading();
                //     Popup_GotItems.Show("Popup_GotItems_HeaderBuyProduct".L()).SetTable(update.Items);
                //     break;
                // }
                
                GameManager.Get().DispatchEvent(GameEventType.AcquiredItemsUpdated, update);
                break;
            }
            case Update.UpdateOneofCase.PlayerUpdate:
            {
                var update = p.Update.PlayerUpdate;
                var prevPlayer = MyPlayer.Player;
                MyPlayer.Player = update.Player;

                if (prevPlayer.Power != MyPlayer.Player.Power)
                {
                    GameManager.Get().DispatchEvent(GameEventType.MyPlayerPowerUpdated, prevPlayer.Power, MyPlayer.Player.Power);
                    Debug.Log($"[PowerChanged] {prevPlayer.Power} -> {MyPlayer.Player.Power}");
                }
                
                break;
            }
            case Update.UpdateOneofCase.PlayerDisplayMessageUpdate:
            {
                var update = p.Update.PlayerDisplayMessageUpdate;
                switch (update.Type)
                {
                    case PlayerDisplayMessageUpdate.Types.Type.Alert:
                        Popup_Alert.Show()
                            .SetTitle(update.Title)
                            .SetDesc(update.Message)
                            .SetButtonType(Popup_Alert.ButtonViewFlag.OK);
                        break;
                    case PlayerDisplayMessageUpdate.Types.Type.Toast:
                        Toast.Show<Popup_Toast>(update.Message);
                        break;
                    default:
                        throw new ArgumentOutOfRangeException();
                }

                Debug.Log($@"
Received display message:
[Title]: {update.Title} 
[Message]: {update.Message}");
                
                break;
            }
        }
    }
}