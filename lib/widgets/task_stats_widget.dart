import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_text_styles.dart';

class TaskStatsWidget extends StatelessWidget {
  final int totalTasks;
  final int completedTasks;
  final int pendingTasks;

  const TaskStatsWidget({
    Key? key,
    required this.totalTasks,
    required this.completedTasks,
    required this.pendingTasks,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        maxWidth: AppDimensions.getContainerWidth(screenWidth),
      ),
      child: Column(
        children: [
          // Estadística de tareas pendientes
          _buildStatItem(
            text: "Tasks to do - $pendingTasks",
            icon: Icons.radio_button_unchecked,
            color: AppColors.accentPurple,
            screenWidth: screenWidth,
          ),
          
          const SizedBox(height: AppDimensions.smallPadding),
          
          // Estadística de tareas completadas
          _buildStatItem(
            text: "Done - $completedTasks",
            icon: Icons.check_circle,
            color: AppColors.successGreen,
            screenWidth: screenWidth,
          ),
        ],
      ),
    );
  }
  Widget _buildStatItem({
    required String text,
    required IconData icon,
    required Color color,
    required double screenWidth,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: color,
          size: screenWidth <= AppDimensions.mobileBreakpoint ? 18 : 20,
        ),
        const SizedBox(width: AppDimensions.smallPadding),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.statsText,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
