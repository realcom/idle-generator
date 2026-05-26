// using System;
// using System.Collections;
// using System.Collections.Generic;
// using System.Linq;
// using Unity.Burst;
// using Unity.Collections;
// using Unity.Jobs;
// using Unity.Jobs.LowLevel.Unsafe;
// using UnityEngine;
//
// public class UnitUpdateSystem : BaseSystem<UnitUpdateSystem>
// {
//     [RuntimeInitializeOnLoadMethod]
//     public static void Initialize()
//     {
//         ZPlayerLoopSystemHelper.InsertSystemAfter(typeof(UnitUpdateSystem), AfterFixedUpdate, typeof(UnityEngine.PlayerLoop.FixedUpdate.ScriptRunBehaviourFixedUpdate));
//     }
//
//     private static void AfterFixedUpdate()
//     {
//         var units = GameContainer.Get()?.units ?? Enumerable.Empty<MovableUnit>();
//         if (!units.Any())
//             return;
//
//         var count = units.Count();
//         
//         NativeArray<Vector3> positions = new(count, Allocator.TempJob);
//         NativeArray<RaycastHit> results = new(count, Allocator.TempJob);
//         NativeArray<RaycastCommand> commands = new(count, Allocator.TempJob);
//
//         var idx = 0;
//         foreach (var unit in units)
//         {
//             positions[idx] = unit.transform.position;
//             idx++;
//         }
//         
//         UnitGroundCastJob job = new() {
//             positions = positions,
//             commands = commands,
//             layerMask = Layer.GetMask(Layer.Ground) 
//         };
//         
//         var handle = job.ScheduleParallel(commands.Length, 32, default);
//         handle = RaycastCommand.ScheduleBatch(commands, results, Math.Max(count / JobsUtility.JobWorkerCount, 1), 1, handle);
//         
//         handle.Complete();
//
//         var resultIdx = 0;
//         foreach (var unit in units)
//         {
//             var result = results[resultIdx];
//             if (result.collider != null)
//             {
//                 var transform = unit.transform;
//                 var pos = transform.position;
//                 pos.y = result.point.y;
//                 transform.position = pos;
//             }
//             resultIdx++;
//         }
//
//         positions.Dispose();
//         results.Dispose();
//         commands.Dispose();
//     }
//     
//     [BurstCompile]
//     private struct UnitGroundCastJob : IJobFor
//     {
//         [ReadOnly]
//         public NativeArray<Vector3> positions;
//         
//         [NativeDisableParallelForRestriction]
//         public NativeArray<RaycastCommand> commands;
//         
//         public int layerMask;
//         
//         public void Execute(int index)
//         {
//             var pos = positions[index];
//             commands[index] = new(pos + Vector3.up * 10f, Vector3.down, new QueryParameters(layerMask), Mathf.Infinity);
//         }
//     }
//     
// }
