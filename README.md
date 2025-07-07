# 📋 Todo App - Flutter + Hive ✨📝📦

This is an advanced **Flutter Todo List App** built with the **Hive NoSQL database**, featuring dark mode toggle, reminders, due dates, and smooth animations. 🧠📲🗂️

---

## 🚀 Features 🚧🛠️🎯

* Add, edit, delete tasks
* Set due dates and reminders
* Mark tasks as completed
* Highlight overdue tasks
* Dark/light theme toggle (saved in Hive)
* Smooth fade-in animation for UI
* Persistent offline storage using Hive

---

## 🏗️ File Structure & Explanation 🧱📚🔍

### `main()` and Initialization 🧪🔧🚀

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(TodoAdapter());
  await Hive.openBox<Todo>('todos');
  await Hive.openBox('settings');
  runApp(TodoApp());
}
```

* Initializes Hive and Flutter bindings 🌀🧰📦
* Registers `TodoAdapter` for storing `Todo` objects 🔖📁🧠
* Opens two Hive boxes: `todos` for task data, and `settings` for UI preferences 📂⚙️📝

---

### `Todo` Model Class 🧾📋📌

```dart
@HiveType(typeId: 0)
class Todo extends HiveObject {
  @HiveField(0) String id;
  @HiveField(1) String title;
  @HiveField(2) String description;
  @HiveField(3) bool isCompleted;
  @HiveField(4) DateTime createdAt;
  @HiveField(5) DateTime? dueDate;
  @HiveField(6) bool hasReminder;
  // ... constructor
}
```

* Represents a todo item 
* Annotated with Hive fields for local storage 
* Includes optional due date and reminder ⏰

---

### `TodoAdapter` ⚙️🔁📦

```dart
class TodoAdapter extends TypeAdapter<Todo> {
  // Converts Todo to binary (write) and vice versa (read)
}
```

* Required by Hive to serialize and deserialize `Todo` objects 🧰📤📥

---

### `TodoApp` Widget 

```dart
class TodoApp extends StatelessWidget { ... }
```

* Listens to the `settings` Hive box 🕵️‍♂️🎛️📥
* Toggles between dark and light themes based on saved preference 🌗⚙️🎨

---

### `TodoListScreen` 📝📄📲

```dart
class TodoListScreen extends StatefulWidget { ... }
```

* Loads `todos` and `settings` boxes 📦📦🔃
* Uses `ValueListenableBuilder` to watch for changes in the `todoBox` 👁️‍🗨️🎯🧠
* Applies fade-in animation on screen load 🎞️✨🎬

#### Main Widgets:

* ✅ `Checkbox` for marking completed tasks
* 📝 `TextField` and `BottomSheet` for adding/editing tasks
* 📅 Shows due date, created date
* ⚠️ Highlights overdue tasks in red
* 🌙 `IconButton` for theme toggling

---

### `AddEditTodoBottomSheet` 📥✍️🧾

```dart
class AddEditTodoBottomSheet extends StatefulWidget { ... }
```

* Opens when adding or editing a task 🪟🧑‍💻📌
* Handles form input for:

  * Title (required)
  * Description
  * Due date (optional)
  * Reminder toggle (switch)
* On save:

  * Adds a new task or updates existing one
  * Displays `SnackBar` as feedback 🥪📩📣

---

## 💾 Hive Boxes Used 

* \`\` → stores all Todo objects
* \`\` → stores boolean `isDarkMode` flag

---

## 📱 UI Design

* Uses `Material3` design 
* Colors, icons, spacing handled via `ThemeData` 
* Animations for fade-in and list card styling 
* Responsive and clean layout with `ListTile`, `Cards`, and `Dialogs` 

---

## 🔧 Dependencies 📦

```yaml
dependencies:
  flutter:
  hive:
  hive_flutter:
  intl:

dev_dependencies:
  hive_generator:
  build_runner:
```

Run code generation:

```bash
flutter packages pub run build_runner build --delete-conflicting-outputs
```

---

## 📎 Conclusion 📌

This app is a great example of building a modern, persistent, and interactive todo application with Flutter and Hive. You can extend it with: 🚀🧱🛠️

* Notifications
* Categories or priorities
* Firebase sync
* Login/authentication

---

## 👨‍💻 Author 🧑‍💻

**Frank Olien** ✍
