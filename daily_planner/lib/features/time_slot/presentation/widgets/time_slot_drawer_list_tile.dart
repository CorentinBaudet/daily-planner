import 'package:daily_planner/features/task/presentation/cubit/task_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:daily_planner/features/task/domain/entities/task_entity.dart';
import 'package:daily_planner/features/time_slot/domain/entities/time_slot_entity.dart';
import 'package:daily_planner/features/time_slot/presentation/cubit/time_slot_cubit.dart';
import 'package:daily_planner/utils/utils.dart';

class TimeSlotDrawerListTile extends StatelessWidget {
  final Task task;

  const TimeSlotDrawerListTile({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // set the task isPlanned to true
        task.isPlanned = true;
        context.read<TasksCubit>().updateTask(task);

        context.read<TimeSlotCubit>().createTimeSlot(TimeSlot(
            startTime: Utils().troncateCreationTime(DateTime(
                    DateTime.now().year,
                    DateTime.now().month,
                    DateTime.now().day,
                    14)
                .add(const Duration(days: 1))),
            duration: 60,
            content: task,
            createdAt: Utils().troncateCreationTime(DateTime.now())));
      },
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 0.5),
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
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
    );
  }
}
