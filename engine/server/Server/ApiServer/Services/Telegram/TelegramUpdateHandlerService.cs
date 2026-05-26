using Commons;
using Newtonsoft.Json.Linq;
using Server.Models;
using Telegram.Bot;
using Telegram.Bot.Exceptions;
using Telegram.Bot.Types;
using Telegram.Bot.Types.Enums;
using Telegram.Bot.Types.InlineQueryResults;
using Telegram.Bot.Types.Payments;
using Telegram.Bot.Types.ReplyMarkups;

namespace ApiServer.Services.Telegram;

public class TelegramUpdateHandlerService
{
    private readonly ILogger<TelegramUpdateHandlerService> _logger;
    
    public readonly ITelegramBotClient BotClient;

    public TelegramUpdateHandlerService(ITelegramBotClient botClient, ILogger<TelegramUpdateHandlerService> logger)
    {
        BotClient = botClient;
        _logger = logger;
    }

    public async Task EchoAsync(Update update)
    {
        var handler = update.Type switch
        {
            // UpdateType.Unknown:
            // UpdateType.ChannelPost:
            // UpdateType.EditedChannelPost:
            // UpdateType.ShippingQuery:
            UpdateType.PreCheckoutQuery   => BotOnPreCheckoutQueryReceived(update.PreCheckoutQuery!),
            // UpdateType.Poll:
            UpdateType.Message            => BotOnMessageReceived(update.Message!),
            // UpdateType.EditedMessage      => BotOnMessageReceived(update.EditedMessage!),
            // UpdateType.CallbackQuery      => BotOnCallbackQueryReceived(update.CallbackQuery!),
            // UpdateType.InlineQuery        => BotOnInlineQueryReceived(update.InlineQuery!),
            // UpdateType.ChosenInlineResult => BotOnChosenInlineResultReceived(update.ChosenInlineResult!),
            _                             => UnknownUpdateHandlerAsync(update)
        };

        try
        {
            await handler;
        }
        #pragma warning disable CA1031
        catch (Exception exception)
        #pragma warning restore CA1031
        {
            await HandleErrorAsync(exception);
        }
    }
    
    private async Task BotOnPreCheckoutQueryReceived(PreCheckoutQuery preCheckoutQuery)
    {
        _logger.LogInformation("Receive pre-checkout query: {PreCheckoutQuery}", preCheckoutQuery.Id);

        var uuid = preCheckoutQuery.InvoicePayload;
        var receipt = await PlayerReceiptModel.GetByUuidAsync(new Guid(uuid)).ConfigureAwait(false);
        if (receipt == null)
        {
            _logger.LogInformation("The receipt is not found: {ReceiptUuid}", uuid);
            await BotClient.AnswerPreCheckoutQueryAsync(preCheckoutQuery.Id, "Invalid Invoice").ConfigureAwait(false);
            return;
        }
        if (DateTime.UtcNow > receipt.valid_until)
        {
            _logger.LogInformation("The receipt is expired: {ReceiptUuid}", uuid);
            await BotClient.AnswerPreCheckoutQueryAsync(preCheckoutQuery.Id, "Expired Invoice").ConfigureAwait(false);
            return;
        }
        
        await BotClient.AnswerPreCheckoutQueryAsync(preCheckoutQuery.Id).ConfigureAwait(false);
    }

    private async Task BotOnMessageReceived(Message message)
    {
        _logger.LogInformation("Receive message type: {MessageType}", message.Type);
        switch (message.Type)
        {
            case MessageType.Text:
                await BotOnTextMessageReceived(message);
                break;
            case MessageType.SuccessfulPayment:
                await BotOnSuccessfulPaymentMessageReceived(message);
                break;
            default:
                _logger.LogInformation("The message type is not supported: {MessageType}", message.Type);
                break;
        }
    }
    
    private async Task BotOnTextMessageReceived(Message message)
    {
        var telegramModel = (await PlayerTelegramModel.GetByTelegramUserIdAsync(message.From!.Id).ConfigureAwait(false))
            ?? new PlayerTelegramModel
            {
                telegram_user_id = message.From.Id,
                is_bot = message.From.IsBot,
            };
        telegramModel.username = message.From.Username;
        telegramModel.first_name = message.From.FirstName;
        telegramModel.last_name = message.From.LastName;
        telegramModel.is_premium = message.From.IsPremium ?? false;
        await telegramModel.SaveAsync().ConfigureAwait(false);

        await BotClient.SendChatActionAsync(message.Chat.Id, ChatAction.Typing);
        _logger.LogInformation("{Photo}", message.Photo?.FirstOrDefault()?.FileId);
        var action = message.Text!.Split(' ')[0] switch
        {
            // "/inline"   => SendInlineKeyboard(botClient, message),
            // "/keyboard" => SendReplyKeyboard(botClient, message),
            // "/remove"   => RemoveKeyboard(botClient, message),
            // "/photo"    => SendFile(botClient, message),
            // "/request"  => RequestContactAndLocation(botClient, message),
            // "/bots"     => SendInlineKeyboard(user, message),
            // "/position" => SetTradeBotPosition(user, message),
            // "/launch"   => LaunchStopBotPosition(user, message),
            // "/stop"     => LaunchStopBotPosition(user, message),
            "/start"            => HandleStartAsync(telegramModel, message),
            "/confirm_players"  => HandleConfirmPlayersAsync(telegramModel, message),
            _                   => null,
        };
        if (action != null)
        {
            var sentMessage = await action.ConfigureAwait(false);
            _logger.LogInformation("The message was sent with id: {SentMessageId}", sentMessage.MessageId);
        }
    }

    private async Task BotOnSuccessfulPaymentMessageReceived(Message message)
    {
        var uuid = message.SuccessfulPayment!.InvoicePayload;
        var receipt = await PlayerReceiptModel.GetByUuidAsync(new Guid(uuid)).ConfigureAwait(false);
        if (receipt == null)
        {
            _logger.LogInformation("The receipt is not found: {ReceiptUuid}", uuid);
            return;
        }
        if (DateTime.UtcNow - receipt.valid_until >
            TimeSpan.FromSeconds(PlayerReceiptModel.ReceiptValidityPaddingSeconds))
        {
            _logger.LogInformation("The receipt is expired: {ReceiptUuid}", uuid);
            return;
        }
        
        receipt.paid = true;
        await receipt.SaveAsync().ConfigureAwait(false);
        
        _logger.LogInformation("The receipt is paid: {ReceiptUuid}", uuid);
    }

    private Task UnknownUpdateHandlerAsync(Update update)
    {
        _logger.LogInformation("Unknown update type: {UpdateType}", update.Type);
        return Task.CompletedTask;
    }

    private Task HandleErrorAsync(Exception exception)
    {
        var ErrorMessage = exception switch
        {
            ApiRequestException apiRequestException => $"Telegram API Error:\n[{apiRequestException.ErrorCode}]\n{apiRequestException.Message}",
            _ => exception.ToString()
        };

        _logger.LogInformation("HandleError: {ErrorMessage}", ErrorMessage);
        return Task.CompletedTask;
    }

    private async Task<Message> HandleStartAsync(PlayerTelegramModel telegramModel, Message message)
    {
        var inlineKeyboard = new InlineKeyboardMarkup(new[]
        {
            new[]
            {
                InlineKeyboardButton.WithWebApp(Config.Telegram.HelloWebAppText!, new WebAppInfo
                {
                    Url = Config.Telegram.HelloWebAppUrl!,
                }),
            },
            new[]
            {
                InlineKeyboardButton.WithUrl(Config.Telegram.HelloAnnouncementText!, Config.Telegram.HelloAnnouncementUrl!), 
            },
            new[]
            {
                InlineKeyboardButton.WithUrl(Config.Telegram.HelloCommunityText!, Config.Telegram.HelloCommunityUrl!), 
            },
        });
        return await BotClient.SendPhotoAsync(message.Chat.Id,
            photo: new InputFileUrl(Config.Telegram.HelloImage!),
            caption: Config.Telegram.HelloText!,
            replyMarkup: inlineKeyboard,
            parseMode: ParseMode.Html).ConfigureAwait(false);
    }
    
    private async Task<Message> HandleConfirmPlayersAsync(PlayerTelegramModel telegramModel, Message message)
    {
        if (!telegramModel.is_analyst)
            return await BotClient.SendTextMessageAsync(message.Chat.Id, "Access denied").ConfigureAwait(false);
        var snsIds = message.Text!.Split(' ').Skip(1).Take(100).Select(id => $"Telegram_{id}").ToArray();
        var accounts = (await AccountModel.GetAllBySnsIdsAsync(snsIds).ConfigureAwait(false)).ToDictionary(account => account.sns_id);
        var result = new JObject();
        foreach (var snsId in snsIds)
        {
            var telegramUserId = snsId.Split("_").Last();
            if (accounts.TryGetValue(snsId, out var player))
                result[telegramUserId] = player.created_at;
            else
                result[telegramUserId] = false;
        }
        return await BotClient.SendTextMessageAsync(message.Chat.Id, result.ToString()).ConfigureAwait(false);
    }
}
