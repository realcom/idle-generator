using System.Linq;
using Commons.Types.Geometry;
using Commons.Utility;
#if UNITY_5_3_OR_NEWER
using UnityEngine;
#endif

namespace Commons.Game
{
    public partial class GameSkill
    {
        private void UpdateHit()
        {
            if (Destroyed)
                return;
            if (_hits.Count == 0)
                return;
            
            var position = (FixedVector2)position_;
            var rotation = ((FixedVector2)direction_).GetAngle();
            var skillMaxHit = ResSkill.MaxHit == 0 ? int.MaxValue : ResSkill.MaxHit;
            var scale = Scale;
            
            foreach (var hit in _hits)
            {
                var hitCnt = 0;
                var maxHit = hit.MaxHit == 0 ? int.MaxValue : hit.MaxHit;
                var geometries = hit.IGeometries.Select(g =>
                    scale == 0f ? g.Transform(position, rotation) : g.Transform(position, rotation, scale)).ToArray();
                var boundingBox = BoundingBox.Merge(geometries.Select(g => g.GetBoundingBox()));
                using var envelopes = Board.GetUnitsInBound(boundingBox);
                foreach (var envelope in envelopes)
                {
                    var unit = envelope.Unit;
                    if (unit.Destroyed || !unit.IsAlive)
                        continue;
                    var hitCountByUnit = 0;
                    if (ResSkill.MaxHitByUnit > 0
                        && hitCountByUnitIds_.TryGetValue(unit.Id, out hitCountByUnit) && hitCountByUnit >= ResSkill.MaxHitByUnit)
                        continue;
                    if (hit.HitAlly == IsEnemyWith(unit))
                        continue;
                    if (hit.IgnoreSender && unit.Id == senderUnitId_)
                        continue;
                    if (targetUnitId_ != 0 && targetUnitId_ != unit.Id)
                        continue;
                    
                    var isHit = geometries.Any(geometry => geometry.Intersects(unit.HitGeometry));
                    if (!isHit)
                        continue;

                    var hitValid = false;
                    if (hit.AddDamage != null)
                    {
                        var damageResult = unit.AddDamage(this, hit.AddDamage);
                        if (damageResult.IsValid)
                            hitValid = true;
                    }
                    
                    if (hit.AddHeal != null)
                    {
                        var healResult = unit.AddHeal(this, hit.AddHeal);
                        if (healResult.IsValid)
                            hitValid = true;
                    }

                    if (hitValid)
                    {
                        var attacker = Board.GetUnitById(senderUnitId_);
                        foreach (var addBuff in hit.AddBuffs)
                            unit.QueueAddBuff(new GameUnit.QueuedAddBuff(attacker, addBuff, level_)
                            {
                                Duration = timelineSpeed_ * addBuff.Duration,
                            });
                        foreach (var addBuff in ResSkill.HitAddBuffs)
                            unit.QueueAddBuff(new GameUnit.QueuedAddBuff(attacker, addBuff, level_)
                            {
                                Duration = timelineSpeed_ * addBuff.Duration,
                            });
                        if (ResSkill.HitSelfAddHeal != null)
                            attacker?.AddHeal(this, ResSkill.HitSelfAddHeal);
                    }

                    if (hit.UseSkill != null)
                    {
                        var attacker = Board.GetUnitById(senderUnitId_);
                        attacker?.UseSkill(hit.UseSkill, hit.UseSkill.AtTarget ? unit.Position : position_, direction_, itemId: itemId_, itemDataId: itemDataId_, timelineSpeed: timelineSpeed_, ignoreActable: true);
                    }

                    if (hit.SenderAddHeal != null)
                    {
                        var attacker = Board.GetUnitById(senderUnitId_);
                        attacker?.AddHeal(this, hit.SenderAddHeal);
                    }
                    
                    if (++hit_ >= skillMaxHit)
                    {
                        Destroy();
                        break;
                    }

                    if (ResSkill.MaxHitByUnit > 0)
                        hitCountByUnitIds_[unit.Id] = hitCountByUnit + 1;
                    if (++hitCnt >= maxHit)
                        break;
                }

                if (Destroyed)
                    break;
            }
        }
    }
}