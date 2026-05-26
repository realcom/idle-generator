

using Google.Protobuf.WellKnownTypes;

namespace Commons.Resources.Interfaces
{
    public partial interface ITimeValidityResource
    {
        public Timestamp? StartAt { get; }
        public Timestamp? UntilAt { get; }

        public bool IsValidNow(bool checkStartAt = true, bool checkUntilAt = true);
    }
}
