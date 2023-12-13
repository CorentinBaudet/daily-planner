import 'package:daily_planner/features/task/domain/entities/priority_entity.dart';
import 'package:daily_planner/features/task/presentation/cubit/task_cubit.dart';
import 'package:daily_planner/features/time_slot/domain/entities/block_entity.dart';
import 'package:daily_planner/features/time_slot/domain/entities/time_slot_data_source.dart';
import 'package:daily_planner/features/time_slot/domain/entities/time_slot_entity.dart';
import 'package:daily_planner/features/time_slot/domain/entities/work_block_entity.dart';
import 'package:daily_planner/features/time_slot/domain/usecases/time_slot_data_source_usecases.dart';
import 'package:flutter/material.dart';

import 'package:daily_planner/features/task/domain/entities/task_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TimeSlotDrawerListTile extends StatelessWidget {
  final Task task;

  const TimeSlotDrawerListTile({super.key, required this.task});

  _addTimeSlot(BuildContext context) {
    // Get the time slots from the data source
    List<TimeSlot> dataSourceTimeSlots = TimeSlotDataSource().timeSlots;

    // Search for an empty time slot
    TimeSlot? timeSlot = TimeSlotDataSourceUseCases.searchForEmptyTimeSlot(
        dataSourceTimeSlots, task,
        isTomorrow: true);

    if (timeSlot == null) {
      // Display a dialog indicating that there is no available time slot
      _noTimeSlotDialog(context);
    } else {
      debugPrint('timeSlot: $timeSlot');

      // Set the task isPlanned to true
      task.isPlanned = true;
      context.read<TaskCubit>().updateTask(task);

      switch (timeSlot.runtimeType) {
        case Block:
          // Create the block in database
          break;
        case WorkBlock:
          // Add the task to the work block
          (timeSlot as WorkBlock).taskId = task.id as int;
          // TODO : edit the work block in database
          break;
        default:
      }

      // // add the task to the time slot
      // context.read<ts_cubit.TimeSlotCubit>().createTimeSlot(TimeSlot(
      //       startTime: DateTime(
      //               DateTime.now().year,
      //               DateTime.now().month,
      //               DateTime.now().day + 1,
      //               timeSlot.startTime.hour,
      //               timeSlot.startTime.minute)
      //           .troncateDateTime(),
      //       endTime: timeSlot.event is Block
      //           // if the free time slot found is a block, we use its end time for the task
      //           ? DateTime(
      //                   DateTime.now().year,
      //                   DateTime.now().month,
      //                   DateTime.now().day + 1,
      //                   timeSlot.endTime.hour,
      //                   timeSlot.endTime.minute)
      //               .troncateDateTime()
      //           // else we simply make the task last 1 hour
      //           : DateTime(
      //                   DateTime.now().year,
      //                   DateTime.now().month,
      //                   DateTime.now().day + 1,
      //                   timeSlot.startTime.hour + 1,
      //                   timeSlot.startTime.minute)
      //               .troncateDateTime(),
      //       subject: task.name,
      //       event:
      //           // timeSlot.event is Block
      //           // // if the free time slot found is a block, we happen its name to the task name
      //           // ? () {
      //           //     Task renamedTask = task;
      //           //     renamedTask.name += ' (${timeSlot.event.name})';
      //           //     return renamedTask;
      //           //   }()
      //           // :
      //           task,
      //     ));
    }
  }

  Future<dynamic> _noTimeSlotDialog(BuildContext context) {
    return showDialog(
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
              // TODO: variabilize the color
              color: task.color,
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: const [
                BoxShadow(
                  color: Colors.grey,
                  offset: Offset(0.0, 1.0),
                  blurRadius: 4.0,
                )
              ]),
          child: ListTile(
            title: Text(task.subject,
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
