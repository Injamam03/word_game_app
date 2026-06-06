import 'package:get/get.dart';
import '../../features/home/view/home_screen.dart';
import '../constants/app_strings.dart';

class AppRoutes {
  AppRoutes._();

  static final List<GetPage> pages = [
    GetPage(
      name: AppStrings.routeHome,
      page: () => const HomeScreen(),
    ),

  ];
}
