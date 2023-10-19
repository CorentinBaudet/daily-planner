import 'package:daily_planner/features/block/domain/entities/block_entity.dart';
import 'package:daily_planner/features/task/presentation/cubit/task_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:daily_planner/features/task/domain/entities/task_entity.dart';
import 'package:daily_planner/features/time_slot/domain/entities/time_slot_entity.dart';
import 'package:daily_planner/features/time_slot/presentation/cubit/time_slot_cubit.dart'
    as ts_cubit;
import 'package:daily_planner/utils/utils.dart';

class TimeSlotDrawerListTile extends StatelessWidget {
  final Task task;

  const TimeSlotDrawerListTile({super.key, required this.task});

  _addTimeSlot(BuildContext context) {
    TimeSlot? workTimeSlot = _searchForWorkTimeSlot(context);

    // set the task isPlanned to true
    task.isPlanned = true;
    context.read<TaskCubit>().updateTask(task);

    if (workTimeSlot == null) {
      context.read<ts_cubit.TimeSlotCubit>().createTimeSlot(TimeSlot(
          startTime: Utils().troncateDateTime(DateTime(DateTime.now().year,
                  DateTime.now().month, DateTime.now().day, 14)
              .add(const Duration(days: 1))),
          duration: 60,
          event: task,
          createdAt: Utils().troncateDateTime(DateTime.now())));
    } else {
      context.read<ts_cubit.TimeSlotCubit>().createTimeSlot(TimeSlot(
          startTime: Utils().troncateDateTime(DateTime(
              DateTime.now().year,
              DateTime.now().month,
              DateTime.now().day + 1,
              workTimeSlot.startTime.hour,
              workTimeSlot.startTime.minute)),
          duration: workTimeSlot.duration,
          event: task,
          createdAt: Utils().troncateDateTime(DateTime.now())));
    }
  }

  TimeSlot? _searchForWorkTimeSlot(BuildContext context) {
    // search for all work time slots
    List<TimeSlot> workBlocks = [];

    if (context.read<ts_cubit.TimeSlotCubit>().state is ts_cubit.LoadedState) {
      var timeSlots =
          (context.read<ts_cubit.TimeSlotCubit>().state as ts_cubit.LoadedState)
              .timeSlots;
      for (var timeSlot in timeSlots) {
        if (timeSlot.event is Block) {
          if ((timeSlot.event as Block).isWork == true) {
            workBlocks.add(timeSlot);
          }
        }
      }
    }

    // TODO: return the first empty work time slot
    // OR return the first available time slot
    if (workBlocks.isEmpty) {
      return null;
    } else {
      return workBlocks[0];
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _addTimeSlot(context);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Container(
          height: 56,
          margin: const EdgeInsets.only(bottom: 9.0),
          decoration: BoxDecoration(
              color: Colors.lightBlue.shade100,
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: const [
                BoxShadow(
                  color: Colors.grey,
                  offset: Offset(0.0, 1.0),
                  blurRadius: 4.0,
                )
              ]),
          child: ListTile(
            title: Text(task.name, style: const TextStyle(fontSize: 14)),
            trailing: task.priority == Priority.high
                ? const Padding(
                    padding: EdgeInsets.all(0.0),
                    child: Text(
                      '!',
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                : null,
          ),
        ),
      ),
    );
  }
}
