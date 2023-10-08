import 'package:daily_planner/features/time_slot/domain/entities/time_slot_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:daily_planner/features/time_slot/domain/repositories/time_slot_base_repository.dart';

part 'time_slot_state.dart';

class PlannerCubit extends Cubit<PlannerState> {
  PlannerCubit({required this.repository}) : super(InitialState()) {
    getAllTimeSlots();
  }

  final TimeSlotBaseRepository repository;

  void getAllTimeSlots() {
    try {
      emit(LoadingState());
      final timeSlots = repository.getTimeSlots();
      emit(LoadedState(timeSlots: timeSlots));
    } catch (e) {
      emit(ErrorState(message: e.toString()));
    }
  }
}
