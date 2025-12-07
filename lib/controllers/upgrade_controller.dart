import '../models/game_state.dart';
import '../models/upgrade.dart';

class UpgradeController {
  final GameState state;

  UpgradeController(this.state);

  bool purchase(Upgrade upgrade) {
    String statId = upgrade.costStat;
    double cost = upgrade.currentCost();

    if (state.stats[statId]!.points < cost) return false;

    // Deduct cost
    state.stats[statId]!.points -= cost;

    // Increase level
    upgrade.level++;

    // Apply the effect
    _applyEffect(upgrade);

    state.notifyListeners();
    return true;
  }

  void _applyEffect(Upgrade up) {
    switch (up.type) {
      case UpgradeType.clickPower:
      // increase base click value for all stats
        state.stats.values.forEach((s) => s.clickValue += 1);
        break;

    // Legacy single passive generator (if your enum still has this)
      case UpgradeType.passiveGenerator:
      // If you have the single passive variant, apply it to compassion level as fallback.
      // You can change this mapping if you prefer a different default stat.
        state.passiveCompLevel++;
        break;

    // Per-stat passive upgrades (preferred)
      case UpgradeType.passiveCompassion:
        state.passiveCompLevel++;
        break;

      case UpgradeType.passiveCompetence:
        state.passiveCompeteLevel++;
        break;

      case UpgradeType.passiveCommitment:
        state.passiveCommitLevel++;
        break;

      case UpgradeType.duplicationLite:
        state.duplicationLevel++;
        break;

      default:
      // Safety: if a new enum value appears, do nothing (or log)
        break;
    }
  }
}
