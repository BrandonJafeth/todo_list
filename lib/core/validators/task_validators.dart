// lib/core/validators/task_validators.dart
import '../../models/task.dart';

class TaskValidators {
  /// Verifica si ya existe una tarea con el mismo título
  /// (pendiente o completada), ignorando mayúsculas/minúsculas.
  static bool isDuplicateTitle(
    String title,
    List<Task> pendingTasks,
    List<Task> completedTasks, {
    int? excludingId,
  }) {    final normalized = title.trim().toLowerCase();
    final inPending = pendingTasks.any((t) =>
        t.id != excludingId && t.title.trim().toLowerCase() == normalized);
    final inCompleted = completedTasks.any((t) =>
        t.id != excludingId && t.title.trim().toLowerCase() == normalized);
    return inPending || inCompleted;
  }

  /// Valida el título. Devuelve `null` si todo OK,
  /// o un mensaje de error si no cumple las reglas.
  static String? validateTitle(
    String? value,
    List<Task> pendingTasks,
    List<Task> completedTasks, {
    int? excludingId,
  }) {
    final txt = value?.trim() ?? '';
    if (txt.isEmpty) return 'El título es obligatorio';
    if (txt.length < 3) return 'Mínimo 3 caracteres';
    if (txt.length > 50) return 'Máximo 50 caracteres';
    if (_containsOnlyWhitespace(txt)) {
      return 'El título no puede contener solo espacios';
    }
    if (_hasInvalidCharacters(txt)) {
      return 'Caracteres especiales no permitidos: < > & " \\';
    }
    if (_startsOrEndsWithWhitespace(txt)) {
      return 'El título no puede empezar o terminar con espacios';
    }
    if (_hasConsecutiveSpaces(txt)) {
      return 'No se permiten espacios consecutivos';
    }
    if (isDuplicateTitle(txt, pendingTasks, completedTasks,
        excludingId: excludingId)) {
      return 'Ya existe una tarea con ese título';
    }
    return null;
  }

  /// Valida la descripción. Devuelve `null` si todo OK,
  /// o un mensaje de error si no cumple las reglas.
  static String? validateDescription(String? value) {
    final txt = value?.trim() ?? '';
    if (txt.isEmpty) return null; // La descripción es opcional
    if (txt.length > 200) return 'Máximo 200 caracteres';
    if (_containsOnlyWhitespace(txt)) {
      return 'La descripción no puede contener solo espacios';
    }
    if (_hasInvalidCharacters(txt)) {
      return 'Caracteres especiales no permitidos: < > & " \\';
    }
    if (_startsOrEndsWithWhitespace(txt)) {
      return 'La descripción no puede empezar o terminar con espacios';
    }
    return null;
  }

  // Métodos auxiliares privados
  static bool _containsOnlyWhitespace(String text) {
    return text.trim().isEmpty && text.isNotEmpty;
  }

  static bool _hasInvalidCharacters(String text) {
    final invalidChars = RegExp(r'[<>&"\\]');
    return invalidChars.hasMatch(text);
  }

  static bool _startsOrEndsWithWhitespace(String text) {
    return text != text.trim();
  }

  static bool _hasConsecutiveSpaces(String text) {
    return text.contains(RegExp(r'\s{2,}'));
  }
}
