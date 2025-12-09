import 'package:shared_preferences/shared_preferences.dart';
import '../models/game_state.dart';

class PersistenceController {
  static final PersistenceController _instance = PersistenceController._internal();
  factory PersistenceController() => _instance;
  PersistenceController._internal();

  // =============================
  // SAVE GAME STATE
  // =============================
  Future<void> saveGame(GameState state) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setDouble("compassion", state.stats["compassion"]!.points);
    await prefs.setDouble("competence", state.stats["competence"]!.points);
    await prefs.setDouble("commitment", state.stats["commitment"]!.points);

    await prefs.setInt("totalClicks", state.totalClicks);

    await prefs.setInt("passiveComp", state.passiveCompLevel);
    await prefs.setInt("passiveCompete", state.passiveCompeteLevel);
    await prefs.setInt("passiveCommit", state.passiveCommitLevel);

    await prefs.setInt("duplicationLevel", state.duplicationLevel);

    await prefs.setInt("prestigeLevel", state.prestigeLevel);
    await prefs.setDouble("permanentClickBonus", state.permanentClickBonus);

    print("GAME SAVED!");
  }

  // =============================
  // LOAD GAME STATE
  // =============================
  Future<void> loadGame(GameState state) async {
    final prefs = await SharedPreferences.getInstance();

    state.stats["compassion"]!.points = prefs.getDouble("compassion") ?? 0;
    state.stats["competence"]!.points = prefs.getDouble("competence") ?? 0;
    state.stats["commitment"]!.points = prefs.getDouble("commitment") ?? 0;

    state.totalClicks = prefs.getInt("totalClicks") ?? 0;

    state.passiveCompLevel = prefs.getInt("passiveComp") ?? 0;
    state.passiveCompeteLevel = prefs.getInt("passiveCompete") ?? 0;
    state.passiveCommitLevel = prefs.getInt("passiveCommit") ?? 0;

    state.duplicationLevel = prefs.getInt("duplicationLevel") ?? 0;

    state.prestigeLevel = prefs.getInt("prestigeLevel") ?? 0;
    state.permanentClickBonus = prefs.getDouble("permanentClickBonus") ?? 0.0;


    print("GAME LOADED!");
  }

  // =============================
  // CLEAR SAVE DATA (FOR DEBUG)
  // =============================
  Future<void> wipeSave() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    print("SAVE FILE WIPED!");
  }
}
