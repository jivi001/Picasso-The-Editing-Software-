import 'package:flutter/material.dart';
import 'picasoo_colors.dart';

class PicasooTypography {
  static const String fontFamily = 'Inter';
  static const String monoFontFamily = 'JetBrains Mono';

  static const TextStyle display = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 32 / 24,
    color: PicasooColors.textHigh,
  );

  static const TextStyle h1 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 24 / 18,
    color: PicasooColors.textHigh,
  );

  static const TextStyle h2 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 24 / 16,
    color: PicasooColors.textHigh,
  );

  static const TextStyle body = TextStyle(
    fontFamily: fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 20 / 13,
    color: PicasooColors.textMed,
  );

  static const TextStyle small = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w400,
    height: 16 / 11,
    color: PicasooColors.textMed,
  );

  static const TextStyle mono = TextStyle(
    fontFamily: monoFontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 16 / 12,
    color: PicasooColors.textMed,
  );

  static const TextStyle button = TextStyle(
    fontFamily: fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w500,
    height: 16 / 13,
    color: PicasooColors.textHigh,
  );
}
