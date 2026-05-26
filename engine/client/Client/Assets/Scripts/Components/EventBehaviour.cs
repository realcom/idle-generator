using System.Collections;
using System.Collections.Generic;
using Cysharp.Threading.Tasks;
using Sirenix.OdinInspector;
using UnityEngine;

public abstract class EventBehaviour : MonoBehaviour, EventListener {

	public virtual bool listenEdgeEvents => true;
    public virtual bool listenWorldEvents => true;

    public virtual void Awake()
    {
	    GameManager.Get().AddListener(this);
	    // if(listenEdgeEvents)
		    // EdgeClient.Get().AddListener(this);
	    if (listenWorldEvents)
		    ZWorldClient.Get().AddListener(this);
	    // Refresh();
    }
    

    public virtual void Start () {
		// GameManager.Get().AddListener(this);
		// if(listenEdgeEvents)
		// 	EdgeClient.Get().AddListener(this);
  //       if (listenWorldEvents)
  //           WorldClient.Get().AddListener(this);
		Refresh();
	}

	public virtual void OnDestroy() {
		GameManager.Get().RemoveListener(this);
		// EdgeClient.Get().RemoveListener(this);
        ZWorldClient.Get().RemoveListener(this);
    }

	public virtual void Refresh() {
		
	}

	public abstract UniTask HandleEvent(GameEvent e);
}

public abstract class ZEventBehaviour : SerializedMonoBehaviour, EventListener
{
	public virtual bool listenEdgeEvents => true;
	public virtual bool listenWorldEvents => true;

	public virtual void Awake()
	{
		GameManager.Get().AddListener(this);
		// if(listenEdgeEvents)
		// EdgeClient.Get().AddListener(this);
		if (listenWorldEvents)
			ZWorldClient.Get().AddListener(this);
		// Refresh();
	}
    

	public virtual void Start () {
		// GameManager.Get().AddListener(this);
		// if(listenEdgeEvents)
		// 	EdgeClient.Get().AddListener(this);
		//       if (listenWorldEvents)
		//           WorldClient.Get().AddListener(this);
		Refresh();
	}

	public virtual void OnDestroy() {
		GameManager.Get().RemoveListener(this);
		// EdgeClient.Get().RemoveListener(this);
		ZWorldClient.Get().RemoveListener(this);
	}

	public virtual void Refresh() {
		
	}

	public virtual async UniTask HandleEvent(GameEvent e) {
		
	}
}