// lib/screens/task_list_screen.dart
import 'package:flutter/material.dart';

import '../models/task.dart';
import '../services/task_service.dart';
import '../widgets/sections/task_section_widget.dart';
import '../widgets/dialogs/task_dialog.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_dimensions.dart';
import '../core/constants/app_text_styles.dart';
import '../core/utils/snackbar_utils.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final TaskService _taskService = TaskService();

  List<Task> _pendingTasks = [];
  List<Task> _completedTasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  /* ───────────────────────── CRUD OPERATIONS ───────────────────────── */

  Future<void> _loadTasks() async {
    try {
      final tasks = await _taskService.loadTasks();
      setState(() {
        _pendingTasks = tasks['pending']!;
        _completedTasks = tasks['completed']!;
      });
    } catch (e) {
      SnackBarUtils.showError(context, 'Error al cargar las tareas: $e');
    }
  }

  Future<void> _toggleTaskStatus(Task task) async {
    try {
      await _taskService.toggleTaskStatus(task.id!);
      await _loadTasks();
    } catch (e) {
      SnackBarUtils.showError(context, 'Error al actualizar la tarea: $e');
    }
  }

  Future<void> _deleteTask(Task task) async {
    try {
      await _taskService.deleteTask(task.id!);
      await _loadTasks();
      SnackBarUtils.showSuccess(context, 'Tarea eliminada correctamente');
    } catch (e) {
      SnackBarUtils.showError(context, 'Error al eliminar la tarea: $e');
    }
  }
  Future<void> _showAddTaskDialog() async {
    final result = await TaskDialog.showAddTaskDialog(
      context,
      _pendingTasks,
      _completedTasks,
    );

    if (result != null) {
      try {
        await _taskService.addTask(result['title']!, result['description']!);
        await _loadTasks();
        SnackBarUtils.showSuccess(context, 'Tarea agregada correctamente');
      } catch (e) {
        SnackBarUtils.showError(context, 'Error al agregar la tarea: $e');
      }
    }
  }

  Future<void> _showEditTaskDialog(Task task) async {
    final result = await TaskDialog.showEditTaskDialog(
      context,
      task,
      _pendingTasks,
      _completedTasks,
    );

    if (result != null) {
      try {
        await _taskService.updateTask(task, result['title']!, result['description']!);
        await _loadTasks();
        SnackBarUtils.showSuccess(context, 'Tarea actualizada correctamente');
      } catch (e) {
        SnackBarUtils.showError(context, 'Error al actualizar la tarea: $e');
      }
    }
  }

  /* ───────────────────────── UI PRINCIPAL ───────────────────────── */

  @override
  Widget build(BuildContext context) {
    final screenWidth       = MediaQuery.of(context).size.width;
    final horizontalPadding = AppDimensions.getHorizontalPadding(screenWidth);

    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        backgroundColor: AppColors.accentPurple,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Center(
                child: Container(
                  width: double.infinity,
                  constraints: BoxConstraints(
                    maxWidth: AppDimensions.getMainContainerWidth(screenWidth),
                    minHeight: constraints.maxHeight,
                  ),
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(AppDimensions.largeRadius),
                    color: AppColors.primaryBackground,
                  ),
                  padding: EdgeInsets.all(
                    screenWidth <= AppDimensions.mobileBreakpoint
                        ? AppDimensions.mediumPadding
                        : AppDimensions.largePadding,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildAddTaskInput(),
                      const SizedBox(height: AppDimensions.largePadding),                      
                      TaskSectionWidget(
                        title: 'Tasks to do - ${_pendingTasks.length}',
                        tasks: _pendingTasks,
                        onToggleComplete: _toggleTaskStatus,
                        onDelete: _deleteTask,
                        onEdit: _showEditTaskDialog,
                      ),
                      const SizedBox(height: AppDimensions.largePadding),

                      // TAREAS COMPLETADAS
                      TaskSectionWidget(
                        title: 'Done - ${_completedTasks.length}',
                        tasks: _completedTasks,
                        onToggleComplete: _toggleTaskStatus,
                        onDelete: _deleteTask,
                        onEdit: _showEditTaskDialog,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  /* ───────────────────────── COMPONENTES REUTILIZABLES ───────────────────────── */

  Widget _buildAddTaskInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppDimensions.mediumRadius),
        border: Border.all(
            color: AppColors.secondaryText.withAlpha(77)), 
      ),
      child: TextField(
        controller: TextEditingController(),
        style: AppTextStyles.body,
        decoration: InputDecoration(
          hintText: 'Add a new task',
          hintStyle:
              AppTextStyles.body.copyWith(color: AppColors.secondaryText.withAlpha(128)),
          border: InputBorder.none,
          suffixIcon: IconButton(
            icon: const Icon(Icons.add, color: AppColors.accentPurple),
            onPressed: _showAddTaskDialog,
          ),
        ),
        onTap: _showAddTaskDialog,
        readOnly: true,
      ),
    );
  }

}
