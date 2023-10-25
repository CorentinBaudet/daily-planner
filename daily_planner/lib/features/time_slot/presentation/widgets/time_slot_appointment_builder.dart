import 'package:daily_planner/features/task/domain/entities/task_entity.dart';
import 'package:daily_planner/features/task/presentation/cubit/task_cubit.dart';
import 'package:daily_planner/features/time_slot/domain/entities/time_slot_entity.dart';
import 'package:daily_planner/features/time_slot/presentation/cubit/time_slot_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

// ignore: must_be_immutable
class TimeSlotAppointmentBuilder extends StatefulWidget {
  final CalendarAppointmentDetails appointmentDetails;

  TimeSlotAppointmentBuilder({super.key, required this.appointmentDetails});

  late Appointment appointment;
  late TimeSlot timeSlot;
  late Task task;

  @override
  State<TimeSlotAppointmentBuilder> createState() =>
      _TimeSlotAppointmentBuilderState();
}

class _TimeSlotAppointmentBuilderState
    extends State<TimeSlotAppointmentBuilder> {
  bool checked = false;

  IconButton _rescheduleButton(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.double_arrow_rounded),
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      onPressed: () {
        // TODO : add task to tomorrow
        // open confirmation dialog
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('reschedule task'),
            content:
                const Text('this will add the task to tomorrow\'s planning'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: const Text('cancel'),
              ),
              TextButton(
                style: ButtonStyle(
                    foregroundColor: MaterialStateColor.resolveWith(
                        (Set<MaterialState> states) => Colors.white),
                    backgroundColor: MaterialStateProperty.all(
                        Theme.of(context).colorScheme.primary)),
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: const Text('confirm'),
              ),
            ],
          ),
        ).then((value) {
          if (value == true) {
            // if confirmed, add task to tomorrow
            context.read<TimeSlotCubit>().createTimeSlot(
                  TimeSlot(
                    startTime:
                        widget.timeSlot.startTime.add(const Duration(days: 1)),
                    endTime:
                        widget.timeSlot.endTime.add(const Duration(days: 1)),
                    event: widget.timeSlot.event,
                    createdAt: widget.timeSlot.createdAt,
                  ),
                );
          }
        });
      },
    );
  }

  @override
  void initState() {
    super.initState();
    widget.appointment = widget.appointmentDetails.appointments.first;
    if (widget.appointment.appointmentType == AppointmentType.normal) {
      widget.timeSlot = context
          .read<TimeSlotCubit>()
          .repository
          .getTimeSlot(widget.appointment.id as int);
      widget.task = context
          .read<TaskCubit>()
          .repository
          .getTask((widget.timeSlot.event as Task).id as int);
      checked = widget.task.isDone;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.appointment.appointmentType != AppointmentType.normal) {
      return Container(
        width: widget.appointmentDetails.bounds.width,
        height: widget.appointmentDetails.bounds.height,
        color: widget.appointmentDetails.appointments.first.color,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text(widget.appointment.subject),
            ),
            IconButton(
              icon: const Icon(
                Icons.change_circle_rounded,
                size: 19,
              ),
              padding: const EdgeInsets.only(right: 8),
              constraints: const BoxConstraints(),
              onPressed: () {},
            )
          ],
        ),
      );
    } else {
      return Container(
        width: widget.appointmentDetails.bounds.width,
        height: widget.appointmentDetails.bounds.height,
        color: widget.appointmentDetails.appointments.first.color,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text(
                widget.appointment.subject,
                style: checked
                    ? const TextStyle(decoration: TextDecoration.lineThrough)
                    : null,
              ),
            ),
            widget.appointment.endTime.isBefore(DateTime.now())
                ? Row(
                    children: [
                      checked
                          ? const SizedBox.shrink()
                          : _rescheduleButton(context),
                      Checkbox(
                          value: checked,
                          onChanged: (c) {
                            setState(() {
                              checked = c!;
                            });
                            // TODO : set task to done
                            context.read<TaskCubit>().updateTask(
                                  Task(
                                    id: widget.task.id as int,
                                    name: widget.task.name,
                                    priority: widget.task.priority,
                                    createdAt: widget.task.createdAt,
                                    isDone: true,
                                    isPlanned: widget.task.isPlanned,
                                  ),
                                );
                          }),
                    ],
                  )
                : const SizedBox.shrink()
          ],
        ),
      );
    }
  }
}
