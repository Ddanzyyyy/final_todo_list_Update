import 'package:flutter/material.dart';

class Task {
  int? id;
  String title;
  String description;
  String priority;
  DateTime dueDate;
  bool isCompleted;
  bool isDeleted; // Tambahkan properti isDeleted
  Color? priorityColor;

  Task({
    this.id,
    required this.title,
    required this.description,
    required this.priority,
    required this.dueDate,
    this.isCompleted = false,
    this.isDeleted = false, // Inisialisasi default ke false
    this.priorityColor,
  });

  String _colorToString(Color? color) {
    if (color == null) return '';
    return '${color.value}';
  }

  Color? _stringToColor(String? colorString) {
    if (colorString == null || colorString.isEmpty) return null;
    return Color(int.parse(colorString));
  }

  Map<String, dynamic> toMap() {
    return {
      // 'id': id, // ID akan dikelola oleh database
      'title': title,
      'description': description,
      'priority': priority,
      'dueDate': dueDate.toIso8601String(),
      'isCompleted': isCompleted ? 1 : 0,
      'isDeleted': isDeleted ? 1 : 0, // Tambahkan isDeleted ke map
      'priorityColor': _colorToString(priorityColor),
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] as int?,
      title: map['title'] as String,
      description: map['description'] as String? ?? '',
      priority: map['priority'] as String,
      dueDate: DateTime.parse(map['dueDate'] as String),
      isCompleted: (map['isCompleted'] as int) == 1,
      isDeleted: (map['isDeleted'] as int) == 1, // Ambil nilai isDeleted dari map
      priorityColor: map['priorityColor'] != null 
          ? Color(int.parse(map['priorityColor'] as String))
          : null,
    );
  }

  Task copyWith({
    int? id,
    String? title,
    String? description,
    String? priority,
    DateTime? dueDate,
    bool? isCompleted,
    bool? isDeleted, // Tambahkan parameter isDeleted untuk copyWith
    Color? priorityColor,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      dueDate: dueDate ?? this.dueDate,
      isCompleted: isCompleted ?? this.isCompleted,
      isDeleted: isDeleted ?? this.isDeleted, // Copy nilai isDeleted
      priorityColor: priorityColor ?? this.priorityColor,
    );
  }

  static Color getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'urgent':
        return Colors.red;
      case 'high':
        return Colors.orange;
      case 'medium':
        return Colors.yellow;
      case 'low':
        return Colors.green;
      case 'optional':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}
