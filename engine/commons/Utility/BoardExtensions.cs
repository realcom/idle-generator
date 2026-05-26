using System;
using System.IO;
using System.Collections.Generic;
using System.Text;
using Commons.Algorithm.AStar;
using Commons.Game;
using Commons.Resources;
using Commons.Types.Players;
using Google.Protobuf.Reflection;
using RBush;

namespace Commons.Utility
{
    public static class BoardExtensions
    {
        private static readonly HashSet<Type> OmitTypes = new HashSet<Type>
        {
            typeof(MessageDescriptor),
            typeof(ResourceAchievement),
            typeof(ResourceAudio),
            typeof(ResourceBuff),
            typeof(ResourceItem),
            typeof(ResourceMap),
            typeof(ResourceSkill),
            typeof(ResourceString),
            typeof(ResourceTrigger),
            typeof(ResourceUnit),
            typeof(AStar),
            typeof(Envelope),
            typeof(PlayerMessage),
            typeof(PlayerItemMessage),
            typeof(PlayerAvatar),
        };
        
        public static string DebugDump(this GameBoard board)
        {
            return board.DebugDump(OmitTypes);
        }
        
        public static void SaveDebugDump(this GameBoard board, string path, ref bool clearLog)
        {
            var sb = new StringBuilder();
            sb.AppendLine($"---------- Hash: {board.GetHashCode()} | Tick: {board.Tick} ----------");
            sb.AppendLine(board.DebugDump());
            sb.AppendLine();
        
            var append = true;
            if (!clearLog)
            {
                append = false;
                clearLog = true;
            }
            using var writer = new StreamWriter(path, append);
            writer.WriteLine(sb.ToString());
        }
    }
}
