class Task {
  int? id;
  final String name;
  final Priority priority;
  bool isDone;

  Task({
    this.id,
    required this.name,
    required this.priority,
    this.isDone = false,
  });

  factory Task.fromJson(Map<dynamic, dynamic> json) {
    return Task(
      id: json['id'],
      name: json['name'],
      priority: Priority.values.firstWhere(
        (priority) => priority.toString() == 'Priority.${json['priority']}',
        orElse: () => Priority.normal,
      ),
      isDone: json['isDone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'priority': priority.toString().split('.').last,
      'isDone': isDone,
    };
  }
}

enum Priority {
  normal,
  high,
}
