import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_text_styles.dart';

class AddTaskWidget extends StatelessWidget {
  final VoidCallback onTap;
  final String text;

  const AddTaskWidget({
    Key? key,
    required this.onTap,
    this.text = "Add a new task",
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        maxWidth: AppDimensions.getContainerWidth(screenWidth),
      ),
      height: AppDimensions.addButtonHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimensions.mediumRadius),
        color: Colors.transparent,
        border: Border.all(
          color: AppColors.accentPurple.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppDimensions.mediumRadius),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppDimensions.getHorizontalPadding(screenWidth),
            ),
            child: Row(
              children: [
                // Botón circular de agregar
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppDimensions.mediumRadius),
                    color: AppColors.accentPurple,
                  ),
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                
                const SizedBox(width: AppDimensions.mediumPadding),
                
                // Texto
                Expanded(
                  child: Text(
                    text,
                    style: AppTextStyles.buttonText.copyWith(
                      color: AppColors.accentPurple,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
