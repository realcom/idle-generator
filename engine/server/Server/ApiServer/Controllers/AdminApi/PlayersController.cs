// PlayersController.cs
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization;
using Server.Models;

namespace ApiServer.Controllers.AdminApi
{
    [Authorize]
    [ApiController]
    [Route("admin/players")]
    public class PlayersController : ControllerBase
    {
        [HttpGet]
        public async Task<IActionResult> GetAllPlayers()
        {
            var players = await PlayerModel.GetAllAsync();
            return Ok(players);
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> GetPlayer(int id)
        {
            var player = await PlayerModel.GetAsync(id);
            if (player == null)
                return NotFound();
            return Ok(player);
        }

        [HttpPost]
        public async Task<IActionResult> CreatePlayer([FromBody] PlayerModel player)
        {
            await player.SaveAsync();
            return CreatedAtAction(nameof(GetPlayer), new { id = player.id }, player);
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> UpdatePlayer(int id, [FromBody] PlayerModel player)
        {
            if (id != player.id)
                return BadRequest();
            await player.SaveAsync();
            return NoContent();
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> DeletePlayer(int id)
        {
            // not implemented
            return NoContent();
        }
    }
}