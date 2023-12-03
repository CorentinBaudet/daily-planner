import 'package:daily_planner/features/task/domain/entities/task_entity.dart';
import 'package:daily_planner/features/task/domain/repositories/task_local_storage_repository.dart';
import 'package:daily_planner/features/task/presentation/cubit/task_cubit.dart';
import 'package:daily_planner/features/time_slot/domain/entities/block_entity.dart';
import 'package:daily_planner/features/time_slot/domain/entities/time_slot_data_source.dart';
import 'package:daily_planner/features/time_slot/domain/entities/time_slot_entity.dart';
import 'package:daily_planner/features/time_slot/domain/repositories/time_slot_local_storage_repository.dart';
import 'package:daily_planner/features/time_slot/domain/usecases/time_slot_usecases.dart';
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
    TimeSlot timeSlot = context
        .read<TimeSlotCubit>()
        .repository
        .getTimeSlot(appointment.id as int);
    var taskTimeSlot;
    if (timeSlot.event is Block) {
      // check if there is a task associated to the block
      List<TimeSlot> timeSlots =
          TimeSlotLocalStorageRepository().getTimeSlots();
      // look for a timeslot containing a task starting and ending at the same time as the work timeslot
      for (var item in timeSlots) {
        if (item.event is Task &&
            TimeSlotUseCases().isSameTimeSlot(item, appointment)) {
          taskTimeSlot = item;
          break;
        }
      }
      if (taskTimeSlot == null) {
        // if no task found for the block, return
        return;
      }
      // else, update the edited time slot to be the task time slot
      timeSlot = taskTimeSlot;
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
      // TODO weird and probably not clean use of local storage repository directly
      // if the content is a task, update isPlanned to false
      Task task = TaskLocalStorageRepository()
          .getTask((timeSlot.event as Task).id as int);
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
    // TODO center the calendar on the current time
    return Expanded(
      child: SfCalendar(
        dataSource: TimeSlotDataSource.getDataSource(context, timeSlots,
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
