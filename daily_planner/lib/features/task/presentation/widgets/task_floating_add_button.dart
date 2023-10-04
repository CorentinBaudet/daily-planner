import 'package:daily_planner/features/task/presentation/widgets/task_add_dialog.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TaskFloatingAddButton extends StatelessWidget {
  const TaskFloatingAddButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      // open dialog to add a new task
      onPressed: () =>
          showDialog(context: context, builder: (_) => const TaskAddDialog()),
      child: const Icon(Icons.add),
    );
  }
}
