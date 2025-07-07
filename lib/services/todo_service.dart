
import 'package:hive_flutter/hive_flutter.dart';
import '../models/todo_model.dart';

class TodoService {
  static const String _todoBoxName = 'todos';
  static const String _settingsBoxName = 'settings';

  Box<Todo>? _todoBox;
  Box? _settingsBox;


  Future<void> initialize() async {
    await Hive.initFlutter();
    
    // Register adapters
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(TodoAdapter());
    }
    
    _todoBox = await Hive.openBox<Todo>(_todoBoxName);
    _settingsBox = await Hive.openBox(_settingsBoxName);
  }

  Box<Todo>? get todoBox => _todoBox;
  Box? get settingsBox => _settingsBox;

  List<Todo> getAllTodos() {
    if (_todoBox == null) return [];
    return _todoBox!.values.toList();
  }

  Future<void> addTodo(Todo todo) async {
    await _todoBox?.add(todo);
  }

  Future<void> updateTodo(Todo todo) async {
    await todo.save();
  }

  Future<void> deleteTodo(Todo todo) async {
    await todo.delete();
  }

  Future<void> toggleTodoComplete(Todo todo) async {
    todo.isCompleted = !todo.isCompleted;
    await todo.save();
  }

  // settings 
  bool get isDarkMode => _settingsBox?.get('isDarkMode', defaultValue: false) ?? false;
  
  Future<void> toggleTheme() async {
    await _settingsBox?.put('isDarkMode', !isDarkMode);
  }

  // Streams for reactive updates
  Stream<List<Todo>> get todosStream => _todoBox?.watch().map((_) => getAllTodos()) ?? Stream.empty();
  Stream<bool> get themeStream => _settingsBox?.watch(key: 'isDarkMode').map((_) => isDarkMode) ?? Stream.empty();
}

