import 'package:daily_planner/features/task/domain/entities/task_entity.dart';
import 'package:daily_planner/features/task/domain/repositories/task_base_repository.dart';
import 'package:hive/hive.dart';

class TaskLocalStorageRepository implements TaskBaseRepository {
  // unique instance of Hive box 'my_tasks'
  final Box _myTasks = Hive.box('my_tasks');

  TaskLocalStorageRepository();

  @override
  Future<List<Task>> getTasks() async {
    // get all tasks from Hive box 'my_tasks'
    final tasks = _myTasks.values;

    List<Task> taskList = [];

    for (var task in tasks) {
      taskList.add(Task.fromJson(task));
    }
    return taskList;
  }

  @override
  Future<void> createTask(Task task) async {
    print(task.hashCode);
    // add a task in Hive box 'my_tasks'
    await _myTasks.put(task.hashCode, task.toJson());
  }

  @override
  Future<void> deleteTask(Task task) async {
    print(task.id);
    // delete a task from Hive box 'my_tasks'
    await _myTasks.delete(task.id);
  }
}
