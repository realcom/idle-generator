namespace Commons.Packets.Requests
{
    public static class StatusCodeExtensions
    {
        public static bool IsSuccess(this StatusCode status)
        {
            return status >= 0;
        }
    }
}
