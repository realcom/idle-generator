using Commons;
using Commons.Resources;
using Server.Models;
using Telegram.Bot;
using Telegram.Bot.Types;
using Telegram.Bot.Types.Enums;

namespace ApiServer.Services.Telegram;

public class TelegramPushService : IHostedService
{
    public const double TickSeconds = 1.0;
    
    private readonly ILogger<TelegramPushService> _logger;
    
    public readonly ITelegramBotClient BotClient;
    
    private bool _stopped;

    public TelegramPushService(ITelegramBotClient botClient, ILogger<TelegramPushService> logger)
    {
        BotClient = botClient;
        _logger = logger;
    }
    
    public async Task StartAsync(CancellationToken cancellationToken)
    {
        Run();
    }

    public async Task StopAsync(CancellationToken cancellationToken)
    {
        _stopped = true;
    }
    
    private async void Run()
    {
        while (!_stopped)
        {
            var updateAt = DateTime.UtcNow;
            try
            {
                await Update().ConfigureAwait(false);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, $"{nameof(TelegramPushService)}.Update");
            }

            await Task.Delay(Math.Max(10,
                    (int)(updateAt + TimeSpan.FromSeconds(TickSeconds) - DateTime.UtcNow).TotalMilliseconds))
                .ConfigureAwait(false);
        }
    }
    
    private async Task Update()
    {
        await SendPushMessages().ConfigureAwait(false);
    }

    private async Task SendPushMessages()
    {
        var pushes = (await PlayerPushModel.GetAllUnpublishedAsync().ConfigureAwait(false)).ToArray();
        var accountModels =
            (await AccountModel.GetAllByMainPlayerIdsAsync(pushes.Select(p => p.player_id).ToArray())).Where(p => p.sns_type == AccountModel.SnsType.Telegram).ToDictionary(p => p.id);
        var playerTelegrams =
            (await PlayerTelegramModel.GetAllByTelegramUserIdsAsync(
                accountModels.Values.Select(p => long.Parse(p.sns_key)))).ToDictionary(t => t.telegram_user_id);
        foreach (var push in pushes)
        {
            try
            {
                var accountModel = accountModels.GetValueOrDefault(push.player_id);
                if (accountModel == null)
                    continue;
                var playerTelegram = playerTelegrams.GetValueOrDefault(long.Parse(accountModel.sns_key));
                if (playerTelegram == null)
                    continue;
                Enum.TryParse(push.language, true, out ResourceString.Types.Language language);
                var message = ResourceString.Get(push.message, language);
                if (string.IsNullOrEmpty(push.image_url))
                    await BotClient.SendTextMessageAsync(playerTelegram.telegram_user_id, message, parseMode: ParseMode.Html).ConfigureAwait(false);
                else
                    await BotClient.SendPhotoAsync(playerTelegram.telegram_user_id,
                        photo: new InputFileUrl(push.image_url),
                        caption: message,
                        parseMode: ParseMode.Html).ConfigureAwait(false);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, $"{nameof(TelegramPushService)}.SendPushMessages");
            }
        }
        
        await PlayerPushModel.SetPublishedByIdsAsync(pushes.Select(p => p.id).ToArray()).ConfigureAwait(false);
    }
}
