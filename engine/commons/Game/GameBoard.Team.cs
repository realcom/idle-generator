using System;
using Commons.Resources;

namespace Commons.Game
{
    public partial class GameBoard
    {
        public static class Team
        {
            public const int Neutral = 0;

            public const int Player = 1;
            public const int PlayerRed = 2;
            public const int PlayerBlue = 3;
            
            public const int Enemy = 4;
            public const int EnemyElite = 5;
            public const int EnemyBoss = 6;
            
            public const int Count = 7;
        }

        public class TeamInteraction
        {
            private readonly bool[,] IsEnemy = new bool[Team.Count, Team.Count];
            private readonly bool[,] IsCollide = new bool[Team.Count, Team.Count];
            
            private static readonly Action<TeamInteraction> DefaultSetEnemy = interaction =>
            {
                interaction.SetEnemy(Team.PlayerRed, Team.PlayerBlue);

                interaction.SetEnemy(Team.Player, Team.Enemy);
                interaction.SetEnemy(Team.Player, Team.EnemyElite);
                interaction.SetEnemy(Team.Player, Team.EnemyBoss);
                
                interaction.SetEnemy(Team.PlayerRed, Team.Enemy);
                interaction.SetEnemy(Team.PlayerRed, Team.EnemyElite);
                interaction.SetEnemy(Team.PlayerRed, Team.EnemyBoss);
                
                interaction.SetEnemy(Team.PlayerBlue, Team.Enemy);
                interaction.SetEnemy(Team.PlayerBlue, Team.EnemyElite);
                interaction.SetEnemy(Team.PlayerBlue, Team.EnemyBoss);
            };
            
            private static readonly Action<TeamInteraction> DefaultSetCollide = interaction =>
            {
                interaction.SetCollide(Team.Player, Team.EnemyElite);
                interaction.SetCollide(Team.Player, Team.EnemyBoss);
                
                interaction.SetCollide(Team.PlayerRed, Team.EnemyElite);
                interaction.SetCollide(Team.PlayerRed, Team.EnemyBoss);
                
                interaction.SetCollide(Team.PlayerBlue, Team.EnemyElite);
                interaction.SetCollide(Team.PlayerBlue, Team.EnemyBoss);
                
                interaction.SetCollide(Team.Enemy, Team.Enemy);
                interaction.SetCollide(Team.EnemyElite, Team.EnemyElite);
                interaction.SetCollide(Team.EnemyBoss, Team.EnemyBoss);
            };

            public static readonly TeamInteraction Default = new(DefaultSetEnemy, DefaultSetCollide);
            
            public static readonly TeamInteraction PlayerCollide = new(Default, interaction =>
            {
            }, interaction =>
            {
                interaction.SetCollide(Team.Player, Team.Player);
                interaction.SetCollide(Team.PlayerRed, Team.PlayerRed);
                interaction.SetCollide(Team.PlayerBlue, Team.PlayerBlue);

                interaction.SetCollide(Team.Player, Team.Enemy);
                interaction.SetCollide(Team.PlayerRed, Team.Enemy);
                interaction.SetCollide(Team.PlayerBlue, Team.Enemy);
            });

            public static readonly TeamInteraction NonCollide = new(DefaultSetEnemy, _ => { });
            
            private TeamInteraction(Action<TeamInteraction> setEnemy, Action<TeamInteraction> setCollide)
            {
                setEnemy(this);
                setCollide(this);
            }
            
            private TeamInteraction(TeamInteraction baseTeamInteraction, Action<TeamInteraction> setEnemy, Action<TeamInteraction> setCollide)
            {
                for (var i = 0; i < Team.Count; i++)
                {
                    for (var j = 0; j < Team.Count; j++)
                    {
                        IsEnemy[i, j] = baseTeamInteraction.IsEnemy[i, j];
                        IsCollide[i, j] = baseTeamInteraction.IsCollide[i, j];
                    }
                }
                
                setEnemy(this);
                setCollide(this);
            }
            
            private void SetEnemy(int team1, int team2)
            {
                IsEnemy[team1, team2] = true;
                IsEnemy[team2, team1] = true;
            }
            
            private void SetCollide(int team1, int team2)
            {
                IsCollide[team1, team2] = true;
                IsCollide[team2, team1] = true;
            }
            
            public bool IsEnemyWith(int team1, int team2)
            {
                return IsEnemy[team1, team2];
            }
            
            public bool IsCollideWith(int team1, int team2)
            {
                return IsCollide[team1, team2];
            }
            
        }

        private TeamInteraction? _teamInteraction;
        
        private void InitTeamInteraction()
        {
            if (ResMap.ContainsTag(Tag.TeamInteractionNonCollide))
                _teamInteraction = TeamInteraction.NonCollide;
            else if (ResMap.ContainsTag(Tag.TeamInteractionPlayerCollide))
                _teamInteraction = TeamInteraction.PlayerCollide;
            else
                _teamInteraction = TeamInteraction.Default;
        }
        
        public bool IsEnemyWith(int team1, int team2)
        {
            return _teamInteraction!.IsEnemyWith(team1, team2);
        }
        
        public bool IsCollideWith(int team1, int team2)
        {
            return _teamInteraction!.IsCollideWith(team1, team2);
        }
    }
}
