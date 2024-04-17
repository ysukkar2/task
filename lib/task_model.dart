class Task {
  int id;
  String title;
  bool isCompleted;

  Task({required this.id, required this.title, required this.isCompleted});

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      isCompleted: json['completed'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'completed': isCompleted,
  };
}
