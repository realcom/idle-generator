using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using Commons.Resources;
using Commons.Types.Players;
using Cysharp.Threading.Tasks;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

public class TopBar : ZEventBehaviour, IGoodsViewer
{
    public TextMeshProUGUI txtUserName;
    public TextMeshProUGUI txtUserTrainingRank;
    public TextMeshProUGUI txtUserPower;

    [SerializeField] private ProfileCell _profile;

    public GoodsContainer goodsContainer = new();

    private void OnEnable()
    {
        RefreshUserInfo();

        if (m_GoodsIds.Count == 0)
        {
            RefreshGoods();
        }
    }

    public void RefreshUserInfo()
    {
        RefreshUserName();
        RefreshUserTrainingRank();
        RefreshUserPortrait();
        RefreshUserPower();
    }

    public void RefreshUserName()
    {
        if (txtUserName)
            txtUserName.text = MyPlayer.Player.Name;
    }
    
    public void RefreshUserTrainingRank()
    {
        if (txtUserTrainingRank == null)
            return;
        
        var trainingRank = GlobalResourceItem.TrainingRankItem;
        var trainingRankItem = MyPlayer.GetItemByDataID(trainingRank.Id);
        txtUserTrainingRank.text = trainingRank.GetLocalizedString($"UnitTrainingRank_{trainingRankItem.Level}");
    }
    
    public void RefreshUserPortrait()
    {
        if (_profile)
            _profile.Refresh(MyPlayer.Player);
    }
    
    public void RefreshUserPower()
    {
        if (txtUserPower)
            txtUserPower.text = "UserPowerFormat".L(MyPlayer.Player.Power.ToPowerString());
    }
    
    public void RefreshGoods()
    {
        RefreshGoods(CRC.Get().GetGoodsItemDataIds("Default"));
    }

    private List<int> m_GoodsIds = new();
    public void RefreshGoods(IList<int> goodsIds)
    {
        m_GoodsIds.Clear();
        m_GoodsIds.AddRange(goodsIds);
        goodsContainer.RefreshGoods(m_GoodsIds);
    }

    public override async UniTask HandleEvent(GameEvent e)
    {
        await base.HandleEvent(e);

        switch (e.type)
        {
            case GameEventType.MY_PLAYER_AVATAR_UPDATED:
            case GameEventType.MyPlayerUpdated:
            {
                RefreshUserInfo();
                break;
            }
            case GameEventType.MyPlayerItemUpdated:
            {
                if (e.args.GetSafe(0) is not IList<PlayerItemMessage> items)
                    break;

                foreach (var item in items)
                {
                    if (item.ItemDataId == GlobalResourceItem.TrainingRankItem.Id)
                        RefreshUserTrainingRank();
                    
                    if (m_GoodsIds.Contains(item.ItemDataId))
                        goodsContainer.RefreshGoods(m_GoodsIds);                    
                }
                break;
            }
        }
    }
}
