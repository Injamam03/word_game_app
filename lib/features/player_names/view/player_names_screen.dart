import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/app_bar_widget.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text.dart';
import '../controller/player_names_controller.dart';

class PlayerNamesScreen extends StatelessWidget {
  const PlayerNamesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<PlayerNamesController>();
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppBarWidget(showBackButton: true),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(24.h),
              Align(
                alignment: Alignment.center,
                child: CustomText.headlineLg(
                  AppStrings.setupGame,
                  color: AppColors.onBackground,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Gap(8.h),
              Align(
                alignment: Alignment.center,
                child: CustomText.bodyLg(
                  AppStrings.whoIsJoining,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              Gap(24.h),
              Expanded(
                child: ListView.separated(
                  itemCount: ctrl.playerCount,
                  separatorBuilder: (_, __) => Gap(12.h),
                  itemBuilder: (_, i) {
                    final isComputerPlayer =
                        ctrl.isComputer && i == ctrl.playerCount - 1;
                    return _PlayerNameField(
                      index: i,
                      controller: ctrl.nameControllers[i],
                      isComputer: isComputerPlayer,
                    );
                  },
                ),
              ),
              Gap(16.h),
              _ModeBadge(ctrl: ctrl),
              Gap(16.h),
              Obx(
                () => CustomButton(
                  label: AppStrings.startGame,
                  onTap: ctrl.isFormValid.value ? ctrl.startGame : null,
                  trailing: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: AppColors.onPrimary,
                    size: 18.sp,
                  ),
                ),
              ),
              Gap(24.h),
            ],
          ),
        ),
      ),
    );
  }
}

class _PlayerNameField extends StatelessWidget {
  final int index;
  final TextEditingController controller;
  final bool isComputer;

  const _PlayerNameField({
    required this.index,
    required this.controller,
    required this.isComputer,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 36.w,
            height: 36.h,
            decoration: BoxDecoration(
              color: isComputer
                  ? AppColors.secondaryContainer
                  : AppColors.primaryFixed,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: isComputer
                  ? Icon(
                      Icons.smart_toy_rounded,
                      color: AppColors.onSecondaryContainer,
                      size: 20.sp,
                    )
                  : CustomText.bodyMd(
                      '${index + 1}',
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
            ),
          ),
          Gap(12.w),
          Expanded(
            child: TextField(
              controller: controller,
              readOnly: isComputer,
              textCapitalization: TextCapitalization.words,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.onSurface,
              ),
              decoration: InputDecoration(
                hintText: isComputer
                    ? AppStrings.computerName
                    : AppStrings.enterName,
                hintStyle: TextStyle(color: AppColors.outline, fontSize: 16.sp),
                border: InputBorder.none,
              ),
            ),
          ),
          if (isComputer)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: AppColors.secondaryContainer,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: CustomText.labelSm(
                AppStrings.computerName,
                color: AppColors.onSecondaryContainer,
                fontWeight: FontWeight.w600,
              ),
            ),
        ],
      ),
    );
  }
}

class _ModeBadge extends StatelessWidget {
  final PlayerNamesController ctrl;
  const _ModeBadge({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    final bool isLevelMode = ctrl.selectedLevel != null;
    final String modeText = isLevelMode
        ? '${AppStrings.level} ${ctrl.selectedLevel.toString().padLeft(2, '0')} • vs Computer'
        : 'Classic Mode • ${ctrl.playerCount} Players';

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        children: [
          Icon(
            isLevelMode ? Icons.auto_awesome_rounded : Icons.sports_esports_rounded,
            color: AppColors.primary,
            size: 18.sp,
          ),
          Gap(8.w),
          CustomText.labelLg(
            modeText,
            color: AppColors.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
        ],
      ),
    );
  }
}
