// AdminController.cs
using Microsoft.AspNetCore.Authorization;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using Microsoft.IdentityModel.Tokens;
using System.Text;
using Commons;
using Microsoft.AspNetCore.Mvc;

namespace ApiServer.Controllers.AdminApi
{
    [ApiController]
    [Route("admin")]
    public class AdminController : ControllerBase
    {
        [AllowAnonymous]
        [HttpPost("login")]
        public IActionResult Login([FromBody] LoginRequest request)
        {
            if (!Config.HasAdminCredentialsConfigured())
                return StatusCode(StatusCodes.Status503ServiceUnavailable, new { message = "Admin login is not configured" });

            if (string.IsNullOrWhiteSpace(request?.Id) || string.IsNullOrWhiteSpace(request.Password))
                return BadRequest(new { message = "Missing credentials" });

            if (String.Equals(request.Id, Config.Admin.defaultId, StringComparison.Ordinal) &&
                Config.VerifyAdminPassword(request.Password))
            {
                var key = Encoding.UTF8.GetBytes(Config.GetJwtSecret());
                var tokenHandler = new JwtSecurityTokenHandler();
                var tokenDescriptor = new SecurityTokenDescriptor
                {
                    Subject = new ClaimsIdentity(new[] { new Claim(ClaimTypes.Name, request.Id) }),
                    Expires = DateTime.UtcNow.AddHours(12),
                    SigningCredentials = new SigningCredentials(new SymmetricSecurityKey(key), SecurityAlgorithms.HmacSha256Signature)
                };
                var token = tokenHandler.CreateToken(tokenDescriptor);
                var tokenString = tokenHandler.WriteToken(token);

                return Ok(new { token = tokenString });
            }

            return Unauthorized(new { message = "Invalid credentials" });
        }

        public class LoginRequest
        {
            public string Id { get; set; }
            public string Password { get; set; }
        }

        [Authorize]
        [HttpGet]
        public IActionResult Get()
        {
            return Ok(new { message = "adminapi get" });
        }

        [Authorize]
        [HttpPost]
        public IActionResult Post([FromBody] AdminRequest request)
        {
            return Ok(new { message = $"adminapi action {request.Action}" });
        }
    }

    public class AdminRequest
    {
        public string Action { get; set; }
    }
}
