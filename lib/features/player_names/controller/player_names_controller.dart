import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_strings.dart';

class PlayerNamesController extends GetxController {
  late int playerCount;
  late bool isComputer;
  int? selectedLevel;
  late List<TextEditingController> nameControllers;

  final RxList<String> playerNames = <String>[].obs;
  final RxBool isFormValid = false.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    playerCount = args['playerCount'] as int? ?? 2;
    isComputer = args['isComputer'] as bool? ?? false;
    selectedLevel = args['level'] as int?;

    nameControllers = List.generate(playerCount, (_) => TextEditingController());

    if (isComputer) {
      nameControllers.last.text = AppStrings.computerName;
    }

    for (final c in nameControllers) {
      c.addListener(_validateForm);
    }

    _validateForm();
  }

  void _validateForm() {
    isFormValid.value = nameControllers.every((c) => c.text.trim().isNotEmpty);
  }

  void startGame() {
    if (!isFormValid.value) return;
    final names = nameControllers.map((c) => c.text.trim()).toList();
    Get.toNamed(
      AppStrings.routeGamePlay,
      arguments: {
        'playerNames': names,
        'isComputer': isComputer,
        'level': selectedLevel,
      },
    );
  }

  @override
  void onClose() {
    for (final c in nameControllers) {
      c.removeListener(_validateForm);
      c.dispose();
    }
    super.onClose();
  }
}
