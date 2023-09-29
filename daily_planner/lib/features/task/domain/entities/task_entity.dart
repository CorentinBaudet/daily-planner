class Task {
  final String name;
  final Priority priority;

  Task({
    required this.name,
    required this.priority,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      name: json['name'],
      priority: Priority.values.firstWhere(
        (priority) => priority.toString() == 'Priority.${json['priority']}',
        orElse: () => Priority.normal,
      ),
    );
  }
}

enum Priority {
  normal,
  high,
}
