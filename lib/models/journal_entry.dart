import 'dart:convert';

class JournalEntry {
  final String id;
  String title;
  String content;
  String mood;
  List<String> tags;
  DateTime date;

  JournalEntry({
    required this.id,
    required this.title,
    this.content = '',
    this.mood = '😊',
    this.tags = const [],
    DateTime? date,
  }) : date = date ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'content': content,
        'mood': mood,
        'tags': tags,
        'date': date.toIso8601String(),
      };

  factory JournalEntry.fromJson(Map<String, dynamic> json) => JournalEntry(
        id: json['id'],
        title: json['title'],
        content: json['content'] ?? '',
        mood: json['mood'] ?? '😊',
        tags: List<String>.from(json['tags'] ?? []),
        date: DateTime.parse(json['date']),
      );

  static String encodeList(List<JournalEntry> entries) =>
      jsonEncode(entries.map((e) => e.toJson()).toList());

  static List<JournalEntry> decodeList(String data) =>
      (jsonDecode(data) as List).map((e) => JournalEntry.fromJson(e)).toList();
}
