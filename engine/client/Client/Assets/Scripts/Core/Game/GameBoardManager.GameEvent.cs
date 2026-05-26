using Commons.Packets;
using Commons.Packets.Requests;
using Cysharp.Threading.Tasks;

public partial class GameBoardManager
{
   public override async UniTask HandleEvent(GameEvent e)
   {
      await base.HandleEvent(e);
      
      switch (e.type)
      {
         case GameEventType.GAMEBOARD_UPDATED:
         {
            SyncBoard(MyPlayer.GameBoard);
            break;
         }
         case GameEventType.GAMEBOARD_HASH_UPDATED:
         {
            if (gameBoard?.ResMap?.UsesBoardNoReplaySync() == true)
               break;

            if (!CheckBoardResponse(MyPlayer.GameBoardResponse))
            {
               // GameManager.Get().ShowLoading();
               ZWorldClient.Get().ClearSendPackets();
               ClearQueuedPackets();
               BlockBoardPacketSending(true);
               var getBoardPacket = Packet.Pop(0, new GetBoardRequest());
               ZWorldClient.Get().SendPacket(getBoardPacket).Forget();
            }
            break;
         }
         case GameEventType.SOCKET_DISCONNECTED:
         {
            if (IsLocalMushroomerBoard())
               break;

            PauseBoard();
            break;
         }
         case GameEventType.SOCKET_CONNECTED:
         {
            ResumeBoard();
            break;
         }
      }
   }
   
   public override void HandleRequestPacket(Packet p)
   {
      switch (p.Request.RequestCase)
      {
         default:
            break;
      }
   }
    
   public override void HandleUpdatePacket(Packet p)
   {
      switch (p.Update.UpdateCase)
      {
         default:
            break;
      }
   }
}

public abstract class WrappedEventBehaviour : EventBehaviour
{
   public override async UniTask HandleEvent(GameEvent e)
   {
      switch (e.type)
      {
         case GameEventType.SOCKET_GOT_PACKET:
         {
            var p = e.args[0] as Packet;
            HandlePacket(p);
            break;
         }
      }
   }
   
   public virtual void HandlePacket(Packet p)
   {
      switch (p.PacketType)
      {
         case Packet.Type.Request:
         {
            HandleRequestPacket(p);
            break;
         }
         case Packet.Type.Update:
         {
            HandleUpdatePacket(p);
            break;
         }
      }
   }

   public abstract void HandleRequestPacket(Packet p);

   public abstract void HandleUpdatePacket(Packet p);

}
