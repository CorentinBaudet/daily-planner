import 'package:daily_planner/features/time_slot/domain/entities/time_slot_data_source.dart';
import 'package:daily_planner/features/time_slot/domain/entities/time_slot_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:daily_planner/features/time_slot/presentation/cubit/time_slot_cubit.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class TimeSlotPage extends StatelessWidget {
  const TimeSlotPage({super.key});

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
    return Scaffold(
        body: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        BlocBuilder<PlannerCubit, PlannerState>(builder: (context, state) {
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
    ));
  }
}
