# Hamster Growth Dock Runtime Mapping

| UI | Runtime source | Notes |
| --- | --- | --- |
| Top combat power | `MyPlayer.Player.Power`, fallback to local `GameUnit.Attack + MaxHp / 10` | Server power can be `0` in local mushroom smoke, so the fallback keeps the HUD live. |
| Top gold | `GameBoard.GetPlayerById(MyPlayer.Player.Id).Gold` | Mutated through `BoardPlayerMessage.HandleGoldChange()` after spending or collecting. |
| Top heart | `GameBoard.GetUnitByPlayerId(MyPlayer.Player.Id).Hp / MaxHp` | The prefab label stays "하트"; the runtime value is current combat HP. |
| Stage progress | `GameBoard.Variables[BoardVariableId.Map.wave]` and enemy team count | Falls back to map name before the first wave value exists. |
| Attack card | Stat item `1000` level and `MyPlayer.PlayerItemStat[UnitStatType.Attack]`, displayed through `GameUnit.Attack` | Upgrade calls the same stat-item level-up path as the engine examples, then syncs the recalculated item stat to the local board unit. |
| Health card | Stat item `1001` level and `MyPlayer.PlayerItemStat[UnitStatType.Hp]`, displayed through `GameUnit.MaxHp` | HP growth is persisted as the stat item's level, not as a raw runtime-only HP number. |
| Attack speed card | Stat item `1002` level and `MyPlayer.PlayerItemStat[UnitStatType.AttackSpeedPercent]` | The displayed value comes from the stat item growth curve's `addStats`. |
| Critical damage card | Stat item `1003` level and `MyPlayer.PlayerItemStat[UnitStatType.CriticalDamagePercent]` | The displayed value comes from the stat item growth curve's `addStats`. |
| Growth button | Cheapest affordable stat-item upgrade among item `1000..1003` | This replaces the confusing manual reward claim behavior; the saved progression is the selected stat item's level. |
| Auto enhance button | Presenter-local toggle, repeats the same stat-item upgrade path while affordable | State is intentionally not persisted for the first runtime binding pass; upgraded stat item levels are persisted. |
| Legacy quick growth buttons | Delegated to `HamsterGrowthDockPresenter.TryUpgradeById()` | These no longer mutate `BoardPlayerMessage.ItemStat` directly; they use the same saved stat-item path as the prefab cards. |
| Gold pickup | Player unit `hitDropItemSize` in `player_hamster.unit.yaml` | The engine already collects drops inside the unit pickup radius through `GameUnit.GetDropItems()`, so no UI-side collection code is needed. |
