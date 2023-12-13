import 'package:daily_planner/features/time_slot/domain/entities/time_slot_data_source.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:daily_planner/features/time_slot/presentation/cubit/time_slot_cubit.dart';
import 'package:daily_planner/features/time_slot/presentation/pages/time_slot_tomorrow_page.dart';
import 'package:daily_planner/features/time_slot/presentation/widgets/time_slot_today_planner.dart';

class TimeSlotTodayPage extends StatelessWidget {
  const TimeSlotTodayPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
              // backgroundColor: Colors.white,
              title: Text('today',
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold))),
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
                  // Synchronize the state of TimeSlotDataSource with the state of the TimeSlot cubit
                  TimeSlotDataSource().buildTimeSlotDataSource(state.timeSlots);
                  return TimeSlotTodayPlanner(
                      context: context, timeSlots: state.timeSlots);
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
