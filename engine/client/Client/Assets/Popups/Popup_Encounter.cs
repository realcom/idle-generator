using System.Collections;
using System.Collections.Generic;
using Commons.Resources;
using TMPro;
using UnityEngine;

public class Popup_Encounter : UIPopup
{
    public UnitUIRenderer unitUIRenderer;
    public TextMeshProUGUI txtName;
    public TextMeshProUGUI txtDialogue;

    public override void InitializeUsingToken(string[] tokens)
    {
        base.InitializeUsingToken(tokens);

        if (tokens.Length > 0)
        {
            if (int.TryParse(tokens[0], out var unitDataId))
            {
                Initialize(unitDataId);
            }
            else
            {
                OnCancel();   
            }
        }
    }

    public void Initialize(int unitDataId)
    {
        var resUnit = ResourceUnit.Get(unitDataId);
        if (resUnit == null)
        {
            OnCancel();
            return;
        }
        
        unitUIRenderer.Initialize(resUnit);
        txtName.text = resUnit.GetLocalizedString("Encounter_Name");
        txtDialogue.text = resUnit.GetLocalizedString("Encounter_Dialogue");
        
    }
    
    protected override void RefreshByFlag()
    {
        
    }
}
