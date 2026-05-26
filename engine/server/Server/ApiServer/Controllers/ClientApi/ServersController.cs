using Microsoft.AspNetCore.Mvc;
using Server.Models;
using System.Linq;
using System.Threading.Tasks;
using Newtonsoft.Json;
using System.Collections.Generic;
using Microsoft.Extensions.Caching.Memory;
using System;
using Commons;

namespace ApiServer.Controllers.ClientApi
{
    [ApiController]
    [Route("api/client/servers")]
    public class ServersController : ControllerBase
    {
        private readonly IMemoryCache _cache;

        public ServersController(IMemoryCache cache)
        {
            _cache = cache;
        }

        [HttpGet("bootstrap")]
        public async Task<IActionResult> Bootstrap([FromQuery] int clientVersion)
        {
            // Get Server Address
            string hostsKey = "HostsPerClientVersion";
            var hostsConfig = await GetConfigValueAsync(hostsKey);
            var serverAddress = GetAddressForVersion(clientVersion, hostsConfig);

            // Get Patchset Host
            string patchsetKey = "PatchsetHostsPerClientVersion";
            var patchsetConfig = await GetConfigValueAsync(patchsetKey);
            var patchsetHost = GetAddressForVersion(clientVersion, patchsetConfig);

            if (serverAddress == null && patchsetHost == null)
            {
                return NotFound("No suitable configuration found for the given version.");
            }

            return Ok(new { Host = serverAddress, PatchsetHost = patchsetHost });
        }

        private async Task<string> GetConfigValueAsync(string key)
        {
            return Config.GetString(key);
        }

        private string GetAddressForVersion(int clientVersion, string jsonConfig)
        {
            if (string.IsNullOrEmpty(jsonConfig))
            {
                return null;
            }

            try
            {
                var versionMap = JsonConvert.DeserializeObject<Dictionary<string, string>>(jsonConfig);
                string clientVersionStr = clientVersion.ToString();

                if (versionMap != null && versionMap.TryGetValue(clientVersionStr, out var address))
                {
                    return address;
                }

                return null;
            }
            catch (JsonException)
            {
                // In a real-world scenario, you would log this exception.
                return null;
            }
        }
    }
}

