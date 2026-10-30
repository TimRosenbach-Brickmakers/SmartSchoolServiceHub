using Microsoft.Data.Sqlite;

namespace SmartSchoolHub.Api.Infrastructure;

public sealed class DbConnectionProvider
{
    private static readonly Lazy<DbConnectionProvider> _instance = new(() => new DbConnectionProvider());
    public static DbConnectionProvider Instance => _instance.Value;

    private DbConnectionProvider() { }

    // TODO: Connection-String aus appsettings
    public SqliteConnection Create() => new("Data Source=smartschoolhub.db");
}
