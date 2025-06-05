// lib/widgets/dialogs/task_dialog.dart
import 'package:flutter/material.dart';
import '../../models/task.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/validators/task_validators.dart';

class TaskDialog {
  /// Muestra el diálogo para agregar una nueva tarea
  static Future<Map<String, String>?> showAddTaskDialog(
    BuildContext context,
    List<Task> pendingTasks,
    List<Task> completedTasks,
  ) async {
    return await _showTaskDialog(
      context: context,
      title: 'Nueva Tarea',
      buttonText: 'Agregar',
      pendingTasks: pendingTasks,
      completedTasks: completedTasks,
    );
  }

  /// Muestra el diálogo para editar una tarea existente
  static Future<Map<String, String>?> showEditTaskDialog(
    BuildContext context,
    Task task,
    List<Task> pendingTasks,
    List<Task> completedTasks,
  ) async {
    return await _showTaskDialog(
      context: context,
      title: 'Editar Tarea',
      buttonText: 'Guardar',
      initialTitle: task.title,
      initialDescription: task.description ?? '',
      excludingId: task.id,
      pendingTasks: pendingTasks,
      completedTasks: completedTasks,
    );
  }

  /// Método privado que construye el diálogo genérico
  static Future<Map<String, String>?> _showTaskDialog({
    required BuildContext context,
    required String title,
    required String buttonText,
    required List<Task> pendingTasks,
    required List<Task> completedTasks,
    String initialTitle = '',
    String initialDescription = '',
    int? excludingId,
  }) async {
    final formKey = GlobalKey<FormState>();
    final titleController = TextEditingController(text: initialTitle);
    final descriptionController = TextEditingController(text: initialDescription);
    final screenWidth = MediaQuery.of(context).size.width;

    return await showDialog<Map<String, String>?>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.secondaryBackground,
        title: Text(title, style: AppTextStyles.subtitle),
        content: Form(
          key: formKey,
          child: SizedBox(
            width: screenWidth <= AppDimensions.mobileBreakpoint
                ? screenWidth * 0.9
                : 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: titleController,
                  style: AppTextStyles.body,
                  validator: (v) => TaskValidators.validateTitle(
                    v,
                    pendingTasks,
                    completedTasks,
                    excludingId: excludingId,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Título *',
                    labelStyle: TextStyle(color: AppColors.secondaryText),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.secondaryText),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.accentPurple),
                    ),
                  ),
                ),
                const SizedBox(height: AppDimensions.mediumPadding),
                TextFormField(
                  controller: descriptionController,
                  style: AppTextStyles.body,
                  validator: TaskValidators.validateDescription,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Descripción (opcional)',
                    labelStyle: TextStyle(color: AppColors.secondaryText),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.secondaryText),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.accentPurple),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancelar',
              style: TextStyle(color: AppColors.secondaryText),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.pop(context, {
                  'title': titleController.text.trim(),
                  'description': descriptionController.text.trim(),
                });
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accentPurple,
            ),
            child: Text(
              buttonText,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
