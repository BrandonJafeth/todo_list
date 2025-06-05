# 📝 Todo List App - Flutter

Una aplicación moderna de lista de tareas desarrollada en Flutter con arquitectura modular y validaciones avanzadas.

## 🚀 Características

- ✅ **Gestión completa de tareas**: Crear, editar, eliminar y marcar como completadas
- 🔒 **Validaciones avanzadas**: Sistema robusto de validación de entrada
- 💾 **Persistencia local**: Base de datos SQLite para almacenamiento local
- 🎨 **Interfaz moderna**: Diseño responsivo con tema oscuro
- 🏗️ **Arquitectura modular**: Código organizado y escalable
- 📱 **Multiplataforma**: Compatible con Android, iOS, Web y Desktop

## 🛠️ Tecnologías Utilizadas

- **Flutter 3.x**: Framework principal
- **SQLite**: Base de datos local (`sqflite`)
- **Path Provider**: Gestión de rutas del sistema
- **Arquitectura MVVM**: Separación de responsabilidades

## 📋 Requisitos Previos

Antes de ejecutar el proyecto, asegúrate de tener instalado:

- [Flutter SDK](https://flutter.dev/docs/get-started/install) (versión 3.0 o superior)
- [Dart SDK](https://dart.dev/get-dart) (incluido con Flutter)
- Un IDE compatible:
  - [Visual Studio Code](https://code.visualstudio.com/) con extensión Flutter
  - [Android Studio](https://developer.android.com/studio) con plugin Flutter
  - [IntelliJ IDEA](https://www.jetbrains.com/idea/) con plugin Flutter

### Para desarrollo móvil:
- **Android**: [Android Studio](https://developer.android.com/studio) y SDK de Android
## ⚡ Instalación y Ejecución

### 1. Clonar o descargar el proyecto
```bash
# Si tienes acceso al repositorio
git clone <url-del-repositorio>
cd todo_list

# O simplemente navega al directorio del proyecto descargado
cd "ruta/al/proyecto/todo_list"
```

### 2. Verificar instalación de Flutter
```bash
flutter doctor
```
Asegúrate de que no haya errores críticos antes de continuar.

### 3. Instalar dependencias
```bash
flutter pub get
```

### 4. Ejecutar la aplicación

#### Opción A: Modo Debug (Recomendado para desarrollo)
```bash
# En un dispositivo/emulador conectado
flutter run

# Para web
flutter run -d chrome

# Para desktop (Windows)
flutter run -d windows
```

#### Opción B: Modo Release (Para producción)
```bash
# Android APK
flutter build apk --release

# Web
flutter build web --release

# Windows
flutter build windows --release
```

### 5. Ejecutar en diferentes plataformas

#### Android
```bash
# Listar dispositivos disponibles
flutter devices

# Ejecutar en dispositivo específico
flutter run -d <device-id>

# Construir APK
flutter build apk
```


