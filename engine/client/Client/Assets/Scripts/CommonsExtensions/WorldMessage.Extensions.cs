
using System;

namespace Commons.Types
{
    public partial class WorldMessage
    {
        public DateTime GetNextDayResetTime()
        {
            return DateTime.UtcNow.Date.AddDays(1).AddHours(utcOffsetHours_);
        }
    }
}