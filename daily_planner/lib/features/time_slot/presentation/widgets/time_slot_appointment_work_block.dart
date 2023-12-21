import 'package:daily_planner/features/task/domain/entities/task_entity.dart';
import 'package:daily_planner/features/time_slot/presentation/widgets/time_slot_appointment_task.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class TimeSlotAppointmentWorkBlock extends StatelessWidget {
  final Appointment appointment;
  final Task? task;
  final bool isTomorrow;

  const TimeSlotAppointmentWorkBlock(
      {super.key,
      required this.appointment,
      required this.task,
      this.isTomorrow = false});

  @override
  Widget build(BuildContext context) {
    bool isTaskPlanned = task != null;

    return isTaskPlanned
        ? // if there is a task, and the planned date is corresponding, we use a stack to display the task on top of the work block
        Stack(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 3, 8, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(appointment.subject),
                    const Icon(
                      Icons.change_circle_rounded,
                      size: 19,
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8, top: 24),
                child: Container(
                  decoration: BoxDecoration(
                      // if the task is passed, we change its color to grey
                      color: DateTime.now().isAfter(appointment.endTime)
                          ? Colors.grey.shade300
                          : const Color(0xFFffc2a9),
                      borderRadius: BorderRadius.circular(8.0)),
                  constraints: const BoxConstraints
                      .expand(), // to make the task fill the available space left
                  child: TimeSlotAppointmentTask(
                      appointment: appointment,
                      task: task!,
                      isTomorrow: isTomorrow),
                ),
              ),
            ],
          )
        : // if there is no task, we display the block as a normal appointment
        Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(appointment.subject),
                const Icon(
                  Icons.change_circle_rounded,
                  size: 19,
                )
              ],
            ),
          );
  }
}
