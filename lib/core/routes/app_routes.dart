import 'package:get/get.dart';
import '../../features/home/view/home_screen.dart';
import '../../features/player_selection/view/player_selection_screen.dart';
import '../constants/app_strings.dart';

class AppRoutes {
  AppRoutes._();

  static final List<GetPage> pages = [
    GetPage(
      name: AppStrings.routeHome,
      page: () => const HomeScreen(),
    ),

    GetPage(
      name: AppStrings.routePlayerSelection,
      page: () => const PlayerSelectionScreen(),
    ),

  ];
}
