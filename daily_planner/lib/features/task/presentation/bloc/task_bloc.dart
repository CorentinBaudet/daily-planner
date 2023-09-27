import 'package:daily_planner/features/task/domain/entities/task_entity.dart';
import 'package:daily_planner/features/task/domain/repositories/task_base_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'task_event.dart';
part 'task_state.dart';

// class TaskBloc extends Bloc<TaskEvent, TaskState> {
//   TaskBloc() : super(InitialState()) {
//     on<TaskEvent>((event, emit) {
//       // TODO: implement event handler
//     });
//   }
// }

class TasksCubit extends Cubit<TasksState> {
  TasksCubit({required this.repository}) : super(InitialState()) {
    getAllTasks();
  }

  final TaskFakeRepository repository;

  void getAllTasks() async {
    try {
      emit(LoadingState());
      final tasks = await repository.getTasks();
      emit(LoadedState(tasks: tasks));
    } catch (e) {
      emit(ErrorState());
    }
  }
}
