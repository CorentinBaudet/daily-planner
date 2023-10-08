import 'package:daily_planner/constants/intl.dart';
import 'package:daily_planner/features/task/domain/entities/task_entity.dart';

class TaskUseCases {
  DateTime troncateCreationTime(DateTime createdAt) {
    return ConstantsIntl.dateTimeFormat
        .parse(ConstantsIntl.dateTimeFormat.format(createdAt));
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
