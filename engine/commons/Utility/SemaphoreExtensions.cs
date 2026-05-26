using System;
using System.Runtime;
using System.Threading;
using System.Threading.Tasks;

namespace Commons.Utility
{
    public static class SemaphoreExtensions
    {
        public static async Task<bool> WaitAsyncWithTimeoutException(this SemaphoreSlim semaphore, TimeSpan timeout)
        {
            if (!await semaphore.WaitAsync(timeout).ConfigureAwait(false))
                throw new TimeoutException("Semaphore Timeout");
            return true;
        }
    }
}
