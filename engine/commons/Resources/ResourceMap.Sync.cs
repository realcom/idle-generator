using System;
using System.Globalization;

namespace Commons.Resources
{
    public partial class ResourceMap
    {
        public enum BoardSyncMode
        {
            Replay = 0,
            NoReplay = 1,
        }

        public const string BoardSyncModePopupArg = "BoardSyncMode";
        public const string BoardValidationSamplingRatePopupArg = "BoardValidationSamplingRate";
        public const string BoardValidationSamplingIntervalSecondsPopupArg = "BoardValidationSamplingIntervalSeconds";

        private const float DefaultBoardValidationSamplingRate = 0.35f;
        private const float DefaultBoardValidationSamplingIntervalSeconds = 5f;

        public BoardSyncMode GetBoardSyncMode()
        {
            if (TryGetPopupArg(BoardSyncModePopupArg, out var popupSyncMode))
            {
                switch (popupSyncMode.Trim().ToLowerInvariant())
                {
                    case "replay":
                    case "server-recovery":
                    case "server_recovery":
                        return BoardSyncMode.Replay;
                    case "noreplay":
                    case "no-replay":
                    case "no_replay":
                    case "single":
                    case "singleplayer":
                    case "single-player":
                        return BoardSyncMode.NoReplay;
                }
            }

            return Type switch
            {
                Types.Type.Dungeon => BoardSyncMode.NoReplay,
                Types.Type.RespawnDungeon => BoardSyncMode.NoReplay,
                Types.Type.ScenarioDungeon => BoardSyncMode.NoReplay,
                Types.Type.BackpackDungeon => BoardSyncMode.NoReplay,
                _ => BoardSyncMode.Replay
            };
        }

        public bool UsesBoardReplaySync()
        {
            return GetBoardSyncMode() == BoardSyncMode.Replay;
        }

        public bool UsesBoardNoReplaySync()
        {
            return GetBoardSyncMode() == BoardSyncMode.NoReplay;
        }

        public float GetBoardValidationSamplingRate()
        {
            if (!UsesBoardNoReplaySync())
                return 0f;

            if (!TryGetPopupArgFloat(BoardValidationSamplingRatePopupArg, out var value))
                return DefaultBoardValidationSamplingRate;

            if (value > 1f)
                value /= 100f;

            return Math.Max(0f, Math.Min(1f, value));
        }

        public float GetBoardValidationSamplingIntervalSeconds()
        {
            if (!UsesBoardNoReplaySync())
                return DefaultBoardValidationSamplingIntervalSeconds;

            if (!TryGetPopupArgFloat(BoardValidationSamplingIntervalSecondsPopupArg, out var value))
                return DefaultBoardValidationSamplingIntervalSeconds;

            return Math.Max(1f, value);
        }

        private bool TryGetPopupArg(string key, out string value)
        {
            if (PopupArgs.TryGetValue(key, out value) && !string.IsNullOrWhiteSpace(value))
                return true;

            value = string.Empty;
            return false;
        }

        private bool TryGetPopupArgFloat(string key, out float value)
        {
            value = default;
            return TryGetPopupArg(key, out var rawValue) &&
                   float.TryParse(rawValue, NumberStyles.Float, CultureInfo.InvariantCulture, out value);
        }
    }
}
