import 'package:daily_planner/features/task/domain/entities/task_entity.dart';
import 'package:daily_planner/features/task/presentation/cubit/task_cubit.dart';
import 'package:daily_planner/features/time_slot/presentation/cubit/time_slot_cubit.dart'
    as ts_cubit;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

// TODO refactor this widget, too much logic in it
class TimeSlotAppointmentTask extends StatelessWidget {
  // final String displayName;
  final Appointment appointment;
  final Task task;
  final bool isTomorrow;

  const TimeSlotAppointmentTask(
      {super.key,
      // required this.displayName,
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
                              startTime: task.startTime,
                              endTime: task.endTime,
                              subject: task.subject,
                              priority: task.priority,
                              id: task.id as int,
                              createdAt: task.createdAt,
                              isPlanned: task.isPlanned,
                              isDone: !task.isDone,
                              isRescheduled: task.isRescheduled,
                            ),
                          );
                      // ask for reload of timeslot state
                      context.read<ts_cubit.TimeSlotCubit>().getTimeSlots();

                      Navigator.pop(context, true);
                    },
                    child: const Text('done')),
                TextButton(
                    onPressed: () {
                      // reschedule task to first available time slot of tomorrow
                      // _addTimeSlot(context);
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

  // _addTimeSlot(BuildContext context) {
  //   List<TimeSlot> timeSlots = context.read<ts_cubit.TimeSlotCubit>().getTimeSlots();

  //   TimeSlotDataSource timeSlotDataSource = TimeSlotDataSource(timeSlots);
  //   TimeSlotDataSource.getDataSource(context, timeSlots);

  //   TimeSlot? timeSlot =
  //       timeSlotDataSource.searchForEmptyTimeSlot(timeSlot, task);

  //   if (timeSlot == null) {
  //     // display a dialog indicating that there is no available time slot
  //     _noTimeSlotDialog(context);
  //   } else {
  //     // TODO try to avoid reloading the today planning page when rescheduling a task, or at least scroll to where the user was
  //     // create a new time slot with the task tomorrow
  //     context.read<ts_cubit.TimeSlotCubit>().createTimeSlot(
  //           TimeSlot(
  //             // TODO only pass parameters to troncateDateTime and let it handle the rest to avoid code duplication and make it more readable
  //             startTime: DateTime(
  //                 DateTime.now().year,
  //                 DateTime.now().month,
  //                 DateTime.now().day + 1,
  //                 timeSlot.startTime.hour,
  //                 timeSlot.startTime.minute).troncateDateTime(),
  //             endTime: timeSlot.event is Block
  //                 // if the free time slot found is a block, we use its end time for the task
  //                 ? DateTime(
  //                     DateTime.now().year,
  //                     DateTime.now().month,
  //                     DateTime.now().day + 1,
  //                     timeSlot.endTime.hour,
  //                     timeSlot.endTime.minute).troncateDateTime()
  //                 // else we simply make the task last 1 hour
  //                 : DateTime(
  //                     DateTime.now().year,
  //                     DateTime.now().month,
  //                     DateTime.now().day + 1,
  //                     timeSlot.startTime.hour + 1,
  //                     timeSlot.startTime.minute).troncateDateTime(),
  //             subject: ,
  //             color: ,
  //             event: task,
  //             ,
  //           ),
  //         );
  //     // set task to rescheduled
  //     context.read<TaskCubit>().updateTask(
  //           Task(
  //             id: task.id as int,
  //             name: task.name,
  //             priority: task.priority,
  //             createdAt: task.createdAt,
  //             isPlanned: task.isPlanned,
  //             isDone: task.isDone,
  //             isRescheduled: !task.isRescheduled,
  //           ),
  //         );
  //   }
  // }

  // Future<dynamic> _noTimeSlotDialog(BuildContext context) {
  //   return showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           title: const Text('No available time slot'),
  //           content:
  //               const Text('There is no available time slot for this task.'),
  //           actions: [
  //             TextButton(
  //                 onPressed: () {
  //                   Navigator.of(context).pop();
  //                 },
  //                 child: const Text('OK'))
  //           ],
  //         );
  //       });
  // }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ts_cubit.TimeSlotCubit, ts_cubit.TimeSlotState>(
        listener: (context, state) {
          // TODO: implement listener
          if (state is LoadedState) {}
        },
        child: isTomorrow
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Text(
                      task.subject,
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
                      task.subject,
                      style: task.isDone || task.isRescheduled
                          ? const TextStyle(
                              decoration: TextDecoration.lineThrough)
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
                                    child: Icon(Icons.check_circle_rounded,
                                        size: 19),
                                  )
                                : const SizedBox.shrink(),
                          ],
                        )
                      : const SizedBox.shrink()
                ],
              ));
  }
}
