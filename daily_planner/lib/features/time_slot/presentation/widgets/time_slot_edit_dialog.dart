import 'package:daily_planner/constants/intl.dart';
import 'package:daily_planner/features/time_slot/domain/entities/time_slot_entity.dart';
import 'package:daily_planner/features/time_slot/domain/usecases/time_slot_usecases.dart';
import 'package:daily_planner/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

// ignore: must_be_immutable
class TimeSlotEditDialog extends StatefulWidget {
  TimeSlot timeSlot;

  TimeSlotEditDialog({super.key, required this.timeSlot});

  @override
  State<TimeSlotEditDialog> createState() => _TimeSlotEditDialogState();
}

class _TimeSlotEditDialogState extends State<TimeSlotEditDialog> {
  Row _editStartTime(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text("start time: ",
            style: TextStyle(color: Theme.of(context).primaryColor)),
        const SizedBox(
          width: 16,
        ),
        DropdownButton(
          items: TimeSlotUseCases().getStartTimeSlots().map((item) {
            return DropdownMenuItem(
              value: item,
              child: Text(
                textAlign: TextAlign.center,
                item,
              ),
            );
          }).toList(),
          value: Utils().formatTime(widget.timeSlot.startTime),
          icon: const Icon(null),
          menuMaxHeight: 250,
          onChanged: (value) {
            setState(() => widget.timeSlot.startTime = DateTime(
                widget.timeSlot.startTime.year,
                widget.timeSlot.startTime.month,
                widget.timeSlot.startTime.day,
                ConstantsIntl.timeFormat.parse(value.toString()).hour,
                ConstantsIntl.timeFormat.parse(value.toString()).minute));
          },
        ),
      ],
    );
  }

  Row _editDuration(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
            onPressed: () {
              setState(() {
                widget.timeSlot.duration -= 15;
              });
            },
            icon: const Icon(Icons.remove_rounded)),
        NumberPicker(
          axis: Axis.horizontal,
          itemCount: 3,
          itemWidth: MediaQuery.of(context).size.width * 0.15,
          value: widget.timeSlot.duration,
          minValue: 15,
          maxValue: 180,
          step: 15,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.black, width: 0.5),
          ),
          onChanged: (value) =>
              setState(() => widget.timeSlot.duration = value),
        ),
        IconButton(
            onPressed: () {
              setState(() {
                widget.timeSlot.duration += 15;
              });
            },
            icon: const Icon(Icons.add_rounded)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('edit time slot'),
          IconButton(
            onPressed: () {
              // delete the time slot
              Navigator.of(context).pop(false);
            },
            icon: const Icon(Icons.delete_rounded),
          ),
        ],
      ),
      insetPadding: const EdgeInsets.all(0),
      content: SizedBox(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _editStartTime(context),
            const SizedBox(
              height: 16,
            ),
            _editDuration(context),
          ],
        ),
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
          onPressed: () {
            // edit the time slot
            Navigator.of(context).pop(widget.timeSlot);
          },
          child: const Text('edit'),
        ),
      ],
    );
  }
}
