import 'package:get/get.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/services/level_service.dart';

class LevelSelectionController extends GetxController {
  final RxInt highestUnlocked = 1.obs;
  final RxList<int> completedLevels = <int>[].obs;
  final int totalLevels = 500;

  @override
  void onInit() {
    super.onInit();
    loadProgress();
  }

  @override
  void onReady() {
    super.onReady();
    // Refresh progress whenever we return to this screen
    loadProgress();
  }

  Future<void> loadProgress() async {
    highestUnlocked.value = await LevelService.getHighestUnlockedLevel();
    completedLevels.assignAll(await LevelService.getCompletedLevels());
  }

  bool isLocked(int level) => level > highestUnlocked.value;
  bool isCompleted(int level) => completedLevels.contains(level);
  bool isCurrent(int level) => level == highestUnlocked.value;

  int get unlockedCount => highestUnlocked.value;

  void selectLevel(int level) {
    if (isLocked(level)) return;
    
    Get.toNamed(
      AppStrings.routePlayerNames,
      arguments: {
        'playerCount': 2,
        'isComputer': true,
        'level': level,
      },
    );
  }
}
