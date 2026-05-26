using ApiServer.Services.Telegram;
using Microsoft.AspNetCore.Mvc;
using Telegram.Bot.Types;

namespace ApiServer.Controllers.Telegram;

public class TelegramWebhookController : ControllerBase
{
    [HttpPost]
    public async Task<IActionResult> Post([FromServices] TelegramUpdateHandlerService telegramUpdateHandlerService,
        [FromBody] Update update)
    {
        await telegramUpdateHandlerService.EchoAsync(update);
        return StatusCode(200);
    }
}
