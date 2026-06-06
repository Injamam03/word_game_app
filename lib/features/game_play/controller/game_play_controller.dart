import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/computer_player.dart';
import '../../../core/utils/word_validator.dart';

class PlayerModel {
  final String name;
  final bool isComputer;
  RxInt score = 0.obs;
  RxBool isEliminated = false.obs;
  RxBool isActive = false.obs;

  PlayerModel({required this.name, this.isComputer = false});
}

class GamePlayController extends GetxController {
  late List<PlayerModel> players;
  late bool hasComputer;

  final RxList<String> usedWords = <String>[].obs;
  final RxString currentWord = ''.obs;
  final RxString lastWord = ''.obs;
  final RxString requiredLetter = ''.obs;
  final RxString errorMessage = ''.obs;
  final RxBool showError = false.obs;
  final RxInt currentPlayerIndex = 0.obs;
  final RxInt elapsedSeconds = 0.obs;
  final wordController = TextEditingController();
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    final names = args['playerNames'] as List<dynamic>? ?? ['Player 1', 'Player 2'];
    hasComputer = args['isComputer'] as bool? ?? false;

    players = names.map((name) => PlayerModel(
      name: name.toString(),
      isComputer: name.toString() == AppStrings.computerName,
    )).toList();

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

  List<PlayerModel> get activePlayers => players.where((p) => !p.isEliminated.value).toList();

  void submitWord() {
    final word = wordController.text.trim();
    if (word.isEmpty) return;

    if (usedWords.isNotEmpty && !WordValidator.isValidChain(word, lastWord.value)) {
      _showError('Word must start with letter "${requiredLetter.value}"');
      return;
    }

    if (WordValidator.isDuplicate(word, usedWords)) {
      _showError(AppStrings.wordAlreadyUsed);
      return;
    }

    _acceptWord(word);
  }

  void _acceptWord(String word) {
    usedWords.add(word);
    lastWord.value = word;
    requiredLetter.value = WordValidator.getRequiredStartLetter(word);
    currentPlayer.score.value += word.length * 10;
    wordController.clear();
    showError.value = false;
    errorMessage.value = '';
    currentWord.value = '';
    _nextTurn();
  }

  void _showError(String msg) {
    errorMessage.value = msg;
    showError.value = true;
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
            requiredLetter.value.isEmpty ? 'a' : requiredLetter.value.toLowerCase(),
            usedWords.toList(),
          );
          if (word.isEmpty) {
            stopPlayer();
          } else {
            _acceptWord(word);
          }
        }
      });
    }
  }

  void _endGame() {
    _timer?.cancel();
    final winner = activePlayers.isNotEmpty ? activePlayers.first : players.first;
    Get.toNamed(
      AppStrings.routeWinner,
      arguments: {
        'winnerName': winner.name,
        'winnerScore': winner.score.value,
        'usedWords': usedWords.toList(),
        'duration': formattedTime,
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
