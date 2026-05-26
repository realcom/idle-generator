using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using UnityEngine;

namespace Commons.Resources
{
    public partial class ResourceAudio
    {
        public override int GetId() => id_;
        public override ResourceString.Types.Category StringCategory => ResourceString.Types.Category.Unspecified;
        public override bool CanDisplay => false;
        
        public override bool HasRelevanceNotice()
        {
            return false;
        }

        [NonSerialized] private AudioClip _audioClipInstance = null;

        private bool GetAudioClip_Internal(out AudioClip clip)
        {
            clip = null;
            if (_audioClipInstance)
            {
                clip = _audioClipInstance;
                return true;
            }

            if (string.IsNullOrEmpty(Prefab))
                return false;
		
            clip = _audioClipInstance = Prefab.Contains("/") ? global::Utility.LoadResource<AudioClip>(Prefab) : UnityEngine.Resources.Load<AudioClip>("Sounds/" + Path.GetFileNameWithoutExtension(Prefab));
            return _audioClipInstance;
        }

        public AudioClip GetAudioClip()
        {
            return GetAudioClip_Internal(out var clip) ? clip : null;
        }
    }
}
