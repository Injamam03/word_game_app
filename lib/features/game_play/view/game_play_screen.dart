import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../controller/game_play_controller.dart';

class GamePlayScreen extends StatelessWidget {
  const GamePlayScreen({super.key});

  @override

  Widget build(BuildContext context) {
    final ctrl = Get.find<GamePlayController>();
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _GameAppBar(ctrl: ctrl),
      body: SafeArea(
        child: Column(
          children: [
            _PlayerRow(ctrl: ctrl),
            _TurnIndicator(ctrl: ctrl),
            // ✅ error banner
            Obx(() => ctrl.showError.value
                ? _ErrorBanner(ctrl: ctrl)
                : const SizedBox.shrink()),
            // ✅ computer word banner
            Obx(() => (ctrl.players.any((p) => p.isComputer) &&
                ctrl.computerLastWord.value.isNotEmpty)
                ? _ComputerWordBanner(ctrl: ctrl)
                : const SizedBox.shrink()),
            // ✅ player word columns — Expanded দিয়ে বাকি space নেবে
            Expanded(
              child: _PlayerWordsArea(ctrl: ctrl),
            ),
            // ✅ required letter — Obx সরিয়ে widget এর ভেতরে রাখা হয়েছে
            _RequiredLetterHint(ctrl: ctrl),
            _InputArea(ctrl: ctrl),
            Gap(24.h),
          ],
        ),
      ),
    );
  }
}

// ─── AppBar ──────────────────────────────────────────────────────────────────

class _GameAppBar extends StatelessWidget implements PreferredSizeWidget {
  final GamePlayController ctrl;
  const _GameAppBar({required this.ctrl});

  @override
  Size get preferredSize => Size.fromHeight(56.h);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.surface,
      elevation: 0,
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Icon(Icons.arrow_back_rounded,
                color: AppColors.primary, size: 24.sp),
          ),
          Gap(12.w),
          CustomText.headlineSm(AppStrings.appName,
              color: AppColors.primary, fontWeight: FontWeight.w800),
        ],
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 16.w),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: AppColors.primaryFixed,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Obx(() => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.timer_rounded,
                    color: AppColors.primary, size: 14.sp),
                Gap(4.w),
                CustomText.labelLg(ctrl.formattedTime,
                    color: AppColors.primary, fontWeight: FontWeight.w700),
              ],
            )),
          ),
        ),
      ],
    );
  }
}

// ─── Player Row ───────────────────────────────────────────────────────────────
// ✅ Horizontal scroll, fixed card size, word count instead of pts

class _PlayerRow extends StatelessWidget {
  final GamePlayController ctrl;
  const _PlayerRow({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: ctrl.players.map((player) {
            return Padding(
              padding: EdgeInsets.only(right: 8.w),
              // ✅ Obx শুধু card এর ভেতরে, বাইরে না
              child: _PlayerCard(player: player),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _PlayerCard extends StatelessWidget {
  final PlayerModel player;
  const _PlayerCard({required this.player});

  @override
  Widget build(BuildContext context) {
    // ✅ একটাই Obx, nested Obx নেই
    return Obx(() {
      final isActive = player.isActive.value;
      final isEliminated = player.isEliminated.value;
      final wordCount = player.wordCount.value;

      return Opacity(
        opacity: isEliminated ? 0.4 : 1.0,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 88.w,
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.primaryFixed
                : AppColors.surfaceContainer,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: isActive ? AppColors.primary : AppColors.transparent,
              width: isActive ? 2 : 0,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isEliminated)
                    Icon(Icons.cancel_rounded,
                        color: AppColors.error, size: 11.sp)
                  else if (isActive)
                    Icon(Icons.play_arrow_rounded,
                        color: AppColors.primary, size: 11.sp),
                  Flexible(
                    child: CustomText.labelSm(
                      player.name,
                      color: isActive
                          ? AppColors.primary
                          : AppColors.onSurfaceVariant,
                      fontWeight:
                      isActive ? FontWeight.w700 : FontWeight.w500,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              Gap(3.h),
              // ✅ "0 word" / "1 word" / "2 words"
              CustomText.labelSm(
                '$wordCount ${wordCount == 1 ? 'word' : 'words'}',
                color: isActive ? AppColors.primary : AppColors.outline,
                fontWeight: FontWeight.w600,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    });
  }
}

// ─── Turn Indicator ───────────────────────────────────────────────────────────

class _TurnIndicator extends StatelessWidget {
  final GamePlayController ctrl;
  const _TurnIndicator({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.outlineVariant),
        boxShadow: [
          BoxShadow(
              color: AppColors.shadow,
              blurRadius: 8,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.play_arrow_rounded,
              color: AppColors.primary, size: 18.sp),
          Gap(8.w),
          CustomText.titleMd(
            '${AppStrings.nowPlaying}${ctrl.currentPlayer.name}',
            color: AppColors.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ],
      ),
    ));
  }
}

// ─── Error Banner ─────────────────────────────────────────────────────────────

class _ErrorBanner extends StatelessWidget {
  final GamePlayController ctrl;
  const _ErrorBanner({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColors.errorContainer,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.error.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.warning_rounded, color: AppColors.error, size: 18.sp),
          Gap(8.w),
          Expanded(
            child: CustomText.bodySm(
              ctrl.errorMessage.value,
              color: AppColors.error,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Computer Word Banner ─────────────────────────────────────────────────────

class _ComputerWordBanner extends StatelessWidget {
  final GamePlayController ctrl;
  const _ComputerWordBanner({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColors.secondaryContainer.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.secondaryContainer),
      ),
      child: Row(
        children: [
          Icon(Icons.smart_toy_rounded,
              color: AppColors.secondary, size: 18.sp),
          Gap(8.w),
          CustomText.bodySm('Computer played: ',
              color: AppColors.onSurfaceVariant),
          CustomText.bodyMd(
            ctrl.computerLastWord.value.toUpperCase(),
            color: AppColors.secondary,
            fontWeight: FontWeight.w700,
          ),
        ],
      ),
    );
  }
}

// ─── Player Words Area ────────────────────────────────────────────────────────
// ✅ Obx নেই বাইরে — প্রতিটা column নিজে reactive

class _PlayerWordsArea extends StatelessWidget {
  final GamePlayController ctrl;
  const _PlayerWordsArea({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: ctrl.players.map((player) {
        return Expanded(child: _PlayerWordColumn(player: player));
      }).toList(),
    );
  }
}

class _PlayerWordColumn extends StatelessWidget {
  final PlayerModel player;
  const _PlayerWordColumn({required this.player});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ─── Name Header with underline ───
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 8.h),
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: AppColors.primary, width: 2),
            ),
          ),
          child: CustomText.labelSm(
            player.name,
            color: AppColors.onSurface,
            fontWeight: FontWeight.w700,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        // ─── Word List ───
        Expanded(
          // ✅ শুধু word list Obx এ
          child: Obx(() {
            if (player.myWords.isEmpty) {
              return Padding(
                padding: EdgeInsets.only(top: 12.h),
                child: CustomText.labelSm(
                  '—',
                  color: AppColors.outline,
                  textAlign: TextAlign.center,
                ),
              );
            }
            return ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 8.h),
              itemCount: player.myWords.length,
              itemBuilder: (_, i) {
                // সবচেয়ে নতুন word উপরে
                final word = player.myWords[player.myWords.length - 1 - i];
                final isLatest = i == 0;
                return Container(
                  margin: EdgeInsets.only(bottom: 6.h),
                  padding:
                  EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
                  decoration: BoxDecoration(
                    color: isLatest
                        ? AppColors.primaryFixed
                        : AppColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      color: isLatest
                          ? AppColors.primary
                          : AppColors.outlineVariant,
                    ),
                  ),
                  child: CustomText.labelSm(
                    word.toUpperCase(),
                    color: isLatest ? AppColors.primary : AppColors.onSurface,
                    fontWeight:
                    isLatest ? FontWeight.w700 : FontWeight.w500,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              },
            );
          }),
        ),
      ],
    );
  }
}

// ─── Required Letter Hint ─────────────────────────────────────────────────────

class _RequiredLetterHint extends StatelessWidget {
  final GamePlayController ctrl;
  const _RequiredLetterHint({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    // ✅ Obx ভেতরে, widget বাইরে
    return Obx(() {
      if (ctrl.requiredLetter.value.isEmpty) return const SizedBox.shrink();
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 6.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomText.bodyMd(
              AppStrings.nextWordStartsWith,
              color: AppColors.onSurfaceVariant,
            ),
            Gap(8.w),
            Container(
              width: 34.w,
              height: 34.h,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Center(
                child: CustomText.headlineSm(
                  ctrl.requiredLetter.value,
                  color: AppColors.onPrimary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

// ─── Input Area ───────────────────────────────────────────────────────────────

class _InputArea extends StatelessWidget {
  final GamePlayController ctrl;
  const _InputArea({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Obx(() {
        final isComputerTurn = ctrl.currentPlayer.isComputer;
        final isValidating = ctrl.isValidating.value;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextField(
              controller: ctrl.wordController,
              hintText: isComputerTurn
                  ? 'Computer is thinking...'
                  : 'Type your word...',
              enabled: !isComputerTurn && !isValidating,
              textCapitalization: TextCapitalization.words,
              onSubmitted: (_) => ctrl.submitWord(),
              textInputAction: TextInputAction.done,
            ),
            Gap(10.h),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    label: AppStrings.stop,
                    onTap: isComputerTurn || isValidating
                        ? null
                        : ctrl.stopPlayer,
                    variant: ButtonVariant.outline,
                    height: 50.h,
                  ),
                ),
                Gap(10.w),
                Expanded(
                  flex: 2,
                  child: CustomButton(
                    label:
                    isValidating ? 'Checking...' : AppStrings.submitWord,
                    onTap: isComputerTurn || isValidating
                        ? null
                        : ctrl.submitWord,
                    isLoading: isValidating,
                    height: 50.h,
                    trailing: isValidating
                        ? null
                        : Icon(Icons.check_rounded,
                        color: AppColors.onPrimary, size: 20.sp),
                  ),
                ),
              ],
            ),
          ],
        );
      }),
    );
  }
}