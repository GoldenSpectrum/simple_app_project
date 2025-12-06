import '../models/game_state.dart';
import '../models/upgrade.dart';

class UpgradeController {
  final GameState state;

  UpgradeController(this.state);

  bool purchase(String upgradeId) {
    final upgrade =
    state.upgrades.firstWhere((u) => u.id == upgradeId, orElse: () => throw "Upgrade not found");

    if (upgrade.purchased) return false;

    // Use total points as currency
    if (state.totalPoints() < upgrade.cost) return false;

    // Deduct cost equally from all 3 stats (simple currency model)
    final deduction = upgrade.cost / 3;
    state.stats.values.forEach((s) => s.points -= deduction);

    upgrade.purchased = true;

    _applyUpgradeEffect(upgrade);

    state.notifyListeners();
    return true;
  }

  void _applyUpgradeEffect(Upgrade u) {
    switch (u.type) {
      case UpgradeType.clickPower:
        state.stats.values.forEach((s) => s.clickValue += 1);
        break;

      case UpgradeType.passiveGenerator:
        state.passiveEnabled = true;
        break;

      case UpgradeType.duplicationLite:
      // GameController will check for this flag
        break;
    }
  }
}
