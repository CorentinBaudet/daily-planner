import 'package:daily_planner/features/task/domain/entities/task_entity.dart';
import 'package:daily_planner/features/task/domain/repositories/task_local_storage_repository.dart';
import 'package:daily_planner/features/task/presentation/cubit/task_cubit.dart';
import 'package:daily_planner/features/time_slot/domain/repositories/time_slot_local_storage_repository.dart';
import 'package:daily_planner/features/time_slot/presentation/cubit/time_slot_cubit.dart';
import 'package:daily_planner/features/time_slot/presentation/widgets/time_slot_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'package:daily_planner/features/time_slot/domain/entities/time_slot_data_source.dart';
import 'package:daily_planner/features/time_slot/domain/entities/time_slot_entity.dart';
import 'package:daily_planner/features/time_slot/presentation/cubit/time_slot_cubit.dart'
    as ts_cubit;

class TimeSlotTomorrowPage extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _isTaskListVisible = ValueNotifier<bool>(false);

  TimeSlotTomorrowPage({super.key});

  Widget _buildEmptyPlanner() {
    return Flexible(
      fit: FlexFit.loose,
      child: SfCalendar(
        headerHeight: 0,
      ),
    );
  }

  Widget _buildPlanner(BuildContext context, List<TimeSlot> timeSlots) {
    return Flexible(
        fit: FlexFit.loose,
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
          onTap: (calendarTapDetails) {
            if (calendarTapDetails.appointments == null) {
              return;
            }

            Appointment appointment = calendarTapDetails.appointments!.first;
            TimeSlot timeSlot = TimeSlotLocalStorageRepository()
                .getTimeSlot(appointment.id as int);

            // if the content is a task, update isPlanned to false
            Task task = TaskLocalStorageRepository().getTask(timeSlot.content.id
                as int); // TODO condition to check is the content is a task
            task.isPlanned = false;
            context.read<TasksCubit>().updateTask(task);

            context.read<TimeSlotCubit>().deleteTimeSlot(timeSlot.id as int);
          },
        ));
  }

  // switch back _isTaskListVisible to false when the drawer is closed
  void drawerClosingCallBack() {
    _isTaskListVisible.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: const Text('tomorrow'),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BlocBuilder<ts_cubit.TimeSlotCubit, ts_cubit.TimeSlotState>(
                builder: (context, state) {
              if (state is ts_cubit.InitialState) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is ts_cubit.LoadingState) {
                return Stack(children: [
                  _buildEmptyPlanner(),
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
                ]);
              } else if (state is ts_cubit.LoadedState) {
                return _buildPlanner(context, state.timeSlots);
              } else if (state is ts_cubit.ErrorState) {
                return const Center(
                  child: Text('error loading tasks'),
                );
              } else {
                return const Center(
                  child: Text('unknown error'),
                );
              }
            })
          ],
        ),
        floatingActionButton: FloatingActionButton(
            heroTag: 'show_task_list',
            child: const Icon(Icons.list_rounded),
            onPressed: () {
              _isTaskListVisible.value = !_isTaskListVisible.value;
            }),
      ),
      Positioned(
          right: 0,
          child: ValueListenableBuilder(
            valueListenable: _isTaskListVisible,
            builder: (context, value, child) {
              return TimeSlotDrawer(
                  isTaskListVisible: value, onClosing: drawerClosingCallBack);
            },
          )),
    ]);
  }
}
