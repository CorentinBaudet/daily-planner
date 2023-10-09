part of 'time_slot_cubit.dart';

abstract class TimeSlotState extends Equatable {
  const TimeSlotState();
}

class InitialState extends TimeSlotState {
  @override
  List<Object> get props => [];
}

class LoadingState extends TimeSlotState {
  @override
  List<Object> get props => [];
}

class LoadedState extends TimeSlotState {
  final List<TimeSlot> timeSlots;

  const LoadedState({required this.timeSlots});

  @override
  List<Object> get props => [timeSlots];
}

class ErrorState extends TimeSlotState {
  final String message;

  const ErrorState({required this.message});

  @override
  List<Object> get props => [message];
}
