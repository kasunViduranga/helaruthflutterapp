import 'package:flutter/material.dart';
import 'package:helaruth/constants/colors.dart';

class AppTextStyles {
  static const TextStyle body = TextStyle(
    fontSize: 16,
    color: AppColors.textColor,
  );

  static const TextStyle heading = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.textColor,
  );

  static const TextStyle sinhala = TextStyle(
    fontFamily: 'IskoolaPota',
    fontSize: 16,
    color: AppColors.textColor,
  );

  static const TextStyle darkBody = TextStyle(
    fontSize: 16,
    color: AppColors.darkTextColor,
  );

  static const TextStyle darkHeading = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.darkTextColor,
  );

  static const TextStyle darkSinhala = TextStyle(
    fontFamily: 'IskoolaPota',
    fontSize: 16,
    color: AppColors.darkTextColor,
  );
}