import 'package:daily_planner/features/task/presentation/widgets/task_add_dialog.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TaskFloatingActionButton extends StatefulWidget {
  bool isDeleteModeOn;
  final VoidCallback toggleDeleteMode;

  TaskFloatingActionButton(
      {super.key,
      required this.isDeleteModeOn,
      required this.toggleDeleteMode});

  @override
  State<TaskFloatingActionButton> createState() =>
      _TaskFloatingActionButtonState();
}

class _TaskFloatingActionButtonState extends State<TaskFloatingActionButton> {
  @override
  Widget build(BuildContext context) {
    return widget.isDeleteModeOn
        ? FloatingActionButton(
            onPressed: () {
              // delete selected tasks
              // context.read<TasksCubit>().deleteTasks();
              widget.toggleDeleteMode;
            },
            child: const Icon(Icons.delete),
          )
        : FloatingActionButton(
            // open dialog to add a new task
            onPressed: () => showDialog(
                context: context, builder: (_) => const TaskAddDialog()),
            child: const Icon(Icons.add),
          );
  }
}
