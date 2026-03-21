import 'dart:convert';

class Board {
  final String id;
  String name;
  String description;
  int color;
  DateTime createdAt;

  Board({
    required this.id,
    required this.name,
    this.description = '',
    this.color = 0xFF6366F1,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'color': color,
        'createdAt': createdAt.toIso8601String(),
      };

  factory Board.fromJson(Map<String, dynamic> json) => Board(
        id: json['id'],
        name: json['name'],
        description: json['description'] ?? '',
        color: json['color'] ?? 0xFF6366F1,
        createdAt: DateTime.parse(json['createdAt']),
      );

  static String encodeList(List<Board> boards) =>
      jsonEncode(boards.map((b) => b.toJson()).toList());

  static List<Board> decodeList(String data) =>
      (jsonDecode(data) as List).map((e) => Board.fromJson(e)).toList();
}
