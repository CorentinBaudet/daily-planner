import 'package:daily_planner/features/task/domain/entities/task_entity.dart';

abstract class TaskBaseRepository {
  List<Task> getTasks();
  Task getTask(int id);
  Future<void> createTask(Task task);
  Future<void> updateTask(Task task);
  Future<void> deleteTask(int id);
}
