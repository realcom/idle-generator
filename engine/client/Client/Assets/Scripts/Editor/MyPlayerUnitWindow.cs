using System;
using UnityEngine;
using UnityEditor;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Commons;
using Commons.Packets;
using Commons.Packets.Requests;
using Commons.Types.Players;
using Components;
using Cysharp.Threading.Tasks;
using Random = UnityEngine.Random;

#if UNITY_EDITOR
public class MyPlayerUnitWindow : EditorWindow
{
    [MenuItem("Tools/IdleZ/Player Status Window")]
    public static void ShowWindow()
    {
        GetWindow<MyPlayerUnitWindow>("Player Status Window");
    }

    private int _tab;
    private int _tabSkill;
    private Vector2 _scroll;

    private double _statsUpdatedAt;
    private List<float> _stats = new();
    
    private string _input2;
    private const int CheatInputCount = 15;
    private string[] _cheatInputs = new string[CheatInputCount];
    
    private void OnInspectorUpdate()
    {
        Repaint();
    }

    private void OnGUI()
    {
        if (!MyGameUnitObject.Get())
        {
            RefreshUtils();
            return;
        }
            
        // _tab = GUILayout.Toolbar(_tab, new []{ "Utils" }, GUILayout.Height(40));
        _scroll = EditorGUILayout.BeginScrollView(_scroll);
        RefreshUtils();

        // switch (_tab)
        // {
            // case 0:
                // RefreshUtils();
                // break;
        // }
        EditorGUILayout.EndScrollView();
    }

    private void RefreshStats()
    {
        // if (Room.Get()?.state < RoomState.ENDED && _statsUpdatedAt + 1 < Utility.GetTime())
        // {
        //     _statsUpdatedAt = Utility.GetTime();
        //     
        //     EdgeClient.Get().SendPacket(Packet.Type.GetStats, new GetStats
        //     {
        //         unitID = MyPlayerUnit.Get().tunit.id,
        //     }, p =>
        //     {
        //         var l = p.Get<GetStats.Result>();
        //         _stats = l.stats;
        //     });
        // }

        if (_stats.Count > 0)
        {
            //foreach (var name in Enum.GetNames(typeof(NekoStat)))
            //    EditorGUILayout.LabelField($"{name} : {_stats.GetSafe((int)Enum.Parse<NekoStat>(name))}");
        }
    }

    private void RefreshBuffs()
    {
        //var i = 0;
        //var cellWidth = 300f;
        //var rowCnt = (int)Mathf.Floor(position.width / cellWidth);
        //var rowClosed = true;
        //EditorGUILayout.BeginVertical(GUI.skin.box);
        //foreach (var tbuff in MyPlayerUnit.Get().tunit.buffs.buffs)
        //{
        //    if (i % rowCnt == 0)
        //    {
        //        EditorGUILayout.BeginHorizontal(GUI.skin.box);
        //        rowClosed = false;
        //    }
        //    
        //    //
        //    var resBuff = Old_ResourceBuff.Get(tbuff.dataID);
        //    EditorGUILayout.BeginVertical(GUI.skin.box);
        //    
        //    //
        //    EditorGUILayout.LabelField($"#{resBuff.id} {resBuff.name}", GUILayout.Width(cellWidth));
        //    GUILayout.Space(5);
        //    
        //    //
        //    EditorGUILayout.LabelField($"레벨 {tbuff.outLevel}", GUILayout.Width(cellWidth));
        //    GUILayout.Space(5);
        //    
        //    //
        //    EditorGUILayout.LabelField($"스택 {tbuff.stack}", GUILayout.Width(cellWidth));
        //    GUILayout.Space(5);
        //    
        //    //
        //    EditorGUILayout.LabelField($"남은 시간 {(resBuff.ContainsTag(old_Tag.INFINITE) ? "INFINITE" : Utility.BeautyTime((int)(tbuff.untilAt - Utility.GetTime())))}", GUILayout.Width(cellWidth));
        //    
        //    //
        //    EditorGUILayout.EndVertical();
        //    GUILayout.Space(10);
        //
        //    //
        //    if (i % rowCnt == rowCnt - 1)
        //    {
        //        EditorGUILayout.EndHorizontal();
        //        rowClosed = true;
        //    }
        //    
        //    i++;
        //}
        //if (!rowClosed) 
        //    EditorGUILayout.EndHorizontal();
        //EditorGUILayout.EndVertical();
    }
    
    private void RefreshSkills()
    {
        _tabSkill = GUILayout.Toolbar(_tabSkill, new []{ "Learnable", "UnitAttacks", "UnitShotSkills" }, GUILayout.Height(20), GUILayout.Width(300));

        switch (_tabSkill)
        {
            case 0:
                RefreshLearnableSkills();
                break;
            case 1:
                RefreshUnitAttacks();
                break;
            case 2:
                RefreshUnitShotSkills();
                break;
        }
    }

    private void RefreshUnitAttacks()
    {
    }

    private void RefreshUnitShotSkills()
    {
    }
    
    private void RefreshLearnableSkills()
    {
    }

    private void RefreshUtils()
    {
        EditorGUILayout.BeginVertical(GUI.skin.box);

        //
        for (var i = 0; i < _cheatInputs.Length; ++i)
        {

            EditorGUILayout.BeginHorizontal(GUI.skin.box);
            _cheatInputs[i] = EditorGUILayout.TextField(_cheatInputs[i], GUILayout.Width(150));
            if (GUILayout.Button("치트 사용", GUILayout.Width(100)))
            {
                CheatManager.HandleInputCheat(_cheatInputs[i]).Forget();
            }

            EditorGUILayout.EndHorizontal();
        }
        
        EditorGUILayout.BeginHorizontal(GUI.skin.box);
        if (GUILayout.Toggle(Config.AutoPlay, new GUIContent("자동 사냥"), GUILayout.Width(100)))
        {
            Config.AutoPlay = true;
        }
        else
        {
            Config.AutoPlay = false;
        }
        EditorGUILayout.EndHorizontal();
        
        //
        EditorGUILayout.BeginHorizontal(GUI.skin.box);
        _input2 = EditorGUILayout.TextField(_input2, GUILayout.Width(150));
        //if (GUILayout.Button("Dialog", GUILayout.Width(100)))
        //    GameManager.Get().ShowPopup<Popup_Dialog>().Initialize(int.Parse(_input2));
        EditorGUILayout.EndHorizontal();
                    
        //
        EditorGUILayout.EndVertical();
    }

    private void RefreshSystems()
    {
	    
    }
}
#endif