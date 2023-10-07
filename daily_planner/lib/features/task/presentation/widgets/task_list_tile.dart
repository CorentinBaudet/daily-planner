import 'package:daily_planner/features/task/domain/entities/task_entity.dart';
import 'package:daily_planner/features/task/presentation/cubit/task_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TaskListTile extends StatefulWidget {
  final Task task;
  final VoidCallback onChecked; // callback for task check snackbar
  final VoidCallback onLongPress; // callback for delete
  final bool isDeleteModeOn;
  final void Function(Task) onSelected;

  const TaskListTile({
    super.key,
    required this.task,
    required this.onChecked,
    required this.onLongPress,
    required this.isDeleteModeOn,
    required this.onSelected,
  });

  @override
  State<TaskListTile> createState() => _TaskListTileState();
}

class _TaskListTileState extends State<TaskListTile> {
  bool isSelected = false;

  onChecked(BuildContext context, bool? value) {
    widget.task.isDone = value!;
    context.read<TasksCubit>().updateTask(widget.task);

    widget.onChecked();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // activate delete mode on long press and select the task
      onLongPress: () {
        setState(() {
          isSelected = !isSelected;
        });
        widget.onLongPress();
        widget.onSelected(widget.task);
      },
      // if delete mode is on, then tap to select a task
      onTap: () {
        if (widget.isDeleteModeOn) {
          setState(() {
            isSelected = !isSelected;
          });
          widget.onSelected(widget.task);
        }
      },
      child: ListTile(
        tileColor: widget.isDeleteModeOn
            ? (isSelected ? Colors.grey[300] : Colors.transparent)
            : () {
                isSelected = false;
                return Colors.transparent;
              }(),
        title: Text(widget.task.name),
        leading: Checkbox.adaptive(
            value: widget.task.isDone,
            shape: const CircleBorder(),
            onChanged: (bool? value) {
              onChecked(context, value);
            }),
        horizontalTitleGap: 4,
        trailing: widget.task.priority == Priority.high
            ? const Text(
                '!',
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              )
            : null,
      ),
    );
  }
}
