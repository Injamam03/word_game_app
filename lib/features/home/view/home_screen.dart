import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/app_bar_widget.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppBarWidget(),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(32.h),

              _HeaderSection(),
              Gap(32.h),
              _RulesCard(),
              Gap(24.h),
              _ExampleCard(),
              const Spacer(),
              CustomButton(
                label: AppStrings.startButton,
                onTap: () => Get.toNamed(AppStrings.routePlayerSelection),
                trailing: Icon(Icons.arrow_forward_rounded, color: AppColors.onPrimary, size: 20.sp),
              ),
              Gap(24.h),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeaderSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.center,
          child: Container(
            width: 56.w,
            height: 56.h,
            decoration: BoxDecoration(
              color: AppColors.primaryFixed,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Icon(Icons.sports_esports_rounded, color: AppColors.primary, size: 28.sp),
          ),
        ),
        Gap(16.h),
        Align(
          alignment: Alignment.center,
          child: CustomText.displayLg(
            AppStrings.gameTitle,
            color: AppColors.primary,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
        Gap(8.h),
        Align(
          alignment: Alignment.center,
          child: CustomText.bodyLg(
            AppStrings.howToPlay,
            color: AppColors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _RulesCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.outlineVariant),
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
        children: [
          Row(
            children: [
              Icon(Icons.rule_rounded, color: AppColors.primary, size: 20.sp),
              Gap(8.w),
              CustomText.labelLg(
                'Rules',
                color: AppColors.onSurfaceVariant,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ],
          ),
          Gap(16.h),
          _RuleItem(number: '01', text: AppStrings.rule1),
          Gap(12.h),
          _RuleItem(number: '02', text: AppStrings.rule2),
          Gap(12.h),
          _RuleItem(number: '03', text: AppStrings.rule3),
        ],
      ),
    );
  }
}

class _RuleItem extends StatelessWidget {
  final String number;
  final String text;
  const _RuleItem({required this.number, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 28.w,
          height: 28.h,
          decoration: BoxDecoration(
            color: AppColors.primaryFixed,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: CustomText.labelSm(
              number,
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Gap(12.w),
        Expanded(
          child: CustomText.bodySm(
            text,
            color: AppColors.onSurfaceVariant,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

class _ExampleCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.secondaryContainer.withOpacity(0.25),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.secondaryContainer),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb_rounded, color: AppColors.secondary, size: 18.sp),
              Gap(8.w),
              CustomText.labelLg(
                AppStrings.exampleLabel,
                color: AppColors.secondary,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
          Gap(12.h),
          CustomText.titleMd(
            AppStrings.exampleWords,
            color: AppColors.onBackground,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ],
      ),
    );
  }
}
