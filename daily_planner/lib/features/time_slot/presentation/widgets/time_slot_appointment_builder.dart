import 'package:daily_planner/features/task/domain/entities/task_entity.dart';
import 'package:daily_planner/features/block/domain/entities/block_entity.dart';
import 'package:daily_planner/features/time_slot/domain/entities/time_slot_entity.dart';
import 'package:daily_planner/features/block/domain/entities/work_block_entity.dart';
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

  _initTimeSlot(BuildContext context) {
    appointment = widget.appointmentDetails.appointments.first;
    final timeSlotCubit = context.read<TimeSlotCubit>();
    // pass the timeSlot to the widget instead of retrieving it here ? Custom AppointmentDetails class ? => hard to do
    timeSlot = timeSlotCubit.repository.getTimeSlot(appointment.id as int);
    Task? task;

    switch (timeSlot.runtimeType) {
      case Task:
        task = timeSlot as Task;
        break;
      case Block:
        break;
      case WorkBlock:
        if (!widget.isTomorrow) {
          (timeSlot as WorkBlock).todayTaskId != 0
              ? task = timeSlotCubit.repository
                  .getTimeSlot((timeSlot as WorkBlock).todayTaskId) as Task
              : task = null;
        } else {
          (timeSlot as WorkBlock).tomorrowTaskId != 0
              ? task = timeSlotCubit.repository
                  .getTimeSlot((timeSlot as WorkBlock).tomorrowTaskId) as Task
              : task = null;
        }
        break;
      default:
      // TODO: handle this case by logging it
    }
    return task;
  }

  @override
  Widget build(BuildContext context) {
    Task? task = _initTimeSlot(context);
    return Container(
        width: widget.appointmentDetails.bounds.width,
        height: widget.appointmentDetails.bounds.height,
        color: appointment.color,
        child: () {
          if (timeSlot is Task) {
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
          // if it is a recurring appointment
          else if (timeSlot is Block) {
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
          } else {
            // if it is a work block, we use a Stack widget to display the task on top of it
            return TimeSlotAppointmentWorkBlock(
                appointment: appointment,
                task: task,
                isTomorrow: widget.isTomorrow);
          }
        }());
  }
}
