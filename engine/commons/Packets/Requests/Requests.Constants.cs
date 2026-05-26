

namespace Commons.Packets.Requests
{
    public partial class UseCashItemRequest
    {
        public static class PetParams
        {
            public static class Param2
            {
                public const int LockOption = 1;
                public const int UnLockOption = 2;
                public const int RerollOption = 3; // temp
            }
        }
    }

    public partial class Request
    {
        public IPacketResponse Response => request_ as IPacketResponse;
    }
    
    public class EmptyResponse : IPacketResponse
    {
        public StatusCode Status { get; set; }
        public string Message { get; set; }
    }

}