import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:daily_planner/features/task/domain/entities/task_entity.dart';
import 'package:daily_planner/features/task/presentation/cubit/task_cubit.dart';

class TaskAddDialog extends StatefulWidget {
  const TaskAddDialog({super.key});

  @override
  State<TaskAddDialog> createState() => _TaskAddDialogState();
}

class _TaskAddDialogState extends State<TaskAddDialog> {
  final taskNameController = TextEditingController();
  bool isHighPriority = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('new task'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            decoration: const InputDecoration(hintText: 'task name'),
            controller: taskNameController,
            autofocus: true,
          ),
          const SizedBox(height: 10),
          Switch(
              value: isHighPriority,
              onChanged: (newValue) {
                setState(() {
                  isHighPriority = newValue;
                });
              }),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            // add task
            context.read<TasksCubit>().createTask(Task(
                name: taskNameController.text,
                priority: isHighPriority ? Priority.high : Priority.normal));

            Navigator.of(context).pop();
          },
          child: const Text('add'),
        ),
        TextButton(
          onPressed: () {
            // close the dialog
            Navigator.of(context).pop();
          },
          child: const Text('cancel'),
        ),
      ],
    );
  }
}
