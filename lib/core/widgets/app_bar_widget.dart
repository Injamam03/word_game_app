import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import 'custom_text.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onMenuTap;
  final bool showBackButton;

  const AppBarWidget({
    super.key,
    this.onMenuTap,
    this.showBackButton = false,
  });

  @override
  Size get preferredSize => Size.fromHeight(64.h);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.surface,
      elevation: 0,
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: false,
      titleSpacing: 20.w,
      title: Row(
        children: [
          GestureDetector(
            onTap: showBackButton ? () => Get.back() : onMenuTap,
            child: Icon(
              showBackButton ? Icons.arrow_back_rounded : Icons.menu_rounded,
              color: AppColors.primary,
              size: 24.sp,
            ),
          ),
          SizedBox(width: 16.w),
          CustomText.headlineSm(
            AppStrings.appName,
            color: AppColors.primary,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.3,
          ),
        ],
      ),
      actions: [
        // Padding(
        //   padding: EdgeInsets.only(right: 20.w),
        //   child: CircleAvatar(
        //     radius: 20.r,
        //     backgroundColor: AppColors.surfaceContainerHighest,
        //     child: Icon(Icons.person_rounded, color: AppColors.onSurfaceVariant, size: 20.sp),
        //   ),
        // ),
      ],
    );
  }
}
