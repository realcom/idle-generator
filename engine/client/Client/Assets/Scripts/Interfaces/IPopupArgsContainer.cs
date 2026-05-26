using System;
using System.Collections.Generic;
using System.Linq;
using Commons.Utility;
using Google.Protobuf.Collections;
using Interfaces;
using UnityEngine;

namespace Interfaces
{
    public interface IPopupArgsContainer
    {
        public MapField<string, string> PopupArgs { get; }

        public Dictionary<string, List<string>> ParsedPopupArgs { get; }
        public List<int> TargetPopupParsedArgs { get; }
        public string TargetPopupName { get; set; }
        public string TargetPopupArgs { get; set; }

        public void ShowPopup();
        public void InitArgs(string key, string args);
        public string GetPopupArgument(string key, int index = 0);
        public bool HasPopupArgs(string key);
        public int GetTargetPopupArgument(int index = 0);
        public bool CompareTargetPopupName(string popupName, params int[] args);
    }
    
    public static class IPopupArgsContainerExtensions
    {
        public static string GetPopupArgument(IPopupArgsContainer container, string key, int index = 0)
        {
            if (index >= 0 && container.ParsedPopupArgs.TryGetValue(key, out var args) && args.Count > index)
                return args[index];
            return string.Empty;
        }

        public static bool HasPopupArgs(IPopupArgsContainer container, string key)
        {
            return container.ParsedPopupArgs.ContainsKey(key);
        }

        public static int GetTargetPopupArgument(IPopupArgsContainer container, int index = 0)
        {
            if (index < 0 || container.TargetPopupParsedArgs.Count <= index)
                return int.MinValue;

            return container.TargetPopupParsedArgs.GetClamped(index);
        }

        public static bool CompareTargetPopupName(IPopupArgsContainer container, string popupName)
        {
            return !string.IsNullOrEmpty(container.TargetPopupName) && container.TargetPopupName.Equals(popupName, StringComparison.OrdinalIgnoreCase);
        }
    }
    
}

public abstract class PopupArgsContainer<TContainer> where TContainer : IPopupArgsContainer
{
    private static readonly Dictionary<string, List<TContainer>> _containersByPopupArgKey = new();
    private static readonly Dictionary<string, List<TContainer>> _containersByTargetPopupName = new();
    private static readonly List<TContainer> EmptyList = new();

    public static void Clear()
    {
        _containersByPopupArgKey.Clear();
        _containersByTargetPopupName.Clear();
    }

    public static void Register(TContainer container)
    {
        foreach (var (key, value) in container.PopupArgs)
        {
            if (string.IsNullOrEmpty(key))
                continue;

            var popupArgs = value.Split(':').ToList();
            container.ParsedPopupArgs[key] = popupArgs;

            if (!_containersByPopupArgKey.TryGetValue(key, out var achList))
                _containersByPopupArgKey[key] = achList = new();
            achList.Add(container);

            switch (key)
            {
                case "TargetPopup":
                {
                    //Ex: TargetPopup=Popup_GamePass:1234:1234....
                    if (popupArgs.Count > 1)
                    {
                        for (var i = 1; i < popupArgs.Count; i++)
                        {
                            var args = popupArgs[i];
                            if (int.TryParse(args, out var arg))
                                container.TargetPopupParsedArgs.Add(arg);
                            else if (int.TryParse(args.Split(';')[0], out arg)) //in case of "1234:2345:3456;2345". For arguments targeting
                                container.TargetPopupParsedArgs.Add(arg);
                            else
                            {
                                Debug.LogWarning($"Invalid TargetPopup argument: {popupArgs[i]} in [{key}={value}] in {container.GetType().Name}");
                            }
                        }
                    }
                    container.TargetPopupName = popupArgs[0];
                    container.TargetPopupArgs = value;
                    
                    if (!_containersByTargetPopupName.TryGetValue(container.TargetPopupName, out var targetList))
                        _containersByTargetPopupName[container.TargetPopupName] = targetList = new();
                    targetList.Add(container);

                    break;
                }
            }

            container.InitArgs(key, value);
        }
    }

    public static IReadOnlyList<TContainer> GetAllByTargetPopupName(string popupName)
    {
        return _containersByTargetPopupName.GetValueOrDefault(popupName, EmptyList);
    }

    public static IEnumerable<TContainer> GetAllByTargetPopupNameWithArgs(string popupName, params int[] args)
    {
        foreach (var container in GetAllByTargetPopupName(popupName))
        {
            var match = true;
            for (var i = 0; i < args.Length; i++)
            {
                if (args[i] != container.TargetPopupParsedArgs.GetSafe(i))
                {
                    match = false;
                    break;
                }
            }

            if (match)
                yield return container;
        }
    }

    public static TContainer GetByTargetPopupNameWithArgs(string popupName, params int[] args)
    {
        return GetAllByTargetPopupNameWithArgs(popupName, args).FirstOrDefault();
    }
}