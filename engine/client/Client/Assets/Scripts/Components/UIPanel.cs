using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using Cysharp.Threading.Tasks;
using UnityEngine.EventSystems;

public class UIPanel : MonoBehaviour, EventListener {

	
	protected List<GameObject> _guiObjects = new List<GameObject>();

    public bool IsPointerOnUI(int button = -1)
    {
#if UNITY_STANDALONE || UNITY_EDITOR
        if (EventSystem.current.IsPointerOverGameObject())
            return true;
#else

        foreach (var touch in Input.touches)
        {
            if ((button < 0 || button == touch.fingerId) && EventSystem.current.IsPointerOverGameObject(touch.fingerId))
                return true;
        }
#endif

        return false;
    }

    public virtual void Awake() {
		GameManager.Get ().AddListener (this);
	}

	//
	public virtual void Start() {
		Refresh ();
	}

	public virtual void Refresh() {

	}
	
	public virtual void OnDestroy() {
		GameManager.Get ().RemoveListener (this);
	}

	public virtual async UniTask HandleEvent(GameEvent e) {

	}
}
