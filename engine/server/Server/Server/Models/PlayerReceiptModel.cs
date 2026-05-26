using System.Data;
using Dapper;
using Server.Managers;

namespace Server.Models;

[Table("player_receipts")]
public class PlayerReceiptModel : Model<PlayerReceiptModel>
{
    public const double ReceiptValiditySeconds = 5 * 60;
    public const double ReceiptValidityPaddingSeconds = 60;
    
    [IgnoreUpdate]
    public Guid uuid { get; set; }
    
    [IgnoreUpdate]
    public long player_id { get; set; }
    [IgnoreUpdate]
    public int product_item_data_id { get; set; }
    
    [IgnoreUpdate]
    public DateTime valid_until { get; set; }
    
    public bool paid { get; set; }
    public bool applied { get; set; }
    public bool restored { get; set; }
    public DateTime restored_at { get; set; }
    public string data { get; set; }
    public string order_id { get; set; }
    public string purchase_token { get; set; }
    
    [IgnoreUpdate]
    public float price { get; set; }
    [IgnoreUpdate]
    public string currency { get; set; }
    
    [IgnoreUpdate]
    public string? telegram_invoice_link { get; set; }
    
    public static async Task<PlayerReceiptModel?> GetByUuidAsync(Guid uuid)
    {
        return await DbManager.WithSessionAsync(db =>
            db.QueryFirstOrDefaultAsync<PlayerReceiptModel>(
                "SELECT * FROM player_receipts WHERE uuid = @uuid",
                new { uuid })).ConfigureAwait(false);
    }
    
    public static async Task<PlayerReceiptModel?> GetByOrderIdAsync(string order_id)
    {
        return await DbManager.WithSessionAsync(db =>
            db.QueryFirstOrDefaultAsync<PlayerReceiptModel>(
                "SELECT * FROM player_receipts WHERE order_id = @order_id",
                new { order_id })).ConfigureAwait(false);
    }
    
    public static async Task<PlayerReceiptModel?> GetOnProgressAsync(long playerId, int productItemDataId)
    {
        return await DbManager.WithSessionAsync(db =>
            db.QueryFirstOrDefaultAsync<PlayerReceiptModel>(
                "SELECT * FROM player_receipts WHERE player_id = @playerId AND product_item_data_id = @productItemDataId AND NOW() < valid_until AND paid = FALSE ORDER BY created_at DESC LIMIT 1",
                new { playerId, productItemDataId })).ConfigureAwait(false);
    }
    
    public static async Task<IEnumerable<PlayerReceiptModel>> GetAllPaidUnappliedByPlayerIdAsync(long playerId)
    {
        return await DbManager.WithSessionAsync(db =>
            db.QueryAsync<PlayerReceiptModel>(
                "SELECT * FROM player_receipts WHERE player_id = @playerId AND paid = TRUE AND applied = FALSE",
                new { playerId })).ConfigureAwait(false);
    }
    
    public static async Task ApplyByIdsAsync(IDbConnection db, IDbTransaction transaction, IEnumerable<long> ids)
    {
        await db.ExecuteAsync(
            "UPDATE player_receipts SET applied = TRUE WHERE id = ANY(@ids)",
            new { ids }, transaction).ConfigureAwait(false);
    }
}
