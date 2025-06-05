// lib/services/task_service.dart
import '../models/task.dart';
import '../db/db_helper.dart';

class TaskService {
  final DBHelper _dbHelper = DBHelper();

  /// Cargar todas las tareas separadas por estado
  Future<Map<String, List<Task>>> loadTasks() async {
    try {
      final pending = await _dbHelper.getTasksByStatus(false);
      final completed = await _dbHelper.getTasksByStatus(true);
      return {
        'pending': pending,
        'completed': completed,
      };
    } catch (e) {
      rethrow;
    }
  }

  /// Cambiar el estado de completado de una tarea
  Future<void> toggleTaskStatus(int taskId) async {
    try {
      await _dbHelper.toggleTaskStatus(taskId);
    } catch (e) {
      rethrow;
    }
  }

  /// Eliminar una tarea
  Future<void> deleteTask(int taskId) async {
    try {
      await _dbHelper.deleteTask(taskId);
    } catch (e) {
      rethrow;
    }
  }

  /// Agregar una nueva tarea
  Future<void> addTask(String title, String description) async {
    try {
      final task = Task(
        title: title,
        description: description.isEmpty ? null : description,
        createdAt: DateTime.now(),
      );
      await _dbHelper.insertTask(task);
    } catch (e) {
      rethrow;
    }
  }

  /// Actualizar una tarea existente
  Future<void> updateTask(Task task, String title, String description) async {
    try {
      final updatedTask = task.copyWith(
        title: title,
        description: description.isEmpty ? null : description,
      );
      await _dbHelper.updateTask(updatedTask);
    } catch (e) {
      rethrow;
    }
  }
}
