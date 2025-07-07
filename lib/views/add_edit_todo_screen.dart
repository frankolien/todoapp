// File: lib/views/add_edit_todo_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:todoapp/viewmodels/todo_view_model.dart';
import '../viewmodels/add_edit_todo_viewmodel.dart';
import '../models/todo_model.dart';

class AddEditTodoScreen extends StatefulWidget {
  final Todo? todo;

  AddEditTodoScreen({this.todo});

  @override
  _AddEditTodoScreenState createState() => _AddEditTodoScreenState();
}

class _AddEditTodoScreenState extends State<AddEditTodoScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late AddEditTodoViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = AddEditTodoViewModel();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();

    if (widget.todo != null) {
      _viewModel.initializeForEdit(widget.todo!);
      _titleController.text = widget.todo!.title;
      _descriptionController.text = widget.todo!.description;
    }

    _titleController.addListener(() => _viewModel.setTitle(_titleController.text));
    _descriptionController.addListener(() => _viewModel.setDescription(_descriptionController.text));
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDueDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _viewModel.dueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (picked != null) {
      _viewModel.setDueDate(picked);
    }
  }

  Future<void> _saveTodo() async {
    if (!_viewModel.isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a title')),
      );
      return;
    }

    final todoViewModel = context.read<TodoViewModel>();
    final data = _viewModel.getTodoData();

    try {
      if (_viewModel.isEditing && data['originalTodo'] != null) {
        await todoViewModel.updateTodo(
          data['originalTodo'],
          title: data['title'],
          description: data['description'],
          dueDate: data['dueDate'],
          hasReminder: data['hasReminder'],
        );
        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Todo updated')),
          );
        }
      } else {
        await todoViewModel.addTodo(
          title: data['title'],
          description: data['description'],
          dueDate: data['dueDate'],
          hasReminder: data['hasReminder'],
        );
        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Todo added')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Consumer<AddEditTodoViewModel>(
              builder: (context, viewModel, child) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          viewModel.isEditing ? 'Edit Todo' : 'Add New Todo',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        labelText: 'Title *',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.title),
                      ),
                      textCapitalization: TextCapitalization.sentences,
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        labelText: 'Description (optional)',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.description),
                      ),
                      maxLines: 3,
                      textCapitalization: TextCapitalization.sentences,
                    ),
                    SizedBox(height: 16),
                    Card(
                      child: ListTile(
                        leading: Icon(Icons.calendar_today),
                        title: Text('Due Date'),
                        subtitle: Text(viewModel.dueDate == null
                            ? 'No due date set'
                            : DateFormat('MMM dd, yyyy').format(viewModel.dueDate!)),
                        trailing: viewModel.dueDate == null
                            ? null
                            : IconButton(
                                icon: Icon(Icons.clear),
                                onPressed: () => viewModel.clearDueDate(),
                              ),
                        onTap: _selectDueDate,
                      ),
                    ),
                    SizedBox(height: 8),
                    Card(
                      child: SwitchListTile(
                        secondary: Icon(Icons.notifications),
                        title: Text('Reminder'),
                        subtitle: Text('Get notified about this todo'),
                        value: viewModel.hasReminder,
                        onChanged: (value) => viewModel.setHasReminder(value),
                      ),
                    ),
                    SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: viewModel.isValid ? _saveTodo : null,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(
                        viewModel.isEditing ? 'Save Changes' : 'Add Todo',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    SizedBox(height: 16),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}