class Task {
  int? id;
  final String name;
  final Priority priority;

  Task({
    required this.name,
    required this.priority,
    this.id,
  });

  factory Task.fromJson(Map<dynamic, dynamic> json) {
    return Task(
      id: json.keys.first,
      name: json[json.keys.first]['name'],
      priority: Priority.values.firstWhere(
        (priority) =>
            priority.toString() ==
            'Priority.${json[json.keys.first]['priority']}',
        orElse: () => Priority.normal,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'priority': priority.toString().split('.').last,
    };
  }
}

enum Priority {
  normal,
  high,
}
