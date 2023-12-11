import 'dart:async';

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
  Task? getTask(int id) {
    // get a task by id from Hive box 'my_tasks'
    Task? task;
    try {
      task = getTasks().firstWhere((task) => task.id == id);
    } catch (e) {
      task = null;
    }
    return task;
  }

  @override
  Future<int> createTask(Task task) async {
    // add a task in Hive box 'my_tasks'
    task.id = task.hashCode;
    await _myTasks.put(task.id, task.toJson());
    return Future<int>.value(task.id as FutureOr<int>?);
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
