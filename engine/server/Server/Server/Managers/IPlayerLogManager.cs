using Newtonsoft.Json.Linq;
using Server.Models;

namespace Server.Managers;

public interface IPlayerLogManager
{
    public void Queue(PlayerLogModel.Type type);
    public void Queue(PlayerLogModel.Type type, object data);
    public void Queue(PlayerLogModel.Type type, JObject data);
}
