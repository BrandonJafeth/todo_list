import 'package:flutter/material.dart';
import 'package:todo_list/screens/task_list_screen.dart';

import 'core/constants/app_colors.dart';

void main() {
  runApp(const ToDoApp());
}

class ToDoApp extends StatelessWidget {
  const ToDoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo List App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: AppColors.accentPurple,
        scaffoldBackgroundColor: AppColors.primaryBackground,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primaryBackground,
          elevation: 0,
          centerTitle: true,
        ),
        colorScheme: const ColorScheme.dark(
          primary: AppColors.accentPurple,
          secondary: AppColors.accentPurple,
          surface: AppColors.secondaryBackground,
          background: AppColors.primaryBackground,
        ),
      ),
      home: TaskListScreen(),
    );
  }
}
