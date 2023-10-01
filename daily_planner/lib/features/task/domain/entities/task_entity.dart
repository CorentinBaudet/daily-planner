class Task {
  final String name;
  final Priority priority;
  int? hashcode;

  Task({
    required this.name,
    required this.priority,
    this.hashcode,
  });

  factory Task.fromJson(Map<dynamic, dynamic> json) {
    return Task(
      hashcode: json.keys.first,
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
