import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/computer_player.dart';
import '../../../core/utils/word_validator.dart';

class PlayerModel {
  final String name;
  final bool isComputer;
  RxInt score = 0.obs;
  RxBool isEliminated = false.obs;
  RxBool isActive = false.obs;
  RxList<String> myWords = <String>[].obs;
  RxInt wordCount = 0.obs; // ✅ word count

  PlayerModel({required this.name, this.isComputer = false});
}

class GamePlayController extends GetxController {
  late List<PlayerModel> players;
  late bool hasComputer;

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

  // ─── Dictionary API Check ────────────────────────────────────────────────
  Future<bool> _isValidEnglishWord(String word) async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://api.dictionaryapi.dev/api/v2/entries/en/${word.toLowerCase()}'),
      ).timeout(const Duration(seconds: 5));
      return response.statusCode == 200;
    } catch (_) {
      // internet না থাকলে valid ধরে নেব
      return true;
    }
  }

  // ─── Submit Word ─────────────────────────────────────────────────────────
  Future<void> submitWord() async {
    final word = wordController.text.trim().toLowerCase();
    if (word.isEmpty) return;

    // Duplicate check
    if (WordValidator.isDuplicate(word, usedWords)) {
      _showError(AppStrings.wordAlreadyUsed);
      return;
    }

    // Chain check
    if (usedWords.isNotEmpty &&
        !WordValidator.isValidChain(word, lastWord.value)) {
      _showError('Word must start with letter "${requiredLetter.value}"');
      return;
    }

    // Dictionary check
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
    currentPlayer.score.value += word.length * 10;
    currentPlayer.myWords.add(word);
    currentPlayer.wordCount.value++; // ✅ এই line add করো
    wordController.clear();
    showError.value = false;
    errorMessage.value = '';
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
            requiredLetter.value.isEmpty
                ? 'a'
                : requiredLetter.value.toLowerCase(),
            usedWords.toList(),
          );
          if (word.isEmpty) {
            stopPlayer();
          } else {
            computerLastWord.value = word; // ✅ computer word দেখানোর জন্য
            _acceptWord(word);
          }
        }
      });
    }
  }

  void _endGame() {
    _timer?.cancel();
    final winner =
    activePlayers.isNotEmpty ? activePlayers.first : players.first;
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