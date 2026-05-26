using System.Diagnostics;
using FirebaseAdmin;
using FirebaseAdmin.Messaging;
using Google.Apis.Auth.OAuth2;
using Commons;
using Commons.Resources;
using log4net;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using Server.Models;
using Telegram.Bot;
using Telegram.Bot.Types.Enums;
using Telegram.Bot.Exceptions;
using Telegram.Bot.Types;
using Message = FirebaseAdmin.Messaging.Message;

namespace Server.Services;

public class PushService
{
    public const double TickSeconds = 1.0;
    public const int MaxRetries = 3;
    public const int BatchLimit = 200;

    private static readonly ILog Logger = LogManager.GetLogger("", System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);
    private readonly ITelegramBotClient _botClient;

    private CancellationTokenSource? _cts;
    private Task? _loopTask;

    // 전송 결과를 성공/재시도/즉시실패로 구분
    private enum DeliveryResult { Success, Retry, Fail }

    public PushService()
    {
        _botClient = new TelegramBotClient(Config.Telegram.BotToken!);
    }

    public async Task StartAsync(CancellationToken cancellationToken)
    {
        // Firebase는 먼저 초기화
        await InitializeFirebase(cancellationToken).ConfigureAwait(false);

        _cts = CancellationTokenSource.CreateLinkedTokenSource(cancellationToken);
        _loopTask = RunAsync(_cts.Token);
    }

    public async Task StopAsync(CancellationToken cancellationToken)
    {
        if (_cts != null)
        {
            await _cts.CancelAsync();
            if (_loopTask != null)
            {
                try { await _loopTask.ConfigureAwait(false); }
                catch (OperationCanceledException) { /* expected */ }
            }
        }
    }

    private async Task RunAsync(CancellationToken ct)
    {
        using var timer = new PeriodicTimer(TimeSpan.FromSeconds(TickSeconds));
        while (await timer.WaitForNextTickAsync(ct).ConfigureAwait(false))
        {
            try
            {
                await Update(ct).ConfigureAwait(false);
            }
            catch (OperationCanceledException) { throw; }
            catch (Exception ex)
            {
                Logger.Error($"Error: {ex.Message}");
            }
        }
    }

    private Task Update(CancellationToken ct) => SendPushMessages(ct);

    private async Task SendPushMessages(CancellationToken ct)
    {
        var pushes = (await PlayerPushModel.GetAllUnpublishedAsync(BatchLimit).ConfigureAwait(false))
            .ToArray();

        if (pushes.Length == 0)
            return;

        var mainPlayerIds = pushes.Select(p => p.player_id).Distinct().ToArray();
        var accounts = await AccountModel.GetAllByMainPlayerIdsAsync(mainPlayerIds).ConfigureAwait(false);
        
        var accountModels = accounts
            .Where(p => p.sns_type == AccountModel.SnsType.Telegram || !string.IsNullOrEmpty(p.push_token))
            .ToDictionary(p => p.main_player_id);

        var telegramUserIds = accountModels.Values
            .Where(p => p.sns_type == AccountModel.SnsType.Telegram && long.TryParse(p.sns_key, out _))
            .Select(p => long.Parse(p.sns_key))
            .Distinct()
            .ToArray();

        var playerTelegrams = (await PlayerTelegramModel
                .GetAllByTelegramUserIdsAsync(telegramUserIds)
                .ConfigureAwait(false))
            .ToDictionary(t => t.telegram_user_id);

        var successIds = new List<long>();
        var retryIds   = new List<long>();
        var failIds    = new List<long>();

        foreach (var push in pushes)
        {
            DeliveryResult result = DeliveryResult.Retry; // 기본값(일시실패 가정)

            try
            {
                ct.ThrowIfCancellationRequested();
                accountModels.TryGetValue(push.player_id, out var accountModel);
                if (accountModel == null)
                {
                    result = DeliveryResult.Fail;
                }
                else
                {

                    Enum.TryParse(
                        string.IsNullOrEmpty(push.language) ? accountModel.language : push.language,
                        true,
                        out ResourceString.Types.Language language);

                    var pushBody = ResourceString.Get(push.message, language);
                    var pushTitle = string.IsNullOrEmpty(push.title)
                        ? ResourceString.Get("AppName", language)
                        : ResourceString.Get(push.title, language);

                    if (accountModel.sns_type == AccountModel.SnsType.Telegram)
                    {
                        result = await TrySendTelegramAsync(push.player_id, accountModel, playerTelegrams, pushBody,
                                push.image_url, push.id, ct)
                            .ConfigureAwait(false);
                    }
                    else
                    {
                        result = await TrySendFcmAsync(push.player_id, accountModel.push_token, accountModel.device_os,
                                pushTitle, pushBody, push.id, ct)
                            .ConfigureAwait(false);
                    }
                }
            }
            catch (OperationCanceledException) { throw; }
            catch (Exception ex)
            {
                Logger.Error($"Push send error (player_id={push.player_id}, push_id={ push.id})", ex);
                result = DeliveryResult.Retry;
            }

            switch (result)
            {
                case DeliveryResult.Success:
                    successIds.Add(push.id);
                    break;

                case DeliveryResult.Fail:
                    failIds.Add(push.id); // 즉시 실패
                    break;

                case DeliveryResult.Retry:
                    if ((push.retry_count + 1) >= MaxRetries)
                        failIds.Add(push.id);
                    else
                        retryIds.Add(push.id);
                    break;
            }
        }

        // === DB 반영 ===
        if (successIds.Count > 0)
            await PlayerPushModel.SetPublishedByIdsAsync(successIds.ToArray()).ConfigureAwait(false);

        if (retryIds.Count > 0)
            await PlayerPushModel.IncrementRetryByIdsAsync(retryIds.ToArray()).ConfigureAwait(false);

        if (failIds.Count > 0)
            await PlayerPushModel.SetFailedByIdsAsync(failIds.ToArray(), true).ConfigureAwait(false);
    }

    private async Task<DeliveryResult> TrySendTelegramAsync(
        long playerId,
        AccountModel accountModel,
        Dictionary<long, PlayerTelegramModel> playerTelegrams,
        string body, string? imageUrl, long pushId, CancellationToken ct)
    {
        if (!long.TryParse(accountModel?.sns_key, out var tgUserId))
        {
            Logger.Warn($"Invalid Telegram sns_key={accountModel?.sns_key} for player_id={playerId}");
            return DeliveryResult.Fail; // 영구 실패(잘못된 키)
        }

        if (!playerTelegrams.TryGetValue(tgUserId, out var playerTelegram))
        {
            Logger.Warn("Telegram mapping not found for user {tgUserId} (player_id={playerId})");
            return DeliveryResult.Fail; // 영구 실패(매핑 없음)
        }

        try
        {
            if (string.IsNullOrEmpty(imageUrl))
            {
                await _botClient.SendTextMessageAsync(
                    playerTelegram.telegram_user_id,
                    body,
                    parseMode: ParseMode.Html,
                    cancellationToken: ct
                ).ConfigureAwait(false);
            }
            else
            {
                await _botClient.SendPhotoAsync(
                    playerTelegram.telegram_user_id,
                    photo: new InputFileUrl(imageUrl),
                    caption: body,
                    parseMode: ParseMode.Html,
                    cancellationToken: ct
                ).ConfigureAwait(false);
            }
            return DeliveryResult.Success;
        }
        catch (ApiRequestException tgEx) when (tgEx.ErrorCode == 403) // 봇 차단
        {
            Logger.Warn($"Telegram blocked (push_id={pushId}) → mark as failed immediately", tgEx);
            return DeliveryResult.Fail; // 영구 실패
        }
        catch (Exception ex)
        {
            Logger.Error($"Telegram send error (push_id={pushId})", ex);
            return DeliveryResult.Retry; // 일시 실패 → 재시도
        }
    }

    private async Task<DeliveryResult> TrySendFcmAsync(long playerId, string? token, string deviceOs, string title, string body, long pushId, CancellationToken ct)
    {
        if (string.IsNullOrEmpty(token))
        {
            Logger.Warn($"Empty push_token (playerId={playerId})");
            return DeliveryResult.Fail; // 영구 실패
        }

        var message = new Message
        {
            Token = token,
            Data =  new Dictionary<string, string> {
                ["push_id"] = pushId.ToString(),   // 고유 ID(서버 push.id)
                ["title"]   = title,
                ["body"]    = body
            },
            // Notification = new Notification { Title = title, Body = body }
        };
        if (deviceOs == "android")
        {
            //추후 세팅으로 변경하도록
            message.Android = new AndroidConfig
            {
                Priority = Priority.High,
                Notification = new AndroidNotification
                {
                    Title = title,
                    Body = body,
                    Icon = "default_small",
                    ImageUrl = "https://storage.googleapis.com/backpackhamster/appicon_default",
                    ChannelId = "default", // 앱에서 생성한 채널 ID와 동일
                    Color = "#5A3B14"           // 선택: 아이콘 틴트 색
                }
            };
        }
        Logger.Debug(message.ToString());
        try
        {
            var response = await FirebaseMessaging.DefaultInstance.SendAsync(message, ct).ConfigureAwait(false);
            Logger.Info($"Successfully sent push message: {response}");
            return DeliveryResult.Success;
        }
        catch (Exception ex)
        {
            Logger.Error($"FCM push send error (player_id={playerId} push_id={pushId}, token={token})", ex);
            return DeliveryResult.Retry; // 일시 실패
        }
    }

    private async Task InitializeFirebase(CancellationToken ct)
    {
        try
        {
            FirebaseApp? app = null;
            try { app = FirebaseApp.DefaultInstance; } catch { /* not initialized */ }

            if (app == null)
            {
                var credential = await GoogleCredential
                    .FromFileAsync(Config.Path.GoogleServiceAccountForPushCredential, ct)
                    .ConfigureAwait(false);

                FirebaseApp.Create(new AppOptions { Credential = credential });
                Logger.Info("FirebaseApp initialized successfully.");
            }
        }
        catch (Exception ex)
        {
            Logger.Error("FirebaseApp initialization failed.", ex);
            throw; // 초기화 실패 시 서비스 시작 중단
        }
    }
}