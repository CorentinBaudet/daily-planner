import 'package:daily_planner/features/task/domain/entities/task_entity.dart';
import 'package:daily_planner/features/task/domain/repositories/task_base_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'task_state.dart';

class TasksCubit extends Cubit<TasksState> {
  TasksCubit({required this.repository}) : super(InitialState()) {
    getTasks();
  }

  final TaskBaseRepository repository;

  void getTasks() {
    try {
      emit(LoadingState());
      final tasks = repository.getTasks();
      emit(LoadedState(tasks: tasks));
    } catch (e) {
      emit(ErrorState(message: e.toString()));
    }
  }

  void createTask(Task task) async {
    try {
      emit(LoadingState());
      await repository.createTask(task);
      getTasks();
    } catch (e) {
      emit(ErrorState(message: e.toString()));
    }
  }

  void updateTask(Task task) async {
    try {
      emit(LoadingState());
      await repository.updateTask(task);
      getTasks();
    } catch (e) {
      emit(ErrorState(message: e.toString()));
    }
  }

  void deleteTask(int id) async {
    try {
      emit(LoadingState());
      await repository.deleteTask(id);
      getTasks();
    } catch (e) {
      emit(ErrorState(message: e.toString()));
    }
  }
}
