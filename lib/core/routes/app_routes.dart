import 'package:get/get.dart';
import '../../features/authScreen/splashScreen/splashScreen.dart';
import '../../features/home/view/home_screen.dart';
import '../../features/player_selection/view/player_selection_screen.dart';
import '../../features/player_selection/controller/player_selection_controller.dart';
import '../../features/player_names/view/player_names_screen.dart';
import '../../features/player_names/controller/player_names_controller.dart';
import '../../features/game_play/view/game_play_screen.dart';
import '../../features/game_play/controller/game_play_controller.dart';
import '../../features/winner/view/winner_screen.dart';
import '../../features/winner/controller/winner_controller.dart';
import '../constants/app_strings.dart';

class AppRoutes {
  AppRoutes._();

  static final List<GetPage> pages = [
    GetPage(
      name: AppStrings.splashScreen,
      page: () => const SplashScreen(),
    ),GetPage(
      name: AppStrings.routeHome,
      page: () => const HomeScreen(),
    ),
    GetPage(
      name: AppStrings.routePlayerSelection,
      page: () => const PlayerSelectionScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => PlayerSelectionController());
      }),
    ),
    GetPage(
      name: AppStrings.routePlayerNames,
      page: () => const PlayerNamesScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => PlayerNamesController());
      }),
    ),
    GetPage(
      name: AppStrings.routeGamePlay,
      page: () => const GamePlayScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => GamePlayController());
      }),
    ),
    GetPage(
      name: AppStrings.routeWinner,
      page: () => const WinnerScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => WinnerController());
      }),
    ),
  ];
}
