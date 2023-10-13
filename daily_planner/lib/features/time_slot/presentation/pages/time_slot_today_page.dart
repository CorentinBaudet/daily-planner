import 'package:daily_planner/features/time_slot/domain/entities/time_slot_data_source.dart';
import 'package:daily_planner/features/time_slot/domain/entities/time_slot_entity.dart';
import 'package:daily_planner/features/time_slot/presentation/pages/time_slot_tomorrow_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:daily_planner/features/time_slot/presentation/cubit/time_slot_cubit.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class TimeSlotTodayPage extends StatelessWidget {
  // final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TimeSlotTodayPage({super.key});

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

          dragAndDropSettings: const DragAndDropSettings(
            allowNavigation: false,
          ),
          appointmentTextStyle: const TextStyle(
            color: Colors.black,
            fontSize: 12,
          ),
          onTap: (calendarTapDetails) {
            print(calendarTapDetails.date);
            print(calendarTapDetails.appointments);
          },
        )

        // DragTarget<Task>(
        //   builder: (context, candidateData, rejectedData) {
        //     return SfCalendar(
        //       dataSource: TimeSlotDataSource.getPlannerDataSource(timeSlots),
        //       headerHeight: 0,
        //       backgroundColor: Colors.transparent,
        //       allowDragAndDrop: true,
        //       viewNavigationMode:
        //           ViewNavigationMode.none, // prevent from swiping to other days
        //       // timeSlotViewSettings: const TimeSlotViewSettings(timeRulerSize: 35),
        //       // initialSelectedDate: DateTime.now(), // TODO to improve
        //       dragAndDropSettings: const DragAndDropSettings(
        //         allowNavigation: false,
        //       ),
        //     );
        //   },
        //   onAccept: (data) {
        //     _taskDroppedOnCalendar(data);
        //   },
        // ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          // key: _scaffoldKey,
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
              heroTag: 'plan_tomorrow',
              child: const Icon(Icons.edit_calendar_rounded),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TimeSlotTomorrowPage(),
                    ));
              }),
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
      ],
    );
  }

  // void _taskDroppedOnCalendar(Task task) {}
}
