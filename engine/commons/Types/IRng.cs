namespace Commons.Types
{
    public interface IRng
    {
        public int Random();

        public int Random(int maxValueExclusive);
        
        public long Random(long maxValueExclusive);

        public FixedFloat RandomFloat();
    }
}
