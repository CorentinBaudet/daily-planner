import 'package:daily_planner/features/block/presentation/widgets/block_delete_mode_widgets.dart';
import 'package:daily_planner/features/block/presentation/widgets/block_list_tile.dart';
import 'package:daily_planner/features/time_slot/domain/entities/time_slot_entity.dart';
import 'package:daily_planner/features/time_slot/domain/usecases/time_slot_usecases.dart';
import 'package:daily_planner/features/time_slot/presentation/cubit/time_slot_cubit.dart';
import 'package:daily_planner/utils/double_value_listenable_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlockPage extends StatelessWidget {
  final _isDeleteModeOn = ValueNotifier<bool>(false);
  final _selectedBlocks = List<TimeSlot>.empty(growable: true);
  final _selectedBlocksNb = ValueNotifier<int>(0);

  BlockPage({super.key});

  _buildBlockList(BuildContext context, List<TimeSlot> timeSlots) {
    timeSlots = TimeSlotUseCases().getWorkBlockTimeSlots(timeSlots);
    timeSlots = TimeSlotUseCases().sortTimeSlots(timeSlots);

    return timeSlots.isEmpty
        ? const Center(
            child: Text('no blocks yet',
                style: TextStyle(fontStyle: FontStyle.italic)),
          )
        : ListView.builder(
            padding: const EdgeInsets.only(top: 8),
            itemCount: timeSlots.length,
            itemBuilder: (context, index) {
              return BlockListTile(
                  timeSlot: timeSlots[index],
                  onLongPress: (() => _toggleDeleteMode(context)),
                  isDeleteModeOn: _isDeleteModeOn.value,
                  onSelected: (timeSlot) =>
                      _handleSelectedBlock(context, timeSlot, _selectedBlocks));
            },
          );
  }

  _toggleDeleteMode(BuildContext context) {
    _isDeleteModeOn.value = !_isDeleteModeOn.value;
    if (!_isDeleteModeOn.value) {
      _selectedBlocks.clear();
    }
    context.read<TimeSlotCubit>().getTimeSlots();
  }

  _handleSelectedBlock(
      BuildContext context, TimeSlot timeSlot, List<TimeSlot> selectedTasks) {
    selectedTasks.where((element) => element.id == timeSlot.id).isEmpty
        ? selectedTasks.add(timeSlot)
        : selectedTasks.remove(
            selectedTasks.firstWhere((element) => element.id == timeSlot.id));
    selectedTasks.isEmpty ? _toggleDeleteMode(context) : null;

    // to update the number of selected tasks for the delete mode widgets
    _selectedBlocksNb.value = selectedTasks.length;
  }

  @override
  Widget build(BuildContext context) {
    // display a list of the blocks
    return Scaffold(
        appBar: AppBar(
          title: Text('blocks',
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold)),
          actions: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              DoubleValueListenableBuilder(
                first: _isDeleteModeOn,
                second: _selectedBlocksNb,
                builder: (context, first, second, child) =>
                    BlockDeleteModeWidgets(
                        isDeleteModeOn: first,
                        selectedTimeSlots: _selectedBlocks,
                        selectedTimeSlotsNb: second,
                        toggleDeleteMode: _toggleDeleteMode),
              )
            ])
          ],
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
              return _buildBlockList(context, state.timeSlots);
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
            // showDialog(
            //     context: context, builder: (context) => BlockAddDialog());
          },
          child: const Icon(Icons.add),
        ));
  }
}
