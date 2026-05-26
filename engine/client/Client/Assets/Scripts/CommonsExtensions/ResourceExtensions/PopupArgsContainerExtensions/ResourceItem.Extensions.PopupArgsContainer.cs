using System.Collections;
using System.Collections.Generic;
using Interfaces;
using UnityEngine;

namespace Commons.Resources
{
    public partial class ResourceItem : IPopupArgsContainer
    {
        public Dictionary<string, List<string>> ParsedPopupArgs { get; } = new ();
        public List<int> TargetPopupParsedArgs { get; } = new ();
        public string TargetPopupName { get; set; } = null;
        public string TargetPopupArgs { get; set; } = null;
        private string AcquisitionablePopupArgs { get; set; } = null;
        private string InfoPopupArgs { get; set; } = null;
        private string ProbabilityPopupArgs { get; set; } = null;
        public string AcquiredItemViewerPopupArgs { get; private set; } = null;
        
        public void ShowPopup()
        {
            if (string.IsNullOrEmpty(TargetPopupArgs))
                return;

            GameManager.Get().ShowPopup(TargetPopupArgs);
        }
        
        public void ShowAcquisitionablePopup()
        {
            if (string.IsNullOrEmpty(AcquisitionablePopupArgs))
                return;

            GameManager.Get().ShowPopup(AcquisitionablePopupArgs);
        }
        
        public UIPopup ShowInfoPopup()
        {
            if (string.IsNullOrEmpty(InfoPopupArgs))
                return Popup_Tooltip.Show(this);
            
            return GameManager.Get().ShowPopup(InfoPopupArgs);
        }
        
        public void ShowProbabilityPopup()
        {
            if (string.IsNullOrEmpty(ProbabilityPopupArgs))
                return;

            GameManager.Get().ShowPopup(ProbabilityPopupArgs);
        }

        public void InitArgs(string key, string args)
        {
            switch (key)
            {
                case "AcquisitionablePopup":
                    AcquisitionablePopupArgs = args;
                    break;
                case "InfoPopup":
                    InfoPopupArgs = args;
                    break;
                case "ProbabilityPopup":
                    ProbabilityPopupArgs = args;
                    break;
                case "AcquiredItemViewerPopup":
                    AcquiredItemViewerPopupArgs = args;
                    break;
            }
        }

        public string GetPopupArgument(string key, int index = 0)
        {
            return IPopupArgsContainerExtensions.GetPopupArgument(this, key, index);
        }

        public bool HasPopupArgs(string key)
        {
            return IPopupArgsContainerExtensions.HasPopupArgs(this, key);
        }
        
        public int GetTargetPopupArgument(int index = 0)
        {
            return IPopupArgsContainerExtensions.GetTargetPopupArgument(this, index);
        }

        public bool CompareTargetPopupName(string popupName, params int[] args)
        {
            if (!IPopupArgsContainerExtensions.CompareTargetPopupName(this, popupName))
                return false;
            
            for (var i = 0; i < args.Length; i++)
            {
                if (args[i] != TargetPopupParsedArgs.GetSafe(i))
                {
                    return false;
                }
            }

            return true;
        }

        public bool CompareTargetPopupName(string popupName)
        {
            return IPopupArgsContainerExtensions.CompareTargetPopupName(this, popupName);
        }
        
        public static IReadOnlyList<ResourceItem> GetAllByTargetPopupName(string popupName) => 
            PopupArgsContainer<ResourceItem>.GetAllByTargetPopupName(popupName);
        public static IEnumerable<ResourceItem> GetAllByTargetPopupNameWithArgs(string popupName, params int[] args) =>
            PopupArgsContainer<ResourceItem>.GetAllByTargetPopupNameWithArgs(popupName, args);
        public static ResourceItem GetByTargetPopupNameWithArgs(string popupName, params int[] args) =>
            PopupArgsContainer<ResourceItem>.GetByTargetPopupNameWithArgs(popupName, args);
    }
}
