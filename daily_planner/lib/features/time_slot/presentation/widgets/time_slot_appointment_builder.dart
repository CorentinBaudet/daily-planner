import 'package:daily_planner/features/task/domain/entities/task_entity.dart';
import 'package:daily_planner/features/task/presentation/cubit/task_cubit.dart';
import 'package:daily_planner/features/time_slot/domain/entities/time_slot_entity.dart';
import 'package:daily_planner/features/time_slot/domain/entities/work_block_entity.dart';
import 'package:daily_planner/features/time_slot/presentation/cubit/time_slot_cubit.dart';
import 'package:daily_planner/features/time_slot/presentation/widgets/time_slot_appointment_task.dart';
import 'package:daily_planner/features/time_slot/presentation/widgets/time_slot_appointment_work_block.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

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
  late Appointment appointment;
  late TimeSlot timeSlot;
  Task? task;

  _initTask(BuildContext context) {
    appointment = widget.appointmentDetails.appointments.first;

    // pass the timeSlot to the widget instead of retrieving it here ? Custom AppointmentDetails class ? => hard to do
    timeSlot = context
        .read<TimeSlotCubit>()
        .repository
        .getTimeSlot(appointment.id as int);

    debugPrint('timeSlot: $timeSlot');

    if (appointment.appointmentType == AppointmentType.normal) {
      // if the appointment is normal (not recurring), retrieve the task from the current time slot
      // TODO: now WorkBlock are normal appointments
      task = timeSlot as Task;
    } else if (timeSlot is WorkBlock) {
      // if it is a work block, we should be able to retrieve the task from it
      if ((timeSlot as WorkBlock).taskId != 0) {
        task = context
            .read<TaskCubit>()
            .repository
            .getTask((timeSlot as WorkBlock).taskId);
      }

      // // check if there is a task associated to it
      // List<TimeSlot> timeSlots =
      //     context.read<TimeSlotCubit>().repository.getTimeSlots();
      // // look for a timeslot containing a task starting and ending at the same time as the work timeslot
      // for (var timeSlotItem in timeSlots) {
      //   if (timeSlotItem.event is Task &&
      //       TimeSlotUseCases().isSameTimeSlot(timeSlotItem, appointment)) {
      //     // verify that the task is planned for the same day as the work block
      //     // task = timeSlotItem.startTime.day == timeSlot!.startTime.day
      //     //     ? timeSlotItem.event as Task
      //     //     : null;
      //     task = timeSlotItem.event as Task;
      //     break;
      //   }
      // }
    }
  }

  // TODO bug when a block duration is modified, the task does not appear under it anymore (because the link is created with the same duration, should be with an id for example)

  @override
  Widget build(BuildContext context) {
    _initTask(context);
    return Container(
        width: widget.appointmentDetails.bounds.width,
        height: widget.appointmentDetails.bounds.height,
        color: appointment.color,
        child: () {
          if (appointment.appointmentType != AppointmentType.normal) {
            // if it is a recurring appointment
            if (timeSlot is WorkBlock) {
              // if it is a work block, we use a Stack widget to display the task on top of it
              return TimeSlotAppointmentWorkBlock(
                  appointment: appointment,
                  task: task,
                  isTomorrow: widget.isTomorrow);
            } else {
              // if it is a standard block, we display it as a normal appointment
              return Padding(
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
          } else {
            // if it is a task
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TimeSlotAppointmentTask(
                    appointment: appointment,
                    task: task!,
                    isTomorrow: widget.isTomorrow),
              ],
            );
          }
        }());
  }
}
