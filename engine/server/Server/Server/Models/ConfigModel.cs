using System.Data;
using Dapper;
using Server.Managers;

namespace Server.Models;

[Table("configs")]
public class ConfigModel : Model<ConfigModel>
{
    [IgnoreUpdate]
    public string key { get; set; }
    
    public bool? value_bool { get; set; }
    public int? value_int { get; set; }
    public float? value_float { get; set; }
    public string? value_string { get; set; }
    public DateTime? value_datetime { get; set; }
}
