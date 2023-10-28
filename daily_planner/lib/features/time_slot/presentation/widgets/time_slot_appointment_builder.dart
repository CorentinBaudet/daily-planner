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

  const TimeSlotAppointmentBuilder(
      {super.key, required this.appointmentDetails});

  @override
  State<TimeSlotAppointmentBuilder> createState() =>
      _TimeSlotAppointmentBuilderState();
}

class _TimeSlotAppointmentBuilderState
    extends State<TimeSlotAppointmentBuilder> {
  IconButton _taskStateButton(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.add_rounded),
      padding: const EdgeInsets.only(right: 8),
      constraints: const BoxConstraints(),
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                    onPressed: () {
                      // set task to done
                      context.read<TaskCubit>().updateTask(
                            Task(
                              id: task!.id as int,
                              name: task!.name,
                              priority: task!.priority,
                              createdAt: task!.createdAt,
                              isPlanned: task!.isPlanned,
                              isDone: !task!.isDone,
                              isRescheduled: task!.isRescheduled,
                            ),
                          );
                      // ask for reload of timeslot state
                      context.read<TimeSlotCubit>().getTimeSlots();

                      Navigator.pop(context, true);
                    },
                    child: const Text('done')),
                TextButton(
                    onPressed: () {
                      // reschedule task to first available time slot of tomorrow
                      _addTimeSlot(context);
                      Navigator.pop(context, true);
                    },
                    child: const Text('reschedule')),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: const Text('cancel'),
              ),
            ],
          ),
        );
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
    TimeSlot? timeSlot = TimeSlotUseCases().searchForTimeSlot(context, task!);

    if (timeSlot == null) {
      // display a dialog indicating that there is no available time slot
      _noTimeSlotDialog(context);
    } else {
      // create a new time slot with the task tomorrow
      context.read<TimeSlotCubit>().createTimeSlot(
            TimeSlot(
              // TODO : only pass parameters to troncateDateTime and let it handle the rest to avoid code duplication and make it more readable
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
              event: task!,
              createdAt: Utils().troncateDateTime(DateTime.now()),
            ),
          );
      // set task to rescheduled
      context.read<TaskCubit>().updateTask(
            Task(
              id: task!.id as int,
              name: task!.name,
              priority: task!.priority,
              createdAt: task!.createdAt,
              isPlanned: task!.isPlanned,
              isDone: task!.isDone,
              isRescheduled: !task!.isRescheduled,
            ),
          );
    }
  }

  _initTasks(BuildContext context) {
    if (widget.appointmentDetails.appointments.first.appointmentType ==
        AppointmentType.normal) {
      timeSlot = context
          .read<TimeSlotCubit>()
          .repository
          .getTimeSlot(widget.appointmentDetails.appointments.first.id as int);
      task = context
          .read<TaskCubit>()
          .repository
          .getTask((timeSlot!.event as Task).id as int);
    }
  }

  @override
  void initState() {
    super.initState();
    _initTasks(context);
  }

  TimeSlot? timeSlot;
  Task? task;

  // TODO display work block, and display task on top of it !!!
  // TODO try to display appointment notes (name of the block) with FlutterFlow eventually
  // TODO : STYLE
  @override
  Widget build(BuildContext context) {
    _initTasks(context);

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
                style: task!.isDone || task!.isRescheduled
                    ? const TextStyle(decoration: TextDecoration.lineThrough)
                    : null,
              ),
            ),
            widget.appointmentDetails.appointments.first.endTime
                    .isBefore(DateTime.now())
                ? Row(
                    children: [
                      // on affiche le bouton si la tâche n'est pas replanifiée, ou si elle n'est pas done
                      (task!.isDone || task!.isRescheduled)
                          ? const SizedBox.shrink()
                          : _taskStateButton(context),

                      // if the task is rescheduled, we display a schedule icon
                      task!.isRescheduled
                          ? const Padding(
                              padding: EdgeInsets.only(right: 8),
                              child:
                                  Icon(Icons.calendar_today_rounded, size: 19),
                            )
                          : const SizedBox.shrink(),

                      // if the task is done, we display a check icon
                      task!.isDone
                          ? const Padding(
                              padding: EdgeInsets.only(right: 8),
                              child: Icon(Icons.check_circle_rounded, size: 19),
                            )
                          : const SizedBox.shrink(),
                    ],
                  )
                : const SizedBox.shrink()
          ],
        ),
      );
    }
  }
}
