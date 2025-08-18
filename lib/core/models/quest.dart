// Directory: lib/core/models

class Quest {
  final int id;
  final int userId;
  final String title;
  final bool completed;

  Quest({
    required this.id,
    required this.userId,
    required this.title,
    required this.completed,
  });

  factory Quest.fromJson(Map<String, dynamic> json) {
    return Quest(
      id: json['id'],
      userId: json['userId'],
      title: json['title'],
      completed: json['completed'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'completed': completed,
    };
  }
}