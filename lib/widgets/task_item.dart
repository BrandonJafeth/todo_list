import 'package:flutter/material.dart';
import '../../models/task.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_text_styles.dart';

class TaskItem extends StatelessWidget {
  final Task task;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onToggleComplete;
  final bool showActions;

  const TaskItem({
    Key? key,
    required this.task,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.onToggleComplete,
    this.showActions = true,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        minHeight: AppDimensions.taskItemMinHeight,
        maxWidth: AppDimensions.getContainerWidth(screenWidth),
      ),
      margin: const EdgeInsets.symmetric(vertical: AppDimensions.taskItemMargin),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimensions.mediumRadius),
        color: AppColors.taskItemBackground,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppDimensions.mediumRadius),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.taskItemPadding),
            child: Row(
              children: [
           
                _buildCheckbox(),
                const SizedBox(width: AppDimensions.mediumPadding),
                
           
                Expanded(
                  child: _buildTaskContent(screenWidth),
                ),
                
                // Botones de acción
                if (showActions) ...[
                  const SizedBox(width: AppDimensions.smallPadding),
                  _buildActionButtons(),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCheckbox() {
    return GestureDetector(
      onTap: onToggleComplete,
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: task.isCompleted ? AppColors.accentPurple : AppColors.secondaryText,
            width: 2,
          ),
          color: task.isCompleted ? AppColors.accentPurple : Colors.transparent,
        ),
        child: task.isCompleted
            ? const Icon(
                Icons.check,
                color: Colors.white,
                size: 16,
              )
            : null,
      ),
    );
  }
  Widget _buildTaskContent(double screenWidth) {
    final titleMaxLines = AppDimensions.getTaskTitleMaxLines(screenWidth);
    final descriptionMaxLines = AppDimensions.getTaskDescriptionMaxLines(screenWidth);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          task.title,
          style: task.isCompleted 
              ? AppTextStyles.taskTitleCompleted 
              : AppTextStyles.taskTitle,
          maxLines: titleMaxLines,
          overflow: TextOverflow.ellipsis,
        ),
        if (task.description != null && task.description!.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            task.description!,
            style: AppTextStyles.taskDescription,
            maxLines: descriptionMaxLines,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Botón de editar
        _buildActionButton(
          icon: Icons.edit,
          onPressed: onEdit,
          tooltip: 'Editar tarea',
        ),
        const SizedBox(width: AppDimensions.smallPadding),
        
        // Botón de eliminar
        _buildActionButton(
          icon: Icons.delete,
          onPressed: onDelete,
          tooltip: 'Eliminar tarea',
          iconColor: AppColors.errorRed,
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback? onPressed,
    required String tooltip,
    Color? iconColor,
  }) {
    return Container(
      width: AppDimensions.iconButtonSize,
      height: AppDimensions.iconButtonSize,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimensions.smallRadius),
        color: AppColors.buttonBackground,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppDimensions.smallRadius),
          onTap: onPressed,
          child: Tooltip(
            message: tooltip,
            child: Icon(
              icon,
              color: iconColor ?? AppColors.primaryText,
              size: 16,
            ),
          ),
        ),
      ),
    );
  }
}
