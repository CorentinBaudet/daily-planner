import 'package:daily_planner/constants/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:daily_planner/features/task/domain/entities/task_entity.dart';
import 'package:daily_planner/features/task/presentation/cubit/task_cubit.dart';
import 'package:flutter_switch/flutter_switch.dart';

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
    final formKey = GlobalKey<FormState>();

    Widget prioritySwitch = FlutterSwitch(
      width: 110.0,
      height: 35.0,
      valueFontSize: 15.0,
      toggleSize: 25.0,
      value: isHighPriority,
      padding: 6.0,
      showOnOff: true,
      inactiveText: 'normal',
      activeText: 'important',
      onToggle: (val) {
        setState(() {
          isHighPriority = val;
        });
      },
    );

    return AlertDialog(
      title: const Text('new task'),
      insetPadding: const EdgeInsets.all(0),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.55,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Form(
              key: formKey,
              child: TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: const InputDecoration(hintText: 'task name'),
                controller: taskNameController,
                autofocus: true,
                maxLines: 2,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'task name cannot be empty';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 30),
            prioritySwitch,
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            // close the dialog
            Navigator.of(context).pop();
          },
          child: const Text('cancel'),
        ),
        TextButton(
          style: ButtonStyle(
              foregroundColor: MaterialStateColor.resolveWith(
                  (Set<MaterialState> states) => Colors.white),
              backgroundColor: MaterialStateProperty.all(
                  Theme.of(context).colorScheme.primary)),
          onPressed: () {
            // use the TextFormField to validate the task name
            if (!formKey.currentState!.validate()) {
              return;
            }

            context.read<TasksCubit>().createTask(Task(
                name: taskNameController.text,
                priority: isHighPriority ? Priority.high : Priority.normal,
                createdAt: ConstantsIntl.dateTimeFormat.parse(
                    ConstantsIntl.dateTimeFormat.format(DateTime.now()))));

            Navigator.of(context).pop();
          },
          child: const Text('add'),
        ),
      ],
    );
  }
}
