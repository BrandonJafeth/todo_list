import 'package:flutter/material.dart';
import '../models/task.dart';
import '../db/db_helper.dart';
import '../widgets/task_item.dart';
import '../widgets/task_stats_widget.dart';
import '../widgets/add_task_widget.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_dimensions.dart';
import '../core/constants/app_text_styles.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final DBHelper _dbHelper = DBHelper();
  List<Task> _tasks = [];
  List<Task> _pendingTasks = [];
  List<Task> _completedTasks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    setState(() => _isLoading = true);
    
    try {
      final allTasks = await _dbHelper.getTasks();
      final pending = await _dbHelper.getTasksByStatus(false);
      final completed = await _dbHelper.getTasksByStatus(true);
      
      setState(() {
        _tasks = allTasks;
        _pendingTasks = pending;
        _completedTasks = completed;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showErrorSnackBar('Error al cargar las tareas: $e');
    }
  }

  Future<void> _toggleTaskStatus(Task task) async {
    try {
      await _dbHelper.toggleTaskStatus(task.id!);
      await _loadTasks();
    } catch (e) {
      _showErrorSnackBar('Error al actualizar la tarea: $e');
    }
  }

  Future<void> _deleteTask(Task task) async {
    try {
      await _dbHelper.deleteTask(task.id!);
      await _loadTasks();
      _showSuccessSnackBar('Tarea eliminada correctamente');
    } catch (e) {
      _showErrorSnackBar('Error al eliminar la tarea: $e');
    }
  }

  Future<void> _showAddTaskDialog() async {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final screenWidth = MediaQuery.of(context).size.width;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.secondaryBackground,
        title: const Text(
          'Nueva Tarea',
          style: AppTextStyles.subtitle,
        ),
        content: SizedBox(
          width: screenWidth <= AppDimensions.mobileBreakpoint 
              ? screenWidth * 0.9 
              : 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                style: AppTextStyles.body,
                decoration: const InputDecoration(
                  labelText: 'Título',
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
              TextField(
                controller: descriptionController,
                style: AppTextStyles.body,
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
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancelar',
              style: TextStyle(color: AppColors.secondaryText),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              if (titleController.text.trim().isNotEmpty) {
                await _addTask(
                  titleController.text.trim(),
                  descriptionController.text.trim(),
                );
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accentPurple,
            ),
            child: const Text(
              'Agregar',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _addTask(String title, String description) async {
    try {
      final task = Task(
        title: title,
        description: description.isEmpty ? null : description,
        createdAt: DateTime.now(),
      );
      
      await _dbHelper.insertTask(task);
      await _loadTasks();
      _showSuccessSnackBar('Tarea agregada correctamente');
    } catch (e) {
      _showErrorSnackBar('Error al agregar la tarea: $e');
    }
  }

  Future<void> _showEditTaskDialog(Task task) async {
    final titleController = TextEditingController(text: task.title);
    final descriptionController = TextEditingController(text: task.description ?? '');
    final screenWidth = MediaQuery.of(context).size.width;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.secondaryBackground,
        title: const Text(
          'Editar Tarea',
          style: AppTextStyles.subtitle,
        ),
        content: SizedBox(
          width: screenWidth <= AppDimensions.mobileBreakpoint 
              ? screenWidth * 0.9 
              : 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                style: AppTextStyles.body,
                decoration: const InputDecoration(
                  labelText: 'Título',
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
              TextField(
                controller: descriptionController,
                style: AppTextStyles.body,
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
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancelar',
              style: TextStyle(color: AppColors.secondaryText),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              if (titleController.text.trim().isNotEmpty) {
                await _updateTask(
                  task,
                  titleController.text.trim(),
                  descriptionController.text.trim(),
                );
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accentPurple,
            ),
            child: const Text(
              'Guardar',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _updateTask(Task task, String title, String description) async {
    try {
      final updatedTask = task.copyWith(
        title: title,
        description: description.isEmpty ? null : description,
      );
      
      await _dbHelper.updateTask(updatedTask);
      await _loadTasks();
      _showSuccessSnackBar('Tarea actualizada correctamente');
    } catch (e) {
      _showErrorSnackBar('Error al actualizar la tarea: $e');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.errorRed,
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.successGreen,
      ),
    );
  }

  Widget _buildHeader(double screenWidth) {
    return Column(
      children: [
        Text(
          'Todo List',
          style: screenWidth <= AppDimensions.mobileBreakpoint 
              ? AppTextStyles.title.copyWith(fontSize: 20)
              : AppTextStyles.title,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppDimensions.smallPadding),
        Text(
          'Organiza tus tareas de manera eficiente',
          style: AppTextStyles.caption,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = AppDimensions.getHorizontalPadding(screenWidth);
    
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
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
                    borderRadius: BorderRadius.circular(AppDimensions.largeRadius),
                    color: AppColors.primaryBackground,
                  ),
                  padding: EdgeInsets.all(
                    screenWidth <= AppDimensions.mobileBreakpoint 
                        ? AppDimensions.mediumPadding 
                        : AppDimensions.largePadding,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Header con título
                      _buildHeader(screenWidth),
                      
                      const SizedBox(height: AppDimensions.largePadding),
                      
                      // Lista de tareas
                      if (_isLoading)
                        const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.accentPurple,
                          ),
                        )
                      else if (_tasks.isEmpty)
                        _buildEmptyState()
                      else
                        _buildTaskList(),

                      const SizedBox(height: AppDimensions.largePadding),

                      // Estadísticas
                      TaskStatsWidget(
                        totalTasks: _tasks.length,
                        completedTasks: _completedTasks.length,
                        pendingTasks: _pendingTasks.length,
                      ),

                      const SizedBox(height: AppDimensions.largePadding),

                      // Botón agregar tarea
                      AddTaskWidget(
                        onTap: _showAddTaskDialog,
                      ),
                      
                      const SizedBox(height: AppDimensions.mediumPadding),
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

  Widget _buildEmptyState() {
    return Container(
      height: 300,
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.task_alt,
              size: 64,
              color: AppColors.secondaryText,
            ),
            SizedBox(height: AppDimensions.mediumPadding),
            Text(
              'No hay tareas',
              style: AppTextStyles.subtitle,
            ),
            SizedBox(height: AppDimensions.smallPadding),
            Text(
              'Agrega tu primera tarea',
              style: AppTextStyles.caption,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskList() {
    return Column(
      children: [
        // Mostrar tareas pendientes primero
        ..._pendingTasks.map((task) => TaskItem(
          task: task,
          onToggleComplete: () => _toggleTaskStatus(task),
          onDelete: () => _deleteTask(task),
          onEdit: () => _showEditTaskDialog(task),
        )),
        
        // Luego las completadas
        ..._completedTasks.map((task) => TaskItem(
          task: task,
          onToggleComplete: () => _toggleTaskStatus(task),
          onDelete: () => _deleteTask(task),
          onEdit: () => _showEditTaskDialog(task),
        )),
      ],
    );
  }
}
