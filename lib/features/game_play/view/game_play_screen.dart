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
            // ✅ Obx শুধু error banner এর জন্য আলাদা
             ctrl.showError.value
                ? _ErrorBanner(ctrl: ctrl)
                : const SizedBox.shrink(),
            // ✅ WordChain Obx এ আলাদা
            _WordChainArea(ctrl: ctrl),
            const Spacer(),
            // ✅ RequiredLetter Obx এ আলাদা
           _RequiredLetterHint(ctrl: ctrl),
            _InputArea(ctrl: ctrl),
            Gap(24.h),
          ],
        ),
      ),
    );
  }
}

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
            child: Icon(Icons.arrow_back_rounded, color: AppColors.primary, size: 24.sp),
          ),
          Gap(12.w),
          CustomText.headlineSm(
            AppStrings.appName,
            color: AppColors.primary,
            fontWeight: FontWeight.w800,
          ),
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
            // ✅ শুধু timer Obx এ
            child: Obx(() => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.timer_rounded, color: AppColors.primary, size: 14.sp),
                Gap(4.w),
                CustomText.labelLg(
                  ctrl.formattedTime,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ],
            )),
          ),
        ),
      ],
    );
  }
}

class _PlayerRow extends StatelessWidget {
  final GamePlayController ctrl;
  const _PlayerRow({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      child: Row(
        children: ctrl.players.asMap().entries.map((e) {
          final player = e.value;
          // ✅ প্রতিটা card আলাদা Obx এ
          return Expanded(
            child:  _PlayerCard(player: player),
          );
        }).toList(),
      ),
    );
  }
}

class _PlayerCard extends StatelessWidget {
  final PlayerModel player;
  const _PlayerCard({required this.player});

  @override
  Widget build(BuildContext context) {
    final isActive = player.isActive.value;
    final isEliminated = player.isEliminated.value;

    return Opacity(
      opacity: isEliminated ? 0.4 : 1.0,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: EdgeInsets.symmetric(horizontal: 4.w),
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primaryFixed : AppColors.surfaceContainer,
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
                  Icon(Icons.cancel_rounded, color: AppColors.error, size: 11.sp)
                else if (isActive)
                  Icon(Icons.play_arrow_rounded, color: AppColors.primary, size: 11.sp),
                Flexible(
                  child: CustomText.labelSm(
                    player.name,
                    color: isActive ? AppColors.primary : AppColors.onSurfaceVariant,
                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            Gap(3.h),
            CustomText.labelSm(
              '${player.score.value}${AppStrings.pts}',
              color: isActive ? AppColors.primary : AppColors.outline,
              fontWeight: FontWeight.w600,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _TurnIndicator extends StatelessWidget {
  final GamePlayController ctrl;
  const _TurnIndicator({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.outlineVariant),
        boxShadow: [
          BoxShadow(color: AppColors.shadow, blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.play_arrow_rounded, color: AppColors.primary, size: 18.sp),
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

class _WordChainArea extends StatelessWidget {
  final GamePlayController ctrl;
  const _WordChainArea({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    if (ctrl.usedWords.isEmpty) {
      return Padding(
        padding: EdgeInsets.all(16.r),
        child: CustomText.bodyMd(
          'Start the word chain!',
          color: AppColors.onSurfaceVariant,
          textAlign: TextAlign.center,
        ),
      );
    }

    return SizedBox(
      height: 80.h,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 6.h),
        scrollDirection: Axis.horizontal,
        reverse: true,
        itemCount: ctrl.usedWords.length,
        separatorBuilder: (_, __) => Gap(8.w),
        itemBuilder: (_, i) {
          final word = ctrl.usedWords[ctrl.usedWords.length - 1 - i];
          final isLast = i == 0;
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: isLast ? AppColors.primary : AppColors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: isLast ? AppColors.primary : AppColors.outlineVariant,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText.labelSm(
                  word[0].toUpperCase(),
                  color: isLast ? AppColors.onPrimaryContainer : AppColors.secondary,
                  fontWeight: FontWeight.w700,
                ),
                CustomText.titleMd(
                  word.toUpperCase(),
                  color: isLast ? AppColors.onPrimary : AppColors.onSurface,
                  fontWeight: FontWeight.w700,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _RequiredLetterHint extends StatelessWidget {
  final GamePlayController ctrl;
  const _RequiredLetterHint({required this.ctrl});

  @override
  Widget build(BuildContext context) {
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
  }
}

class _InputArea extends StatelessWidget {
  final GamePlayController ctrl;
  const _InputArea({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      // ✅ শুধু input area Obx এ, পুরো Column না
      child: Obx(() {
        final isComputerTurn = ctrl.currentPlayer.isComputer;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextField(
              controller: ctrl.wordController,
              hintText: isComputerTurn
                  ? 'Computer is thinking...'
                  : 'Type your word...',
              enabled: !isComputerTurn,
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
                    onTap: isComputerTurn ? null : ctrl.stopPlayer,
                    variant: ButtonVariant.outline,
                    height: 50.h,
                  ),
                ),
                Gap(10.w),
                Expanded(
                  flex: 2,
                  child: CustomButton(
                    label: AppStrings.submitWord,
                    onTap: isComputerTurn ? null : ctrl.submitWord,
                    height: 50.h,
                    trailing: Icon(
                      Icons.check_rounded,
                      color: AppColors.onPrimary,
                      size: 20.sp,
                    ),
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