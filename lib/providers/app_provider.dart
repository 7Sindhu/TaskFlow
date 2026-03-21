import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/task.dart';
import '../models/board.dart';
import '../models/journal_entry.dart';
import '../models/habit.dart';

const _uuid = Uuid();

class AppProvider extends ChangeNotifier {
  List<Task> _tasks = [];
  List<Board> _boards = [];
  List<JournalEntry> _journalEntries = [];
  List<Habit> _habits = [];
  bool _isDarkMode = false;

  List<Task> get tasks => _tasks;
  List<Board> get boards => _boards;
  List<JournalEntry> get journalEntries => _journalEntries;
  List<Habit> get habits => _habits;
  bool get isDarkMode => _isDarkMode;

  List<Task> get todoTasks =>
      _tasks.where((t) => !t.isCompleted && t.boardId == null).toList();
  List<Task> get completedTasks => _tasks.where((t) => t.isCompleted).toList();

  List<Task> tasksForBoard(String boardId) =>
      _tasks.where((t) => t.boardId == boardId).toList();

  List<Task> tasksForStatus(String boardId, TaskStatus status) =>
      _tasks.where((t) => t.boardId == boardId && t.status == status).toList();

  AppProvider() {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksData = prefs.getString('tasks');
    final boardsData = prefs.getString('boards');
    final journalData = prefs.getString('journal');
    final habitsData = prefs.getString('habits');
    _isDarkMode = prefs.getBool('darkMode') ?? false;

    if (tasksData != null) _tasks = Task.decodeList(tasksData);
    if (boardsData != null) _boards = Board.decodeList(boardsData);
    if (journalData != null) _journalEntries = JournalEntry.decodeList(journalData);
    if (habitsData != null) _habits = Habit.decodeList(habitsData);

    if (_boards.isEmpty) _seedDefaultBoard();
    notifyListeners();
  }

  void _seedDefaultBoard() {
    _boards = [
      Board(id: _uuid.v4(), name: 'My Project', description: 'Default board', color: 0xFF6366F1),
    ];
    _save();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('tasks', Task.encodeList(_tasks));
    await prefs.setString('boards', Board.encodeList(_boards));
    await prefs.setString('journal', JournalEntry.encodeList(_journalEntries));
    await prefs.setString('habits', Habit.encodeList(_habits));
    await prefs.setBool('darkMode', _isDarkMode);
  }

  // Tasks
  void addTask(Task task) {
    _tasks.add(task);
    _save();
    notifyListeners();
  }

  void updateTask(Task task) {
    final idx = _tasks.indexWhere((t) => t.id == task.id);
    if (idx != -1) {
      _tasks[idx] = task;
      _save();
      notifyListeners();
    }
  }

  void deleteTask(String id) {
    _tasks.removeWhere((t) => t.id == id);
    _save();
    notifyListeners();
  }

  void toggleTaskComplete(String id) {
    final idx = _tasks.indexWhere((t) => t.id == id);
    if (idx != -1) {
      _tasks[idx].isCompleted = !_tasks[idx].isCompleted;
      _save();
      notifyListeners();
    }
  }

  void moveTask(String taskId, TaskStatus newStatus) {
    final idx = _tasks.indexWhere((t) => t.id == taskId);
    if (idx != -1) {
      _tasks[idx].status = newStatus;
      _save();
      notifyListeners();
    }
  }

  String createTask({
    required String title,
    String description = '',
    Priority priority = Priority.medium,
    TaskStatus status = TaskStatus.todo,
    DateTime? dueDate,
    String? boardId,
    List<String> tags = const [],
  }) {
    final task = Task(
      id: _uuid.v4(),
      title: title,
      description: description,
      priority: priority,
      status: status,
      dueDate: dueDate,
      boardId: boardId,
      tags: tags,
    );
    addTask(task);
    return task.id;
  }

  // Boards
  void addBoard(Board board) {
    _boards.add(board);
    _save();
    notifyListeners();
  }

  void updateBoard(Board board) {
    final idx = _boards.indexWhere((b) => b.id == board.id);
    if (idx != -1) {
      _boards[idx] = board;
      _save();
      notifyListeners();
    }
  }

  void deleteBoard(String id) {
    _boards.removeWhere((b) => b.id == id);
    _tasks.removeWhere((t) => t.boardId == id);
    _save();
    notifyListeners();
  }

  String createBoard({required String name, String description = '', int color = 0xFF6366F1}) {
    final board = Board(id: _uuid.v4(), name: name, description: description, color: color);
    addBoard(board);
    return board.id;
  }

  // Journal
  void addJournalEntry(JournalEntry entry) {
    _journalEntries.insert(0, entry);
    _save();
    notifyListeners();
  }

  void updateJournalEntry(JournalEntry entry) {
    final idx = _journalEntries.indexWhere((e) => e.id == entry.id);
    if (idx != -1) {
      _journalEntries[idx] = entry;
      _save();
      notifyListeners();
    }
  }

  void deleteJournalEntry(String id) {
    _journalEntries.removeWhere((e) => e.id == id);
    _save();
    notifyListeners();
  }

  String createJournalEntry({
    required String title,
    String content = '',
    String mood = '😊',
    List<String> tags = const [],
  }) {
    final entry = JournalEntry(
      id: _uuid.v4(),
      title: title,
      content: content,
      mood: mood,
      tags: tags,
    );
    addJournalEntry(entry);
    return entry.id;
  }

  // Habits
  void addHabit(Habit habit) {
    _habits.add(habit);
    _save();
    notifyListeners();
  }

  void deleteHabit(String id) {
    _habits.removeWhere((h) => h.id == id);
    _save();
    notifyListeners();
  }

  void toggleHabitToday(String id) {
    final idx = _habits.indexWhere((h) => h.id == id);
    if (idx != -1) {
      final habit = _habits[idx];
      final today = DateTime.now();
      final alreadyDone = habit.isCompletedToday();
      if (alreadyDone) {
        habit.completedDates.removeWhere((d) =>
            d.year == today.year && d.month == today.month && d.day == today.day);
      } else {
        habit.completedDates.add(today);
      }
      _save();
      notifyListeners();
    }
  }

  String createHabit({required String name, String icon = '⭐', int color = 0xFF10B981}) {
    final habit = Habit(id: _uuid.v4(), name: name, icon: icon, color: color);
    addHabit(habit);
    return habit.id;
  }

  // Theme
  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    _save();
    notifyListeners();
  }

  // Stats
  Map<String, int> get taskStats => {
        'total': _tasks.length,
        'completed': _tasks.where((t) => t.isCompleted).length,
        'inProgress': _tasks.where((t) => t.status == TaskStatus.inProgress).length,
        'overdue': _tasks
            .where((t) =>
                !t.isCompleted &&
                t.dueDate != null &&
                t.dueDate!.isBefore(DateTime.now()))
            .length,
      };
}
