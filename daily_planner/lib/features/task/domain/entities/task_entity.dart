class Task {
  final String name;
  final Priority priority;
  int? id;

  Task({
    required this.name,
    required this.priority,
    this.id,
  });

  factory Task.fromJson(Map<dynamic, dynamic> json) {
    print(json);
    return Task(
      name: json['name'],
      priority: Priority.values.firstWhere(
        (priority) => priority.toString() == 'Priority.${json['priority']}',
        orElse: () => Priority.normal,
      ),
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'priority': priority.toString().split('.').last,
      'id': id,
    };
  }
}

enum Priority {
  normal,
  high,
}
