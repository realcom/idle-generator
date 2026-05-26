namespace Commons.Game
{
    public static class BoardValidationProbe
    {
        public static uint Encode(uint tick, int hash)
        {
            return ((uint)GetTickPart(tick) << 16) | GetHashPart(hash);
        }

        public static ushort DecodeTickPart(uint payload)
        {
            return (ushort)(payload >> 16);
        }

        public static ushort DecodeHashPart(uint payload)
        {
            return (ushort)payload;
        }

        public static ushort GetTickPart(uint tick)
        {
            return (ushort)tick;
        }

        public static ushort GetHashPart(int hash)
        {
            return unchecked((ushort)hash);
        }
    }
}
