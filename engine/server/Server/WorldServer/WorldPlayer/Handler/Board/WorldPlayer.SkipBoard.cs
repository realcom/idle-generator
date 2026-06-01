using Commons;
using Commons.Game;
using Commons.Packets;
using Commons.Packets.Requests;
using Commons.Resources;
using Server.Models;

// ReSharper disable once CheckNamespace
namespace WorldServer.WorldPlayer;

public partial class WorldPlayer
{
    private partial Task<bool> HandlePacket(long requestId, SkipBoardRequest request)
    {
        var board = Board;
        if (board != null)
        {
            if (board.ResMap.UsesBoardNoReplaySync())
            {
                board.QueueServerPostAction(() =>
                {
                    var validation = board.ValidateNoReplayProbe(request.Tick);
                    if (!validation.HasServerSnapshot)
                    {
                        if (Config.IsDebug)
                        {
                            Logger.Info(
                                $"{this} {board.ToDebugString()} no-replay validation skipped tickPart={validation.ClientTickPart} sampleCount={validation.SampleCount}");
                        }
                        return;
                    }

                    if (validation.Matched)
                        return;

                    PlayerLogManager.Queue(PlayerLogModel.Type.BoardNoReplayValidationMismatch, new
                    {
                        BoardId = board.Id,
                        BoardMapDataId = board.ResMap.Id,
                        BoardTick = board.Tick,
                        SampleTick = validation.ServerTick,
                        ClientTickPart = validation.ClientTickPart,
                        ServerHashPart = validation.ServerHashPart,
                        ClientHashPart = validation.ClientHashPart,
                        ValidationSampleCount = validation.SampleCount,
                        ValidationMismatchCount = validation.MismatchCount,
                    });

                    Logger.Warn(
                        $"{this} {board.ToDebugString()} no-replay validation mismatch sampleTick={validation.ServerTick} clientTickPart={validation.ClientTickPart} serverHashPart={validation.ServerHashPart} clientHashPart={validation.ClientHashPart} mismatches={validation.MismatchCount}/{validation.SampleCount}");
                });

                return Task.FromResult(true);
            }

            if (board.CreatedAt != null)
            {
                board.GameSpeedMultiplier = GameSpeedMultiplier;
                if (board.IsTickInFuture(request.Tick, DateTime.UtcNow))
                    throw new InvalidOperationException(
                        $"{board.ToDebugString()} SkipBoardRequest.Tick {request.Tick} is in the future ({GameBoard.TicksToTime(request.Tick)} s, speed={board.GetEffectiveGameSpeedMultiplier()})");
            }
            board.LastUnhandledTick = request.Tick;
        }
        
        return Task.FromResult(true);
    }
}
