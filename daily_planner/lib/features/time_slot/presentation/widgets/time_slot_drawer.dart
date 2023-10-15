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

class _TimeSlotDrawerState extends State<TimeSlotDrawer> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Visibility(
        visible: widget.isTaskListVisible,
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
          height: MediaQuery.of(context)
              .size
              .height, // height of the body TODO: improve
          padding: const EdgeInsets.only(top: 24, left: 24, right: 24),
          child: Column(
            children: <Widget>[
              Row(children: [
                IconButton(
                  icon: const Icon(Icons.arrow_forward_ios_rounded),
                  padding: null,
                  onPressed: () {
                    // close the container
                    setState(() {
                      widget.isTaskListVisible = false;
                    });
                    widget.onClosing();
                  },
                )
              ]),
              const SizedBox(height: 16),
              const TimeSlotDrawerList(),
            ],
          ),
        ),
      ),
    );
  }
}



// class DraggingTile extends StatelessWidget {
//   final GlobalKey dragKey;
//   final DrawerTile drawerTile;
//   const DraggingTile(
//       {super.key, required this.dragKey, required this.drawerTile});

//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }
