
using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

/// <summary>
/// 코루틴을 트리 구조로 관리하여 부모가 중단될 때 자식 코루틴도 함께 중단되도록 하는 컨테이너입니다.
/// IDisposable을 구현하여 'using' 구문과 함께 사용 시 자동 정리를 보장합니다.
/// </summary>
public class CoroutineTree : IDisposable
{
    private readonly MonoBehaviour _owner;
    private readonly List<Coroutine> _coroutines = new List<Coroutine>();
    private readonly List<CoroutineTree> _childTrees = new List<CoroutineTree>();
    private bool _isDisposed;

    /// <summary>
    /// 코루틴 트리를 생성합니다.
    /// </summary>
    /// <param name="owner">코루틴을 실행할 MonoBehaviour 인스턴스입니다.</param>
    public CoroutineTree(MonoBehaviour owner)
    {
        _owner = owner;
    }

    /// <summary>
    /// 이 트리 내에서 새로운 자식 코루틴을 시작합니다.
    /// </summary>
    public Coroutine Start(IEnumerator routine)
    {
        if (_isDisposed)
        {
            Debug.LogWarning("Disposed CoroutineTree cannot start new coroutines.");
            return null;
        }

        var coroutine = _owner.StartCoroutine(routine);
        _coroutines.Add(coroutine);
        return coroutine;
    }

    /// <summary>
    /// 새로운 자식 코루틴 트리를 생성하고 반환합니다.
    /// </summary>
    public CoroutineTree CreateChild()
    {
        if (_isDisposed)
        {
            Debug.LogWarning("Disposed CoroutineTree cannot create new child trees.");
            return null;
        }
        
        var childTree = new CoroutineTree(_owner);
        _childTrees.Add(childTree);
        return childTree;
    }

    /// <summary>
    /// 이 트리에 속한 모든 코루틴과 모든 자식 트리를 중지합니다.
    /// </summary>
    public void StopAll()
    {
        if (_isDisposed) return;

        // 자식 트리부터 재귀적으로 중지
        foreach (var child in _childTrees)
        {
            child.StopAll();
        }
        _childTrees.Clear();

        // 이 트리가 직접 관리하는 코루틴 중지
        foreach (var coroutine in _coroutines)
        {
            if (coroutine != null)
            {
                _owner.StopCoroutine(coroutine);
            }
        }
        _coroutines.Clear();
    }

    /// <summary>
    /// IDisposable 인터페이스 구현. 'using' 구문이 끝날 때 자동으로 호출됩니다.
    /// </summary>
    public void Dispose()
    {
        if (_isDisposed)
            return;
        
        StopAll();
        _isDisposed = true;
    }
}

/// <summary>
/// CoroutineTree를 편리하게 사용하기 위한 MonoBehaviour 확장 메서드입니다.
/// </summary>
public static class MonoBehaviourExtensions
{
    /// <summary>
    /// 관리되는 코루틴 트리를 시작합니다.
    /// 이 코루틴이 끝나거나 중단되면 트리 내의 모든 자식 코루틴이 자동으로 중지됩니다.
    /// </summary>
    /// <param name="owner">코루틴을 실행할 MonoBehaviour</param>
    /// <param name="coroutineBuilder">실행할 코루틴 로직을 정의하는 함수. CoroutineTree 인스턴스를 매개변수로 받습니다.</param>
    /// <returns>전체 트리 시퀀스를 제어하는 마스터 코루틴을 반환합니다.</returns>
    public static CoroutineTree StartCoroutineTree(this MonoBehaviour owner, Func<CoroutineTree, IEnumerator> coroutineBuilder)
    {
        var tree = new CoroutineTree(owner);
        tree.Start(RunCoroutineTree(tree.CreateChild(), coroutineBuilder));
        return tree;
    }

    private static IEnumerator RunCoroutineTree(CoroutineTree tree, Func<CoroutineTree, IEnumerator> coroutineBuilder)
    {
        // 'using' 블록을 통해 CoroutineTree의 생명주기를 관리합니다.
        // 블록이 끝나면 (정상 종료 또는 외부 중단 시) tree.Dispose()가 자동으로 호출됩니다.
        using (tree)
        {
            yield return tree.Start(coroutineBuilder(tree.CreateChild()));
        }
    }
}

// public class Example : MonoBehaviour
// {
//     private CoroutineTree _coroutineTree;
//     public void ExampleMethod()
//     {
//         _coroutineTree?.Dispose();
//
//         // CoroutineTree를 사용하여 코루틴을 관리합니다.
//         _coroutineTree = this.StartCoroutineTree(MainCoroutine);
//     }
//     
//     private IEnumerator MainCoroutine(CoroutineTree tree)
//     {
//         yield return tree.Start(SomeChildCoroutine());
//         yield return tree.Start(AnotherChildCoroutine());
//         
//         // 메인 코루틴 로직
//         yield return new WaitForSeconds(1f);
//         Debug.Log("Main Coroutine Finished");
//     }
//     
//     private IEnumerator SomeChildCoroutine()
//     {
//         // 자식 코루틴 로직
//         yield return new WaitForSeconds(2f);
//         Debug.Log("Some Child Coroutine Finished");
//     }
//     
//     private IEnumerator AnotherChildCoroutine()
//     {
//         // 또 다른 자식 코루틴 로직
//         yield return new WaitForSeconds(3f);
//         Debug.Log("Another Child Coroutine Finished");
//     }
// }