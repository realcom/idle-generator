using System;
using System.Collections.Generic;
using System.Reflection;
using UnityEngine;
using UnityEngine.Rendering;
using Object = UnityEngine.Object;
#if UNITY_EDITOR
using UnityEditor;
#endif

public class FXSystem : BaseSystem<FXSystem>
{
    [RuntimeInitializeOnLoadMethod]
    private static void Initialize()
    {
        // after animation update
        // https://forum.unity.com/threads/when-the-update-of-a-playabledirector-happens-during-the-execution-order.1369830/
        ZPlayerLoopSystemHelper.InsertSystemAfter(typeof(FXSystem), Update,
            typeof(UnityEngine.PlayerLoop.PreLateUpdate.DirectorDeferredEvaluate));
    }

    private abstract class FxRunner<T> : IFxRunner where T : FxSettingsProperties
    {
        public T settings;
        public FxSettings.FxContext context;
        public double startAt;
        public double untilAt => startAt + duration;
        public double duration;

        public virtual bool IsExpired() => _lastCurrentAt >= untilAt;

        public bool HasSettings() => settings != null;
        public bool initialized { get; set; }

        public void Initialize(T settings, FxSettings.FxContext context, double startAt, double duration)
        {
            Clear();
            
            this.settings = settings;
            this.context = context;
            this.startAt = startAt; // for delay application use later, leave it as is
            this.duration = duration / context.fxSpeed;
            
            _lastCurrentAt = startAt - Time.deltaTime;
        }

        private double _lastCurrentAt;
        public void Update(double currentAt)
        {
            if (!initialized)
            {
                OnInitialize();
                initialized = true;
            }
            _lastCurrentAt += Time.deltaTime;
            var passedAt = _lastCurrentAt - startAt;
            var passedNormalizedAt = Mathf.Clamp01((float)(passedAt / duration));
            
            var passedAtUnscaled = currentAt - startAt;
            var passedNormalizedAtUnscaled = Mathf.Clamp01((float)(passedAtUnscaled / duration));

            OnUpdate(passedAt, passedNormalizedAt, passedAtUnscaled, passedNormalizedAtUnscaled);
        }

        public void Release()
        {
            if (!HasSettings())
                return;
            
            OnRelease();
            Clear();
        }


        protected abstract void OnInitialize();

        protected abstract void OnUpdate(double passedAt, double passedNormalizedAt, double passedAtUnscaled, double passedNormalizedAtUnscaled);

        protected abstract void OnRelease();

        public void Clear()
        {
            initialized = false;
            settings = null;
            context = FxSettings.FxContext.Empty;
            startAt = 0;
            duration = 0;
        }
    }

    public interface IFxRunner
    {
        void Update(double currentAt);
        void Release();
        bool IsExpired();

        bool HasSettings();
        bool initialized { get; set; }
    }

    private static readonly List<IFxRunner> fxRunners = new();

    public static void RegisterRunner(IFxRunner runner)
    {
        if (!fxRunners.Contains(runner))
            fxRunners.Add(runner);
    }

    private static void Update()
    {
        if (_isPaused)
            return;
        
        var currentAt = Utility.GetTime();

        foreach (var runner in fxRunners)
        {
            if (runner.HasSettings())
                runner.Update(currentAt);

            if (runner.IsExpired())
            {
                runner.Release();
            }
        }

        fxRunners.RemoveAll(x => x.IsExpired());
    }
    
    private static bool _isPaused;

    public static void Pause()
    {
        _isPaused = true;
    }
    
    public static void Resume()
    {
        _isPaused = false;
    }

    #region GlobalVolume

    private class GlobalVolumeFxRunner : FxRunner<DynamicVolumeFxSettingsProperties>
    {
        private Volume volume = null;

        protected override void OnInitialize()
        {
            //TODO: temporary
            volume = Camera.main.Get<Volume>("GlobalVolume");
            volume.profile = settings.profile;
        }

        protected override void OnUpdate(double passedAt, double passedNormalizedAt, double passedAtUnscaled, double passedNormalizedAtUnscaled)
        {
            volume.weight = settings.weightCurve.Evaluate((float)passedNormalizedAt);
        }

        protected override void OnRelease()
        {
            volume.profile = null;
            volume = null;
        }
    }

    private static readonly GlobalVolumeFxRunner globalVolumeFxRunner = new();

    public static void RequestGlobalVolumeFx(DynamicVolumeFxSettingsProperties settings, FxSettings.FxContext context)
    {
        globalVolumeFxRunner.Release();

        globalVolumeFxRunner.Initialize(settings, context, Utility.GetTime(), settings.duration);
        RegisterRunner(globalVolumeFxRunner);
    }

    #endregion

    #region AnimationFx & Particle

    private class AnimationFxRunner : FxRunner<AnimationFxSettingsProperties>
    {
        private long _key;

        private GameObject _effectInstance;

        //private ParticleSystem[] _particleSystems;
        //private ParticleSystem _rootParticleSystem = null;
        //private ParticleSystem[] _randomSeedParticleSystems = Array.Empty<ParticleSystem>();
        
        private static readonly List<ParticleSystem> randomSeedParticleSystems = new();

        protected override void OnInitialize()
        {
            if (_effectInstance)
                return;
            
            if (!context.fxApplyingUnitObject)
                return;
            
            var gameUnitObject = context.fxApplyingUnitObject;

            var prefab = settings.GetPrefab(context);
            var position = gameUnitObject.transform.position;

            if (context.authorEvent?.Position != null)
                position = (Vector2)context.authorEvent.Position;
            
            _key = prefab.GetInstanceID();
            _effectInstance = GameObjectPool.Get(prefab, position + settings.positionOffset, settings.rotationOffset, gameUnitObject.transform);
            
            var transform = _effectInstance.transform;
            transform.position = position + settings.positionOffset;
            if (settings.followUnitDirection)
                transform.rotation = gameUnitObject.transform.rotation * settings.rotationOffset;
            transform.localScale = settings.scaleOffset;

            //_particleSystems = _effectInstance.GetComponentsInChildren<ParticleSystem>() ??
            //                      Array.Empty<ParticleSystem>();
            //
            //if (_particleSystems.Length > 0)
            //{
            //    _rootParticleSystem = _particleSystems.GetSafe(0);
            //    _rootParticleSystem.Stop(true, ParticleSystemStopBehavior.StopEmittingAndClear);
            //    randomSeedParticleSystems.Clear();
            //    foreach (var ps in _particleSystems)
            //    {
            //        ps.Stop();
            //        if (ps.useAutoRandomSeed)
            //        {
            //            ps.useAutoRandomSeed = false;
            //            randomSeedParticleSystems.Add(ps);
            //        }
            //    }
            //    _randomSeedParticleSystems = randomSeedParticleSystems.ToArray();            
            //}
            //
            //if (_rootParticleSystem)
            //{
            //    _rootParticleSystem.Stop(true, ParticleSystemStopBehavior.StopEmittingAndClear);
            //    foreach (var ps in _randomSeedParticleSystems)
            //    {
            //        ps.randomSeed = (uint)UnityEngine.Random.Range(0, uint.MaxValue);
            //    }
            //}

            if (settings.parentAsWorld)
            {
                if (GameBoardManager.Get() is { } gameBoardManager)
                {
                    var worldParent = gameBoardManager.transform;
                    transform.SetParent(worldParent);
                }

                if (settings.followUnitDirection)
                    transform.rotation = gameUnitObject.transform.rotation * settings.rotationOffset;
            }
        }

        protected override void OnUpdate(double passedAt, double passedNormalizedAt, double passedAtUnscaled, double passedNormalizedAtUnscaled)
        {
            //if (_effectInstance != null)
            //{
            //    _effectInstance.SetActive(true);
            //    foreach (var ps in _particleSystems)
            //    {
            //        var passedTime = passedAt * context.fxSpeed;
            //        ps.Simulate((float)passedTime);
            //    }
            //}
            
            if (context.fxGeneratingSkill is { Destroyed: true } && !settings.independentOfTimeline)
                Release();
        }

        protected override void OnRelease()
        {
            if (_effectInstance != null)
            {
                //if (_rootParticleSystem)
                //{
                //    _rootParticleSystem.Stop(true, ParticleSystemStopBehavior.StopEmittingAndClear);
                //    foreach (var ps in _randomSeedParticleSystems)
                //    {
                //        ps.useAutoRandomSeed = true;
                //    }
                //}
                
                GameObjectPool.Release(_effectInstance);
                _effectInstance = null;
            }

            //Recycle
            queuedAnimationFxRunners.Enqueue(this);
        }
    }

    private static readonly Queue<AnimationFxRunner> queuedAnimationFxRunners = new();

    public static void RequestAnimationFx(AnimationFxSettingsProperties settings, FxSettings.FxContext context)
    {
        if (!queuedAnimationFxRunners.TryDequeue(out var animationFxRunner))
            animationFxRunner = new AnimationFxRunner();

        animationFxRunner.Initialize(settings, context, Utility.GetTime(), settings.duration);
        RegisterRunner(animationFxRunner);
    }

    #endregion
    
    #region AreaDisplayFx

    private class AreaDisplayFxRunner : FxRunner<AreaDisplayFxSettingsProperties>
    {
        private AreaMeshRenderer _areaMeshRendererInstance;

        protected override void OnInitialize()
        {
            if (_areaMeshRendererInstance)
                _areaMeshRendererInstance.SetActive(true);

            if (!context.fxApplyingUnitObject)
            {
                OnRelease();
                return;
            }
            
            _areaMeshRendererInstance =
                AreaMeshRendererExtension.Get(settings.mesh, settings.material, settings.size.x, settings.size.y);
            var unitTransform = context.fxApplyingUnitObject.transform;

            _areaMeshRendererInstance.transform.position =
                unitTransform.TransformPoint(settings.offset.X0Z()) + new Vector3(0, 0.01f, 0);

            if (settings.followUnitRotation)
                _areaMeshRendererInstance.transform.rotation = context.fxApplyingUnitObject.transform.rotation;
            _areaMeshRendererInstance.transform.rotation *= settings.deltaRotation;
        }

        protected override void OnUpdate(double passedAt, double passedNormalizedAt, double passedAtUnscaled, double passedNormalizedAtUnscaled)
        {
            if (_areaMeshRendererInstance == null)
                return;

            _areaMeshRendererInstance.SetFillValue(settings.fillCurve.Evaluate((float)passedNormalizedAt));
            
            if (context.fxApplyingUnitObject == null || context.fxApplyingUnitObject.gameUnit is not {} gameUnit || gameUnit.DestroyTick > 0 || !context.fxApplyingUnitObject.gameObject.activeInHierarchy)
                OnRelease();
        }

        protected override void OnRelease()
        {
            if (_areaMeshRendererInstance)
            {
                _areaMeshRendererInstance.SetActive(false);
                Object.Destroy(_areaMeshRendererInstance.gameObject);
            }

            queuedAreaDisplayFxRunners.Enqueue(this);
        }
    }

    private static readonly Queue<AreaDisplayFxRunner> queuedAreaDisplayFxRunners = new();

    public static void RequestAreaDisplayFx(AreaDisplayFxSettingsProperties settings, FxSettings.FxContext context)
    {
        if (!queuedAreaDisplayFxRunners.TryDequeue(out var areaDisplayFxRunner))
            areaDisplayFxRunner = new AreaDisplayFxRunner();

        areaDisplayFxRunner.Initialize(settings, context, Utility.GetTime(), settings.duration);
        RegisterRunner(areaDisplayFxRunner);
    }

    #endregion

    #region TimeScaleFx

    private class TimeScaleFxRunner : FxRunner<TimeScaleFxSettingsProperties>
    {
        private const float ORIGINAL_TIME_SCALE = 1f;
        private const float ORIGINAL_GAME_BOARD_UPDATE_SCALE = 1f;
        
        public override bool IsExpired() => Utility.GetTime() >= untilAt;

        protected override void OnInitialize()
        {
        }

        protected override void OnUpdate(double passedAt, double passedNormalizedAt, double passedAtUnscaled, double passedNormalizedAtUnscaled)
        {
            GameBoardManager.Get().BoardUpdateScale = settings.boardSpeed > 0 ? settings.boardSpeed : ORIGINAL_GAME_BOARD_UPDATE_SCALE;
            TimeSystem.timeScale = settings.boardSpeed > 0 ? settings.editorSpeed : ORIGINAL_TIME_SCALE;
        }

        protected override void OnRelease()
        {
            GameBoardManager.Get().BoardUpdateScale = ORIGINAL_GAME_BOARD_UPDATE_SCALE;
            TimeSystem.timeScale = ORIGINAL_TIME_SCALE;
        }
    }

    private static readonly TimeScaleFxRunner timeScaleFxRunner = new();

    public static void RequestTimeScaleFx(TimeScaleFxSettingsProperties settings, FxSettings.FxContext context)
    {
        timeScaleFxRunner.Initialize(settings, context, Utility.GetTime(), settings.duration);
        RegisterRunner(timeScaleFxRunner);
    }

    #endregion
}

#if UNITY_EDITOR
public static class EditorFXAudioSystem
{
    public static void PlayClip(AudioClip clip, int startSample = 0, bool loop = false)
    {
        var unityEditorAssembly = typeof(AudioImporter).Assembly;

        var audioUtilClass = unityEditorAssembly.GetType("UnityEditor.AudioUtil");
        var method = audioUtilClass.GetMethod(
            "PlayPreviewClip",
            BindingFlags.Static | BindingFlags.Public,
            null,
            new Type[] { typeof(AudioClip), typeof(int), typeof(bool) },
            null
        );

        method.Invoke(
            null,
            new object[] { clip, startSample, loop }
        );
    }

    public static void StopAllClips()
    {
        var unityEditorAssembly = typeof(AudioImporter).Assembly;

        var audioUtilClass = unityEditorAssembly.GetType("UnityEditor.AudioUtil");
        var method = audioUtilClass.GetMethod(
            "StopAllPreviewClips",
            BindingFlags.Static | BindingFlags.Public,
            null,
            new Type[] { },
            null
        );

        method.Invoke(
            null,
            new object[] { }
        );
    }
}
#endif