import 'package:daily_planner/features/block/domain/entities/block_entity.dart';
import 'package:daily_planner/features/task/presentation/cubit/task_cubit.dart';
import 'package:daily_planner/features/time_slot/domain/usecases/time_slot_usecases.dart';
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
    List<TimeSlot> timeSlots = [];
    List<TimeSlot> workBlocks = [];
    List<DateTime> emptyTimeSlots = [];

    if (context.read<ts_cubit.TimeSlotCubit>().state is ts_cubit.LoadedState) {
      timeSlots =
          (context.read<ts_cubit.TimeSlotCubit>().state as ts_cubit.LoadedState)
              .timeSlots;

      for (var block in TimeSlotUseCases().getBlockTimeSlots(timeSlots)) {
        if ((block.event as Block).isWork == true) {
          workBlocks.add(block);
        }
      }
      // workBlocks = TimeSlotUseCases()
      //         .getBlockTimeSlots(timeSlots)
      //         .every((element) => (element.event as Block).isWork == true)
      //     as List<TimeSlot>;

      // final tomorrowPlanning = TimeSlotDataSource.getPlannerDataSource(timeSlots,
      //       isTomorrow: true);
    }

    if (workBlocks.isNotEmpty) {
      // return the first work time slot
      return workBlocks[0];
    }

    // search for the first empty time slot by looking at start times of today
    List<DateTime> startTimes = TimeSlotUseCases().getStartTimeSlots();
    for (var startTime in startTimes) {
      if (timeSlots.any((element) => element.startTime == startTime)) {
        // do nothing
        print('pas libre : $startTime');
      } else {
        // TODO: à refaire : le check dépasse de 15min le premier time slot rencontré
        // et n'arrive pas à détecter les time slots qui vont arriver

        // if (timeSlots.any((element) =>
        //     element.startTime.add(const Duration(minutes: 15)) == startTime ||
        //     element.startTime.add(const Duration(minutes: 30)) == startTime ||
        //     element.startTime.add(const Duration(minutes: 45)) == startTime)) {
        //   // do nothing
        //   print('pas assez long : $startTime');
        // } else {
        //   // add the empty time slot to the list
        //   emptyTimeSlots.add(startTime);
        //   break;
        // }
      }
    }
    // return the first available time slot of 60 min
    return TimeSlot(
        startTime: emptyTimeSlots[0],
        duration: 60,
        event: task,
        createdAt: Utils().troncateDateTime(DateTime.now()));
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
