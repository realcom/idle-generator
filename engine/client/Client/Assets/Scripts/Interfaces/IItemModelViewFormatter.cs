using Commons.Resources;
using JetBrains.Annotations;

namespace Interfaces
{
    public interface IItemModelViewFormatter
    {
        ResourceItem? GetData();
        public long Id { get; }
        long GetCount();
        int GetLevel();
        
        string FormatCount(string countReplaceText, int unitDigitLimit)
        {
            var count = GetCount();
            return ItemModelViewFormatterExtensions.DefaultFormatCount(count, countReplaceText, unitDigitLimit);
        }

        string FormatLevel()
        {
            return ItemModelViewFormatterExtensions.DefaultFormatLevel(GetLevel());
        }
    }

    public interface IItemModelViewBasedPopup
    {
        public IItemModelViewFormatter formatter { get; }
        public void Initialize(IItemModelViewFormatter itemModelViewFormatter);
        public void OnInitialized(IItemModelViewFormatter itemModelViewFormatter);
    }
    
    public interface IItemModelViewFormatter<out T> : IItemModelViewFormatter where T : IItemModelViewFormatter<T>
    {
        public T Clone();

    }
    
    public static class ItemModelViewFormatterExtensions
    {
        public static string DefaultFormatCount(long count, string countReplaceText = null, int unitDigitLimit = int.MaxValue)
        {
            if (count < 2 && countReplaceText != null)
                return countReplaceText;

            return count.ToUnitString(unitDigitLimit);
        }
        
        public static string DefaultFormatLevel(int level)
        {
            return $"Lv.{level.ToString()}";
        }
    }
}