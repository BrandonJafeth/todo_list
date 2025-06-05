// lib/core/utils/snackbar_utils.dart
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class SnackBarUtils {
  /// Muestra un SnackBar de error
  static void showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.errorRed,
      ),
    );
  }

  /// Muestra un SnackBar de éxito
  static void showSuccess(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.successGreen,
      ),
    );
  }

  /// Muestra un SnackBar informativo
  static void showInfo(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.accentPurple,
      ),
    );
  }
}
