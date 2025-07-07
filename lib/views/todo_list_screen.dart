import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:todoapp/viewmodels/todo_view_model.dart';
import '../models/todo_model.dart';
import 'add_edit_todo_screen.dart';

class TodoListScreen extends StatefulWidget {
  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _showAddTodoBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddEditTodoScreen(),
    );
  }

  void _showEditTodoBottomSheet(Todo todo) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddEditTodoScreen(todo: todo),
    );
  }

  void _showDeleteConfirmation(Todo todo) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Todo'),
        content: Text('Are you sure you want to delete "${todo.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await context.read<TodoViewModel>().deleteTodo(todo);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Todo deleted')),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List'),
        actions: [
          Consumer<TodoViewModel>(
            builder: (context, viewModel, child) {
              if (viewModel.overdueTodosCount > 0) {
                return Badge(
                  label: Text(viewModel.overdueTodosCount.toString()),
                  child: IconButton(
                    icon: Icon(Icons.warning),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('You have ${viewModel.overdueTodosCount} overdue todos'),
                        ),
                      );
                    },
                  ),
                );
              }
              return SizedBox.shrink();
            },
          ),
          IconButton(
            icon: Icon(Icons.brightness_6),
            onPressed: () => context.read<TodoViewModel>().toggleTheme(),
          ),
        ],
      ),
      body: Consumer<TodoViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (viewModel.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error, size: 64, color: Colors.red),
                  SizedBox(height: 16),
                  Text(
                    viewModel.error!,
                    style: TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => viewModel.clearError(),
                    child: Text('Dismiss'),
                  ),
                ],
              ),
            );
          }

          return FadeTransition(
            opacity: _fadeAnimation,
            child: _buildTodoList(viewModel),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTodoBottomSheet,
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: Consumer<TodoViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isEmpty) return SizedBox.shrink();
          
          return Container(
            padding: EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatChip('Total', viewModel.todos.length.toString()),
                _buildStatChip('Completed', viewModel.completedCount.toString()),
                _buildStatChip('Pending', viewModel.pendingCount.toString()),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatChip(String label, String value) {
    return Chip(
      label: Text('$label: $value'),
      backgroundColor: Colors.blue.shade100,
    );
  }

  Widget _buildTodoList(TodoViewModel viewModel) {
    if (viewModel.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle_outline, size: 100, color: Colors.grey),
            SizedBox(height: 20),
            Text(
              'No todos yet!',
              style: TextStyle(fontSize: 24, color: Colors.grey),
            ),
            SizedBox(height: 10),
            Text(
              'Add your first todo by tapping the + button',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: viewModel.sortedTodos.length,
      itemBuilder: (context, index) {
        final todo = viewModel.sortedTodos[index];
        return AnimatedContainer(
          duration: Duration(milliseconds: 300),
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Card(
            elevation: 3,
            color: todo.isOverdue ? Colors.red.shade50 : null,
            child: ListTile(
              leading: Checkbox(
                value: todo.isCompleted,
                onChanged: (value) => viewModel.toggleTodoComplete(todo),
                activeColor: Colors.green,
              ),
              title: Text(
                todo.title,
                style: TextStyle(
                  decoration: todo.isCompleted
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                  color: todo.isCompleted
                      ? Colors.grey
                      : todo.isOverdue
                          ? Colors.red.shade700
                          : null,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: _buildTodoSubtitle(todo),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.blue),
                    onPressed: () => _showEditTodoBottomSheet(todo),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _showDeleteConfirmation(todo),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTodoSubtitle(Todo todo) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (todo.description.isNotEmpty)
          Text(
            todo.description,
            style: TextStyle(
              color: todo.isCompleted ? Colors.grey : Colors.black54,
            ),
          ),
        SizedBox(height: 4),
        Row(
          children: [
            Icon(Icons.calendar_today, size: 12, color: Colors.grey),
            SizedBox(width: 4),
            Text(
              'Created: ${DateFormat('MMM dd, yyyy').format(todo.createdAt)}',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        if (todo.dueDate != null)
          Row(
            children: [
              Icon(
                todo.isOverdue ? Icons.warning : Icons.schedule,
                size: 12,
                color: todo.isOverdue ? Colors.red : Colors.orange,
              ),
              SizedBox(width: 4),
              Text(
                'Due: ${DateFormat('MMM dd, yyyy').format(todo.dueDate!)}',
                style: TextStyle(
                  fontSize: 12,
                  color: todo.isOverdue ? Colors.red : Colors.orange,
                  fontWeight: todo.isOverdue ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        if (todo.hasReminder)
          Row(
            children: [
              Icon(Icons.notifications, size: 12, color: Colors.blue),
              SizedBox(width: 4),
              Text(
                'Reminder set',
                style: TextStyle(fontSize: 12, color: Colors.blue),
              ),
            ],
          ),
      ],
    );
  }
}
