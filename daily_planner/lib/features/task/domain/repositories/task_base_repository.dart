import 'package:daily_planner/features/task/domain/entities/task_entity.dart';

abstract class TaskBaseRepository {
  List<Task> getTasks();
  List<Task> getUndoneTasks();
  Future<void> createTask(Task task);
  Future<void> updateTask(Task task);
  Future<void> deleteTask(Task task);
}

class TaskFakeRepository implements TaskBaseRepository {
  @override
  List<Task> getTasks() {
    throw UnimplementedError();
  }

  @override
  List<Task> getUndoneTasks() {
    throw UnimplementedError();
  }

  @override
  Future<void> createTask(Task task) {
    throw UnimplementedError();
  }

  @override
  Future<void> updateTask(Task task) {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteTask(Task task) {
    throw UnimplementedError();
  }
}
