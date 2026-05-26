using System;
using JetBrains.Annotations;

namespace ReferenceFinder.Editor
{
    public class ElapseTimer
    {
        private DateTime startsAt;

        public void Start()
        {
            startsAt = DateTime.Now;
        }

        [Pure]
        public TimeSpan GetElapsed()
        {
            return DateTime.Now - startsAt;
        }
    }
}
