import 'package:daily_planner/features/time_slot/domain/entities/time_slot_entity.dart';
import 'package:flutter/material.dart';

class BlockDeleteConfirmationDialog extends StatelessWidget {
  final List<TimeSlot> selectedBlocks;

  const BlockDeleteConfirmationDialog(
      {super.key, required this.selectedBlocks});

  @override
  Widget build(BuildContext context) {
    // set up the buttons
    Widget noButton = ElevatedButton(
      child: const Text("no"),
      onPressed: () => Navigator.of(context).pop(false),
    );
    Widget yesButton = ElevatedButton(
      child: const Text("yes"),
      onPressed: () => Navigator.of(context).pop(true),
    );

    return selectedBlocks.length == 1
        ? AlertDialog(
            title: const Text("delete block"),
            content: Text(
                'would you like to permanently delete "${selectedBlocks.first.event.name}"?'),
            actions: [
              noButton,
              yesButton,
            ],
          )
        : AlertDialog(
            title: const Text("delete blocks"),
            content: Text(
                'would you like to permanently delete ${selectedBlocks.length} blocks?'),
            actions: [
              noButton,
              yesButton,
            ],
          );
  }
}
