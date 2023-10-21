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
    TimeSlot? timeSlot = _searchForTimeSlot(context);

    if (timeSlot == null) {
      // display a dialog indicating that there is no available time slot
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('No available time slot'),
              content:
                  const Text('There is no available time slot for this task.'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('OK'))
              ],
            );
          });
    } else {
      // set the task isPlanned to true
      task.isPlanned = true;
      context.read<TaskCubit>().updateTask(task);
      context.read<ts_cubit.TimeSlotCubit>().createTimeSlot(TimeSlot(
          startTime: Utils().troncateDateTime(DateTime(
              DateTime.now().year,
              DateTime.now().month,
              DateTime.now().day + 1,
              timeSlot.startTime.hour,
              timeSlot.startTime.minute)),
          endTime: timeSlot.endTime,
          event: task,
          createdAt: Utils().troncateDateTime(DateTime.now())));
    }
  }

  TimeSlot? _searchForTimeSlot(BuildContext context) {
    List<TimeSlot> timeSlots = [];

    if (context.read<ts_cubit.TimeSlotCubit>().state is ts_cubit.LoadedState) {
      timeSlots =
          (context.read<ts_cubit.TimeSlotCubit>().state as ts_cubit.LoadedState)
              .timeSlots;
    }

    TimeSlot? resultTimeSlot = _searchForWorkBlock(timeSlots);
    if (resultTimeSlot != null) {
      // if there is an empty work block, return it
      return resultTimeSlot;
    }

    return _searchForEmptyTimeSlot(timeSlots);
  }

  TimeSlot? _searchForWorkBlock(List<TimeSlot> timeSlots) {
    List<TimeSlot> workBlocks = [];

    for (var block in TimeSlotUseCases().getBlockTimeSlots(timeSlots)) {
      if ((block.event as Block).isWork == true) {
        workBlocks.add(block);
      }
    }

    if (workBlocks.isNotEmpty) {
      // return the first work time slot
      return workBlocks[0];
    }
    return null;
  }

  TimeSlot? _searchForEmptyTimeSlot(List<TimeSlot> timeSlots) {
    // TODO : fix parce que ça ne marche pas (almuerzo entre 12h30 et 13h30 par ex)
    List<DateTime> emptyTimeSlots = [];

    // search for the first empty time slot by looking at start times of today
    List<DateTime> startTimes = TimeSlotUseCases().getStartTimeSlots();
    int sixtyMinFlag = 0;
    for (var currentStartTime in startTimes) {
      if (timeSlots.any((element) {
        if (element.startTime.hour == currentStartTime.hour) {
          if (element.startTime.minute == currentStartTime.minute) {
            // if the time slot starts at the current start time
            return true;
          }
        }

        if (element.startTime.isBefore(currentStartTime) &&
            element.endTime.isAfter(currentStartTime)) {
          // or if the time slot ends begins before and ends after the current start time
          return true;
        } else {
          return false;
        }
      })) {
        // do nothing
        sixtyMinFlag = 0;
      } else {
        sixtyMinFlag++;
        // we count to 4 to see if there is a 60 min empty time slot
        if (sixtyMinFlag == 4) {
          // add the empty time slot to the list
          emptyTimeSlots
              .add(currentStartTime.subtract(const Duration(minutes: 45)));
          return TimeSlot(
              startTime: emptyTimeSlots[0],
              endTime: emptyTimeSlots[0].add(const Duration(minutes: 60)),
              event: task,
              createdAt: Utils().troncateDateTime(DateTime.now()));
        }
      }
    }
    // if no empty time slot was found
    return null;
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
            title: Text(task.name,
                style: const TextStyle(fontSize: 14),
                maxLines: 2,
                overflow: TextOverflow.ellipsis),
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
