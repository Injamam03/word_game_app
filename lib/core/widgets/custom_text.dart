import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/app_colors.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;
  final double? height;
  final double? letterSpacing;
  final TextDecoration? decoration;
  final bool softWrap;

  const CustomText(
    this.text, {
    super.key,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.textAlign,
    this.overflow,
    this.maxLines,
    this.height,
    this.letterSpacing,
    this.decoration,
    this.softWrap = true,
  });

  const CustomText.displayLg(this.text, {super.key, this.color, this.fontWeight, this.textAlign, this.overflow, this.maxLines, this.height, this.letterSpacing, this.decoration, this.softWrap = true}) : fontSize = 40;

  const CustomText.headlineLg(this.text, {super.key, this.color, this.fontWeight, this.textAlign, this.overflow, this.maxLines, this.height, this.letterSpacing, this.decoration, this.softWrap = true}) : fontSize = 32;

  const CustomText.headlineMd(this.text, {super.key, this.color, this.fontWeight, this.textAlign, this.overflow, this.maxLines, this.height, this.letterSpacing, this.decoration, this.softWrap = true}) : fontSize = 24;

  const CustomText.headlineSm(this.text, {super.key, this.color, this.fontWeight, this.textAlign, this.overflow, this.maxLines, this.height, this.letterSpacing, this.decoration, this.softWrap = true}) : fontSize = 20;

  const CustomText.titleLg(this.text, {super.key, this.color, this.fontWeight, this.textAlign, this.overflow, this.maxLines, this.height, this.letterSpacing, this.decoration, this.softWrap = true}) : fontSize = 18;

  const CustomText.titleMd(this.text, {super.key, this.color, this.fontWeight, this.textAlign, this.overflow, this.maxLines, this.height, this.letterSpacing, this.decoration, this.softWrap = true}) : fontSize = 16;

  const CustomText.bodyLg(this.text, {super.key, this.color, this.fontWeight, this.textAlign, this.overflow, this.maxLines, this.height, this.letterSpacing, this.decoration, this.softWrap = true}) : fontSize = 18;

  const CustomText.bodyMd(this.text, {super.key, this.color, this.fontWeight, this.textAlign, this.overflow, this.maxLines, this.height, this.letterSpacing, this.decoration, this.softWrap = true}) : fontSize = 16;

  const CustomText.bodySm(this.text, {super.key, this.color, this.fontWeight, this.textAlign, this.overflow, this.maxLines, this.height, this.letterSpacing, this.decoration, this.softWrap = true}) : fontSize = 14;

  const CustomText.labelLg(this.text, {super.key, this.color, this.fontWeight, this.textAlign, this.overflow, this.maxLines, this.height, this.letterSpacing, this.decoration, this.softWrap = true}) : fontSize = 14;

  const CustomText.labelSm(this.text, {super.key, this.color, this.fontWeight, this.textAlign, this.overflow, this.maxLines, this.height, this.letterSpacing, this.decoration, this.softWrap = true}) : fontSize = 12;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
      softWrap: softWrap,
      style: TextStyle(
        fontSize: (fontSize ?? 14).sp,
        fontWeight: fontWeight ?? FontWeight.w400,
        color: color ?? AppColors.onSurface,
        height: height,
        letterSpacing: letterSpacing,
        decoration: decoration,
      ),
    );
  }
}
