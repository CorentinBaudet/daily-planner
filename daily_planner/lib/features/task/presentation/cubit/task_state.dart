part of 'task_cubit.dart';

abstract class TaskState extends Equatable {
  const TaskState();
}

class InitialState extends TaskState {
  @override
  List<Object> get props => [];
}

class LoadingState extends TaskState {
  @override
  List<Object> get props => [];
}

class LoadedState extends TaskState {
  final List<Task> tasks;

  const LoadedState({required this.tasks});

  @override
  List<Object> get props => [tasks];
}

class ErrorState extends TaskState {
  final String message;

  const ErrorState({required this.message});

  @override
  List<Object> get props => [];
}
