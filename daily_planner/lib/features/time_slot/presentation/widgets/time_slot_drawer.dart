import 'package:daily_planner/features/time_slot/domain/entities/time_slot_entity.dart';
import 'package:daily_planner/features/time_slot/presentation/widgets/time_slot_drawer_list.dart';
import 'package:flutter/material.dart';

class TimeSlotDrawer extends StatefulWidget {
  final List<TimeSlot> timeSlots;
  bool isTaskListVisible;
  final VoidCallback onClosing;

  TimeSlotDrawer(
      {super.key,
      required this.timeSlots,
      required this.isTaskListVisible,
      required this.onClosing});

  @override
  State<TimeSlotDrawer> createState() => _TimeSlotDrawerState();
}

// TODO add shadow to the drawer
class _TimeSlotDrawerState extends State<TimeSlotDrawer> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(
          maxWidth: 175,
        ),
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(32.0),
              bottomLeft: Radius.circular(32.0),
            ),
            // color: Colors.grey.shade100,
            color: Color(0xFFfff3ee)),
        height: MediaQuery.of(context).size.height - 60,
        padding: const EdgeInsets.only(top: 24, left: 16, right: 16),
        child: Column(
          children: <Widget>[
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              IconButton(
                icon: const Icon(Icons.arrow_forward_ios_rounded, size: 20),
                constraints:
                    const BoxConstraints(), // remove the padding around the icon
                padding: EdgeInsets.zero, // remove the padding around the icon
                onPressed: () {
                  // close the container
                  setState(() {
                    widget.isTaskListVisible = false;
                  });
                  widget.onClosing();
                },
              ),
              // Spacer(),
              const Text('my tasks',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ]),
            TimeSlotDrawerList(timeSlots: widget.timeSlots),
          ],
        ),
      ),
    );
  }
}
