class AppStrings {
  AppStrings._();

  static const String appName = 'Word Game';

  // Home / Rules
  static const String gameTitle = 'Word Game';
  static const String howToPlay = 'How to Play';
  static const String rule1 = 'Players take turns saying words.';
  static const String rule2 = 'Each new word must start with the last letter of the previous word.';
  static const String rule3 = 'A word cannot be reused again in the same game.';
  static const String exampleLabel = 'Example:';
  static const String exampleWords = 'yes → seen → need → date';
  static const String startButton = 'Start Game';

  // Player Selection
  static const String choosePlayers = 'Choose Players Number';
  static const String selectModeSubtitle = 'Select a mode to start your word journey';
  static const String soloMode = 'Solo Mode';
  static const String vsComputer = 'You vs Computer';
  static const String versus = 'Versus';
  static const String twoPlayers = '2 Players';
  static const String battle = 'Battle';
  static const String threePlayers = '3 Players';
  static const String party = 'Party';
  static const String fourPlayers = '4 Players';
  static const String customPlayersLabel = 'Custom number of players';
  static const String customPlayersHint = 'e.g. 5';
  static const String maxPlayersNote = 'Maximum 12 players allowed.';
  static const String next = 'Next';

  // Player Names
  static const String setupGame = 'Setup Game';
  static const String whoIsJoining = "Who's joining the match today?";
  static const String enterName = 'Enter name';
  static const String startGame = 'Start Game';
  static const String computerName = 'Computer';

  // Gameplay
  static const String active = 'Active';
  static const String nowPlaying = 'Now playing: ';
  static const String wordAlreadyUsed = 'This word is already used. Please enter a different word.';
  static const String nextWordStartsWith = 'Next word must start with';
  static const String submitWord = 'Submit Word';
  static const String stop = 'Stop';
  static const String pts = ' pts';
  static const String eliminated = 'Eliminated';

  // Winner
  static const String congratulations = 'Congratulations!';
  static const String isWinner = ' is the winner!';
  static const String finalScore = 'Final Score';
  static const String newPersonalBest = 'New Personal Best';
  static const String accuracy = 'Accuracy';
  static const String bestWord = 'Best Word';
  static const String gameDuration = 'Game Duration';
  static const String recentWords = 'Recent Words';
  static const String playAgain = 'Play Again';
  static const String home = 'Home';

  // Bottom Nav
  static const String play = 'Play';
  static const String rankings = 'Rankings';
  static const String settings = 'Settings';

  // Routes
  static const String routeHome = '/';
  static const String routePlayerSelection = '/player-selection';
  static const String routePlayerNames = '/player-names';
  static const String routeGamePlay = '/game-play';
  static const String routeWinner = '/winner';
  static const String routeMainScreen = '/main';
}
