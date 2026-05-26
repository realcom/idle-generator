using System.Text;
using Commons;
using Commons.Resources;
using Commons.Utility;
using Newtonsoft.Json.Linq;
using Server.Models;

namespace ApiServer.Services.Ton;

public class TonTransactionService : IHostedService
{
    public const double TickSeconds = 5.0;
    public const int TransactionHardLimit = 200;
    public const double MaxError = 1e-3; // Allowable error for floating point comparison
    
    private readonly ILogger<TonTransactionService> _logger;

    private bool _stopped;

    public TonTransactionService(ILogger<TonTransactionService> logger)
    {
        _logger = logger;
    }
    
    public async Task StartAsync(CancellationToken cancellationToken)
    {
        Run();
    }

    public async Task StopAsync(CancellationToken cancellationToken)
    {
        _stopped = true;
    }
    
    private async void Run()
    {
        while (!_stopped)
        {
            var updateAt = DateTime.UtcNow;
            try
            {
                await Update().ConfigureAwait(false);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, $"{nameof(TonTransactionService)}.Update");
            }

            await Task.Delay(Math.Max(10,
                    (int)(updateAt + TimeSpan.FromSeconds(TickSeconds) - DateTime.UtcNow).TotalMilliseconds))
                .ConfigureAwait(false);
        }
    }
    
    private async Task Update()
    {
        await CheckNewTransactions().ConfigureAwait(false);
    }

    private async Task CheckNewTransactions(int limit = 100)
    {
        var apiUrl = Config.Ton.Endpoint;
        var walletAddress = Config.Ton.TonAddress;
        var requestUrlTemplate = $"{apiUrl}/getTransactions?address={walletAddress}&limit={limit}";
        string? lt = null;
        var foundPaidTransaction = false;
        var transactionCount = 0;

        using (var client = new HttpClient())
        {
            // TODO: lt is not working as expected
            while (!foundPaidTransaction)
            {
                var requestUrl = lt == null
                    ? requestUrlTemplate
                    : $"{requestUrlTemplate}&lt={lt}";

                try
                {
                    var response = await client.GetAsync(requestUrl).ConfigureAwait(false);
                    response.EnsureSuccessStatusCode();
                    var responseBody = await response.Content.ReadAsStringAsync().ConfigureAwait(false);
                    var jsonResponse = JObject.Parse(responseBody);
                    var isSuccess = jsonResponse["ok"]?.Value<bool>() ?? false;

                    if (isSuccess)
                    {
                        var transactions = (JArray)jsonResponse["result"];
                        if (transactions == null || transactions.Count == 0)
                        {
                            // No more transactions to process
                            break;
                        }

                        foreach (var transaction in transactions)
                        {
                            var utime = transaction["utime"]?.ToString();
                            // Wait at least 30 seconds before processing the transaction
                            var utimeInt = long.Parse(utime);
                            if (string.IsNullOrEmpty(utime) || DateTime.UtcNow.ToUnixTime() - utimeInt < 30)
                            {
                                // Skip the transaction
                                continue;
                            }

                            var inMsg = transaction["in_msg"];
                            if (inMsg == null)
                            {
                                // No in_msg in the transaction
                                continue;
                            }
                            var amountStr = inMsg["value"]?.ToString();
                            if (!long.TryParse(amountStr, out long transactionValue))
                            {
                                // Invalid transaction value
                                continue;
                            }

                            var payloadBase64 = inMsg["message"]?.ToString();
                            if (string.IsNullOrEmpty(payloadBase64))
                            {
                                // No payload in the transaction
                                continue;
                            }

                            try
                            {
                                var decodedPayloadBytes = Convert.FromBase64String(payloadBase64.TrimEnd('\n'));
                                var decodedPayload = Encoding.UTF8.GetString(decodedPayloadBytes);

                                if (Guid.TryParse(decodedPayload, out Guid uuid))
                                {
                                    var receipt = await PlayerReceiptModel.GetByUuidAsync(uuid);

                                    if (receipt != null)
                                    {
                                        if (receipt.paid)
                                        {
                                            // transaction already processed
                                            // But some transactions may be handled late
                                            // foundPaidTransaction = true;
                                            // break;
                                        }
                                        else
                                        {
                                            if (transactionValue >= receipt.price * (1 - MaxError))
                                            {
                                                receipt.paid = true;
                                                await receipt.SaveAsync().ConfigureAwait(false);
                                            }
                                            else
                                                _logger.LogError($"Undervalued transaction: {uuid}");
                                        }
                                    }
                                    else
                                    {
                                        // No receipt found for the transaction
                                    }
                                }
                                else
                                {
                                    // Invalid payload
                                }
                            }
                            catch (FormatException fe)
                            {
                                _logger.LogError(fe, "Failed to decode Base64 payload.");
                            }
                            catch (Exception ex)
                            {
                                _logger.LogError(ex, "Failed to process transaction.");
                            }

                            transactionCount++;
                            if (transactionCount >= TransactionHardLimit)
                            {
                                _logger.LogError("Transaction hard limit reached.");
                                foundPaidTransaction = true;
                                break;
                            }
                        }

                        var lastTransaction = transactions.LastOrDefault();
                        if (lastTransaction != null)
                            lt = lastTransaction["transaction_id"]?["lt"]?.ToString();

                        // No more transactions to process
                        if (transactions.Count < limit || lastTransaction == null)
                            break;
                    }
                    else
                    {
                        _logger.LogError("Failed to fetch transactions.");
                        break;
                    }
                }
                catch (HttpRequestException e)
                {
                    _logger.LogError(e, $"TON API Request error: {requestUrl}");
                    break;
                }
                catch (Exception ex)
                {
                    _logger.LogError(ex, "TON API Error");
                    break;
                }
                // API rate limit
                await Task.Delay(100).ConfigureAwait(false);
                // TODO: now force exit loop, because lt is not working as expected.
                // Remove this line when lt is fixed.
                foundPaidTransaction = true;
            }
        }
    }


}
