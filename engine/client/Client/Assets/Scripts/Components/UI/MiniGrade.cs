using System.Collections;
using System.Collections.Generic;
using Commons.Resources;
using Commons.Utility;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

public class MiniGrade : MonoBehaviour
{
    public Image imgFrame;
    public Image imgDeco;
    public TextMeshProUGUI txtGrade;
    
    public void Refresh(int grade, int extraGrade = 0)
    {
        this.SetActive(grade > 0);
        
        if (imgFrame)
            imgFrame.sprite = CRC.Get().miniGradeFrameSprites.GetClamped(grade);
        if (imgDeco)
            imgDeco.SetActive(imgDeco.sprite = CRC.Get().miniGradeDecoSprites.GetClamped(grade));
        if (txtGrade)
            txtGrade.text = grade.ToLocalizedGradeString(extraGrade);
    }

    public void RefreshGradeToPotentialGrade(int grade)
    {
        if (txtGrade)
            txtGrade.text = grade.ToLocalizedPotentialGradeString();
    }

    public void Refresh(ResourceItem resItem)
    {
        Refresh(resItem?.Grade ?? 0, resItem?.ExtraGrade ?? 0);
    }
    
}
