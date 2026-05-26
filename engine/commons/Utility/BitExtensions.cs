using System;

namespace Commons.Utility
{
    public static class BitExtensions
    {
        public static int CountBits(this int value)
        {
            return ((ulong)value).CountBits();
        }
        
        public static int CountBits(this ulong value)
        {
            var count = 0;
            while (value != 0)
            {
                count++;
                value &= value - 1;
            }

            return count;
        }
        
        public static bool IsBitSet(this int value, int bitIndex)
        {
            return ((ulong)value).IsBitSet(bitIndex);
        }
        
        public static bool IsBitSet(this ulong value, int bitIndex)
        {
            return (value & (ulong)(1 << bitIndex)) != 0;
        }
        
        public static int MarkBit(this int value, int bitIndex)
        {
            return value | (1 << bitIndex);
        }
        
        public static ulong MarkBit(this ulong value, int bitIndex)
        {
            return value | (uint)(1 << bitIndex);
        }
        
        public static int ClearBit(this int value, int bitIndex)
        {
            return value & ~(1 << bitIndex);
        }
        
        public static  ulong ClearBit(this ulong value, int bitIndex)
        {
            return value & (ulong)~(1 << bitIndex);
        }
        
    }   
}