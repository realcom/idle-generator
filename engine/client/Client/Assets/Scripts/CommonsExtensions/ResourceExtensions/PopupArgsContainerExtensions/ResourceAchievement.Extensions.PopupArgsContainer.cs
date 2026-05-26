using System.Collections;
using System.Collections.Generic;
using Interfaces;
using UnityEngine;

namespace Commons.Resources
{
    public partial class ResourceAchievement : IPopupArgsContainer
    {
        public Dictionary<string, List<string>> ParsedPopupArgs { get; } = new ();
        public List<int> TargetPopupParsedArgs { get; } = new ();
        public string TargetPopupName { get; set; } = null;
        public string TargetPopupArgs { get; set; } = null;
        public string ProgressLandingPopupArgs { get; private set; } = null;

        public void ShowPopup()
        {
            if (string.IsNullOrEmpty(TargetPopupArgs))
                return;

            GameManager.Get().ShowPopup(TargetPopupArgs);
        }

        public void InitArgs(string key, string args)
        {
            switch (key)
            {
                case "ProgressLandingPopup":
                    ProgressLandingPopupArgs = args;
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
        
        public static IReadOnlyList<ResourceAchievement> GetAllByTargetPopupName(string popupName) => 
            PopupArgsContainer<ResourceAchievement>.GetAllByTargetPopupName(popupName);
        public static IEnumerable<ResourceAchievement> GetAllByTargetPopupNameWithArgs(string popupName, params int[] args) =>
            PopupArgsContainer<ResourceAchievement>.GetAllByTargetPopupNameWithArgs(popupName, args);
        public static ResourceAchievement GetByTargetPopupNameWithArgs(string popupName, params int[] args) =>
            PopupArgsContainer<ResourceAchievement>.GetByTargetPopupNameWithArgs(popupName, args);
        
        public void ShowLandingPopup()
        {
            if (string.IsNullOrEmpty(ProgressLandingPopupArgs))
                return;

            GameManager.Get().ShowPopup(ProgressLandingPopupArgs);
        }
    }
}
