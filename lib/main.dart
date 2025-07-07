
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/models/todo_model.dart';
import 'package:todoapp/services/todo_service.dart';
import 'package:todoapp/viewmodels/todo_view_model.dart';
import 'views/todo_list_screen.dart';

void main() {
  runApp(TodoApp());
}

class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<TodoService>(create: (_) => TodoService()),
        ChangeNotifierProxyProvider<TodoService, TodoViewModel>(
          create: (context) => TodoViewModel(context.read<TodoService>()),
          update: (context, service, previous) => previous ?? TodoViewModel(service),
        ),
      ],
      child: Consumer<TodoViewModel>(
        builder: (context, viewModel, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Advanced Todo List',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              brightness: Brightness.light,
              useMaterial3: true,
            ),
            darkTheme: ThemeData(
              primarySwatch: Colors.blue,
              brightness: Brightness.dark,
              useMaterial3: true,
            ),
            themeMode: viewModel.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: TodoListScreen(),
          );
        },
      ),
    );
  }
}