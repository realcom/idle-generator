using System;
using System.Threading;
using System.Threading.Tasks;
using Commons;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;

namespace ApiServer.Services
{
    public class PeriodicTaskService : BackgroundService
    {
        private readonly ILogger<PeriodicTaskService> _logger;

        public PeriodicTaskService(ILogger<PeriodicTaskService> logger)
        {
            _logger = logger;
        }

        protected override async Task ExecuteAsync(CancellationToken stoppingToken)
        {
            _logger.LogInformation("Periodic Task Service is starting.");

            while (!stoppingToken.IsCancellationRequested)
            {

                await Config.Reload().ConfigureAwait(false);
                await Task.Delay(TimeSpan.FromSeconds(5), stoppingToken);
            }

            _logger.LogInformation("Periodic Task Service is stopping.");
        }
    }
}
