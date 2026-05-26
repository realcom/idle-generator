using System.Collections;
using System.Collections.Generic;
using Interfaces;
using UnityEngine;

namespace Commons.Resources
{
    public partial class ResourceMap : IPopupArgsContainer
    {
        public Dictionary<string, List<string>> ParsedPopupArgs { get; } = new ();
        public List<int> TargetPopupParsedArgs { get; } = new ();
        public string TargetPopupName { get; set; } = null;
        public string TargetPopupArgs { get; set; } = null;
        private string JoinPopupArgs { get; set; } = null;
        
        public void ShowPopup()
        {
            if (string.IsNullOrEmpty(TargetPopupArgs))
                return;

            GameManager.Get().ShowPopup(TargetPopupArgs);
        }
        
        public void ShowJoinPopup()
        {
            if (string.IsNullOrEmpty(JoinPopupArgs))
                return;

            GameManager.Get().ShowPopup(JoinPopupArgs);
        }
        
        public void InitArgs(string key, string args)
        {
            switch (key)
            {
                case "JoinPopup":
                    JoinPopupArgs = args;
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
        
        public static IReadOnlyList<ResourceMap> GetAllByTargetPopupName(string popupName) => 
            PopupArgsContainer<ResourceMap>.GetAllByTargetPopupName(popupName);
        public static IEnumerable<ResourceMap> GetAllByTargetPopupNameWithArgs(string popupName, params int[] args) =>
            PopupArgsContainer<ResourceMap>.GetAllByTargetPopupNameWithArgs(popupName, args);
        public static ResourceMap GetByTargetPopupNameWithArgs(string popupName, params int[] args) =>
            PopupArgsContainer<ResourceMap>.GetByTargetPopupNameWithArgs(popupName, args);
    }
}
