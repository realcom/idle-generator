using System.Data;
using Dapper;
using Server.Managers;

namespace Server.Models;

public abstract class Model<T> where T : Model<T>
{
    [Key]
    public long id { get; set; }
    
    [ReadOnly(true)]
    public DateTime updated_at { get; private set; }
    [ReadOnly(true)]
    public DateTime created_at { get; private set; }

    public virtual T OnConstructionByDb()
    {
        return (T)this;
    }
    
    public virtual T BeforeSave()
    {
        return (T)this;
    }
    
    public virtual T OnSave()
    {
        return (T)this;
    }
    
    private T Insert()
    {
        BeforeSave();
        id = DbManager.WithSession(db => db.Insert<long, T>((T)this));
        updated_at = created_at = DateTime.UtcNow;
        return OnSave();
    }
    
    private async Task<T> InsertAsync()
    {
        BeforeSave();
        id = await DbManager.WithSessionAsync(db => db.InsertAsync<long, T>((T)this)).ConfigureAwait(false);
        updated_at = created_at = DateTime.UtcNow;
        return OnSave();
    }
    
    private async Task<T> InsertAsync(IDbConnection db, IDbTransaction transaction)
    {
        BeforeSave();
        id = await db.InsertAsync<long, T>((T)this, transaction).ConfigureAwait(false);
        updated_at = created_at = DateTime.UtcNow;
        return OnSave();
    }
    
    public static T? Get(long id)
    {
        return DbManager.WithSession(db => db.Get<T?>(id))?.OnConstructionByDb();
    }
    
    public static async Task<T?> GetAsync(long id)
    {
        return (await DbManager.WithSessionAsync(db => db.GetAsync<T>(id)).ConfigureAwait(false))?.OnConstructionByDb();
    }
    
    public static IEnumerable<T> GetAll()
    {
        return DbManager.WithSession(db => db.GetList<T>()).Select(item => item.OnConstructionByDb());
    }
    
    public static async Task<IEnumerable<T>> GetAllAsync()
    {
        return (await DbManager.WithSessionAsync(db => db.GetListAsync<T>()).ConfigureAwait(false))
            .Select(item => item.OnConstructionByDb());
    }
    
    public static async Task<IEnumerable<T>> GetAllByIdsAsync(IList<long> ids)
    {
        return (await DbManager.WithSessionAsync(db =>
                db.GetListAsync<T>(
                    "WHERE id = ANY(@ids)",
                    new { ids })).ConfigureAwait(false))
            .Select(item => item.OnConstructionByDb());
    }
    
    public virtual T Save()
    {
        if (id == 0L)
            return Insert();
        BeforeSave();
        DbManager.WithSession(db => db.Update((T)this));
        updated_at = DateTime.UtcNow;
        return OnSave();
    }
    
    public virtual async Task<T> SaveAsync()
    {
        if (id == 0L)
            return await InsertAsync().ConfigureAwait(false);
        BeforeSave();
        await DbManager.WithSessionAsync(db => db.UpdateAsync((T)this)).ConfigureAwait(false);
        updated_at = DateTime.UtcNow;
        return OnSave();
    }
    
    public virtual async Task<T> SaveAsync(IDbConnection db, IDbTransaction transaction)
    {
        if (id == 0L)
            return await InsertAsync(db, transaction).ConfigureAwait(false);
        BeforeSave();
        await db.UpdateAsync((T)this, transaction).ConfigureAwait(false);
        updated_at = DateTime.UtcNow;
        return OnSave();
    }
}
