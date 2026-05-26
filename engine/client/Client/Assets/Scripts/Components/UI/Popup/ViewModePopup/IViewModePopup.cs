using Commons.Types.Players;
using UnityEngine;

public interface IViewModePopup
{
    public enum ViewMode
    {
        Normal,
        ViewOnly
    }

    public ViewMode viewMode { get; set; }

    public void UpdateView();

}
