import 'package:daily_planner/features/task/domain/entities/task_entity.dart';
import 'package:localstorage/localstorage.dart';

abstract class TaskBaseRepository {
  Future<List<Task>> getTasks();
}

class TaskFakeRepository implements TaskBaseRepository {
  @override
  Future<List<Task>> getTasks() async {
    return [
      Task(name: 'Task 1', priority: Priority.normal),
      Task(name: 'Task 2', priority: Priority.high),
      Task(name: 'Task 3', priority: Priority.normal),
    ];
  }
}

class TaskLocalStorageRepository implements TaskBaseRepository {
  final LocalStorage storage;

  TaskLocalStorageRepository({required this.storage});

  @override
  Future<List<Task>> getTasks() async {
    final tasks = await storage.getItem('tasks');
    if (tasks != null) {
      return List<Task>.from(
        (tasks as List).map(
          (task) => Task.fromJson(task),
        ),
      );
    }
    return [];
  }
}
