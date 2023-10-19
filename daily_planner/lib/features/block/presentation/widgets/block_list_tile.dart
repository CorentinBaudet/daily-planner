import 'package:daily_planner/features/block/domain/entities/block_entity.dart';
import 'package:daily_planner/features/time_slot/domain/entities/time_slot_entity.dart';
import 'package:daily_planner/utils/utils.dart';
import 'package:flutter/material.dart';

class BlockListTile extends StatefulWidget {
  final TimeSlot timeSlot;
  final VoidCallback onLongPress; // callback for delete mode
  final bool isDeleteModeOn;
  final void Function(TimeSlot) onSelected;

  const BlockListTile(
      {super.key,
      required this.timeSlot,
      required this.onLongPress,
      required this.isDeleteModeOn,
      required this.onSelected});

  @override
  State<BlockListTile> createState() => _BlockListTileState();
}

class _BlockListTileState extends State<BlockListTile> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        setState(() {
          isSelected = !isSelected;
        });
        widget.onLongPress();
        widget.onSelected(widget.timeSlot);
      },
      onTap: () {
        if (widget.isDeleteModeOn) {
          setState(() {
            isSelected = !isSelected;
          });
          widget.onSelected(widget.timeSlot);
        }
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Container(
          margin: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 8.0),
          decoration: BoxDecoration(
              color: widget.isDeleteModeOn
                  ? (isSelected
                      ? Colors.grey.shade400
                      : (widget.timeSlot.event as Block).isWork
                          ? Colors.grey.shade200
                          : Colors.indigo.shade100)
                  : () {
                      isSelected = false;
                      return Colors.grey.shade200;
                    }(),
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: const [
                BoxShadow(
                  color: Colors.grey,
                  offset: Offset(0.0, 1.0),
                  blurRadius: 3.0,
                )
              ]),
          child: ListTile(
            title: Text(widget.timeSlot.event.name),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(Utils().formatTime(widget.timeSlot.startTime)),
                    const Text('|'),
                    Text(Utils().formatTime(widget.timeSlot.startTime
                        .add(Duration(minutes: widget.timeSlot.duration)))),
                  ],
                ),
              ],
            ),
            contentPadding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
            shape: ShapeBorder.lerp(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                1),
          ),
        ),
      ),
    );
  }
}
