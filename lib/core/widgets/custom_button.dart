import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/app_colors.dart';

enum ButtonVariant { primary, secondary, outline, text, danger }

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final ButtonVariant variant;
  final Widget? leading;
  final Widget? trailing;
  final bool isLoading;
  final bool isFullWidth;
  final double? height;
  final double? fontSize;
  final EdgeInsets? padding;
  final BorderRadius? borderRadius;

  const CustomButton({
    super.key,
    required this.label,
    required this.onTap,
    this.variant = ButtonVariant.primary,
    this.leading,
    this.trailing,
    this.isLoading = false,
    this.isFullWidth = true,
    this.height,
    this.fontSize,
    this.padding,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      height: height ?? 56.h,
      child: _buildButton(),
    );
  }

  Widget _buildButton() {
    switch (variant) {
      case ButtonVariant.primary:
        return ElevatedButton(
          onPressed: isLoading ? null : onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.onPrimary,
            elevation: 0,
            padding: padding ?? EdgeInsets.symmetric(horizontal: 24.w),
            shape: RoundedRectangleBorder(
              borderRadius: borderRadius ?? BorderRadius.circular(12.r),
            ),
          ),
          child: _buildChild(AppColors.onPrimary),
        );
      case ButtonVariant.secondary:
        return ElevatedButton(
          onPressed: isLoading ? null : onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.secondaryContainer,
            foregroundColor: AppColors.onSecondaryContainer,
            elevation: 0,
            padding: padding ?? EdgeInsets.symmetric(horizontal: 24.w),
            shape: RoundedRectangleBorder(
              borderRadius: borderRadius ?? BorderRadius.circular(12.r),
            ),
          ),
          child: _buildChild(AppColors.onSecondaryContainer),
        );
      case ButtonVariant.outline:
        return OutlinedButton(
          onPressed: isLoading ? null : onTap,
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.secondary,
            side: const BorderSide(color: AppColors.secondary, width: 2),
            padding: padding ?? EdgeInsets.symmetric(horizontal: 24.w),
            shape: RoundedRectangleBorder(
              borderRadius: borderRadius ?? BorderRadius.circular(12.r),
            ),
          ),
          child: _buildChild(AppColors.secondary),
        );
      case ButtonVariant.text:
        return TextButton(
          onPressed: isLoading ? null : onTap,
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary,
            padding: padding ?? EdgeInsets.symmetric(horizontal: 16.w),
            shape: RoundedRectangleBorder(
              borderRadius: borderRadius ?? BorderRadius.circular(8.r),
            ),
          ),
          child: _buildChild(AppColors.primary),
        );
      case ButtonVariant.danger:
        return ElevatedButton(
          onPressed: isLoading ? null : onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.error,
            foregroundColor: AppColors.onError,
            elevation: 0,
            padding: padding ?? EdgeInsets.symmetric(horizontal: 24.w),
            shape: RoundedRectangleBorder(
              borderRadius: borderRadius ?? BorderRadius.circular(12.r),
            ),
          ),
          child: _buildChild(AppColors.onError),
        );
    }
  }

  Widget _buildChild(Color contentColor) {
    if (isLoading) {
      return SizedBox(
        width: 22.w,
        height: 22.h,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          color: contentColor,
        ),
      );
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (leading != null) ...[leading!, SizedBox(width: 8.w)],
        Text(
          label,
          style: TextStyle(
            fontSize: (fontSize ?? 16).sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        if (trailing != null) ...[SizedBox(width: 8.w), trailing!],
      ],
    );
  }
}
