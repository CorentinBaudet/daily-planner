import 'package:daily_planner/features/block/domain/entities/block_entity.dart';
import 'package:daily_planner/features/task/domain/entities/task_entity.dart';
import 'package:daily_planner/features/task/domain/repositories/task_local_storage_repository.dart';
import 'package:daily_planner/features/task/presentation/cubit/task_cubit.dart';
import 'package:daily_planner/features/time_slot/domain/entities/time_slot_data_source.dart';
import 'package:daily_planner/features/time_slot/domain/entities/time_slot_entity.dart';
import 'package:daily_planner/features/time_slot/domain/repositories/time_slot_local_storage_repository.dart';
import 'package:daily_planner/features/time_slot/presentation/cubit/time_slot_cubit.dart';
import 'package:daily_planner/features/time_slot/presentation/widgets/time_slot_edit_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class TimeSlotTomorrowPlanning extends StatelessWidget {
  const TimeSlotTomorrowPlanning({
    super.key,
    required this.context,
    required this.timeSlots,
  });

  final BuildContext context;
  final List<TimeSlot> timeSlots;

  _handleTimeSlotTap(CalendarTapDetails calendarTapDetails) async {
    if (calendarTapDetails.appointments == null) {
      return;
    }

    Appointment appointment = calendarTapDetails.appointments!.first;
    TimeSlot timeSlot =
        TimeSlotLocalStorageRepository().getTimeSlot(appointment.id as int);
    if (timeSlot.event is Block) {
      return; // if the content of the time slot is a block, do nothing
    }

    final result = await showDialog(
      context: context,
      builder: (context) => TimeSlotEditDialog(timeSlot: timeSlot),
    );
    // check if the widget is still in the widget tree
    if (!context.mounted) {
      return;
    }
    if (result == null) {
      return;
    }

    if (result == false) {
      // if the content is a task, update isPlanned to false
      Task task =
          TaskLocalStorageRepository().getTask(timeSlot.event.id as int);
      task.isPlanned = false;
      context.read<TaskCubit>().updateTask(task);

      // and delete the time slot
      context.read<TimeSlotCubit>().deleteTimeSlot(timeSlot.id as int);
    } else {
      context.read<TimeSlotCubit>().updateTimeSlot(result as TimeSlot);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SfCalendar(
        dataSource: TimeSlotDataSource.getPlannerDataSource(timeSlots,
            isTomorrow: true),
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
        onTap: (calendarTapDetails) {
          _handleTimeSlotTap(calendarTapDetails);
        },
      ),
    );
  }
}
