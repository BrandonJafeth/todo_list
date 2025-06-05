# Investigación: SQLite y sqflite en Flutter

## Tabla de Contenidos
1. [¿Qué es SQLite?](#qué-es-sqlite)
2. [¿Qué es sqflite?](#qué-es-sqflite)
3. [Integración con Flutter](#integración-con-flutter)


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

### Estructura de Archivos:

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



Este ejemplo práctico demuestra cómo se implementa una aplicación completa de lista de tareas utilizando SQLite a través de sqflite. La aplicación incluye:

- Lista de tareas con filtrado por pestañas (todas, pendientes, completadas)
- Agregar nuevas tareas con validación de formulario
- Marcar tareas como completadas/pendientes
- Eliminar tareas
- Ver detalles de tareas
- Manejo adecuado del estado de carga

Todas estas operaciones utilizan la base de datos SQLite para persistencia, lo que permite que la aplicación mantenga los datos incluso cuando se cierra, exactamente como se espera de una aplicación de lista de tareas real.
