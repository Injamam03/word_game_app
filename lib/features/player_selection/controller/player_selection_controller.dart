import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_strings.dart';

class PlayerSelectionController extends GetxController {
  final RxInt selectedMode = (-1).obs; // -1 = none, 0=vsComputer, 1=2p, 2=3p, 3=4p, 4=custom
  final RxInt customPlayerCount = 0.obs;
  final TextEditingController customController = TextEditingController();

  final List<Map<String, dynamic>> modes = [
    {'icon': Icons.computer_rounded, 'label': AppStrings.soloMode, 'sub': AppStrings.vsComputer, 'count': -1},
    {'icon': Icons.group_rounded, 'label': AppStrings.versus, 'sub': AppStrings.twoPlayers, 'count': 2},
    {'icon': Icons.groups_rounded, 'label': AppStrings.battle, 'sub': AppStrings.threePlayers, 'count': 3},
    {'icon': Icons.diversity_3_rounded, 'label': AppStrings.party, 'sub': AppStrings.fourPlayers, 'count': 4},
  ];

  int get playerCount {
    if (selectedMode.value == 4) return customPlayerCount.value;
    if (selectedMode.value == 0) return 2; // 1 human + computer
    return modes[selectedMode.value]['count'] as int;
  }

  bool get isComputer => selectedMode.value == 0;

  bool get canProceed {
    if (selectedMode.value == 4) return customPlayerCount.value >= 2;
    return selectedMode.value >= 0;
  }

  void selectMode(int index) {
    selectedMode.value = index;
    customController.clear();
    customPlayerCount.value = 0;
  }

  void onCustomChanged(String val) {
    final n = int.tryParse(val) ?? 0;
    customPlayerCount.value = n;
    if (n >= 2) {
      selectedMode.value = 4;
    } else {
      if (selectedMode.value == 4) selectedMode.value = -1;
    }
  }

  void goNext() {
    if (!canProceed) return;
    Get.toNamed(
      AppStrings.routePlayerNames,
      arguments: {
        'playerCount': playerCount,
        'isComputer': isComputer,
      },
    );
  }

  @override
  void onClose() {
    customController.dispose();
    super.onClose();
  }
}
