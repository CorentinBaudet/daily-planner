import 'package:daily_planner/features/block/domain/entities/block_entity.dart';
import 'package:daily_planner/features/task/domain/entities/task_entity.dart';
import 'package:daily_planner/features/task/presentation/cubit/task_cubit.dart';
import 'package:daily_planner/features/time_slot/domain/entities/time_slot_entity.dart';
import 'package:daily_planner/features/time_slot/domain/usecases/time_slot_usecases.dart';
import 'package:daily_planner/features/time_slot/presentation/cubit/time_slot_cubit.dart';
import 'package:daily_planner/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

// ignore: must_be_immutable
class TimeSlotAppointmentBuilder extends StatefulWidget {
  final CalendarAppointmentDetails appointmentDetails;

  TimeSlotAppointmentBuilder({super.key, required this.appointmentDetails});

  // Appointment? appointment = appointmentDetails.appointments.first;
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
      icon: const Icon(Icons.add_rounded),
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      onPressed: () {
        // TODO : add task to tomorrow
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
            _addTimeSlot(context);
          }
        });
      },
    );
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

  _addTimeSlot(BuildContext context) {
    TimeSlot? timeSlot =
        TimeSlotUseCases().searchForTimeSlot(context, widget.task);

    // TODO : reschedule doesn't seem to work, it adds a copy of the block in case the task is reschudeled in a block
    if (timeSlot == null) {
      // display a dialog indicating that there is no available time slot
      _noTimeSlotDialog(context);
    } else {
      context.read<TimeSlotCubit>().createTimeSlot(
            TimeSlot(
              startTime: Utils().troncateDateTime(DateTime(
                  DateTime.now().year,
                  DateTime.now().month,
                  DateTime.now().day + 1,
                  timeSlot.startTime.hour,
                  timeSlot.startTime.minute)),
              endTime: timeSlot.event is Block
                  // if the free time slot found is a block, we use its end time for the task
                  ? Utils().troncateDateTime(DateTime(
                      DateTime.now().year,
                      DateTime.now().month,
                      DateTime.now().day + 1,
                      timeSlot.endTime.hour,
                      timeSlot.endTime.minute))
                  // else we simply make the task last 1 hour
                  : Utils().troncateDateTime(DateTime(
                      DateTime.now().year,
                      DateTime.now().month,
                      DateTime.now().day + 1,
                      timeSlot.startTime.hour + 1,
                      timeSlot.startTime.minute)),
              event: widget.task,
              createdAt: Utils().troncateDateTime(DateTime.now()),
            ),
          );
    }
  }

  @override
  void initState() {
    super.initState();
    // widget.appointment = widget.appointmentDetails.appointments.first;

    // if (widget.appointment == null) {
    //   return;
    // }

    if (widget.appointmentDetails.appointments.first.appointmentType ==
        AppointmentType.normal) {
      widget.timeSlot = context
          .read<TimeSlotCubit>()
          .repository
          .getTimeSlot(widget.appointmentDetails.appointments.first.id as int);
      widget.task = context
          .read<TaskCubit>()
          .repository
          .getTask((widget.timeSlot.event as Task).id as int);
      checked = widget.task.isDone;
    }
  }

  // TODO display work block, and display task on top of it !!!
  // TODO try to display appointment notes (name of the block) with FlutterFlow eventually
  @override
  Widget build(BuildContext context) {
    if (widget.appointmentDetails.appointments.first.appointmentType !=
        AppointmentType.normal) {
      return Container(
        width: widget.appointmentDetails.bounds.width,
        height: widget.appointmentDetails.bounds.height,
        color: widget.appointmentDetails.appointments.first.color,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text(widget.appointmentDetails.appointments.first.subject),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 8),
              child: Icon(
                Icons.change_circle_rounded,
                size: 19,
              ),
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
                widget.appointmentDetails.appointments.first.subject,
                style: checked
                    ? const TextStyle(decoration: TextDecoration.lineThrough)
                    : null,
              ),
            ),
            widget.appointmentDetails.appointments.first.endTime
                    .isBefore(DateTime.now())
                ? Row(
                    children: [
                      // TODO : si la tâche n'est pas replanifiée, ou qu'est n'est pas done, on affiche le bouton
                      !widget.task.isPlanned || checked
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
