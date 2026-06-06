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
              CustomText.headlineLg(
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
                trailing: Icon(Icons.arrow_forward_rounded, color: AppColors.onPrimary, size: 20.sp),
              )),
              Gap(24.h),
            ],
          ),
        ),
      ),
    );
  }
}

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
        childAspectRatio: 1.4,
      ),
      itemCount: ctrl.modes.length,
      itemBuilder: (_, i) {
        final isSelected = ctrl.selectedMode.value == i;
        final mode = ctrl.modes[i];
        return GestureDetector(
          onTap: () => ctrl.selectMode(i),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primaryFixed : AppColors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.outlineVariant,
                width: isSelected ? 2 : 1,
              ),
              boxShadow: [
                BoxShadow(color: AppColors.shadow, blurRadius: 20, offset: const Offset(0, 4)),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 40.w,
                  height: 40.h,
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : AppColors.primaryFixed,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(
                    mode['icon'] as IconData,
                    color: isSelected ? AppColors.onPrimary : AppColors.primary,
                    size: 22.sp,
                  ),
                ),
                Gap(8.h),
                CustomText.labelSm(
                  mode['label'] as String,
                  color: AppColors.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
                CustomText.titleMd(
                  mode['sub'] as String,
                  color: isSelected ? AppColors.primary : AppColors.onSurface,
                  fontWeight: FontWeight.w700,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

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
          BoxShadow(color: AppColors.shadow, blurRadius: 20, offset: const Offset(0, 4)),
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
            suffixIcon: Icon(Icons.edit_rounded, color: AppColors.outline, size: 18.sp),
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
