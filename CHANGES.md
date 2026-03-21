# 📋 CHANGES — TaskFlow

All notable changes to **TaskFlow** are documented in this file.

Format follows [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).
Versioning follows [Semantic Versioning](https://semver.org/).

Developed by **7Sindhu Team**

---

## [1.0.0] — Initial Release

### 🎉 Initial Public Release

First public release of **TaskFlow**, a free, open-source, feature-rich task management app built with Flutter.

---

### ✅ Added

#### 📋 Kanban Board
- Three-column board: To Do / In Progress / Done
- Drag-and-drop card movement between columns
- Card details: title, description, priority, due date
- Staggered grid layout via `flutter_staggered_grid_view`

#### ✔️ To-Do List
- Add tasks with title, priority (Low / Medium / High), and due date
- Check off completed tasks
- Filter by status or priority
- Swipe-to-delete

#### 📓 Journal
- Daily free-form journal entries with timestamps
- Full entry history sorted by date (newest first)
- Edit and delete entries

#### 🔁 Habit Tracker
- Create daily habits with custom names
- Mark habits complete each day
- Streak counter per habit
- Weekly completion grid view

#### 🗓️ Calendar
- Monthly calendar view
- Tasks and habits overlaid on calendar days
- Tap a day to see all items due

#### 🌙 Theme
- Light and dark mode with system-aware switching
- Manual toggle via `AppProvider`
- Material 3 design system

#### 📱 Responsive Layout
- Bottom navigation bar on mobile (< 720px) — 6 destinations
- Side navigation rail on desktop/tablet (≥ 720px) with logo header

#### 🏗️ Technical
- `AppProvider` (`ChangeNotifier`) for central state management
- `shared_preferences` for JSON-serialized data persistence
- `uuid` for unique IDs across all models
- `intl` for date formatting
