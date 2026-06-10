import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text.dart';
import '../controller/winner_controller.dart';

class WinnerScreen extends StatefulWidget {
  const WinnerScreen({super.key});

  @override
  State<WinnerScreen> createState() => _WinnerScreenState();
}

class _WinnerScreenState extends State<WinnerScreen>
    with TickerProviderStateMixin {
  late ConfettiController _confettiLeft;
  late ConfettiController _confettiRight;
  late ConfettiController _confettiCenter;
  late AnimationController _scaleController;
  late AnimationController _fadeController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _confettiLeft = ConfettiController(duration: const Duration(seconds: 6))..play();
    _confettiRight = ConfettiController(duration: const Duration(seconds: 6))..play();
    _confettiCenter = ConfettiController(duration: const Duration(seconds: 4))..play();

    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    );

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );

    _fadeController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      _scaleController.forward();
    });
  }

  @override
  void dispose() {
    _confettiLeft.dispose();
    _confettiRight.dispose();
    _confettiCenter.dispose();
    _scaleController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<WinnerController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          SafeArea(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Gap(48.h),
                    _TrophySection(ctrl: ctrl, scaleAnimation: _scaleAnimation),
                    Gap(32.h),
                    _StatsGrid(ctrl: ctrl),
                    Gap(24.h),
                    _RecentWords(ctrl: ctrl),
                    Gap(32.h),
                    CustomButton(
                      label: ctrl.levelCompleted ? AppStrings.next : AppStrings.playAgain,
                      onTap: ctrl.playAgain,
                      trailing: Icon(
                        ctrl.levelCompleted ? Icons.arrow_forward_rounded : Icons.replay_rounded,
                        color: AppColors.onPrimary,
                        size: 20.sp,
                      ),
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
          ),

          Align(
            alignment: Alignment.topLeft,
            child: ConfettiWidget(
              confettiController: _confettiLeft,
              blastDirection: 0.5,
              emissionFrequency: 0.05,
              numberOfParticles: 20,
              maxBlastForce: 30,
              minBlastForce: 10,
              gravity: 0.2,
              colors: const [AppColors.primary, AppColors.secondary, Color(0xFFFFD700)],
            ),
          ),

          Align(
            alignment: Alignment.topRight,
            child: ConfettiWidget(
              confettiController: _confettiRight,
              blastDirection: 2.5,
              emissionFrequency: 0.05,
              numberOfParticles: 20,
              maxBlastForce: 30,
              minBlastForce: 10,
              gravity: 0.2,
              colors: const [AppColors.primary, AppColors.secondary, Color(0xFFFFD700)],
            ),
          ),

          Align(
            alignment: const Alignment(0, -0.3),
            child: ConfettiWidget(
              confettiController: _confettiCenter,
              blastDirectionality: BlastDirectionality.explosive,
              emissionFrequency: 0.03,
              numberOfParticles: 30,
              maxBlastForce: 50,
              minBlastForce: 20,
              gravity: 0.3,
              colors: const [AppColors.primary, AppColors.secondary, Color(0xFFFFD700)],
            ),
          ),
        ],
      ),
    );
  }
}

class _TrophySection extends StatelessWidget {
  final WinnerController ctrl;
  final Animation<double> scaleAnimation;

  const _TrophySection({
    required this.ctrl,
    required this.scaleAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ScaleTransition(
          scale: scaleAnimation,
          child: Container(
            width: 120.w,
            height: 120.h,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.primary, Color(0xFFFFA500), AppColors.primary],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.4),
                  blurRadius: 40,
                  spreadRadius: 5,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Icon(
              ctrl.levelCompleted ? Icons.military_tech_rounded : Icons.emoji_events_rounded,
              color: AppColors.white,
              size: 60.sp,
            ),
          ),
        ),

        Gap(24.h),

        CustomText.displayLg(
          ctrl.levelCompleted ? AppStrings.levelCompleted : AppStrings.congratulations,
          color: AppColors.primary,
          fontWeight: FontWeight.w800,
          textAlign: TextAlign.center,
        ),

        Gap(12.h),

        Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: AppColors.primaryFixed,
            borderRadius: BorderRadius.circular(30.r),
          ),
          child: CustomText.headlineSm(
            ctrl.levelCompleted 
                ? '${AppStrings.level} ${ctrl.level.toString().padLeft(2, '0')} Mastered!'
                : '${ctrl.winnerName}${AppStrings.isWinner}',
            color: AppColors.primary,
            fontWeight: FontWeight.w700,
            textAlign: TextAlign.center,
          ),
        ),
        
        if (ctrl.levelCompleted) ...[
          Gap(12.h),
          CustomText.bodyMd(
            AppStrings.nextLevelUnlocked,
            color: AppColors.secondary,
            fontWeight: FontWeight.w700,
          ),
        ],
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
            Expanded(
              child: _StatCard(
                icon: Icons.article_rounded,
                iconColor: AppColors.secondary,
                label: ctrl.levelCompleted ? AppStrings.totalWordsTyped : AppStrings.accuracy,
                value: ctrl.levelCompleted ? '${ctrl.totalWords}' : '${ctrl.accuracy}%',
              ),
            ),
            Gap(12.w),
            Expanded(
              child: _StatCard(
                icon: Icons.auto_stories_rounded,
                iconColor: AppColors.tertiary,
                label: AppStrings.bestWord,
                value: ctrl.bestWord,
              ),
            ),
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
  final bool isFullWidth;

  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    this.isFullWidth = false,
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
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.onSurface,
            overflow: TextOverflow.ellipsis,
          ),
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
            separatorBuilder: (_, _) => Gap(8.w),
            itemBuilder: (_, i) {
              final word = ctrl.usedWords[ctrl.usedWords.length - 1 - i];
              return Container(
                width: 90.w,
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: AppColors.outlineVariant),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText.headlineSm(
                      word[0].toUpperCase(),
                      color: AppColors.primary,
                      fontWeight: FontWeight.w800,
                    ),
                    CustomText.labelSm(
                      word.toUpperCase(),
                      color: AppColors.onSurface,
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
