import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:daily_planner/features/time_slot/presentation/cubit/time_slot_cubit.dart';

class TimeSlotPage extends StatelessWidget {
  const TimeSlotPage({super.key});

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
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is LoadedState) {
            return const Center(
              child: Text('loaded state'),
            );
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
