using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GameSkillDirectionSynchronizer : MonoBehaviour
{
    private GameSkillObject m_GameSkillObjectCache = null;

    private GameSkillObject GameSkillObject  
    {
        get
        {
            return m_GameSkillObjectCache ??= GetComponent<GameSkillObject>();
        }
    }

    private void Update()
    {
        var gameSkillObject = GameSkillObject;
        if (gameSkillObject == null)
            return;
        
        var gameSkill = gameSkillObject.gameSkill;
        if (gameSkill == null)
            return;

        transform.rotation = Quaternion.Euler(gameSkill.Direction.X, gameSkill.Direction.Y, 0f);
    }
}
