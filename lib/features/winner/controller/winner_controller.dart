import 'package:get/get.dart';
import 'package:word_game/core/constants/app_strings.dart';

class WinnerController extends GetxController {
  late String winnerName;
  late int winnerScore;
  late List<String> usedWords;
  late String duration;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    winnerName = args['winnerName'] as String? ?? 'Player';
    winnerScore = args['winnerScore'] as int? ?? 0;
    usedWords = List<String>.from(args['usedWords'] as List? ?? []);
    duration = args['duration'] as String? ?? '00:00';
  }

  int get accuracy {
    if (usedWords.isEmpty) return 100;
    return (winnerScore / (usedWords.length * 1) * 100).clamp(0, 100).round();
  }

  String get bestWord {
    if (usedWords.isEmpty) return '-';
    return usedWords.reduce((a, b) => a.length >= b.length ? a : b).toUpperCase();
  }

  void playAgain() {
    Get.offAllNamed(AppStrings.routeHome);
  }

  void goHome() {
    Get.offAllNamed(AppStrings.routeHome);
  }
}
