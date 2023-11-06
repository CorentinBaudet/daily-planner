import 'package:daily_planner/features/block/presentation/widgets/block_add_dialog.dart';
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
              color: () {
                if (widget.isDeleteModeOn) {
                  return isSelected
                      ? Colors.grey.shade400
                      : const Color(0xFFffe7dc);
                } else {
                  isSelected = false;
                  return const Color(0xFFffe7dc);
                }
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
                    Text(Utils().formatTime(widget.timeSlot.endTime)),
                  ],
                ),
                const SizedBox(width: 24.0),
                IconButton(
                    icon: const Icon(Icons.edit_rounded),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) =>
                              BlockAddDialog(toEditBlock: widget.timeSlot));
                    }),
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
