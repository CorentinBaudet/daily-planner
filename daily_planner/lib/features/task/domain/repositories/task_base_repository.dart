import 'package:daily_planner/features/task/domain/entities/task_entity.dart';
import 'package:hive/hive.dart';

abstract class TaskBaseRepository {
  Future<List<Task>> getTasks();
  Future<void> addTask(Task task);
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

  @override
  Future<void> addTask(Task task) {
    // TODO: implement addTask
    throw UnimplementedError();
  }
}

class TaskLocalStorageRepository implements TaskBaseRepository {
  // final Box storage;

  TaskLocalStorageRepository();

  @override
  Future<List<Task>> getTasks() async {
    final storage = await Hive.openBox('my_tasks');

    final tasks = storage.get('tasks');

    if (tasks != null) {
      return List<Task>.from(
        (tasks as List).map(
          (task) => Task.fromJson(task),
        ),
      );
    }
    return [];

    // final tasks = await storage.getItem('tasks');
    // if (tasks != null) {
    //   return List<Task>.from(
    //     (tasks as List).map(
    //       (task) => Task.fromJson(task),
    //     ),
    //   );
    // }
    // return [];
  }

  @override
  Future<void> addTask(Task task) {
    // TODO: implement addTask
    // add a task in Hive box 'my_tasks'
    throw UnimplementedError();
  }
}
