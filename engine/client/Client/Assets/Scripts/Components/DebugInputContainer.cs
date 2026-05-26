
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Commons;
using Commons.Game;
using Commons.Packets;
using Commons.Packets.Requests;
using Commons.Packets.Updates;
using Commons.Resources;
using Commons.Types.Geometry;
using Commons.Types.Players;
using Components;
using Components.UI.Toggle;
using Cysharp.Threading.Tasks;
using TMPro;
using UnityEngine;

public class DebugInputContainer : MonoBehaviour
{
    public GameObject goDebugInput;
    public TMP_InputField inputDebug;
    public CustomButton btnDebug;

    void Start()
    {
        RefreshDebugInput();
    }

    public void RefreshDebugInput()
    {
        if (Config.IsDebug || (MyPlayer.Player != null && MyPlayer.Player.IsAdmin))
        {
            goDebugInput.SetActive(true);
            if (btnDebug)
                btnDebug.SetOnClick(HandleInputCheat);

            inputDebug.onSubmit.RemoveAllListeners();
            inputDebug.onSubmit.AddListener(s =>
            {
                HandleInputCheat();
                inputDebug.text = string.Empty; // Clear input after submission
            });
        }
        else
        {
            goDebugInput.SetActive(false);
        }
    }

    public void HandleInputCheat()
    {
        var inputString = inputDebug.text;
        CheatManager.HandleInputCheat(inputString).Forget();
    }

}
