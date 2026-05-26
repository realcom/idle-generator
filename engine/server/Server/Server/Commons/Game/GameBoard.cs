using log4net;
using Server.Models;
using Server.Player;

// ReSharper disable once CheckNamespace
namespace Commons.Game;

public partial class GameBoard
{
    public IEnumerable<(PlayerItemModel, int)>? UsedMaterialItems;
    private static readonly ILog Logger = LogManager.GetLogger("", System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);
    public IPlayer? Creator { get; set; }
}
