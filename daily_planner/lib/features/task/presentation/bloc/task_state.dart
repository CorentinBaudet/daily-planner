part of 'task_bloc.dart';

abstract class TasksState extends Equatable {
  const TasksState();

  @override
  List<Object> get props => [];
}

class InitialState extends TasksState {}

class LoadingState extends TasksState {}

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
