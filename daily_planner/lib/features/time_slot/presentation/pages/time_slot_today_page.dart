import 'package:daily_planner/features/time_slot/domain/entities/time_slot_data_source.dart';
import 'package:daily_planner/features/time_slot/domain/entities/time_slot_entity.dart';
import 'package:daily_planner/features/time_slot/presentation/pages/time_slot_tomorrow_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:daily_planner/features/time_slot/presentation/cubit/time_slot_cubit.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class TimeSlotTodayPage extends StatelessWidget {
  const TimeSlotTodayPage({super.key});

  Widget _buildPlanner(List<TimeSlot> timeSlots) {
    return Expanded(
      child: SfCalendar(
        dataSource: TimeSlotDataSource.getPlannerDataSource(timeSlots),
        headerHeight: 0,
        backgroundColor: Colors.transparent,
        allowDragAndDrop: true,
        viewNavigationMode:
            ViewNavigationMode.none, // prevent from swiping to other days
        // timeSlotViewSettings: const TimeSlotViewSettings(timeRulerSize: 35), // reduce the width of the time ruler
        timeSlotViewSettings: const TimeSlotViewSettings(
            timeIntervalHeight:
                75), // increase the height of 1 hour slot to make text appear for 15 min slots
        dragAndDropSettings: const DragAndDropSettings(
          allowNavigation: false,
        ),
        appointmentTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 12,
        ),
        showCurrentTimeIndicator: true,
        // loadMoreWidgetBuilder: (context, loadMoreAppointments) {
        //   // display loader while loading more appointments
        //   return const Center(
        //     child: CircularProgressIndicator(),
        //   );
        // },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
              backgroundColor: Theme.of(context).primaryColor,
              title: const Text('today')),
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
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is LoadedState) {
                  return _buildPlanner(state.timeSlots);
                } else if (state is ErrorState) {
                  return const Center(
                    child: Text('error loading planning'),
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
        ),
      ],
    );
  }
}
