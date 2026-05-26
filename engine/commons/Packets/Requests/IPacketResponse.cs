
namespace Commons.Packets.Requests
{
    public interface IPacketResponse
    {
        public StatusCode Status { get; set; }
        public string Message { get; set; }
    }    
}
