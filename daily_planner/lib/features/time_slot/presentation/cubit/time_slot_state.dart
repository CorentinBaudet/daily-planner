part of 'time_slot_cubit.dart';

abstract class PlannerState extends Equatable {
  const PlannerState();
}

class InitialState extends PlannerState {
  @override
  List<Object> get props => [];
}

class LoadingState extends PlannerState {
  @override
  List<Object> get props => [];
}

class LoadedState extends PlannerState {
  final List<TimeSlot> timeSlots;

  const LoadedState({required this.timeSlots});

  @override
  List<Object> get props => [timeSlots];
}

class ErrorState extends PlannerState {
  final String message;

  const ErrorState({required this.message});

  @override
  List<Object> get props => [message];
}
