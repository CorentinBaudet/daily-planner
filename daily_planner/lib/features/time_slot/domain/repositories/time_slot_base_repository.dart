import 'package:flutter/material.dart';

import 'package:daily_planner/features/time_slot/domain/entities/time_slot_entity.dart';
import 'package:daily_planner/features/task/domain/entities/task_entity.dart';
import 'package:daily_planner/features/task/domain/usecases/task_usecases.dart';

abstract class TimeSlotBaseRepository {
  List<TimeSlot> getTimeSlots();
  Future<void> create(TimeSlot timeSlot);
  Future<TimeSlot> read(int id);
  Future<void> update(TimeSlot timeSlot);
  Future<void> delete(int id);
}

class TimeSlotFakeRepository implements TimeSlotBaseRepository {
  List<TimeSlot> timeSlots = [
    TimeSlot(
        id: 1,
        startTime: const TimeOfDay(hour: 7, minute: 0),
        duration: 60,
        content: Task(
            id: 1,
            name: 'deep work',
            priority: Priority.normal,
            isDone: false,
            createdAt: TaskUseCases().troncateCreationTime(DateTime.now())),
        createdAt: TaskUseCases().troncateCreationTime(DateTime.now())),
    TimeSlot(
        id: 2,
        startTime: const TimeOfDay(hour: 10, minute: 30),
        duration: 60,
        content: Task(
            id: 2,
            name: 'GPE',
            priority: Priority.normal,
            isDone: false,
            createdAt: TaskUseCases().troncateCreationTime(DateTime.now())),
        createdAt: TaskUseCases().troncateCreationTime(DateTime.now())),
    TimeSlot(
        id: 3,
        startTime: const TimeOfDay(hour: 12, minute: 45),
        duration: 45,
        content: Task(
            id: 3,
            name: 'almuerzo',
            priority: Priority.normal,
            isDone: false,
            createdAt: TaskUseCases().troncateCreationTime(DateTime.now())),
        createdAt: TaskUseCases().troncateCreationTime(DateTime.now())),
  ];

  @override
  List<TimeSlot> getTimeSlots() {
    return timeSlots;
  }

  @override
  Future<void> create(TimeSlot timeSlot) async {
    timeSlots.add(timeSlot);
  }

  @override
  Future<TimeSlot> read(int id) async {
    return timeSlots.firstWhere((timeSlot) => timeSlot.id == id);
  }

  @override
  Future<void> update(TimeSlot timeSlot) async {
    final index = timeSlots.indexWhere((ts) => ts.id == timeSlot.id);
    if (index >= 0) {
      timeSlots[index] = timeSlot;
    }
  }

  @override
  Future<void> delete(int id) async {
    timeSlots.removeWhere((timeSlot) => timeSlot.id == id);
  }
}
