<div align="center">

# ✅ TaskFlow — Task Management App

### *Organize Everything. Miss Nothing.*

**Version 1.0.0** &nbsp;|&nbsp; **Developed by 7Sindhu Team**

[![Flutter](https://img.shields.io/badge/Flutter-3.5+-blue?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.5+-blue?logo=dart)](https://dart.dev)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web%20%7C%20Linux%20%7C%20Windows%20%7C%20macOS-indigo)](https://flutter.dev/multi-platform)
[![License](https://img.shields.io/badge/License-MIT-green)](LICENSE)
[![Privacy](https://img.shields.io/badge/Data-100%25%20Local-brightgreen)](https://flutter.dev)

---

> *"For every minute spent organizing, an hour is earned."* — Benjamin Franklin

**TaskFlow** is a free, open-source, feature-rich task management app built with Flutter.
Kanban boards, to-do lists, a journal, habit tracker, and calendar — all in one app, all stored locally.

</div>

---

## ✨ Features

### 📋 Kanban Board
| Feature | Description |
|---|---|
| Columns | To Do / In Progress / Done |
| Drag & Drop | Move cards between columns |
| Card Details | Title, description, priority, due date |
| Staggered Grid | Responsive card layout |

### ✔️ To-Do List
- Add tasks with title, priority (Low / Medium / High), and due date
- Check off completed tasks
- Filter by status or priority
- Swipe to delete

### 📓 Journal
- Daily free-form journal entries with timestamps
- Full entry history sorted by date
- Edit and delete entries

### 🔁 Habit Tracker
- Create daily habits with custom names and icons
- Mark habits complete each day
- Streak counter per habit
- Weekly completion grid

### 🗓️ Calendar
- Monthly calendar view
- Tasks and habits overlaid on calendar days
- Tap a day to see all items due

### 🌙 Dark / Light Mode
- System-aware theme with manual toggle
- Material 3 design

### 📱 Responsive Layout
| Screen Width | Layout |
|---|---|
| < 720px | Bottom navigation bar (6 destinations) |
| ≥ 720px | Side navigation rail with logo header |

---

## 🚀 Getting Started

### Prerequisites
- **Flutter SDK** ≥ 3.0.0 → [Install Flutter](https://flutter.dev/docs/get-started/install)

### Installation

```bash
git clone https://github.com/7Sindhu/TaskFlow.git
cd TaskFlow
flutter pub get
flutter run
```

### Build for Release

```bash
flutter build apk --release
flutter build ios --release
flutter build linux --release
flutter build web --release
flutter build windows --release
flutter build macos --release
```

---

## 🏗️ Project Architecture

```
TaskFlow/
├── lib/
│   ├── main.dart                    # App entry, responsive nav shell
│   ├── models/                      # Task, Habit, Journal models
│   ├── providers/
│   │   └── app_provider.dart        # Central state + dark mode
│   ├── screens/
│   │   ├── dashboard_screen.dart    # Overview stats
│   │   ├── kanban_screen.dart       # Kanban board
│   │   ├── todo_screen.dart         # To-do list
│   │   ├── calendar_screen.dart     # Calendar view
│   │   ├── journal_screen.dart      # Journal entries
│   │   └── habits_screen.dart       # Habit tracker
│   ├── utils/
│   │   └── app_theme.dart           # Light/dark theme definitions
│   └── widgets/                     # Reusable UI components
├── pubspec.yaml
└── README.md
```

---

## 📦 Dependencies

| Package | Version | Purpose |
|---|---|---|
| `provider` | ^6.1.2 | State management |
| `shared_preferences` | ^2.3.2 | Local data persistence |
| `uuid` | ^4.5.1 | Unique IDs |
| `intl` | ^0.19.0 | Date formatting |
| `flutter_staggered_grid_view` | ^0.7.0 | Kanban staggered grid |

---

## 🔒 Privacy

- ✅ All data stored locally via `shared_preferences`
- ✅ No internet permission required
- ✅ No analytics, no tracking, no ads

---

## 📄 License

MIT License — see [LICENSE](LICENSE) for details.

---

<div align="center">

Made with 💙 by **7Sindhu Team**

✅ **TaskFlow** — Plan. Track. Achieve.

</div>
