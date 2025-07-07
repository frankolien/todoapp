// File: lib/viewmodels/add_edit_todo_viewmodel.dart
import 'package:flutter/foundation.dart';
import '../models/todo_model.dart';

class AddEditTodoViewModel extends ChangeNotifier {
  String _title = '';
  String _description = '';
  DateTime? _dueDate;
  bool _hasReminder = false;
  bool _isEditing = false;
  Todo? _originalTodo;

  // Getters
  String get title => _title;
  String get description => _description;
  DateTime? get dueDate => _dueDate;
  bool get hasReminder => _hasReminder;
  bool get isEditing => _isEditing;
  bool get isValid => _title.trim().isNotEmpty;

  void initializeForEdit(Todo todo) {
    _originalTodo = todo;
    _title = todo.title;
    _description = todo.description;
    _dueDate = todo.dueDate;
    _hasReminder = todo.hasReminder;
    _isEditing = true;
    notifyListeners();
  }

  void setTitle(String title) {
    _title = title;
    notifyListeners();
  }

  void setDescription(String description) {
    _description = description;
    notifyListeners();
  }

  void setDueDate(DateTime? dueDate) {
    _dueDate = dueDate;
    notifyListeners();
  }

  void clearDueDate() {
    _dueDate = null;
    notifyListeners();
  }

  void setHasReminder(bool hasReminder) {
    _hasReminder = hasReminder;
    notifyListeners();
  }

  void reset() {
    _title = '';
    _description = '';
    _dueDate = null;
    _hasReminder = false;
    _isEditing = false;
    _originalTodo = null;
    notifyListeners();
  }

  Map<String, dynamic> getTodoData() {
    return {
      'title': _title,
      'description': _description,
      'dueDate': _dueDate,
      'hasReminder': _hasReminder,
      'originalTodo': _originalTodo,
    };
  }
}