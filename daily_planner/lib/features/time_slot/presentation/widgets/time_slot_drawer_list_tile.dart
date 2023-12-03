import 'package:daily_planner/features/block/domain/entities/block_entity.dart';
import 'package:daily_planner/features/task/domain/entities/priority_entity.dart';
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

  // _addTimeSlot(BuildContext context) {
  //   TimeSlot? timeSlot =
  //       TimeSlotUseCases().searchForEmptyTimeSlot(context, task);

  //   if (timeSlot == null) {
  //     // display a dialog indicating that there is no available time slot
  //     _noTimeSlotDialog(context);
  //   } else {
  //     // set the task isPlanned to true
  //     task.isPlanned = true;
  //     context.read<TaskCubit>().updateTask(task);

  //     // add the task to the time slot
  //     context.read<ts_cubit.TimeSlotCubit>().createTimeSlot(TimeSlot(
  //         startTime: Utils().troncateDateTime(DateTime(
  //             DateTime.now().year,
  //             DateTime.now().month,
  //             DateTime.now().day + 1,
  //             timeSlot.startTime.hour,
  //             timeSlot.startTime.minute)),
  //         endTime: timeSlot.event is Block
  //             // if the free time slot found is a block, we use its end time for the task
  //             ? Utils().troncateDateTime(DateTime(
  //                 DateTime.now().year,
  //                 DateTime.now().month,
  //                 DateTime.now().day + 1,
  //                 timeSlot.endTime.hour,
  //                 timeSlot.endTime.minute))
  //             // else we simply make the task last 1 hour
  //             : Utils().troncateDateTime(DateTime(
  //                 DateTime.now().year,
  //                 DateTime.now().month,
  //                 DateTime.now().day + 1,
  //                 timeSlot.startTime.hour + 1,
  //                 timeSlot.startTime.minute)),
  //         event:
  //             // timeSlot.event is Block
  //             // // if the free time slot found is a block, we happen its name to the task name
  //             // ? () {
  //             //     Task renamedTask = task;
  //             //     renamedTask.name += ' (${timeSlot.event.name})';
  //             //     return renamedTask;
  //             //   }()
  //             // :
  //             task,
  //         createdAt: Utils().troncateDateTime(DateTime.now())));
  //   }
  // }

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
        // _addTimeSlot(context);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Container(
          height: 56,
          margin: const EdgeInsets.only(bottom: 9.0),
          decoration: BoxDecoration(
              // color: Colors.lightBlue.shade100,
              color: const Color(0xFFffc2a9),
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
