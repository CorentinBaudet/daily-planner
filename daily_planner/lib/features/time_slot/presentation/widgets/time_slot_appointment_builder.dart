import 'package:daily_planner/features/block/domain/entities/block_entity.dart';
import 'package:daily_planner/features/task/domain/entities/task_entity.dart';
import 'package:daily_planner/features/task/presentation/cubit/task_cubit.dart';
import 'package:daily_planner/features/time_slot/domain/entities/time_slot_entity.dart';
import 'package:daily_planner/features/time_slot/domain/usecases/time_slot_usecases.dart';
import 'package:daily_planner/features/time_slot/presentation/cubit/time_slot_cubit.dart';
import 'package:daily_planner/features/time_slot/presentation/widgets/time_slot_appointment_task.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

// ignore: must_be_immutable
class TimeSlotAppointmentBuilder extends StatefulWidget {
  final CalendarAppointmentDetails appointmentDetails;
  final bool isTomorrow;

  const TimeSlotAppointmentBuilder(
      {super.key, required this.appointmentDetails, this.isTomorrow = false});

  @override
  State<TimeSlotAppointmentBuilder> createState() =>
      _TimeSlotAppointmentBuilderState();
}

class _TimeSlotAppointmentBuilderState
    extends State<TimeSlotAppointmentBuilder> {
  _initTasks(BuildContext context) {
    timeSlot = context
        .read<TimeSlotCubit>()
        .repository
        .getTimeSlot(widget.appointmentDetails.appointments.first.id as int);

    if (widget.appointmentDetails.appointments.first.appointmentType ==
        AppointmentType.normal) {
      // retrieve the task from the current time slot if the appointment is normal (not recurring)
      task = context
          .read<TaskCubit>()
          .repository
          .getTask((timeSlot!.event as Task).id as int);
    } else {
      // if the appointment is recurring, check if there is a task associated to it
      List<TimeSlot> timeSlots =
          context.read<TimeSlotCubit>().repository.getTimeSlots();
      // look for a timeslot containing a task starting and ending at the same time as the work timeslot
      for (var timeSlot in timeSlots) {
        if (timeSlot.event is Task &&
            TimeSlotUseCases().isSameTimeSlot(
                timeSlot, widget.appointmentDetails.appointments.first)) {
          task = context
              .read<TaskCubit>()
              .repository
              .getTask((timeSlot.event as Task).id as int);
          break;
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _initTasks(context);
  }

  TimeSlot? timeSlot;
  Task? task;

  // TODO try @override reassemble method for time slot and task init
  // TODO bug when a block duration is modified, the task does not appear under it anymore (because the link is created with the same duration, should be with an id for example)

  @override
  void reassemble() {
    // TODO implement reassemble
    super.reassemble();
  }

  @override
  Widget build(BuildContext context) {
    _initTasks(context);
    return Container(
        width: widget.appointmentDetails.bounds.width,
        height: widget.appointmentDetails.bounds.height,
        color: widget.appointmentDetails.appointments.first.color,
        child: () {
          if (widget.appointmentDetails.appointments.first.appointmentType !=
              AppointmentType.normal) {
            // if it is a recurring appointment
            if ((timeSlot!.event as Block).isWork) {
              // if it is a work block, we use a Stack widget to display the task on top of it
              return Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 3, 8, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(widget
                            .appointmentDetails.appointments.first.subject),
                        const Icon(
                          Icons.change_circle_rounded,
                          size: 19,
                        )
                      ],
                    ),
                  ),
                  task != null
                      ? Padding(
                          padding: const EdgeInsets.only(left: 8, top: 24),
                          child: Container(
                            decoration: BoxDecoration(
                                // if the task is passed, we change its color to grey
                                color: widget.appointmentDetails.appointments
                                        .first.startTime
                                        .isBefore(DateTime.now())
                                    ? Colors.grey.shade300
                                    // : Colors.lightBlue.shade100,
                                    : const Color(0xFFffc2a9),
                                borderRadius: BorderRadius.circular(8.0)),
                            constraints: const BoxConstraints
                                .expand(), // to make the task fill the available space left
                            child: TimeSlotAppointmentTask(
                              displayName: task!.name,
                              appointment:
                                  widget.appointmentDetails.appointments.first,
                              task: task!,
                              isTomorrow: widget.isTomorrow,
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ],
              );
            } else {
              // if it is a standard block, we display it as a normal appointment
              return Padding(
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(widget.appointmentDetails.appointments.first.subject),
                    const Icon(
                      Icons.change_circle_rounded,
                      size: 19,
                    )
                  ],
                ),
              );
            }
          } else {
            // if it is a task
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TimeSlotAppointmentTask(
                    displayName:
                        widget.appointmentDetails.appointments.first.subject,
                    appointment: widget.appointmentDetails.appointments.first,
                    task: task!,
                    isTomorrow: widget.isTomorrow),
              ],
            );
          }
        }());
  }
}
