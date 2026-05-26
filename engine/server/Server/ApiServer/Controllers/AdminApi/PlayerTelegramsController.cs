using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization;
using Server.Models;

namespace ApiServer.Controllers.AdminApi
{
    [Authorize]
    [ApiController]
    [Route("admin/playertelegrams")]
    public class PlayerTelegramsController : ControllerBase
    {
        // GET: admin/playertelegrams
        [HttpGet]
        public async Task<IActionResult> GetAllPlayerTelegrams()
        {
            var playerTelegrams = await PlayerTelegramModel.GetAllAsync();
            return Ok(playerTelegrams);
        }

        // GET: admin/playertelegrams/{id}
        [HttpGet("{id}")]
        public async Task<IActionResult> GetPlayerTelegram(long id)
        {
            var playerTelegram = await PlayerTelegramModel.GetByTelegramUserIdAsync(id);
            if (playerTelegram == null)
                return NotFound();
            return Ok(playerTelegram);
        }

        // POST: admin/playertelegrams
        [HttpPost]
        public async Task<IActionResult> CreatePlayerTelegram([FromBody] PlayerTelegramModel playerTelegram)
        {
            await playerTelegram.SaveAsync();
            return CreatedAtAction(nameof(GetPlayerTelegram), new { id = playerTelegram.telegram_user_id }, playerTelegram);
        }

        // PUT: admin/playertelegrams/{id}
        [HttpPut("{id}")]
        public async Task<IActionResult> UpdatePlayerTelegram(long id, [FromBody] PlayerTelegramModel playerTelegram)
        {
            if (id != playerTelegram.telegram_user_id)
                return BadRequest();
            await playerTelegram.SaveAsync();
            return NoContent();
        }

        // DELETE: admin/playertelegrams/{id}
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeletePlayerTelegram(long id)
        {
            // not implemented
            return NoContent();
        }
    }
}