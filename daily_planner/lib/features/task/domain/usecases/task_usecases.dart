import 'package:daily_planner/features/task/domain/entities/priority_entity.dart';
import 'package:daily_planner/features/task/domain/entities/task_entity.dart';

class TaskUseCases {
  // Method to retrieve tasks that are not done
  static List<Task> getUndoneTasks(List<Task> tasks) {
    return tasks.where((task) => !task.isDone).toList(growable: false);
  }

  // Method to retrieve tasks that are not planned
  static List<Task> getUnplannedTasks(List<Task> tasks) {
    return tasks
        .where((task) => !task.isPlanned && !task.isDone)
        .toList(growable: false);
  }

  // Method to sort tasks by both creation date and priority
  static List<Task> sortTasks(List<Task> tasks) {
    // Separate tasks in two lists by priority
    final highPriorityTasks = tasks
        .where((task) => task.priority == Priority.high)
        .toList(growable: false);
    final normalPriorityTasks = tasks
        .where((task) => task.priority == Priority.normal)
        .toList(growable: false);

    // Sort each list by creation date in reverse order
    highPriorityTasks.sort((a, b) => _compareCreationDate(a, b));
    normalPriorityTasks.sort((a, b) => _compareCreationDate(a, b));

    // Merge the two lists
    tasks = [...highPriorityTasks, ...normalPriorityTasks];

    return tasks;
  }

  // Method to sort tasks by creation date
  static int _compareCreationDate(Task a, Task b) {
    if (a == b) return 0;
    return a.createdAt.compareTo(b.createdAt);
  }
}
