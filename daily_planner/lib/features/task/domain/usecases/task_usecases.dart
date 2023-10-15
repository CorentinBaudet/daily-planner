import 'package:daily_planner/features/task/domain/entities/task_entity.dart';

class TaskUseCases {
  // method to retrieve tasks that are not done
  List<Task> getUndoneTasks(List<Task> tasks) {
    return tasks.where((task) => !task.isDone).toList(growable: false);
  }

  // method to retrieve tasks that are not planned
  List<Task> getUnplannedTasks(List<Task> tasks) {
    return tasks
        .where((task) => !task.isPlanned && !task.isDone)
        .toList(growable: false);
  }

  // method to sort tasks by both creation date and priority
  List<Task> sortTasks(List<Task> tasks) {
    // separate tasks in two lists by priority
    final highPriorityTasks = tasks
        .where((task) => task.priority == Priority.high)
        .toList(growable: false);
    final normalPriorityTasks = tasks
        .where((task) => task.priority == Priority.normal)
        .toList(growable: false);

    // sort each list by creation date in reverse order
    highPriorityTasks.sort((a, b) => compareCreationDate(a, b));
    normalPriorityTasks.sort((a, b) => compareCreationDate(a, b));

    // merge the two lists
    tasks = [...highPriorityTasks, ...normalPriorityTasks];

    return tasks;
  }

  // method to sort tasks by creation date
  int compareCreationDate(Task a, Task b) {
    if (a == b) return 0;
    return a.createdAt.compareTo(b.createdAt);
  }
}
