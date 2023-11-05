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

class TimeSlotAppointmentTask extends StatelessWidget {
  final String displayName;
  final Appointment appointment;
  final Task task;
  final bool isTomorrow;

  const TimeSlotAppointmentTask(
      {super.key,
      required this.displayName,
      required this.appointment,
      required this.task,
      this.isTomorrow = false});

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
                              id: task.id as int,
                              name: task.name,
                              priority: task.priority,
                              createdAt: task.createdAt,
                              isPlanned: task.isPlanned,
                              isDone: !task.isDone,
                              isRescheduled: task.isRescheduled,
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

  _addTimeSlot(BuildContext context) {
    TimeSlot? timeSlot =
        TimeSlotUseCases().searchForEmptyTimeSlot(context, task);

    if (timeSlot == null) {
      // display a dialog indicating that there is no available time slot
      _noTimeSlotDialog(context);
    } else {
      // TODO try to avoid reloading the today planning page when rescheduling a task, or at least scroll to where the user was
      // create a new time slot with the task tomorrow
      context.read<TimeSlotCubit>().createTimeSlot(
            TimeSlot(
              // TODO only pass parameters to troncateDateTime and let it handle the rest to avoid code duplication and make it more readable
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
              event: task,
              createdAt: Utils().troncateDateTime(DateTime.now()),
            ),
          );
      // set task to rescheduled
      context.read<TaskCubit>().updateTask(
            Task(
              id: task.id as int,
              name: task.name,
              priority: task.priority,
              createdAt: task.createdAt,
              isPlanned: task.isPlanned,
              isDone: task.isDone,
              isRescheduled: !task.isRescheduled,
            ),
          );
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
    return isTomorrow
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Text(
                  displayName,
                ),
              ),
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(
                  displayName,
                  style: task.isDone || task.isRescheduled
                      ? const TextStyle(decoration: TextDecoration.lineThrough)
                      : null,
                ),
              ),
              appointment.endTime.isBefore(DateTime.now())
                  ? Row(
                      children: [
                        // on affiche le bouton si la tâche n'est pas replanifiée, ou si elle n'est pas done
                        (task.isDone || task.isRescheduled)
                            ? const SizedBox.shrink()
                            : _taskStateButton(context),

                        // if the task is rescheduled, we display a schedule icon
                        task.isRescheduled
                            ? const Padding(
                                padding: EdgeInsets.only(right: 8),
                                child: Icon(Icons.calendar_today_rounded,
                                    size: 19),
                              )
                            : const SizedBox.shrink(),

                        // if the task is done, we display a check icon
                        task.isDone
                            ? const Padding(
                                padding: EdgeInsets.only(right: 8),
                                child:
                                    Icon(Icons.check_circle_rounded, size: 19),
                              )
                            : const SizedBox.shrink(),
                      ],
                    )
                  : const SizedBox.shrink()
            ],
          );
  }
}
