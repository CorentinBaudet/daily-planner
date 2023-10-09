import 'package:daily_planner/features/task/domain/entities/task_entity.dart';
import 'package:daily_planner/features/task/domain/repositories/task_base_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'task_event.dart';
part 'task_state.dart';

class TasksCubit extends Cubit<TasksState> {
  TasksCubit({required this.repository}) : super(InitialState()) {
    getAllTasks();
  }

  final TaskBaseRepository repository;

  void getAllTasks() {
    try {
      emit(LoadingState());
      final tasks = repository.getUndoneTasks();
      emit(LoadedState(tasks: tasks));
    } catch (e) {
      emit(ErrorState());
    }
  }

  void createTask(Task task) async {
    try {
      emit(LoadingState());
      await repository.createTask(task);
      getAllTasks();
    } catch (e) {
      emit(ErrorState());
    }
  }

  void updateTask(Task task) async {
    try {
      emit(LoadingState());
      await repository.updateTask(task);
      getAllTasks();
    } catch (e) {
      emit(ErrorState());
    }
  }

  void deleteTask(int id) async {
    try {
      emit(LoadingState());
      await repository.deleteTask(id);
      getAllTasks();
    } catch (e) {
      emit(ErrorState());
    }
  }
}
