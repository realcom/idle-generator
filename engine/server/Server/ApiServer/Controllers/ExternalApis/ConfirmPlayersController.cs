using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json.Linq;
using Commons;
using Server.Models;

namespace ApiServer.Controllers.ExternalApis;

public class ConfirmPlayersController : ControllerBase
{
    [HttpGet]
    [Route("confirm_players")]
    public async Task<IActionResult> Get([FromQuery(Name = "user_ids")] string userIds)
    {
        var isAuthenticated = User?.Identity?.IsAuthenticated ?? false;
        if (!isAuthenticated)
        {
            var apiKey = Request.Headers["X-Confirm-Players-Key"].FirstOrDefault();
            if (!Config.VerifyConfirmPlayersApiKey(apiKey))
                return Unauthorized();
        }

        if (string.IsNullOrWhiteSpace(userIds))
            return BadRequest("user_ids is required.");

        var snsIds = userIds.Split(',').Take(100).Select(id => $"Telegram_{id}").ToArray();
        var accounts = (await AccountModel.GetAllBySnsIdsAsync(snsIds).ConfigureAwait(false)).ToDictionary(account => account.sns_id);
        var response = new JObject();
        foreach (var snsId in snsIds)
        {
            var telegramUserId = snsId.Split("_").Last();
            response[telegramUserId] = accounts.ContainsKey(snsId);
        }
        
        return Ok(response);
    }
}
