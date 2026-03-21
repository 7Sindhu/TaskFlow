import 'dart:convert';

class Habit {
  final String id;
  String name;
  String icon;
  int color;
  List<DateTime> completedDates;
  String frequency; // daily, weekly
  DateTime createdAt;

  Habit({
    required this.id,
    required this.name,
    this.icon = '⭐',
    this.color = 0xFF10B981,
    this.completedDates = const [],
    this.frequency = 'daily',
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  bool isCompletedToday() {
    final today = DateTime.now();
    return completedDates.any((d) =>
        d.year == today.year && d.month == today.month && d.day == today.day);
  }

  int get currentStreak {
    if (completedDates.isEmpty) return 0;
    final sorted = [...completedDates]..sort((a, b) => b.compareTo(a));
    int streak = 0;
    DateTime check = DateTime.now();
    for (final date in sorted) {
      final diff = check.difference(date).inDays;
      if (diff <= 1) {
        streak++;
        check = date.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }
    return streak;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'icon': icon,
        'color': color,
        'completedDates': completedDates.map((d) => d.toIso8601String()).toList(),
        'frequency': frequency,
        'createdAt': createdAt.toIso8601String(),
      };

  factory Habit.fromJson(Map<String, dynamic> json) => Habit(
        id: json['id'],
        name: json['name'],
        icon: json['icon'] ?? '⭐',
        color: json['color'] ?? 0xFF10B981,
        completedDates: (json['completedDates'] as List? ?? [])
            .map((d) => DateTime.parse(d))
            .toList(),
        frequency: json['frequency'] ?? 'daily',
        createdAt: DateTime.parse(json['createdAt']),
      );

  static String encodeList(List<Habit> habits) =>
      jsonEncode(habits.map((h) => h.toJson()).toList());

  static List<Habit> decodeList(String data) =>
      (jsonDecode(data) as List).map((e) => Habit.fromJson(e)).toList();
}
