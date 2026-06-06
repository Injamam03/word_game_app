import 'package:flutter/cupertino.dart';

class WordValidator {
  WordValidator._();

  static bool isValidChain(String newWord, String lastWord) {
    if (newWord.isEmpty || lastWord.isEmpty) return false;
    final lastLetter = lastWord.toLowerCase().trim().characters.last;
    final firstLetter = newWord.toLowerCase().trim().characters.first;
    return lastLetter == firstLetter;
  }

  static bool isDuplicate(String word, List<String> usedWords) {
    return usedWords.any((w) => w.toLowerCase() == word.toLowerCase().trim());
  }

  static String getRequiredStartLetter(String lastWord) {
    if (lastWord.isEmpty) return '';
    return lastWord.trim().characters.last.toUpperCase();
  }
}
