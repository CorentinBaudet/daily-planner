part of 'task_cubit.dart';

abstract class TasksState extends Equatable {
  const TasksState();
}

class InitialState extends TasksState {
  @override
  List<Object> get props => [];
}

class LoadingState extends TasksState {
  @override
  List<Object> get props => [];
}

class LoadedState extends TasksState {
  final List<Task> tasks;

  const LoadedState({required this.tasks});

  @override
  List<Object> get props => [tasks];
}

class ErrorState extends TasksState {
  // final String message;

  // const ErrorState({required this.message});

  // @override
  // List<Object> get props => [message];
  @override
  List<Object> get props => [];
}
