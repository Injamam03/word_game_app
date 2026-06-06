import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/app_bar_widget.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../controller/player_selection_controller.dart';

class PlayerSelectionScreen extends StatelessWidget {
  const PlayerSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<PlayerSelectionController>();
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
              CustomText.headlineMd(
                AppStrings.choosePlayers,
                color: AppColors.onBackground,
                fontWeight: FontWeight.w700,
              ),
              Gap(8.h),
              CustomText.bodyLg(
                AppStrings.selectModeSubtitle,
                color: AppColors.onSurfaceVariant,
              ),
              Gap(24.h),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _ModeGrid(ctrl: ctrl),
                      Gap(20.h),
                      _CustomPlayerInput(ctrl: ctrl),
                      Gap(16.h),
                    ],
                  ),
                ),
              ),
              Obx(() => CustomButton(
                label: AppStrings.next,
                onTap: ctrl.canProceed ? ctrl.goNext : null,
                trailing: Icon(Icons.arrow_forward_rounded,
                    color: AppColors.onPrimary, size: 20.sp),
              )),
              Gap(24.h),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Mode Grid ───────────────────────────────────────────────────────────────

class _ModeGrid extends StatelessWidget {
  final PlayerSelectionController ctrl;
  const _ModeGrid({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12.h,
        crossAxisSpacing: 12.w,
        childAspectRatio: 1.1,
      ),
      itemCount: ctrl.modes.length,
      itemBuilder: (_, i) {
        final mode = ctrl.modes[i];
        final int count = mode['count'] as int;

        // ✅ GridView এর ভেতরে প্রতিটা item আলাদা Obx
        return Obx(() {
          final isSelected = ctrl.selectedMode.value == i;
          return GestureDetector(
            onTap: () => ctrl.selectMode(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.all(14.r),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primaryFixed
                    : AppColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.outlineVariant,
                  width: isSelected ? 2 : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _AvatarRow(count: count, isSelected: isSelected),
                  Gap(10.h),
                  CustomText.labelSm(
                    mode['label'] as String,
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                  Gap(2.h),
                  CustomText.titleMd(
                    mode['sub'] as String,
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.onSurface,
                    fontWeight: FontWeight.w700,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }
}

// ─── Avatar Row ──────────────────────────────────────────────────────────────

class _AvatarRow extends StatelessWidget {
  final int count; // -1 = computer vs human, 2/3/4 = players
  final bool isSelected;

  const _AvatarRow({required this.count, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    final Color bgColor =
    isSelected ? AppColors.primary : AppColors.primaryFixed;
    final Color iconColor =
    isSelected ? AppColors.onPrimary : AppColors.primary;
    final Color compColor =
    isSelected ? AppColors.secondary : AppColors.secondaryContainer;
    final Color compIconColor =
    isSelected ? AppColors.onSecondary : AppColors.onSecondaryContainer;

    // Computer vs Human
    if (count == -1) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _Avatar(bgColor: bgColor, iconColor: iconColor, icon: Icons.person_rounded),
          Gap(6.w),
          Icon(Icons.compare_arrows_rounded,
              color: isSelected ? AppColors.primary : AppColors.outline,
              size: 16.sp),
          Gap(6.w),
          _Avatar(bgColor: compColor, iconColor: compIconColor, icon: Icons.smart_toy_rounded),
        ],
      );
    }

    // 2, 3, 4 players — show person avatars with spacing
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(count, (i) {
        return Padding(
          padding: EdgeInsets.only(right: i < count - 1 ? 6.w : 0),
          child: _Avatar(
            bgColor: bgColor,
            iconColor: iconColor,
            icon: Icons.person_rounded,
          ),
        );
      }),
    );
  }
}

// ─── Single Avatar ───────────────────────────────────────────────────────────

class _Avatar extends StatelessWidget {
  final Color bgColor;
  final Color iconColor;
  final IconData icon;

  const _Avatar({
    required this.bgColor,
    required this.iconColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32.w,
      height: 32.h,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: iconColor, size: 18.sp),
    );
  }
}

// ─── Custom Player Input ──────────────────────────────────────────────────────

class _CustomPlayerInput extends StatelessWidget {
  final PlayerSelectionController ctrl;
  const _CustomPlayerInput({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.outlineVariant),
        boxShadow: [
          BoxShadow(
              color: AppColors.shadow,
              blurRadius: 20,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText.labelLg(
            AppStrings.customPlayersLabel,
            color: AppColors.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
          Gap(8.h),
          CustomTextField(
            controller: ctrl.customController,
            hintText: AppStrings.customPlayersHint,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            maxLength: 2,
            onChanged: ctrl.onCustomChanged,
            suffixIcon:
            Icon(Icons.edit_rounded, color: AppColors.outline, size: 18.sp),
          ),
          Gap(8.h),
          CustomText.labelSm(
            AppStrings.maxPlayersNote,
            color: AppColors.outline,
          ),
        ],
      ),
    );
  }
}