import 'package:daily_planner/features/block/presentation/widgets/block_delete_confirmation_dialog.dart';
import 'package:daily_planner/features/time_slot/domain/entities/time_slot_entity.dart';
import 'package:daily_planner/features/time_slot/presentation/cubit/time_slot_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlockDeleteModeWidgets extends StatefulWidget {
  final bool isDeleteModeOn;
  final List<TimeSlot> selectedTimeSlots;
  final int selectedTimeSlotsNb;
  final void Function(BuildContext context) toggleDeleteMode;

  const BlockDeleteModeWidgets(
      {super.key,
      required this.isDeleteModeOn,
      required this.selectedTimeSlots,
      required this.selectedTimeSlotsNb,
      required this.toggleDeleteMode});

  @override
  State<BlockDeleteModeWidgets> createState() => _BlockDeleteModeWidgetsState();
}

class _BlockDeleteModeWidgetsState extends State<BlockDeleteModeWidgets> {
  _deleteButton(BuildContext context, List<TimeSlot> selectedTimeSlots) {
    return IconButton(
        icon: const Icon(Icons.delete_rounded),
        iconSize: 20,
        onPressed: () async {
          bool result = await showDialog(
              context: context,
              builder: (BuildContext context) {
                return BlockDeleteConfirmationDialog(
                  selectedBlocks: selectedTimeSlots,
                );
              });

          if (!result) return;
          if (!context.mounted) {
            return; // to avoid calling context on widget off the tree (here because of the async gap created by the dialog)
          }

          for (var timeSlot in selectedTimeSlots) {
            context.read<TimeSlotCubit>().deleteTimeSlot(timeSlot.id as int);
          }
          widget.toggleDeleteMode(context);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              duration: Duration(seconds: 3),
              content: Text('deleted'),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.isDeleteModeOn,
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.close_rounded),
            iconSize: 18,
            onPressed: () {
              widget.toggleDeleteMode(context);
            },
          ),
          const SizedBox(width: 8),
          Text(widget.selectedTimeSlotsNb.toString(),
              style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 8),
          _deleteButton(context, widget.selectedTimeSlots),
        ],
      ),
    );
  }
}
