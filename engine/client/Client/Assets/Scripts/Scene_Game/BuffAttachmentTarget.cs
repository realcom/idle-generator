using System.Collections;
using System.Collections.Generic;
using Commons.Resources;
using UnityEngine;

public class BuffAttachmentTarget : MonoBehaviour
{
    [SerializeField] private ResourceBuff.Types.PrefabAttachmentTarget m_AttachmentTarget = ResourceBuff.Types.PrefabAttachmentTarget.SkinRoot;
    public ResourceBuff.Types.PrefabAttachmentTarget AttachmentTarget => m_AttachmentTarget;
}
