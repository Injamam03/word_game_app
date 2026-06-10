import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/services/level_service.dart';
import '../../../core/utils/computer_player.dart';
import '../../../core/utils/word_validator.dart';

class PlayerModel {
  final String name;
  final bool isComputer;
  RxInt score = 0.obs;
  RxBool isEliminated = false.obs;
  RxBool isActive = false.obs;
  RxList<String> myWords = <String>[].obs;
  RxInt wordCount = 0.obs;

  PlayerModel({required this.name, this.isComputer = false});
}

class GamePlayController extends GetxController {
  late List<PlayerModel> players;
  late bool hasComputer;
  int? selectedLevel;
  int? targetWordCount;

  final RxList<String> usedWords = <String>[].obs;
  final RxString lastWord = ''.obs;
  final RxString requiredLetter = ''.obs;
  final RxString errorMessage = ''.obs;
  final RxBool showError = false.obs;
  final RxBool isValidating = false.obs;
  final RxInt currentPlayerIndex = 0.obs;
  final RxInt elapsedSeconds = 0.obs;
  final RxString computerLastWord = ''.obs;
  final wordController = TextEditingController();
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    final names =
        args['playerNames'] as List<dynamic>? ?? ['Player 1', 'Player 2'];
    hasComputer = args['isComputer'] as bool? ?? false;
    selectedLevel = args['level'] as int?;

    if (selectedLevel != null) {
      targetWordCount = LevelService.getRequiredWords(selectedLevel!);
    }

    players = names
        .map((name) => PlayerModel(
      name: name.toString(),
      isComputer: name.toString() == AppStrings.computerName,
    ))
        .toList();

    players[0].isActive.value = true;
    _startTimer();
    _checkComputerTurn();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      elapsedSeconds.value++;
    });
  }

  String get formattedTime {
    final m = elapsedSeconds.value ~/ 60;
    final s = elapsedSeconds.value % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  PlayerModel get currentPlayer => players[currentPlayerIndex.value];

  List<PlayerModel> get activePlayers =>
      players.where((p) => !p.isEliminated.value).toList();

  Future<bool> _isValidEnglishWord(String word) async {
    final cleanWord = word.toLowerCase().trim();
    if (ComputerPlayer.wordBank.contains(cleanWord)) {
      return true;
    }
    try {
      final response = await http.get(
        Uri.parse('https://api.dictionaryapi.dev/api/v2/entries/en/$cleanWord'),
      ).timeout(const Duration(seconds: 5));
      return response.statusCode == 200;
    } catch (_) {
      return true;
    }
  }

  Future<void> submitWord() async {
    final word = wordController.text.trim().toLowerCase();
    if (word.isEmpty) return;

    if (WordValidator.isDuplicate(word, usedWords)) {
      _showError(AppStrings.wordAlreadyUsed);
      return;
    }

    if (usedWords.isNotEmpty &&
        !WordValidator.isValidChain(word, lastWord.value)) {
      _showError('Word must start with letter "${requiredLetter.value}"');
      return;
    }

    isValidating.value = true;
    final isValid = await _isValidEnglishWord(word);
    isValidating.value = false;

    if (!isValid) {
      _showError('"$word" is not a valid English word!');
      return;
    }

    _acceptWord(word);
  }

  void _acceptWord(String word) {
    usedWords.add(word);
    lastWord.value = word;
    requiredLetter.value = WordValidator.getRequiredStartLetter(word);
    
    final player = currentPlayer;
    player.score.value += word.length * 10;
    player.myWords.add(word);
    player.wordCount.value++;

    wordController.clear();
    showError.value = false;
    errorMessage.value = '';

    // Check for level completion
    if (selectedLevel != null && !player.isComputer && targetWordCount != null) {
      if (player.wordCount.value >= targetWordCount!) {
        _endGame(levelCompleted: true);
        return;
      }
    }

    _nextTurn();
  }

  void _showError(String msg) {
    errorMessage.value = msg;
    showError.value = true;

    // Fixed: Removed unsupported 'behavior' parameter. 
    // In GetX, margin + snackStyle: SnackStyle.FLOATING makes it float correctly.
    Get.closeAllSnackbars();
    Get.snackbar(
      'Notice',
      msg,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.errorContainer,
      colorText: AppColors.error,
      margin: EdgeInsets.all(20.w),
      snackStyle: SnackStyle.FLOATING,
      duration: const Duration(seconds: 3),
      icon: const Icon(Icons.warning_rounded, color: AppColors.error),
      shouldIconPulse: true,
      barBlur: 10,
    );

    // Automatically hide error after 3 seconds to keep UI clean
    Future.delayed(const Duration(seconds: 3), () {
      if (errorMessage.value == msg) {
        showError.value = false;
      }
    });
  }

  void stopPlayer() {
    currentPlayer.isEliminated.value = true;
    currentPlayer.isActive.value = false;

    if (activePlayers.length <= 1) {
      _endGame();
      return;
    }
    _nextTurn();
  }

  void _nextTurn() {
    currentPlayer.isActive.value = false;
    int next = (currentPlayerIndex.value + 1) % players.length;
    while (players[next].isEliminated.value) {
      next = (next + 1) % players.length;
    }
    currentPlayerIndex.value = next;
    players[next].isActive.value = true;
    showError.value = false;
    _checkComputerTurn();
  }

  void _checkComputerTurn() {
    if (currentPlayer.isComputer) {
      Future.delayed(const Duration(milliseconds: 1500), () {
        if (currentPlayer.isComputer && !currentPlayer.isEliminated.value) {
          final word = ComputerPlayer.generateWord(
            requiredLetter.value.isEmpty
                ? 'a'
                : requiredLetter.value.toLowerCase(),
            usedWords.toList(),
          );
          if (word.isEmpty) {
            stopPlayer();
          } else {
            computerLastWord.value = word;
            _acceptWord(word);
          }
        }
      });
    }
  }

  void _endGame({bool levelCompleted = false}) {
    _timer?.cancel();
    final winner =
    activePlayers.isNotEmpty ? activePlayers.first : players.first;
    
    // User wins a level only if target reached. If computer eliminates them, user loses level.
    bool userWonLevel = levelCompleted && !winner.isComputer;

    Get.toNamed(
      AppStrings.routeWinner,
      arguments: {
        'winnerName': winner.name,
        'winnerScore': winner.score.value,
        'usedWords': usedWords.toList(),
        'duration': formattedTime,
        'level': selectedLevel,
        'levelCompleted': userWonLevel,
        'totalWords': winner.wordCount.value,
      },
    );
  }

  @override
  void onClose() {
    _timer?.cancel();
    wordController.dispose();
    super.onClose();
  }
}
