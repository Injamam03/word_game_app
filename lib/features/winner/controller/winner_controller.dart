import 'package:get/get.dart';
import 'package:word_game/features/game_play/controller/game_play_controller.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/services/level_service.dart';
import '../../level_selection/controller/level_selection_controller.dart';

class WinnerController extends GetxController {
  late String winnerName;
  late int winnerScore;
  late List<String> usedWords;
  late String duration;
  int? level;
  bool levelCompleted = false;
  int totalWords = 0;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    winnerName = args['winnerName'] as String? ?? 'Player';
    winnerScore = args['winnerScore'] as int? ?? 0;
    usedWords = List<String>.from(args['usedWords'] as List? ?? []);
    duration = args['duration'] as String? ?? '00:00';
    level = args['level'] as int?;
    levelCompleted = args['levelCompleted'] as bool? ?? false;
    totalWords = args['totalWords'] as int? ?? 0;
    if (levelCompleted && level != null) {
      _saveProgress();
    }
  }

  Future<void> _saveProgress() async {
    await LevelService.unlockNextLevel(level!);
  }

  int get accuracy {
    if (usedWords.isEmpty) return 100;
    return (winnerScore / (usedWords.length * 10) * 100).clamp(0, 100).round();
  }

  String get bestWord {
    if (usedWords.isEmpty) return '-';
    return usedWords.reduce((a, b) => a.length >= b.length ? a : b).toUpperCase();
  }

  // void playAgain() {
  //   if (level != null) {
  //     Get.delete<GamePlayController>(force: true);     // game state clear
  //     Get.delete<LevelSelectionController>(force: true); // level screen fresh load
  //     Get.offNamed(AppStrings.routeLevelSelection);
  //   } else {
  //     Get.offAllNamed(AppStrings.routeHome);
  //   }
  // }
  void playAgain() {
    if (level != null) {
      Get.delete<LevelSelectionController>(force: true);
      Get.offNamedUntil(
        AppStrings.routeLevelSelection,
            (route) => route.settings.name == AppStrings.routeHome,
      );
    } else {
      Get.offAllNamed(AppStrings.routeHome);
    }
  }

  void goHome() {
    Get.offAllNamed(AppStrings.routeHome);
  }
}
