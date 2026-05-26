using System.Data;
using Commons;
using Dapper;
using log4net;
using Npgsql;

namespace Server.Managers;

public static class DbManager
{
    private static readonly ILog Logger = LogManager.GetLogger("", System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);
    
    public static void Init()
    {
        SimpleCRUD.SetDialect(SimpleCRUD.Dialect.PostgreSQL);
        NpgsqlConnection.GlobalTypeMapper.UseJsonNet();

        WithSession(db => db.Query<int>("SELECT 1").First());

        Logger.Info("DBManager Initialized");
    }
    
    public static void WithSession(Action<IDbConnection> work)
    {
        try
        {
            using var db = new NpgsqlConnection(Config.Db.ConnectionString);
            db.Open();
            work(db);
        }
        catch (Exception ex)
        {
            Logger.Error("DbManager Exception", ex);
            throw;
        }
    }
    
    public static T WithSession<T>(Func<IDbConnection, T> work)
    {
        try
        {
            using var db = new NpgsqlConnection(Config.Db.ConnectionString);
            db.Open();
            return work(db);
        }
        catch (Exception ex)
        {
            Logger.Error("DbManager Exception", ex);
            throw;
        }
    }
    
    public static void WithTransaction(Action<IDbConnection, IDbTransaction> work)
    {
        try
        {
            using var db = new NpgsqlConnection(Config.Db.ConnectionString);
            db.Open();
            using var transaction = db.BeginTransaction();
            work(db, transaction);
            transaction.Commit();
        }
        catch (Exception ex)
        {
            Logger.Error("DbManager Exception", ex);
            throw;
        }
    }
    
    public static async Task WithSessionAsync(Func<IDbConnection, Task> work)
    {
        try
        {
            await using var db = new NpgsqlConnection(Config.Db.ConnectionString);
            await db.OpenAsync().ConfigureAwait(false);
            await work(db).ConfigureAwait(false);
        }
        catch (Exception ex)
        {
            Logger.Error("DbManager Exception", ex);
            throw;
        }
    }
    
    public static async Task<T> WithSessionAsync<T>(Func<IDbConnection, Task<T>> work)
    {
        try
        {
            await using var db = new NpgsqlConnection(Config.Db.ConnectionString);
            await db.OpenAsync().ConfigureAwait(false);
            return await work(db).ConfigureAwait(false);
        }
        catch (Exception ex)
        {
            Logger.Error("DbManager Exception", ex);
            throw;
        }
    }
    
    public static async Task WithTransactionAsync(Func<IDbConnection, IDbTransaction, Task> work)
    {
        
        try
        {
            await using var db = new NpgsqlConnection(Config.Db.ConnectionString);
            await db.OpenAsync().ConfigureAwait(false);    
            await using var transaction = await db.BeginTransactionAsync().ConfigureAwait(false);

            try
            {
                await work(db, transaction).ConfigureAwait(false);
                await transaction.CommitAsync().ConfigureAwait(false);
            }
            catch
            {
                await transaction.RollbackAsync().ConfigureAwait(false);
                throw;
            }
        }
        catch (Exception ex)
        {
            Logger.Error("DbManager Exception", ex);
            throw;
        }
    }
}
