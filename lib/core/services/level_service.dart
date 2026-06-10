import 'package:shared_preferences/shared_preferences.dart';

class LevelService {
  LevelService._();

  static const String _highestUnlockedKey = 'highest_unlocked_level';
  static const String _completedLevelsKey = 'completed_levels';

  static Future<int> getHighestUnlockedLevel() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_highestUnlockedKey) ?? 1;
  }

  static Future<List<int>> getCompletedLevels() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> completed = prefs.getStringList(_completedLevelsKey) ?? [];
    return completed.map((e) => int.parse(e)).toList();
  }

  static Future<void> unlockNextLevel(int completedLevel) async {
    final prefs = await SharedPreferences.getInstance();
    
    // 1. Mark as completed
    List<String> completed = prefs.getStringList(_completedLevelsKey) ?? [];
    if (!completed.contains(completedLevel.toString())) {
      completed.add(completedLevel.toString());
      await prefs.setStringList(_completedLevelsKey, completed);
    }

    // 2. Unlock next level (highestUnlocked = completedLevel + 1)
    int highest = prefs.getInt(_highestUnlockedKey) ?? 1;
    if (completedLevel >= highest) {
      await prefs.setInt(_highestUnlockedKey, completedLevel + 1);
    }
  }

  static int getRequiredWords(int level) {
    if (level <= 10) {
      return 15 + (level - 1) * 3;
    } else {
      // Level 10 goal is 42. Level 11 is 47.
      return 42 + (level - 10) * 5;
    }
  }
}
