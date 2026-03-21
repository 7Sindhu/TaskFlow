import 'dart:convert';

enum Priority { low, medium, high }
enum TaskStatus { todo, inProgress, review, done }

class Task {
  final String id;
  String title;
  String description;
  Priority priority;
  TaskStatus status;
  DateTime? dueDate;
  bool isCompleted;
  String? boardId;
  List<String> tags;
  DateTime createdAt;

  Task({
    required this.id,
    required this.title,
    this.description = '',
    this.priority = Priority.medium,
    this.status = TaskStatus.todo,
    this.dueDate,
    this.isCompleted = false,
    this.boardId,
    this.tags = const [],
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Task copyWith({
    String? title,
    String? description,
    Priority? priority,
    TaskStatus? status,
    DateTime? dueDate,
    bool? isCompleted,
    String? boardId,
    List<String>? tags,
  }) {
    return Task(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      dueDate: dueDate ?? this.dueDate,
      isCompleted: isCompleted ?? this.isCompleted,
      boardId: boardId ?? this.boardId,
      tags: tags ?? this.tags,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'priority': priority.index,
        'status': status.index,
        'dueDate': dueDate?.toIso8601String(),
        'isCompleted': isCompleted,
        'boardId': boardId,
        'tags': tags,
        'createdAt': createdAt.toIso8601String(),
      };

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        id: json['id'],
        title: json['title'],
        description: json['description'] ?? '',
        priority: Priority.values[json['priority'] ?? 1],
        status: TaskStatus.values[json['status'] ?? 0],
        dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
        isCompleted: json['isCompleted'] ?? false,
        boardId: json['boardId'],
        tags: List<String>.from(json['tags'] ?? []),
        createdAt: DateTime.parse(json['createdAt']),
      );

  static String encodeList(List<Task> tasks) =>
      jsonEncode(tasks.map((t) => t.toJson()).toList());

  static List<Task> decodeList(String data) =>
      (jsonDecode(data) as List).map((e) => Task.fromJson(e)).toList();
}
