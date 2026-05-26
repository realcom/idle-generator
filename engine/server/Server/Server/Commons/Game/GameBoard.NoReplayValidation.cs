using System.Collections.Generic;

namespace Commons.Game;

public partial class GameBoard
{
    private const uint NoReplayValidationRetentionTicks = TicksPerSecond * 60 * 5;

    private readonly Queue<uint> _noReplayValidationTicks = new();
    private readonly Dictionary<ushort, NoReplayValidationSnapshot> _noReplayValidationSnapshotsByTickPart = new();

    public uint NoReplayValidationSampleCount { get; private set; }
    public uint NoReplayValidationMismatchCount { get; private set; }

    public readonly struct NoReplayValidationResult(
        bool hasServerSnapshot,
        bool matched,
        uint sampleCount,
        uint mismatchCount,
        uint serverTick,
        ushort clientTickPart,
        ushort serverHashPart,
        ushort clientHashPart)
    {
        public bool HasServerSnapshot { get; } = hasServerSnapshot;
        public bool Matched { get; } = matched;
        public uint SampleCount { get; } = sampleCount;
        public uint MismatchCount { get; } = mismatchCount;
        public uint ServerTick { get; } = serverTick;
        public ushort ClientTickPart { get; } = clientTickPart;
        public ushort ServerHashPart { get; } = serverHashPart;
        public ushort ClientHashPart { get; } = clientHashPart;
    }

    private readonly struct NoReplayValidationSnapshot(uint tick, ushort hashPart)
    {
        public uint Tick { get; } = tick;
        public ushort HashPart { get; } = hashPart;
    }

    internal void RecordNoReplayValidationHash()
    {
        if (!ResMap.UsesBoardNoReplaySync())
            return;

        var tick = Tick;
        var tickPart = BoardValidationProbe.GetTickPart(tick);
        _noReplayValidationSnapshotsByTickPart[tickPart] =
            new NoReplayValidationSnapshot(tick, BoardValidationProbe.GetHashPart(GetHashCode()));
        _noReplayValidationTicks.Enqueue(tick);

        while (_noReplayValidationTicks.Count > 0 &&
               tick - _noReplayValidationTicks.Peek() > NoReplayValidationRetentionTicks)
        {
            var expiredTick = _noReplayValidationTicks.Dequeue();
            var expiredTickPart = BoardValidationProbe.GetTickPart(expiredTick);
            if (_noReplayValidationSnapshotsByTickPart.TryGetValue(expiredTickPart, out var snapshot) &&
                snapshot.Tick == expiredTick)
            {
                _noReplayValidationSnapshotsByTickPart.Remove(expiredTickPart);
            }
        }
    }

    public NoReplayValidationResult ValidateNoReplayProbe(uint payload)
    {
        NoReplayValidationSampleCount += 1;

        var clientTickPart = BoardValidationProbe.DecodeTickPart(payload);
        var clientHashPart = BoardValidationProbe.DecodeHashPart(payload);
        if (!_noReplayValidationSnapshotsByTickPart.TryGetValue(clientTickPart, out var snapshot))
        {
            return new NoReplayValidationResult(
                hasServerSnapshot: false,
                matched: false,
                sampleCount: NoReplayValidationSampleCount,
                mismatchCount: NoReplayValidationMismatchCount,
                serverTick: 0,
                clientTickPart: clientTickPart,
                serverHashPart: 0,
                clientHashPart: clientHashPart);
        }

        var matched = snapshot.HashPart == clientHashPart;
        if (!matched)
            NoReplayValidationMismatchCount += 1;

        return new NoReplayValidationResult(
            hasServerSnapshot: true,
            matched: matched,
            sampleCount: NoReplayValidationSampleCount,
            mismatchCount: NoReplayValidationMismatchCount,
            serverTick: snapshot.Tick,
            clientTickPart: clientTickPart,
            serverHashPart: snapshot.HashPart,
            clientHashPart: clientHashPart);
    }
}
