using System;
using System.Security.Cryptography;
using System.Threading;

namespace Commons.Utility
{
    public static class StaticRandom
    {
        private static readonly ThreadLocal<Random> Random = new(() => new Random());
        private static readonly ThreadLocal<RandomNumberGenerator> CryptoRandom = new(RandomNumberGenerator.Create);

        public static int Next()
        {
            var r = Random.Value!.Next();
            return r;
        }

        public static int Next(int maxValue)
        {
            var r = Random.Value!.Next(maxValue);
            return r;
        }
        
        public static int Next(int minValue, int maxValueInclusive)
        {
            if (minValue >= maxValueInclusive)
                return minValue;
            var r = Random.Value!.Next(minValue, maxValueInclusive + 1);
            return r;
        }
        
        public static long Next(long maxValue)
        {
            var r = (long)(Random.Value!.NextDouble() * maxValue);
            return r;
        }
        
        public static long Next(long minValue, long maxValueInclusive)
        {
            if (minValue >= maxValueInclusive)
                return minValue;
            var range = maxValueInclusive - minValue + 1;
            var r = (long)(Random.Value!.NextDouble() * range) + minValue;
            return r;
        }

        public static int CryptoNext(int maxValue)
        {
            var bytes = new byte[4];
            CryptoRandom.Value!.GetBytes(bytes);
            // Known issue: This is NOT a uniform distribution (especially for large maxValue)
            var r = (int)(BitConverter.ToUInt32(bytes, 0) % (uint)maxValue);
            return r;
        }
        
        public static int CryptoNext(int minValue, int maxValueInclusive)
        {
            if (minValue >= maxValueInclusive)
                return minValue;
            return minValue + CryptoNext(maxValueInclusive - minValue + 1);
        }
        
        public static long CryptoNext(long maxValue)
        {
            var bytes = new byte[8];
            CryptoRandom.Value!.GetBytes(bytes);
            // Known issue: This is NOT a uniform distribution (especially for large maxValue)
            var r = (long)(BitConverter.ToUInt64(bytes, 0) % (ulong)maxValue);
            return r;
        }
        
        public static long CryptoNext(long minValue, long maxValueInclusive)
        {
            if (minValue >= maxValueInclusive)
                return minValue;
            return minValue + CryptoNext(maxValueInclusive - minValue + 1);
        }

        public static float NextFloat()
        {
            var r = (float)Random.Value!.NextDouble();
            return r;
        }
        
        public static double NextDouble()
        {
            var r = Random.Value!.NextDouble();
            return r;
        }

        public static float CryptoNextFloat()
        {
            var bytes = new byte[4];
            CryptoRandom.Value!.GetBytes(bytes);
            var ul = BitConverter.ToInt32(bytes, 0);
            var result = BitConverter.Int32BitsToSingle(ul & 0x007FFFFF | 0x3F800000) - 1;
            return result;
        }

        public static double CryptoNextDouble()
        {
            var bytes = new byte[8];
            CryptoRandom.Value!.GetBytes(bytes);
            var ul = BitConverter.ToInt64(bytes, 0);
            var result = BitConverter.Int64BitsToDouble(ul & 0x000FFFFFFFFFFFFFL | 0x3FF0000000000000L) - 1;
            return result;
        }
    }
}