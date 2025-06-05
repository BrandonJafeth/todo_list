# Investigación: SQLite y sqflite en Flutter

## Tabla de Contenidos
1. [¿Qué es SQLite?](#qué-es-sqlite)
2. [¿Qué es sqflite?](#qué-es-sqflite)
3. [Integración con Flutter](#integración-con-flutter)
4. [Configuración del Proyecto](#configuración-del-proyecto)
5. [Estructura de Base de Datos](#estructura-de-base-de-datos)
6. [Operaciones CRUD](#operaciones-crud)
7. [Ejemplo Práctico](#ejemplo-práctico)
8. [Ventajas y Desventajas](#ventajas-y-desventajas)
9. [Mejores Prácticas](#mejores-prácticas)
10. [Conclusiones](#conclusiones)

---

## ¿Qué es SQLite?

**SQLite** es un sistema de gestión de bases de datos relacionales (RDBMS) ligero, embebido y de código abierto. Es una biblioteca de software que implementa un motor de base de datos SQL autocontenido, sin servidor y sin configuración.

### Características Principales:

- **📁 Autocontenido**: Toda la base de datos se almacena en un solo archivo
- **🚫 Sin servidor**: No requiere un proceso servidor separado
- **⚡ Ligero**: Biblioteca muy pequeña (~600KB)
- **🔒 ACID**: Cumple con las propiedades de atomicidad, consistencia, aislamiento y durabilidad
- **🌍 Multiplataforma**: Funciona en Windows, macOS, Linux, Android, iOS
- **📚 SQL estándar**: Soporta la mayoría de comandos SQL

### Ventajas de SQLite:
- Zero-configuration (no necesita instalación ni configuración)
- Portable (un archivo = una base de datos completa)
- Rápido para aplicaciones locales
- Confiable y estable
- Ampliamente utilizado (Android, iOS, navegadores web)

---

## ¿Qué es sqflite?

**sqflite** es el plugin oficial de Flutter que proporciona una interfaz Dart para trabajar con bases de datos SQLite en aplicaciones Flutter. Es la implementación nativa de SQLite para el ecosistema Flutter.

### Características de sqflite:

- **🔌 Plugin nativo**: Utiliza SQLite nativo en cada plataforma
- **🔄 Operaciones asíncronas**: Todas las operaciones son Future-based
- **🛠️ CRUD completo**: Create, Read, Update, Delete
- **💼 Transacciones**: Soporte para transacciones complejas
- **📊 Consultas avanzadas**: SQL personalizado, joins, agregaciones
- **🔄 Migraciones**: Sistema de versionado de base de datos
- **🖥️ Multiplataforma**: Android, iOS, macOS, Windows, Linux

---

## Integración con Flutter

### 1. Dependencias del Proyecto

En tu archivo `pubspec.yaml` ya tienes configuradas las dependencias necesarias:

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  sqflite: ^2.3.0        # Plugin principal para SQLite
  path_provider: ^2.1.1   # Para obtener rutas del sistema
  path: ^1.9.0           # Para manipular rutas de archivos
```

### 2. Paquetes Relacionados:

- **`sqflite`**: Plugin principal para SQLite
- **`path_provider`**: Obtiene rutas del sistema de archivos de la plataforma
- **`path`**: Utilidades para manipular rutas de archivos

---

## Configuración del Proyecto

### Estructura de Archivos Recomendada:

```
lib/
├── main.dart
├── models/
│   └── task.dart          # Modelo de datos
├── db/
│   └── db_helper.dart     # Helper de base de datos
└── screens/
    ├── task_list.dart     # Lista de tareas
    └── add_task.dart      # Agregar tarea
```

### Modelo de Datos (Task):

```dart
// lib/models/task.dart
class Task {
  final int? id;
  final String title;
  final String? description;
  final bool isCompleted;
  final DateTime createdAt;

  Task({
    this.id,
    required this.title,
    this.description,
    this.isCompleted = false,
    required this.createdAt,
  });

  // Convertir a Map para la base de datos
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted ? 1 : 0,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Crear Task desde Map de la base de datos
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      isCompleted: map['isCompleted'] == 1,
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  // Crear copia con cambios
  Task copyWith({
    int? id,
    String? title,
    String? description,
    bool? isCompleted,
    DateTime? createdAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
```

---

## Estructura de Base de Datos

### Database Helper (Singleton Pattern):

```dart
// lib/db/db_helper.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../models/task.dart';

class DatabaseHelper {
  static Database? _database;
  static const String _databaseName = 'todo_list.db';
  static const int _databaseVersion = 1;
  
  // Singleton pattern
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  // Obtener instancia de la base de datos
  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  // Inicializar la base de datos
  Future<Database> _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, _databaseName);
    
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  // Crear tablas
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tasks(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT,
        isCompleted INTEGER NOT NULL DEFAULT 0,
        createdAt TEXT NOT NULL
      )
    ''');
  }

  // Manejar actualizaciones de esquema
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Manejar migraciones futuras
    if (oldVersion < 2) {
      // Ejemplo: agregar nueva columna
      // await db.execute('ALTER TABLE tasks ADD COLUMN priority INTEGER DEFAULT 0');
    }
  }

  // Cerrar la base de datos
  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }
}
```

---

## Operaciones CRUD

### Create (Insertar):

```dart
// Insertar nueva tarea
Future<int> insertTask(Task task) async {
  final db = await database;
  return await db.insert(
    'tasks',
    task.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

// Insertar múltiples tareas en una transacción
Future<void> insertTasks(List<Task> tasks) async {
  final db = await database;
  await db.transaction((txn) async {
    for (Task task in tasks) {
      await txn.insert('tasks', task.toMap());
    }
  });
}
```

### Read (Leer):

```dart
// Obtener todas las tareas
Future<List<Task>> getAllTasks() async {
  final db = await database;
  final List<Map<String, dynamic>> maps = await db.query(
    'tasks',
    orderBy: 'createdAt DESC',
  );
  return List.generate(maps.length, (i) => Task.fromMap(maps[i]));
}

// Obtener tarea por ID
Future<Task?> getTaskById(int id) async {
  final db = await database;
  final List<Map<String, dynamic>> maps = await db.query(
    'tasks',
    where: 'id = ?',
    whereArgs: [id],
  );
  
  if (maps.isNotEmpty) {
    return Task.fromMap(maps.first);
  }
  return null;
}

// Obtener tareas completadas/pendientes
Future<List<Task>> getTasksByStatus(bool isCompleted) async {
  final db = await database;
  final List<Map<String, dynamic>> maps = await db.query(
    'tasks',
    where: 'isCompleted = ?',
    whereArgs: [isCompleted ? 1 : 0],
    orderBy: 'createdAt DESC',
  );
  return List.generate(maps.length, (i) => Task.fromMap(maps[i]));
}

// Buscar tareas por título
Future<List<Task>> searchTasks(String query) async {
  final db = await database;
  final List<Map<String, dynamic>> maps = await db.query(
    'tasks',
    where: 'title LIKE ? OR description LIKE ?',
    whereArgs: ['%$query%', '%$query%'],
    orderBy: 'createdAt DESC',
  );
  return List.generate(maps.length, (i) => Task.fromMap(maps[i]));
}
```

### Update (Actualizar):

```dart
// Actualizar tarea
Future<int> updateTask(Task task) async {
  final db = await database;
  return await db.update(
    'tasks',
    task.toMap(),
    where: 'id = ?',
    whereArgs: [task.id],
  );
}

// Marcar tarea como completada/pendiente
Future<int> toggleTaskStatus(int id) async {
  final db = await database;
  final task = await getTaskById(id);
  if (task != null) {
    return await db.update(
      'tasks',
      {'isCompleted': task.isCompleted ? 0 : 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  return 0;
}
```

### Delete (Eliminar):

```dart
// Eliminar tarea por ID
Future<int> deleteTask(int id) async {
  final db = await database;
  return await db.delete(
    'tasks',
    where: 'id = ?',
    whereArgs: [id],
  );
}

// Eliminar todas las tareas completadas
Future<int> deleteCompletedTasks() async {
  final db = await database;
  return await db.delete(
    'tasks',
    where: 'isCompleted = ?',
    whereArgs: [1],
  );
}

// Eliminar todas las tareas
Future<int> deleteAllTasks() async {
  final db = await database;
  return await db.delete('tasks');
}
```

---

## Ejemplo Práctico

### Widget de Lista de Tareas:

```dart
// lib/screens/task_list.dart
import 'package:flutter/material.dart';
import '../models/task.dart';
import '../db/db_helper.dart';

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Task> _tasks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    setState(() => _isLoading = true);
    final tasks = await _dbHelper.getAllTasks();
    setState(() {
      _tasks = tasks;
      _isLoading = false;
    });
  }

  Future<void> _toggleTaskStatus(Task task) async {
    await _dbHelper.toggleTaskStatus(task.id!);
    _loadTasks(); // Recargar lista
  }

  Future<void> _deleteTask(int id) async {
    await _dbHelper.deleteTask(id);
    _loadTasks(); // Recargar lista
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Tareas'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              // Navegar a pantalla de agregar tarea
              final result = await Navigator.pushNamed(context, '/add-task');
              if (result == true) _loadTasks();
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _tasks.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.task_alt, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text('No hay tareas'),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: _tasks.length,
                  itemBuilder: (context, index) {
                    final task = _tasks[index];
                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      child: ListTile(
                        leading: Checkbox(
                          value: task.isCompleted,
                          onChanged: (_) => _toggleTaskStatus(task),
                        ),
                        title: Text(
                          task.title,
                          style: TextStyle(
                            decoration: task.isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                        subtitle: task.description?.isNotEmpty == true
                            ? Text(task.description!)
                            : null,
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteTask(task.id!),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
```

---

## Ventajas y Desventajas

### ✅ Ventajas:

1. **Persistencia Local**: Los datos se mantienen incluso cuando la app se cierra
2. **Sin Conexión**: Funciona completamente offline
3. **Rendimiento**: Consultas muy rápidas para datos locales
4. **Confiabilidad**: Transacciones ACID garantizan integridad
5. **SQL Completo**: Soporte para consultas complejas, joins, agregaciones
6. **Multiplataforma**: Funciona en todas las plataformas de Flutter
7. **Maduro**: SQLite es muy estable y ampliamente probado
8. **Tamaño**: Base de datos ligera, ideal para móviles

### ❌ Desventajas:

1. **Concurrencia Limitada**: No es ideal para múltiples escritores simultáneos
2. **Solo Local**: No hay sincronización automática con servidores
3. **Consultas Complejas**: SQL puede ser verboso para operaciones simples
4. **Migraciones**: Requiere manejo manual de cambios de esquema
5. **Tipado**: SQLite es dinámicamente tipado, puede causar errores
6. **Límites**: Máximo tamaño de base de datos ~280TB (suficiente para móviles)

---

## Mejores Prácticas

### 1. **Singleton Pattern para DatabaseHelper**
```dart
// Una sola instancia de la conexión
static final DatabaseHelper _instance = DatabaseHelper._internal();
factory DatabaseHelper() => _instance;
```

### 2. **Manejo de Errores**
```dart
try {
  await _dbHelper.insertTask(task);
} catch (e) {
  print('Error al insertar tarea: $e');
  // Mostrar mensaje al usuario
}
```

### 3. **Transacciones para Operaciones Múltiples**
```dart
await db.transaction((txn) async {
  // Múltiples operaciones aquí
  await txn.insert('tasks', task1.toMap());
  await txn.insert('tasks', task2.toMap());
});
```

### 4. **Índices para Consultas Frecuentes**
```dart
await db.execute('CREATE INDEX idx_task_status ON tasks(isCompleted)');
```

### 5. **Validación de Datos**
```dart
Map<String, dynamic> toMap() {
  if (title.trim().isEmpty) {
    throw Exception('El título no puede estar vacío');
  }
  return {...};
}
```

### 6. **Cerrar Conexiones**
```dart
@override
void dispose() {
  _dbHelper.close();
  super.dispose();
}
```

---

## Casos de Uso Ideales

### ✅ **Usar sqflite cuando:**
- Necesitas almacenamiento local persistente
- Trabajas con datos estructurados y relacionales
- Requieres consultas complejas
- La app debe funcionar offline
- Necesitas transacciones ACID
- Manejas volúmenes moderados de datos

### ❌ **NO usar sqflite cuando:**
- Solo necesitas almacenar configuraciones simples (usar `SharedPreferences`)
- Los datos son solo temporales (usar variables en memoria)
- Necesitas sincronización en tiempo real (usar Firebase/Cloud)
- Manejas archivos multimedia grandes (usar sistema de archivos)
- Los datos son muy simples y no relacionales (considerar `Hive`)

---

## Alternativas a sqflite

| Alternativa | Uso Recomendado | Ventajas |
|-------------|-----------------|----------|
| **SharedPreferences** | Configuraciones simples | Muy simple, key-value |
| **Hive** | Datos NoSQL, objetos Dart | Más rápido, tipado fuerte |
| **Isar** | Bases de datos grandes | Muy alta performance |
| **Firebase** | Sincronización cloud | Tiempo real, multiplataforma |
| **Sembast** | NoSQL local | Sin SQL, más simple |

---

## Conclusiones

**sqflite** es la solución estándar y más madura para el manejo de bases de datos locales en Flutter. Para tu proyecto de **lista de tareas**, es la elección perfecta porque:

1. **✅ Persistencia**: Las tareas se guardan permanentemente
2. **✅ Offline**: Funciona sin conexión a internet
3. **✅ Estructura**: Los datos están bien organizados
4. **✅ Funcionalidad**: Soporte completo para CRUD
5. **✅ Escalabilidad**: Puede crecer con el proyecto

### Recomendaciones para tu proyecto:

1. **Implementa el patrón Singleton** para `DatabaseHelper`
2. **Usa transacciones** para operaciones múltiples
3. **Maneja errores** apropiadamente
4. **Implementa migraciones** para futuras actualizaciones
5. **Considera agregar índices** si el número de tareas crece mucho

sqflite te proporcionará una base sólida para tu aplicación de lista de tareas, con la flexibilidad de agregar funcionalidades más complejas en el futuro como categorías, fechas de vencimiento, prioridades, etc.

---

## Referencias

- [Documentación oficial de sqflite](https://pub.dev/packages/sqflite)
- [SQLite Documentation](https://www.sqlite.org/docs.html)
- [Flutter Cookbook - Persist data with SQLite](https://docs.flutter.dev/cookbook/persistence/sqlite)
- [path_provider package](https://pub.dev/packages/path_provider)

---

*Investigación realizada para el proyecto: `todo_list`*  
*Fecha: Junio 2025*
