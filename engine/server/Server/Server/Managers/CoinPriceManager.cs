using System.Text.Json;

namespace Server.Managers;

public static class CoinPriceManager
{
    public static double? TonUsdtPrice { get; private set; }

    public static async Task Update()
    {
        var result = await UpdateTonUsdtPrice().ConfigureAwait(false);
        if (result != null)
            TonUsdtPrice = result;
    }

    private static async Task<double?> UpdateTonUsdtPrice()
    {
        var symbol = "TONUSDT";
        var url = $"https://api.binance.com/api/v3/avgPrice?symbol={symbol}";
        using (var client = new HttpClient())
        {
            try
            {
                var response = await client.GetAsync(url);
                response.EnsureSuccessStatusCode();

                var responseBody = await response.Content.ReadAsStringAsync();
                var jsonDoc = JsonDocument.Parse(responseBody);
                var root = jsonDoc.RootElement;

                var price = root.GetProperty("price");
                return double.Parse(price.GetString()!);
            }
            catch (HttpRequestException e)
            {
                return null;
            }
        }
    }
}