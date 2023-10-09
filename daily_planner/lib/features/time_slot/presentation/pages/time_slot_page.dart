import 'package:daily_planner/features/time_slot/domain/entities/time_slot_data_source.dart';
import 'package:daily_planner/features/time_slot/domain/entities/time_slot_entity.dart';
import 'package:daily_planner/features/time_slot/presentation/widgets/time_slot_bottom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:daily_planner/features/time_slot/presentation/cubit/time_slot_cubit.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class TimeSlotPage extends StatelessWidget {
  TimeSlotPage({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
        // initialSelectedDate: DateTime.now(), // TODO to improve
        dragAndDropSettings: const DragAndDropSettings(
          allowNavigation: false,
        ),
      ),
      // TimePlanner(
      //   currentTimeAnimation: true,
      //   startHour: 1,
      //   endHour: 23,
      //   style: TimePlannerStyle(
      //       cellWidth: 320,
      //       borderRadius: const BorderRadius.all(Radius.circular(8))),
      //   headers: const [
      //     TimePlannerTitle(
      //       title: "monday",
      //       date: "9/10/2023",
      //     ),
      //   ],
      //   // List of task will be show on the time planner
      //   tasks: [
      //     TimePlannerTask(
      //       color: Colors.yellow,
      //       dateTime: TimePlannerDateTime(day: 0, hour: 9, minutes: 0),
      //       minutesDuration: 60,
      //       child: const Text("task 1"),
      //     ),
      //   ],
      // ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          key: _scaffoldKey,
          // endDrawer: const Drawer(
          //   backgroundColor: Colors.red,
          // ),
          body: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              BlocBuilder<TimeSlotCubit, TimeSlotState>(
                  builder: (context, state) {
                if (state is InitialState) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is LoadingState) {
                  return Stack(children: [
                    _buildEmptyPlanner(),
                    const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ]);
                } else if (state is LoadedState) {
                  return _buildPlanner(state.timeSlots);
                } else if (state is ErrorState) {
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
        ),
        Positioned(right: 0, child: TimeSlotBottomDrawer()

            // Container(
            //   decoration: BoxDecoration(
            //     borderRadius: const BorderRadius.only(
            //       topLeft: Radius.circular(32.0),
            //       bottomLeft: Radius.circular(32.0),
            //     ),
            //     color: Colors.blue.shade200,
            //   ),
            //   width: 70,
            //   height: MediaQuery.of(context).size.height, // height of the body
            //   child: const Center(child: Text('Tasks')),
            // ),
            ),
      ],
    );
  }
}
