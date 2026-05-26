
using System;
using System.Collections.Generic;

namespace Commons.Types.Units
{
    public class ClientUnitStat : UnitStat
    {
        private static List<int> _gameplayStatIndices;
        public void ClearGameplayStats()
        {
            if (_gameplayStatIndices == null)
            {
                _gameplayStatIndices = new();
                
                var names = Enum.GetNames(typeof(UnitStatType));
                for (var i = 0; i < names.Length; i++)
                {
                    var name = names[i];
                    if (name.StartsWith("Gameplay"))
                    {
                        _gameplayStatIndices.Add(i);
                    }
                }
            }
            
            foreach (var index in _gameplayStatIndices)
            {
                this[index] = FixedFloat.Zero;
            }
        }
    }
}