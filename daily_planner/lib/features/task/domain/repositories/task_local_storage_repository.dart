import 'package:daily_planner/features/task/domain/entities/task_entity.dart';
import 'package:daily_planner/features/task/domain/repositories/task_base_repository.dart';
import 'package:hive/hive.dart';

class TaskLocalStorageRepository implements TaskBaseRepository {
  final Box _myTasks = Hive.box('my_tasks');

  TaskLocalStorageRepository();

  @override
  List<Task> getTasks() {
    // get all tasks from Hive box 'my_tasks'
    final tasks = _myTasks.values;

    List<Task> taskList = [];

    for (var task in tasks) {
      taskList.add(Task.fromJson(task));
    }
    return taskList;
  }

  @override
  List<Task> getUndoneTasks() {
    // get all tasks from Hive box 'my_tasks'
    final tasks = _myTasks.values;

    List<Task> taskList = [];

    // print(tasks.first);
    // var task = tasks.first;
    // Task task1 = Task.fromJson(task);

    for (var task in tasks) {
      Task.fromJson(task).isDone == false
          ? taskList.add(Task.fromJson(task))
          : null;
    }
    return taskList;
  }

  @override
  Future<void> createTask(Task task) async {
    // add a task in Hive box 'my_tasks'
    task.id = task.hashCode;
    await _myTasks.put(task.id, task.toJson());
  }

  @override
  Future<void> updateTask(Task task) {
    // update a task in Hive box 'my_tasks'
    return _myTasks.put(task.id, task.toJson());
  }

  @override
  Future<void> deleteTask(int id) async {
    // delete a task from Hive box 'my_tasks'
    await _myTasks.delete(id);
  }
}
