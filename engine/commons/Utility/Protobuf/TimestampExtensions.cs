using System;
using Google.Protobuf.WellKnownTypes;

namespace Commons.Utility.Protobuf
{
    public static class TimestampExtensions
    {
        public const long BclSecondsAtUnixEpoch = 62135596800;

        public static Timestamp Set(this Timestamp timestamp, DateTime dateTime)
        {
            timestamp.Seconds = dateTime.Ticks / TimeSpan.TicksPerSecond - BclSecondsAtUnixEpoch;
            timestamp.Nanos = (int)(dateTime.Ticks % TimeSpan.TicksPerSecond) * Duration.NanosecondsPerTick;
            return timestamp;
        }
        
        public static Timestamp Min(Timestamp lhs, Timestamp rhs)
        {
            if (lhs == null)
                return rhs;
            if (rhs == null)
                return lhs;
            
            if (lhs.Seconds == rhs.Seconds)
                return lhs.Nanos < rhs.Nanos ? lhs : rhs;
            
            return lhs.Seconds < rhs.Seconds ? lhs : rhs;
        }
        
        public static Timestamp Max(Timestamp lhs, Timestamp rhs)
        {
            if (lhs == null)
                return rhs;
            if (rhs == null)
                return lhs;
            
            if (lhs.Seconds == rhs.Seconds)
                return lhs.Nanos > rhs.Nanos ? lhs : rhs;
            
            return lhs.Seconds > rhs.Seconds ? lhs : rhs;
        }
        
    }
}
