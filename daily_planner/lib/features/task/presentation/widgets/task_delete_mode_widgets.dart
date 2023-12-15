import 'package:daily_planner/features/task/domain/entities/task_entity.dart';
import 'package:daily_planner/features/task/presentation/widgets/task_delete_confirmation_dialog.dart';
import 'package:daily_planner/features/time_slot/presentation/cubit/time_slot_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TaskDeleteModeWidgets extends StatefulWidget {
  final bool isDeleteModeOn;
  final List<Task> selectedTasks;
  final int selectedTasksNb;
  final void Function(BuildContext context) toggleDeleteMode;

  const TaskDeleteModeWidgets(
      {super.key,
      required this.isDeleteModeOn,
      required this.selectedTasks,
      required this.selectedTasksNb,
      required this.toggleDeleteMode});

  @override
  State<TaskDeleteModeWidgets> createState() => _TaskDeleteModeWidgetsState();
}

class _TaskDeleteModeWidgetsState extends State<TaskDeleteModeWidgets> {
  _deleteButton(BuildContext context, List<Task> selectedTasks) {
    return IconButton(
        icon: const Icon(Icons.delete_rounded),
        iconSize: 20,
        onPressed: () async {
          bool result = await showDialog(
              context: context,
              builder: (BuildContext context) {
                return TaskDeleteConfirmationDialog(
                  selectedTasks: selectedTasks,
                );
              });

          if (!result) return;
          if (!context.mounted) {
            return; // to avoid calling context on widget off the tree (here because of the async gap created by the dialog)
          }

          for (var task in selectedTasks) {
            context.read<TimeSlotCubit>().deleteTimeSlot(task.id as int);
          }
          widget.toggleDeleteMode(context);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              duration: Duration(seconds: 3),
              content: Text('deleted'),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.isDeleteModeOn,
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.close_rounded),
            iconSize: 18,
            onPressed: () {
              widget.toggleDeleteMode(context);
            },
          ),
          const SizedBox(width: 8),
          Text(widget.selectedTasksNb.toString(),
              style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 8),
          _deleteButton(context, widget.selectedTasks),
        ],
      ),
    );
  }
}
