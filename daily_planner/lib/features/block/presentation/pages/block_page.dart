import 'package:daily_planner/features/block/presentation/widgets/block_add_dialog.dart';
import 'package:daily_planner/features/time_slot/domain/entities/time_slot_entity.dart';
import 'package:daily_planner/features/time_slot/domain/usecases/time_slot_usecases.dart';
import 'package:daily_planner/features/time_slot/presentation/cubit/time_slot_cubit.dart';
import 'package:daily_planner/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlockPage extends StatelessWidget {
  const BlockPage({super.key});

  _buildBlockList(BuildContext context, List<TimeSlot> timeSlots) {
    timeSlots = TimeSlotUseCases().getBlockTimeSlots(timeSlots);

    return timeSlots.isEmpty
        ? const Center(
            child: Text('no blocks yet'),
          )
        : ListView.builder(
            itemCount: timeSlots.length,
            itemBuilder: (context, index) {
              final timeSlot = timeSlots[index];
              return ListTile(
                title: Text(timeSlot.event.name),
                trailing: Column(
                  children: [
                    Text(Utils().formatTime(timeSlot.startTime)),
                    const Text('|'),
                    Text(Utils().formatTime(timeSlot.startTime
                        .add(Duration(minutes: timeSlot.duration)))),
                  ],
                ),
                contentPadding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
                shape: ShapeBorder.lerp(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    1),
              );
            },
          );
  }

  @override
  Widget build(BuildContext context) {
    // display a list of the blocks
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: const Text('blocks'),
        ),
        body: BlocBuilder<TimeSlotCubit, TimeSlotState>(
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
              return Container(
                  child: _buildBlockList(context, state.timeSlots));
            } else if (state is ErrorState) {
              return const Center(
                child: Text('error loading blocks'),
              );
            } else {
              return const Center(
                child: Text('unknown error'),
              );
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
                context: context, builder: (context) => const BlockAddDialog());
          },
          child: const Icon(Icons.add),
        ));
  }
}
