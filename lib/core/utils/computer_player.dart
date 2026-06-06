import 'dart:math';

class ComputerPlayer {
  ComputerPlayer._();

  static const List<String> _wordBank = [
    'apple', 'elephant', 'table', 'eagle', 'east', 'ant', 'tiger', 'ring',
    'game', 'end', 'dog', 'goal', 'lemon', 'nail', 'lake', 'ear', 'road',
    'door', 'rain', 'nest', 'tree', 'egg', 'great', 'tour', 'robe', 'eye',
    'echo', 'oak', 'king', 'gain', 'need', 'date', 'exit', 'tail', 'lion',
    'note', 'even', 'nice', 'edge', 'dusk', 'keep', 'pool', 'love', 'vine',
    'ember', 'rose', 'earth', 'hat', 'top', 'pen', 'net', 'ten', 'now',
    'wave', 'eel', 'lamp', 'port', 'time', 'elder', 'race', 'cup', 'pear',
  ];

  static String generateWord(String startLetter, List<String> usedWords) {
    final filtered = _wordBank
        .where((w) =>
            w.startsWith(startLetter.toLowerCase()) &&
            !usedWords.any((u) => u.toLowerCase() == w))
        .toList();

    if (filtered.isEmpty) return '';

    final rand = Random();
    return filtered[rand.nextInt(filtered.length)];
  }
}
