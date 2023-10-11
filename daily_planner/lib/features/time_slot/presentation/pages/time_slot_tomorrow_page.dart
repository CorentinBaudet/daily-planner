import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'package:daily_planner/features/time_slot/domain/entities/time_slot_data_source.dart';
import 'package:daily_planner/features/time_slot/domain/entities/time_slot_entity.dart';
import 'package:daily_planner/features/time_slot/presentation/cubit/time_slot_cubit.dart'
    as ts_cubit;

class TimeSlotTomorrowPage extends StatelessWidget {
  const TimeSlotTomorrowPage({super.key});

  Widget _buildEmptyPlanner() {
    return Flexible(
      fit: FlexFit.loose,
      child: SfCalendar(
        headerHeight: 0,
      ),
    );
  }

  Widget _buildPlanner(List<TimeSlot> timeSlots) {
    return Flexible(
        fit: FlexFit.loose,
        child: SfCalendar(
          dataSource: TimeSlotDataSource.getPlannerDataSource(timeSlots),
          headerHeight: 0,
          backgroundColor: Colors.transparent,
          allowDragAndDrop: true,
          viewNavigationMode:
              ViewNavigationMode.none, // prevent from swiping to other days
          // timeSlotViewSettings: const TimeSlotViewSettings(timeRulerSize: 35),
          initialSelectedDate:
              DateTime.now().add(const Duration(days: 1)), // TODO to improve
          dragAndDropSettings: const DragAndDropSettings(
            allowNavigation: false,
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // key: _scaffoldKey,
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
              return _buildPlanner(state.timeSlots);
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
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () {
                // _isTaskListVisible.value = !_isTaskListVisible.value;
              }),
          const SizedBox(height: 16),
          FloatingActionButton(
            child: const Icon(Icons.edit_calendar_rounded),
            onPressed: () {
              // Scaffold.of(context).openEndDrawer();
              // _scaffoldKey.currentState!.openEndDrawer();
              // context.read<TimeSlotCubit>().createTimeSlot(TimeSlot(
              //       id: 4,
              //       startTime: const TimeOfDay(hour: 14, minute: 0),
              //       duration: 60,
              //       content: Task(
              //           name: 'deep work',
              //           priority: Priority.normal,
              //           createdAt:
              //               TaskUseCases().troncateCreationTime(DateTime.now())),
              //     ));
            },
          ),
        ],
      ),
      // bottomNavigationBar: BottomAppBar(
      //   elevation: 0,
      //   color: Theme.of(context).colorScheme.primary,
      //   child: Container(
      //     padding: EdgeInsets.symmetric(horizontal: 10.0),
      //     height: 56.0,
      //     child: Row(children: <Widget>[
      //       IconButton(
      //         // onPressed: showMenu(context),
      //         onPressed: () {
      //           showModalBottomSheet(
      //               context: context,
      //               backgroundColor: Colors.transparent,
      //               builder: (BuildContext context) {
      //                 return TimeSlotBottomDrawer();
      //               });
      //         },
      //         icon: Icon(Icons.menu),
      //         color: Colors.white,
      //       ),
      //     ]),
      //   ),
      // ),
    );
  }
}
