import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/app_bar_widget.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text.dart';
import '../controller/winner_controller.dart';

class WinnerScreen extends StatelessWidget {
  const WinnerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<WinnerController>();
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppBarWidget(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Gap(32.h),
              _TrophySection(ctrl: ctrl),
              Gap(32.h),
              _StatsGrid(ctrl: ctrl),
              Gap(24.h),
              _RecentWords(ctrl: ctrl),
              Gap(32.h),
              CustomButton(
                label: AppStrings.playAgain,
                onTap: ctrl.playAgain,
                trailing: Icon(Icons.replay_rounded, color: AppColors.onPrimary, size: 20.sp),
              ),
              Gap(12.h),
              CustomButton(
                label: AppStrings.home,
                onTap: ctrl.goHome,
                variant: ButtonVariant.outline,
              ),
              Gap(32.h),
            ],
          ),
        ),
      ),
    );
  }
}

class _TrophySection extends StatelessWidget {
  final WinnerController ctrl;
  const _TrophySection({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 100.w,
          height: 100.h,
          decoration: BoxDecoration(
            color: AppColors.secondaryContainer,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.secondary.withOpacity(0.25),
                blurRadius: 32,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Icon(Icons.emoji_events_rounded, color: AppColors.onSecondaryContainer, size: 48.sp),
        ),
        Gap(20.h),
        CustomText.displayLg(
          AppStrings.congratulations,
          color: AppColors.primary,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.5,
          textAlign: TextAlign.center,
        ),
        Gap(8.h),
        CustomText.headlineSm(
          '${ctrl.winnerName}${AppStrings.isWinner}',
          color: AppColors.onSurfaceVariant,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _StatsGrid extends StatelessWidget {
  final WinnerController ctrl;
  const _StatsGrid({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _FinalScoreCard(ctrl: ctrl),
        Gap(12.h),
        Row(
          children: [
            Expanded(child: _StatCard(
              icon: Icons.track_changes_rounded,
              iconColor: AppColors.secondary,
              label: AppStrings.accuracy,
              value: '${ctrl.accuracy}%',
              extra: LinearProgressIndicator(
                value: ctrl.accuracy / 100,
                backgroundColor: AppColors.surfaceContainerHighest,
                color: AppColors.secondary,
                minHeight: 6.h,
                borderRadius: BorderRadius.circular(4.r),
              ),
            )),
            Gap(12.w),
            Expanded(child: _StatCard(
              icon: Icons.auto_stories_rounded,
              iconColor: AppColors.tertiary,
              label: AppStrings.bestWord,
              value: ctrl.bestWord,
              valueFontSize: ctrl.bestWord.length > 6 ? 16 : 20,
            )),
          ],
        ),
        Gap(12.h),
        _StatCard(
          icon: Icons.timer_rounded,
          iconColor: AppColors.onSurfaceVariant,
          label: AppStrings.gameDuration,
          value: ctrl.duration,
          isFullWidth: true,
        ),
      ],
    );
  }
}

class _FinalScoreCard extends StatelessWidget {
  final WinnerController ctrl;
  const _FinalScoreCard({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.outlineVariant),
        boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 20, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText.labelLg(
            AppStrings.finalScore.toUpperCase(),
            color: AppColors.onSurfaceVariant,
            letterSpacing: 1.5,
            fontWeight: FontWeight.w600,
          ),
          Gap(4.h),
          CustomText.displayLg(
            '${ctrl.winnerScore}',
            color: AppColors.primary,
            fontWeight: FontWeight.w800,
          ),
          Gap(8.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: AppColors.secondaryContainer,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.trending_up_rounded, color: AppColors.onSecondaryContainer, size: 16.sp),
                Gap(4.w),
                CustomText.labelLg(
                  AppStrings.newPersonalBest,
                  color: AppColors.onSecondaryContainer,
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final Widget? extra;
  final bool isFullWidth;
  final double? valueFontSize;

  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    this.extra,
    this.isFullWidth = false,
    this.valueFontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isFullWidth ? double.infinity : null,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.outlineVariant),
        boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 12, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 18.sp),
              Gap(6.w),
              CustomText.labelLg(label, color: AppColors.onSurfaceVariant),
            ],
          ),
          Gap(8.h),
          CustomText(
            value,
            fontSize: valueFontSize ?? 22,
            fontWeight: FontWeight.w700,
            color: AppColors.onSurface,
          ),
          if (extra != null) ...[Gap(8.h), extra!],
        ],
      ),
    );
  }
}

class _RecentWords extends StatelessWidget {
  final WinnerController ctrl;
  const _RecentWords({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    if (ctrl.usedWords.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText.labelLg(
          AppStrings.recentWords,
          color: AppColors.onSurfaceVariant,
          fontWeight: FontWeight.w600,
        ),
        Gap(12.h),
        SizedBox(
          height: 90.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: ctrl.usedWords.length,
            separatorBuilder: (_, __) => Gap(8.w),
            itemBuilder: (_, i) {
              final word = ctrl.usedWords[ctrl.usedWords.length - 1 - i];
              final isHighlighted = i == 0;
              return Container(
                width: 90.w,
                decoration: BoxDecoration(
                  color: isHighlighted ? AppColors.primary : AppColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: isHighlighted ? AppColors.primary : AppColors.outlineVariant),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText.headlineSm(
                      word[0].toUpperCase(),
                      color: isHighlighted ? AppColors.onPrimaryContainer : AppColors.onSurface,
                      fontWeight: FontWeight.w800,
                    ),
                    CustomText.labelSm(
                      word.toUpperCase(),
                      color: isHighlighted ? AppColors.onPrimary : AppColors.secondary,
                      fontWeight: FontWeight.w600,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
