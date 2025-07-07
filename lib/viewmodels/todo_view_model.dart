// File: lib/viewmodels/todo_viewmodel.dart
import 'package:flutter/foundation.dart';
import 'package:todoapp/services/todo_service.dart';
import '../models/todo_model.dart';


class TodoViewModel extends ChangeNotifier {
  final TodoService _todoService;
  
  List<Todo> _todos = [];
  bool _isLoading = true;
  String? _error;

  TodoViewModel(this._todoService) {
    _initialize();
  }

  // Getters
  List<Todo> get todos => List.unmodifiable(_todos);
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isEmpty => _todos.isEmpty;
  bool get isDarkMode => _todoService.isDarkMode;

  // Computed properties
  List<Todo> get sortedTodos {
    final sortedList = List<Todo>.from(_todos);
    sortedList.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return sortedList;
  }

  int get completedCount => _todos.where((todo) => todo.isCompleted).length;
  int get pendingCount => _todos.where((todo) => !todo.isCompleted).length;
  int get overdueTodosCount => _todos.where((todo) => todo.isOverdue).length;

  Future<void> _initialize() async {
    try {
      _setLoading(true);
      await _todoService.initialize();
      _loadTodos();
      _setLoading(false);
    } catch (e) {
      _setError('Failed to initialize: $e');
      _setLoading(false);
    }
  }

  void _loadTodos() {
    _todos = _todoService.getAllTodos();
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }

  Future<void> addTodo({
    required String title,
    String description = '',
    DateTime? dueDate,
    bool hasReminder = false,
  }) async {
    try {
      final todo = Todo(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title.trim(),
        description: description.trim(),
        createdAt: DateTime.now(),
        dueDate: dueDate,
        hasReminder: hasReminder,
      );

      await _todoService.addTodo(todo);
      _loadTodos();
    } catch (e) {
      _setError('Failed to add todo: $e');
    }
  }

  Future<void> updateTodo(Todo todo, {
    String? title,
    String? description,
    DateTime? dueDate,
    bool? hasReminder,
  }) async {
    try {
      todo.title = title?.trim() ?? todo.title;
      todo.description = description?.trim() ?? todo.description;
      todo.dueDate = dueDate ?? todo.dueDate;
      todo.hasReminder = hasReminder ?? todo.hasReminder;

      await _todoService.updateTodo(todo);
      _loadTodos();
    } catch (e) {
      _setError('Failed to update todo: $e');
    }
  }

  Future<void> deleteTodo(Todo todo) async {
    try {
      await _todoService.deleteTodo(todo);
      _loadTodos();
    } catch (e) {
      _setError('Failed to delete todo: $e');
    }
  }

  Future<void> toggleTodoComplete(Todo todo) async {
    try {
      await _todoService.toggleTodoComplete(todo);
      _loadTodos();
    } catch (e) {
      _setError('Failed to toggle todo: $e');
    }
  }

  Future<void> toggleTheme() async {
    try {
      await _todoService.toggleTheme();
      notifyListeners();
    } catch (e) {
      _setError('Failed to toggle theme: $e');
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}