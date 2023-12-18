import 'package:daily_planner/features/time_slot/domain/entities/time_slot_entity.dart';
import 'package:daily_planner/features/time_slot/domain/usecases/time_slot_usecases.dart';
import 'package:daily_planner/features/time_slot/presentation/widgets/time_slot_picker.dart';
import 'package:flutter/material.dart';

class TimeSlotEditDialog extends StatefulWidget {
  TimeSlot timeSlot;

  TimeSlotEditDialog({super.key, required this.timeSlot});

  @override
  State<TimeSlotEditDialog> createState() => _TimeSlotEditDialogState();
}

class _TimeSlotEditDialogState extends State<TimeSlotEditDialog> {
  bool isTimeSlotValid = true;

  TimeSlotPicker _editStartTime(BuildContext context) {
    return TimeSlotPicker(timeSlot: widget.timeSlot, isEndTime: false);
  }

  TimeSlotPicker _editEndTime(BuildContext context) {
    return TimeSlotPicker(timeSlot: widget.timeSlot, isEndTime: true);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(widget.timeSlot.subject.characters.length > 18
              ? '${widget.timeSlot.subject.characters.take(18)}...'
              : widget.timeSlot.subject),
          IconButton(
            // remove all padding of this icon button
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: () {
              // delete the time slot
              Navigator.of(context).pop(false);
            },
            icon: const Icon(Icons.delete_rounded),
          ),
        ],
      ),
      insetPadding: const EdgeInsets.all(10),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [_editStartTime(context), _editEndTime(context)],
          ),
          Visibility(
              visible: !isTimeSlotValid,
              child: const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text('invalid time slot',
                    style: TextStyle(color: Colors.red, fontSize: 14)),
              )),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            // close the dialog
            Navigator.of(context).pop();
          },
          child: const Text('cancel'),
        ),
        TextButton(
          style: ButtonStyle(
              foregroundColor: MaterialStateColor.resolveWith(
                  (Set<MaterialState> states) => Colors.white),
              backgroundColor: MaterialStateProperty.all(
                  Theme.of(context).colorScheme.primary)),
          onPressed: () {
            if (!TimeSlotUseCases.isValidTimeSlot(widget.timeSlot)) {
              // If the timeslot is invalid, set isTimeSlotValid to false
              setState(() {
                isTimeSlotValid = false;
              });
              return;
            }
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('time slot updated')),
            );
            Navigator.of(context).pop(widget.timeSlot);
          },
          child: const Text('edit'),
        ),
      ],
    );
  }
}
