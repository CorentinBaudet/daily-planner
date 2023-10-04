import 'package:daily_planner/features/task/domain/entities/task_entity.dart';
import 'package:flutter/material.dart';

class TaskDeleteConfirmationDialog extends StatelessWidget {
  final List<Task> selectedTasks;
  const TaskDeleteConfirmationDialog({super.key, required this.selectedTasks});

  @override
  Widget build(BuildContext context) {
    // set up the buttons
    Widget noButton = ElevatedButton(
      child: const Text("no"),
      onPressed: () => Navigator.of(context).pop(false),
    );
    Widget yesButton = ElevatedButton(
      child: const Text("yes"),
      onPressed: () => Navigator.of(context).pop(true),
    );

    // set up the AlertDialog
    return selectedTasks.length == 1
        ? AlertDialog(
            title: Text("Delete task"),
            content: Text('Would you like to permanently delete "' +
                selectedTasks.first.name +
                '"?'),
            actions: [
              noButton,
              yesButton,
            ],
          )
        : AlertDialog(
            title: Text("Delete tasks"),
            content: Text('Would you like to permanently delete ' +
                selectedTasks.length.toString() +
                ' tasks?'),
            actions: [
              noButton,
              yesButton,
            ],
          );
  }
}
