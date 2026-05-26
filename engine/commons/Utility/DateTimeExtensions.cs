using System;

namespace Commons.Utility
{
    public static class DateTimeExtensions
    {
        public static readonly DateTime UnixEpoch = new(1970, 1, 1, 0, 0, 0, DateTimeKind.Utc);
        public static readonly DateTime OffsetEpoch = new(2020, 1, 1, 0, 0, 0, DateTimeKind.Utc);
        
        public static DateTime FromUnixTime(long unixTime)
        {
            return UnixEpoch.AddSeconds(unixTime);
        }
        
        public static long ToUnixTime(this DateTime dateTime)
        {
            return (long)dateTime.Subtract(UnixEpoch).TotalSeconds;
        }
        
        public static DateTime FromOffsetTime(int offsetTime)
        {
            return OffsetEpoch.AddSeconds(offsetTime);
        }
        
        public static int ToOffsetTime(this DateTime dateTime)
        {
            return (int)dateTime.Subtract(OffsetEpoch).TotalSeconds;
        }
        
        public static DateTime StartOfWeek(this DateTime dateTime, DayOfWeek startOfWeek = DayOfWeek.Monday)
        {
            var diff = dateTime.DayOfWeek - startOfWeek;
            if (diff < 0)
                diff += 7;
            return dateTime.AddDays(-diff).Date;
        }

        public static DateTime Max(DateTime a, DateTime b)
        {
            return a > b ? a : b;
        }
    }
}
