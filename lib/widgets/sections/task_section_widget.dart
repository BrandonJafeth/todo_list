// lib/widgets/sections/task_section_widget.dart
import 'package:flutter/material.dart';
import '../../models/task.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_text_styles.dart';
import '../task_item.dart';

class TaskSectionWidget extends StatelessWidget {
  final String title;
  final List<Task> tasks;
  final Function(Task) onToggleComplete;
  final Function(Task) onDelete;
  final Function(Task) onEdit;

  const TaskSectionWidget({
    Key? key,
    required this.title,
    required this.tasks,
    required this.onToggleComplete,
    required this.onDelete,
    required this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // No mostrar la sección de completadas si está vacía
    if (tasks.isEmpty && title.startsWith('Done')) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.subtitle),
        const SizedBox(height: AppDimensions.mediumPadding),

        // LISTA DE TAREAS
        if (tasks.isEmpty && title.startsWith('Tasks'))
          _buildEmptyState()
        else
          ...tasks.map(
            (task) => TaskItem(
              task: task,
              onToggleComplete: () => onToggleComplete(task),
              onDelete: () => onDelete(task),
              onEdit: () => onEdit(task),
              showActions: true,
            ),
          ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return SizedBox(
      height: 150,
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.task_alt, size: 48, color: AppColors.secondaryText),
            SizedBox(height: AppDimensions.mediumPadding),
            Text('No pending tasks', style: AppTextStyles.caption),
          ],
        ),
      ),
    );
  }
}
