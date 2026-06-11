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
      // Ensures UI resizes for keyboard instead of overflowing
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            //  horizontal scroll player row
            _PlayerRow(ctrl: ctrl),
            _TurnIndicator(ctrl: ctrl),
            
            // NOTE: UI Error Banner removed to prevent vertical layout shifts 
            // and RenderFlex overflows when keyboard is open.
            // Errors are now handled exclusively by floating Snackbars.

            // Computer Word Banner Obx
            Obx(() {
              final computerWord = ctrl.computerLastWord.value;
              final hasComputer = ctrl.players.any((p) => p.isComputer);
              return (hasComputer && computerWord.isNotEmpty)
                  ? _ComputerWordBanner(ctrl: ctrl)
                  : const SizedBox.shrink();
            }),

            // ✅ player word columns — horizontal scroll
            Expanded(
              child: _PlayerWordsArea(ctrl: ctrl),
            ),
            _RequiredLetterHint(ctrl: ctrl),
            _InputArea(ctrl: ctrl),
            Gap(16.h),
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
            child: Obx(() {
              final _ = ctrl.elapsedSeconds.value; 
              final time = ctrl.formattedTime;
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.timer_rounded,
                      color: AppColors.primary, size: 14.sp),
                  Gap(4.w),
                  CustomText.labelLg(time,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }
}

// ─── Player Row — Horizontal Scroll ──────────────────────────────────────────

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
              color: isActive ? AppColors.primary : AppColors.primaryContainer,
              width: isActive ? 2 : 1,
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
                    child: CustomText.labelLg(
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
              CustomText.labelLg(
                '$wordCount ${wordCount == 1 ? "word" : "words"}',
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
    return Obx(() {
      final index = ctrl.currentPlayerIndex.value;
      final currentPlayerName = ctrl.players[index].name;
      return Container(
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
              '${AppStrings.nowPlaying}$currentPlayerName',
              color: AppColors.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ],
        ),
      );
    });
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
        color: AppColors.secondaryContainer.withAlpha(60),
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
            ctrl.computerLastWord.value.isNotEmpty
                ? "${ctrl.computerLastWord.value[0].toUpperCase()}${ctrl.computerLastWord.value.substring(1).toLowerCase()}"
                : ctrl.computerLastWord.value,
            color: AppColors.secondary,
            fontWeight: FontWeight.w700,
          ),
        ],
      ),
    );
  }
}

// ─── Player Words Area — Horizontal Scroll ────────────────────────────────────

class _PlayerWordsArea extends StatelessWidget {
  final GamePlayController ctrl;
  const _PlayerWordsArea({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    final double colWidth = 100.w;
    final double totalWidth = ctrl.players.length * colWidth;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double actualWidth = totalWidth < screenWidth ? screenWidth : totalWidth;

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: actualWidth,
            height: constraints.maxHeight,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: ctrl.players.map((player) {
                return SizedBox(
                  width: actualWidth / ctrl.players.length,
                  height: constraints.maxHeight,
                  child: _PlayerWordColumn(player: player),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}

class _PlayerWordColumn extends StatelessWidget {
  final PlayerModel player;
  const _PlayerWordColumn({required this.player});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 8.h),
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: AppColors.primary, width: 2),
            ),
          ),
          child: CustomText.bodyMd(
            player.name,
            color: AppColors.onSurface,
            fontWeight: FontWeight.w700,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Flexible(
          child: Obx(() {
            final wordList = player.myWords;
            if (wordList.isEmpty) {
              return Padding(
                padding: EdgeInsets.only(top: 12.h),
                child: CustomText.labelSm(
                  "—",
                  color: AppColors.outline,
                  textAlign: TextAlign.center,
                ),
              );
            }
            return ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
              itemCount: wordList.length,
              itemBuilder: (_, i) {
                final word = wordList[wordList.length - 1 - i];
                final isLatest = i == 0;
                return Container(
                  height: 35.h,
                  margin: EdgeInsets.only(bottom: 6.h),
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
                  decoration: BoxDecoration(
                    color: isLatest
                        ? AppColors.primaryFixed
                        : AppColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(
                      color: isLatest
                          ? AppColors.primary
                          : AppColors.outlineVariant,
                    ),
                  ),
                  child: CustomText.bodyMd(
                    word.isNotEmpty
                        ? "${word[0].toUpperCase()}${word.substring(1).toLowerCase()}"
                        : word,
                    color: isLatest ? AppColors.primary : AppColors.onSurface,
                    fontWeight: isLatest ? FontWeight.w700 : FontWeight.w500,
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
    return Obx(() {
      final requiredLetter = ctrl.requiredLetter.value;
      if (requiredLetter.isEmpty) return const SizedBox.shrink();
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 6.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomText.bodyMd(AppStrings.nextWordStartsWith,
                color: AppColors.onSurfaceVariant),
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
                  requiredLetter.toUpperCase(),
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
        final index = ctrl.currentPlayerIndex.value;
        final isComputerTurn = ctrl.players[index].isComputer;
        final isValidating = ctrl.isValidating.value;
        
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextField(
              controller: ctrl.wordController,
              hintText: isComputerTurn
                  ? "Computer is thinking..."
                  : "Type your word...",
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
                    label: isValidating
                        ? "Checking..."
                        : AppStrings.submitWord,
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
