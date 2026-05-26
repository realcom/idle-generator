using System.Text;
using ApiServer.Services.Telegram;
using ApiServer.Services.Ton;
using Commons;
using Commons.Resources;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.IdentityModel.Tokens;
using Server;
using Server.Managers;
using Telegram.Bot;

Logger.Init(typeof(Program));

await Config.Reload(false).ConfigureAwait(false);
ResourceManager.ReloadJson(Config.Path.Resources);
DbManager.Init();
await Config.ReloadConfigModels();
var builder = WebApplication.CreateBuilder(args);

builder.Services.AddControllers().AddNewtonsoftJson();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();
builder.Services.AddMemoryCache();

// builder.Services.AddHttpClient("TelegramWebhook")
//     .AddTypedClient<ITelegramBotClient>(httpClient => new TelegramBotClient(Config.Telegram.BotToken!, httpClient));
// builder.Services.AddScoped<TelegramUpdateHandlerService>();
//
// builder.Services.AddHostedService<TelegramPushService>();
// builder.Services.AddHostedService<TonTransactionService>();
builder.Services.AddHostedService<ApiServer.Services.PeriodicTaskService>();

// JWT-based Authentication
builder.Services.AddAuthentication(options =>
{
    options.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
    options.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
})
.AddJwtBearer(options =>
{
    if (string.IsNullOrWhiteSpace(Config.Admin.jwtSecret))
        Config.LogError("Admin JWT secret is not configured; using an ephemeral in-memory signing key.");

    var key = Encoding.UTF8.GetBytes(Config.GetJwtSecret());
    options.TokenValidationParameters = new TokenValidationParameters
    {
        ValidateIssuer = false,
        ValidateAudience = false,
        ValidateIssuerSigningKey = true,
        IssuerSigningKey = new SymmetricSecurityKey(key),
        ValidateLifetime = true,
        ClockSkew = TimeSpan.Zero
    };
});

var app = builder.Build();

if (app.Environment.IsDevelopment())
{
    app.UseDeveloperExceptionPage();
    app.UseSwagger();
    app.UseSwaggerUI();
}
app.UseRouting();

app.UseAuthentication();
app.UseAuthorization();

// app.MapControllerRoute("TelegramWebhook",
//     $"telegram/{Config.Telegram.ApiToken}",
//     new { controller = "TelegramWebhook", action = "Post" });
app.MapControllerRoute("AdminApi",
    $"admin", new { controller = "Admin", action = "Get" });
app.MapControllers();

app.Run();
