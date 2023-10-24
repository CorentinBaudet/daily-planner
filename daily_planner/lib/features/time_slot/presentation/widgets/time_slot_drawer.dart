import 'package:daily_planner/features/time_slot/presentation/widgets/time_slot_drawer_list.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TimeSlotDrawer extends StatefulWidget {
  bool isTaskListVisible = false;
  final VoidCallback onClosing;

  TimeSlotDrawer(
      {super.key, required this.isTaskListVisible, required this.onClosing});

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
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(32.0),
            bottomLeft: Radius.circular(32.0),
          ),
          color: Colors.grey.shade100,
        ),
        height: MediaQuery.of(context).size.height - 80,
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
              const Text('my tasks', style: TextStyle(fontSize: 16)),
            ]),
            const TimeSlotDrawerList(),
          ],
        ),
      ),
    );
  }
}
