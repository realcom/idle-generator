using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using Commons.Packets;
using Commons.Packets.Requests;
using Commons.Resources;
using Commons.Types.Players;
using Commons.Utility.ObjectPool;
using UnityEngine;

public abstract class Popup_Attendance : UIPopup
{
    public UIElementContainer<PurchaseProductCell> cells = new();
    protected ResourceItem _resAttendanceItem;

    public override void InitializeUsingToken(string[] tokens)
    {
        base.InitializeUsingToken(tokens);

        if (tokens.Length > 0)
            Init(ResourceItem.Get(int.Parse(tokens.First())));
    }

    protected override void RefreshByFlag()
    {
        if (refreshFlag.ContainsFlag(RefreshFlag.MY_PLAYER_ITEM_UPDATED | RefreshFlag.MY_ACHIEVEMENT_UPDATED))
            Refresh();
    }

    protected override void Start()
    {
        if (_resAttendanceItem == null)
            Init(GetAttendanceItem());
        
        base.Start();
    }

    public override void Refresh()
    {
        base.Refresh();

        ResourceAchievement resAchievement = null;
        var i = 0;
        foreach (var resAch in GetAttendanceAchievements())
        {
            RefreshAttendanceInfo(resAch, i++);
            
            var achievement = MyPlayer.GetAchievementByDataID(resAch.Id);
            if (achievement.State == PlayerAchievementMessage.Types.State.InProgress)
                resAchievement = resAch;
        }

        resAchievement ??= GetAttendanceAchievements().Last(MyPlayer.IsAchievementCompletedOrRewarded);
        RefreshProducts(resAchievement);
    }

    private void Init(ResourceItem resAttendanceItem)
    {
        _resAttendanceItem = resAttendanceItem;
    }
    
    protected abstract ResourceItem GetAttendanceItem();
    protected abstract IEnumerable<ResourceAchievement> GetAttendanceAchievements();
    protected abstract void RefreshAttendanceInfo(ResourceAchievement resAchievement, int index);

    protected void RefreshProducts(ResourceAchievement resAchievement)
    {
        var products= PooledList<ResourceItem>.Get();
        foreach (var product in ResourceItem.GetAllByCategory(ResourceItem.Types.Category.Product))
        {
            if (!product.IsValid)
                continue;
            if (!product.TargetAchievementDataIds.Contains(resAchievement.Id))
                continue;
            
            products.Add(product);
        }

        products.Sort((x, y) => x.Order.CompareTo(y.Order));

        foreach (var (cell, _, resProduct) in cells.GetElements(products))
            cell.Refresh(resProduct);
    }
    
}
