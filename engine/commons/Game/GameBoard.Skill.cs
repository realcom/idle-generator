using System;
using System.Collections.Generic;
using System.Linq;
using Commons.Game.Events;
using Commons.Resources;
using Commons.Types.Geometry;

namespace Commons.Game
{
    public partial class GameBoard
    {
        private readonly List<GameSkill> _addSkills = new();

        private readonly Dictionary<int, SortedDictionary<long, GameSkill>> _skillsByDataId = new();
        private readonly Dictionary<long, SortedDictionary<long, GameSkill>> _skillsBySenderId = new();
        private readonly Dictionary<long, Dictionary<int, SortedDictionary<long, GameSkill>>> _skillsBySenderIdSkillDataId = new();
        private readonly List<GameSkill> _destroyedSkills = new();

        private void ClearSkills()
        {
            _skillsByDataId.Clear();
            _skillsBySenderId.Clear();
            _skillsBySenderIdSkillDataId.Clear();
        }

        private void InitSkills()
        {
            ClearSkills();

            foreach (var skill in skills_.Values)
            {
                skill.Init(this);
                if (!_skillsByDataId.TryGetValue(skill.DataId, out var skills))
                    _skillsByDataId[skill.DataId] = skills = new SortedDictionary<long, GameSkill>();
                skills[skill.Id] = skill;
                if (skill.SenderUnitId > 0L)
                {
                    if (!_skillsBySenderId.TryGetValue(skill.SenderUnitId, out var skillsById))
                        _skillsBySenderId[skill.SenderUnitId] = skillsById = new SortedDictionary<long, GameSkill>();
                    skillsById[skill.Id] = skill;
                    
                    if (!_skillsBySenderIdSkillDataId.TryGetValue(skill.SenderUnitId, out var skillsBySkillDataId))
                        _skillsBySenderIdSkillDataId[skill.SenderUnitId] = skillsBySkillDataId = new Dictionary<int, SortedDictionary<long, GameSkill>>();
                    if (!skillsBySkillDataId.TryGetValue(skill.DataId, out skillsById))
                        skillsBySkillDataId[skill.DataId] = skillsById = new SortedDictionary<long, GameSkill>();
                    skillsById[skill.Id] = skill;
                }
            }
        }

        internal void QueueAddSkill(GameSkill skill)
        {
            _addSkills.Add(skill);
        }

        private void HandleAddSkills()
        {
            if (_addSkills.Count == 0)
                return;

            foreach (var skill in _addSkills)
                AddSkill(skill);
            _addSkills.Clear();
        }

        private void AddSkill(GameSkill skill)
        {
            nextSkillId_++;
            skill.Id = nextSkillId_;
            skill.Init(this);

            skills_.Add(skill.Id, skill);
            if (!_skillsByDataId.TryGetValue(skill.DataId, out var skills))
                _skillsByDataId[skill.DataId] = skills = new SortedDictionary<long, GameSkill>();
            skills[skill.Id] = skill;
            if (skill.SenderUnitId > 0L)
            {
                if (!_skillsBySenderId.TryGetValue(skill.SenderUnitId, out var skillsById))
                    _skillsBySenderId[skill.SenderUnitId] = skillsById = new SortedDictionary<long, GameSkill>();
                skillsById[skill.Id] = skill;
                
                if (!_skillsBySenderIdSkillDataId.TryGetValue(skill.SenderUnitId, out var skillsBySkillDataId))
                    _skillsBySenderIdSkillDataId[skill.SenderUnitId] = skillsBySkillDataId = new Dictionary<int, SortedDictionary<long, GameSkill>>();
                if (!skillsBySkillDataId.TryGetValue(skill.DataId, out skillsById))
                    skillsBySkillDataId[skill.DataId] = skillsById = new SortedDictionary<long, GameSkill>();
                skillsById[skill.Id] = skill;
            }
            
            QueueEvent(new UseSkillEvent()
            {
                SenderUnitId = skill.SenderUnitId,
                SenderPlayerId = skill.Sender?.PlayerId ?? 0L,
                SkillId = skill.Id,
                SkillDataId = skill.DataId,
            });
        }
        
        internal void UseSkill(int skillDataId, FixedVector2? position = null, FixedVector2? direction = null,
            long targetUnitId = 0L, float timelineSpeed = 0f, int level = 1)
        {
            position ??= FixedVector2.zero;
            direction ??= FixedVector2.right;
            
            if (targetUnitId != 0L)
            {
                var target = GetUnitById(targetUnitId);
                if (target != null)
                    direction = (target.Position - position.Value).normalized;
            }
            
            var skill = new GameSkill
            {
                DataId = skillDataId,
                TimelineSpeed = timelineSpeed,
                SenderUnitId = id_,
                TargetUnitId = targetUnitId,
                Position = (Vector2Message)position,
                Direction = (Vector2Message)direction,
                Velocity = new Vector2Message(),
                Acceleration = new Vector2Message(),
                Level = level,
            };
            QueueAddSkill(skill);
        }
        
        internal void QueueDestroySkill(GameSkill skill)
        {
            _destroyedSkills.Add(skill);
        }

        private void RemoveDestroyedSkills()
        {
            if (_destroyedSkills.Count == 0)
                return;
            
            foreach (var skill in _destroyedSkills)
            {
                skills_.Remove(skill.Id);
                _skillsByDataId[skill.DataId].Remove(skill.Id);
                if (skill.SenderUnitId > 0L)
                {
                    _skillsBySenderIdSkillDataId[skill.SenderUnitId][skill.DataId].Remove(skill.Id);
                    _skillsBySenderId[skill.SenderUnitId].Remove(skill.Id);
                }
            }
            _destroyedSkills.Clear();
        }

        public GameSkill? GetSkillById(long id)
        {
            return skills_.GetValueOrDefault(id);
        }
        
        public GameSkill? GetSkillByDataId(int dataId)
        {
            return _skillsByDataId.GetValueOrDefault(dataId)?.Values.FirstOrDefault();
        }
        
        public IEnumerable<GameSkill> GetSkillsByDataId(int dataId)
        {
            return (IEnumerable<GameSkill>?)_skillsByDataId.GetValueOrDefault(dataId)?.Values ?? Enumerable.Empty<GameSkill>();
        }
        
        public bool HasSkillByDataId(int dataId)
        {
            return _skillsByDataId.TryGetValue(dataId, out var skills) && skills.Count > 0;
        }
        
        public IEnumerable<GameSkill> GetSkillsBySenderId(long senderId)
        {
            return (IEnumerable<GameSkill>?)_skillsBySenderId.GetValueOrDefault(senderId)?.Values ?? Enumerable.Empty<GameSkill>();
        }
        
        public bool HasSkillBySenderId(long senderId)
        {
            return _skillsBySenderId.TryGetValue(senderId, out var skills) && skills.Count > 0;
        }
        
        public bool HasSkillBySenderIdAndSkillDataId(long senderId, int skillDataId)
        {
            return _skillsBySenderIdSkillDataId.TryGetValue(senderId, out var skillsBySkillDataId) &&
                   skillsBySkillDataId.TryGetValue(skillDataId, out var skills) && skills.Count > 0;
        }
    }
}