using System;
using System.Collections.Generic;
using System.Linq;
using Commons.Game.Interfaces;

namespace Commons.Game
{
    public partial class GameUnit
    {
        /// <summary>
        /// 소유자 유닛 참조 (캐시용)
        /// </summary>
        public GameUnit? Owner
        {
            get => HasOwner ? Board.GetUnitById(ownerUnitId_) : null;
            internal set => ownerUnitId_ = value?.Id ?? 0L;
        }

        /// <summary>
        /// 소유자가 있는지 확인
        /// </summary>
        public bool HasOwner => ownerUnitId_ != 0;

        /// <summary>
        /// 소유자 설정
        /// </summary>
        /// <param name="owner">소유자 유닛 (null이면 소유관계 해제)</param>
        public void SetOwner(GameUnit? owner)
        {
            if (owner == null)
                Owner?._childrenUnitIds.Remove(id_);
            Owner = owner;
            owner?._childrenUnitIds.Add(id_);
        }
        
        private readonly HashSet<long> _childrenUnitIds = new();

        public IEnumerable<GameUnit> Children
        {
            get
            {
                foreach (var unitId in _childrenUnitIds)
                {
                    var unit = Board.GetUnitById(unitId);
                    if (unit == null)
                        continue;
                    
                    yield return unit;
                }
            }
        }
    }
} 