import 'package:daily_planner/features/task/domain/entities/task_entity.dart';
import 'package:flutter/material.dart';

class TaskListTile extends StatefulWidget {
  final Task task;
  final VoidCallback onLongPress; // callback for delete
  final bool isDeleteModeOn;
  final void Function(Task) onSelected;

  const TaskListTile({
    super.key,
    required this.task,
    required this.onLongPress,
    required this.isDeleteModeOn,
    required this.onSelected,
  });

  @override
  State<TaskListTile> createState() => _TaskListTileState();
}

class _TaskListTileState extends State<TaskListTile> {
  bool isTicked = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // activate delete mode on long press and select the task
      onLongPress: () {
        setState(() {
          isTicked = !isTicked;
        });
        widget.onLongPress();
        widget.onSelected(widget.task);
      },
      // if delete mode is on, then tap to select a task
      onTap: () {
        if (widget.isDeleteModeOn) {
          setState(() {
            isTicked = !isTicked;
          });
          widget.onSelected(widget.task);
        }
      },
      child: ListTile(
        tileColor: widget.isDeleteModeOn
            ? (isTicked ? Colors.grey[300] : Colors.transparent)
            : () {
                isTicked = false;
                return Colors.transparent;
              }(),
        title: Text(widget.task.name),
        subtitle: Text(widget.task.priority.toString()),
        // trailing: Visibility(
        //   visible: widget.isDeleteModeOn,
        //   child: Checkbox(
        //     value: isTicked,
        //     onChanged: (bool? value) {
        //       setState(() {
        //         isTicked = value!;
        //       });
        //       widget.onSelected(widget.task);
        //     },
        //   ),
        // ),
      ),
    );
  }
}
