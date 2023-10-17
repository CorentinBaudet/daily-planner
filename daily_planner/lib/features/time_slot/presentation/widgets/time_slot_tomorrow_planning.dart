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

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SfCalendar(
        // TODO make a widget for this
        dataSource: TimeSlotDataSource.getPlannerDataSource(timeSlots),
        headerHeight: 0,
        backgroundColor: Colors.transparent,
        allowDragAndDrop: true,
        viewNavigationMode:
            ViewNavigationMode.none, // prevent from swiping to other days
        // timeSlotViewSettings: const TimeSlotViewSettings(timeRulerSize: 35),
        initialDisplayDate: DateTime.now().add(const Duration(days: 1)),
        dragAndDropSettings: const DragAndDropSettings(
          allowNavigation: false,
        ),
        appointmentTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 12,
        ),
        onTap: (calendarTapDetails) async {
          if (calendarTapDetails.appointments == null) {
            return;
          }
          Appointment appointment = calendarTapDetails.appointments!.first;
          TimeSlot timeSlot = TimeSlotLocalStorageRepository()
              .getTimeSlot(appointment.id as int);

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
          } else if (result == false) {
            // if the content is a task, update isPlanned to false
            Task task = TaskLocalStorageRepository().getTask(timeSlot.event.id
                as int); // TODO condition to check is the content is a task
            task.isPlanned = false;
            context.read<TaskCubit>().updateTask(task);

            // and delete the time slot
            context.read<TimeSlotCubit>().deleteTimeSlot(timeSlot.id as int);
          } else {
            context.read<TimeSlotCubit>().updateTimeSlot(result as TimeSlot);
          }
        },
      ),
    );
  }
}
