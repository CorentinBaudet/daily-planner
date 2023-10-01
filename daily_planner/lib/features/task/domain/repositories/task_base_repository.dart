import 'package:daily_planner/features/task/domain/entities/task_entity.dart';

abstract class TaskBaseRepository {
  Future<List<Task>> getTasks();
  Future<void> createTask(Task task);
}

class TaskFakeRepository implements TaskBaseRepository {
  @override
  Future<List<Task>> getTasks() async {
    return [
      // Task(name: 'Task 1', priority: Priority.normal),
      // Task(name: 'Task 2', priority: Priority.high),
      // Task(name: 'Task 3', priority: Priority.normal),
    ];
  }

  @override
  Future<void> createTask(Task task) {
    // TODO: implement addTask
    throw UnimplementedError();
  }
}
