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
