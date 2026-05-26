using System.Data;
using Commons;
using Commons.Game;
using Dapper;
using Google.Protobuf;
using Newtonsoft.Json.Linq;
using Server.Managers;

namespace Server.Models;

[Table("board_histories")]
public class BoardHistoryModel : Model<BoardHistoryModel>
{
    public byte[] board { get; set; }
    public JArray events { get; set; } = [];
    [Editable(true)]
    public JObject? summary { get; set; }
    [Editable(true)]
    public long[]? player_ids { get;  set; }

    public GameBoard GetBoard()
    {
        return GameBoard.Parser.ParseFrom(board);
    }
    public void SetBoard(GameBoard board)
    {
        this.board = board.ToByteArray();
    }
}
