import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/app_bar_widget.dart';
import '../../../core/widgets/custom_text.dart';
import '../controller/level_selection_controller.dart';

class LevelSelectionScreen extends StatelessWidget {
  const LevelSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<LevelSelectionController>();
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppBarWidget(showBackButton: true),
      body: SafeArea(
        child: Column(
          children: [
            Gap(20.h),
            // ─── Progress Header ───
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Container(
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: AppColors.primary.withOpacity(0.15)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText.labelLg(
                          "Your Progress",
                          color: AppColors.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                        Obx(() => CustomText.titleMd(
                          "Unlocked: ${ctrl.unlockedCount} / ${ctrl.totalLevels}",
                          color: AppColors.primary,
                          fontWeight: FontWeight.w800,
                        )),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.all(10.r),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.stars_rounded, color: AppColors.primary, size: 28.sp),
                    ),
                  ],
                ),
              ),
            ),
            Gap(12.h),
            // ─── Current Level Badge ───
            Obx(() => Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: CustomText.labelLg(
                    "Current Target: Level ${ctrl.highestUnlocked.value}",
                    color: AppColors.secondary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            )),
            Gap(12.h),
            // ─── Scrollable Level Grid ───
            Expanded(
              child: Obx(
                () {
                  // Explicitly access reactive variables to register dependency with Obx
                  final highest = ctrl.highestUnlocked.value;
                  final _ = ctrl.completedLevels.length;
                  
                  return GridView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                    physics: const BouncingScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 12.w,
                      mainAxisSpacing: 12.h,
                      childAspectRatio: 0.9,
                    ),
                    itemCount: ctrl.totalLevels,
                    itemBuilder: (context, index) {
                      final level = index + 1;
                      final isLocked = ctrl.isLocked(level);
                      final isCompleted = ctrl.isCompleted(level);
                      final isCurrent = ctrl.isCurrent(level);

                      return _LevelCard(
                        level: level,
                        isLocked: isLocked,
                        isCompleted: isCompleted,
                        isCurrent: isCurrent,
                        onTap: () => ctrl.selectLevel(level),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LevelCard extends StatelessWidget {
  final int level;
  final bool isLocked;
  final bool isCompleted;
  final bool isCurrent;
  final VoidCallback onTap;

  const _LevelCard({
    required this.level,
    required this.isLocked,
    required this.isCompleted,
    required this.isCurrent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: isLocked
              ? AppColors.surfaceContainer
              : isCurrent
                  ? AppColors.primary
                  : AppColors.white,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isCurrent 
                ? AppColors.primary 
                : isCompleted 
                    ? AppColors.secondary.withOpacity(0.5) 
                    : AppColors.outlineVariant,
            width: isCurrent ? 3 : 1.5,
          ),
          boxShadow: [
            if (!isLocked)
              BoxShadow(
                color: isCurrent
                    ? AppColors.primary.withOpacity(0.3)
                    : AppColors.shadow,
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isLocked)
                    Icon(Icons.lock_rounded,
                        color: AppColors.outline.withOpacity(0.6), size: 24.sp)
                  else ...[
                    CustomText(
                      level.toString().padLeft(3, '0'),
                      color: isCurrent ? AppColors.white : AppColors.onSurface,
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                    if (isCurrent && !isCompleted)
                       Padding(
                         padding: EdgeInsets.only(top: 4.h),
                         child: CustomText.labelSm(
                           "PLAY",
                           color: AppColors.white.withOpacity(0.9),
                           fontWeight: FontWeight.w900,
                           letterSpacing: 1.2,
                         ),
                       ),
                  ],
                ],
              ),
            ),
            if (isCompleted)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: AppColors.secondary,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.check, color: AppColors.white, size: 10.sp),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
