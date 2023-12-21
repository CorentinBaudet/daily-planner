import 'package:daily_planner/features/block/domain/entities/block_entity.dart';
import 'package:daily_planner/features/block/domain/entities/work_block_entity.dart';
import 'package:daily_planner/features/task/domain/entities/task_entity.dart';
import 'package:daily_planner/features/time_slot/domain/entities/time_slot_data_source.dart';
import 'package:daily_planner/features/time_slot/domain/entities/time_slot_entity.dart';
import 'package:daily_planner/features/time_slot/presentation/cubit/time_slot_cubit.dart';
import 'package:daily_planner/features/time_slot/presentation/widgets/time_slot_appointment_builder.dart';
import 'package:daily_planner/features/time_slot/presentation/widgets/time_slot_edit_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class TimeSlotTomorrowPlanner extends StatelessWidget {
  final BuildContext context;
  final List<TimeSlot> timeSlots;

  const TimeSlotTomorrowPlanner({
    super.key,
    required this.context,
    required this.timeSlots,
  });

  _handleTimeSlotTap(
      BuildContext context, CalendarTapDetails calendarTapDetails) async {
    if (calendarTapDetails.appointments == null) {
      return;
    }

    Appointment appointment = calendarTapDetails.appointments!.first;
    final timeSlotCubit = context.read<TimeSlotCubit>();
    TimeSlot timeSlot =
        timeSlotCubit.repository.getTimeSlot(appointment.id as int);

    if (timeSlot is Block) {
      return;
    }

    if (timeSlot is WorkBlock) {
      if (timeSlot.tomorrowTaskId != 0) {
        // Get the task from the work block and unplan it
        Task task = timeSlotCubit.repository
            .getTimeSlot(timeSlot.tomorrowTaskId) as Task;
        task.isPlanned = false;
        timeSlotCubit.updateTimeSlot(task);

        // Update the work block
        timeSlot.tomorrowTaskId = 0;
        timeSlotCubit.updateTimeSlot(timeSlot);
      }
      return;
    }

    // Display the edit dialog
    final result = await showDialog(
      context: context,
      builder: (context) => TimeSlotEditDialog(timeSlot: timeSlot),
    );
    if (result == null) {
      return;
    }

    if (result == false) {
      // Remove the task from tomorrow by updating isPlanned to false
      (timeSlot as Task).startTime = DateTime(0);
      timeSlot.endTime = DateTime(0);
      timeSlot.isPlanned = false;
      timeSlotCubit.updateTimeSlot(timeSlot);
    } else {
      timeSlotCubit.updateTimeSlot(result as TimeSlot);
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO center the calendar on the current time
    return Expanded(
      child: SfCalendar(
        dataSource: TimeSlotDataSource()
            .getTimeSlotDataSource(timeSlots, isTomorrow: true),
        headerHeight: 0,
        backgroundColor: Colors.transparent,
        allowDragAndDrop: true,
        viewNavigationMode:
            ViewNavigationMode.none, // prevent from swiping to other days
        // timeSlotViewSettings: const TimeSlotViewSettings(timeRulerSize: 35), // reduce the width of the time ruler
        timeSlotViewSettings: const TimeSlotViewSettings(
            timeIntervalHeight:
                75), // increase the height of 1 hour slot to make text appear for 15 min slots
        initialDisplayDate: DateTime.now().add(const Duration(days: 1)),
        dragAndDropSettings: const DragAndDropSettings(
          allowNavigation: false,
        ),
        appointmentTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 12,
        ),
        appointmentBuilder: (context, calendarAppointmentDetails) {
          return TimeSlotAppointmentBuilder(
            appointmentDetails: calendarAppointmentDetails,
            isTomorrow: true,
          );
        },
        onTap: (calendarTapDetails) {
          _handleTimeSlotTap(context, calendarTapDetails);
        },
      ),
    );
  }
}
