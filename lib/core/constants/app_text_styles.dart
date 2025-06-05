import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  // Estilos de texto principales
  static const TextStyle title = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryText,
  );
  
  static const TextStyle subtitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: AppColors.primaryText,
  );
  
  static const TextStyle body = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.primaryText,
  );
  
  static const TextStyle caption = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.secondaryText,
  );
  
  // Estilos específicos para tareas
  static const TextStyle taskTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.primaryText,
  );
  
  static const TextStyle taskTitleCompleted = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.completedText,
    decoration: TextDecoration.lineThrough,
  );
  
  static const TextStyle taskDescription = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w300,
    color: AppColors.secondaryText,
  );
  

  static const TextStyle statsText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.primaryText,
  );
  
  // Estilos para botones
  static const TextStyle buttonText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.primaryText,
  );
}
