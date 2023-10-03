import 'package:daily_planner/features/task/domain/entities/task_entity.dart';
import 'package:flutter/material.dart';

class TaskListTile extends StatefulWidget {
  final Task task;
  final bool isDeleteModeOn;
  // callback for delete
  final VoidCallback onLongPress;

  const TaskListTile({
    super.key,
    required this.task,
    required this.isDeleteModeOn,
    required this.onLongPress,
  });

  @override
  State<TaskListTile> createState() => _TaskListTileState();
}

class _TaskListTileState extends State<TaskListTile> {
  bool isTicked = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        // delete task
        widget.onLongPress();
      },
      child: ListTile(
        title: Text(widget.task.name),
        subtitle: Text(widget.task.priority.toString()),
        trailing: Visibility(
          visible: widget.isDeleteModeOn,
          child: Checkbox(
            value: isTicked,
            onChanged: (bool? value) {
              setState(() {
                isTicked = value!;
              });
            },
          ),
        ),
      ),
    );
  }
}
