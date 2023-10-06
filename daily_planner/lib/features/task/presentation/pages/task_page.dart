import 'package:daily_planner/features/task/domain/entities/task_entity.dart';
import 'package:daily_planner/features/task/presentation/cubit/task_cubit.dart';
import 'package:daily_planner/features/task/presentation/widgets/task_delete_mode_widgets.dart';
import 'package:daily_planner/features/task/presentation/widgets/task_floating_add_button.dart';
import 'package:daily_planner/features/task/presentation/widgets/task_list_tile.dart';
import 'package:daily_planner/utils/double_value_listenable_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TaskList extends StatelessWidget {
  final _isDeleteModeOn = ValueNotifier<bool>(false);
  final _selectedTasks = List<Task>.empty(growable: true);
  final _selectedTasksNb = ValueNotifier<int>(0);

  TaskList({super.key});

  Widget _buildTaskList(
      BuildContext context, List<Task> tasks, List<Task> selectedTasks) {
    return tasks.isEmpty
        ? const Text("no tasks yet")
        : Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (BuildContext context, int index) {
                return TaskListTile(
                  task: tasks[index],
                  onLongPress: (() => _toggleDeleteMode(context)),
                  isDeleteModeOn: _isDeleteModeOn.value,
                  onSelected: (task) =>
                      _handleSelectedTask(context, task, selectedTasks),
                );
              },
            ),
          );
  }

  _toggleDeleteMode(BuildContext context) {
    _isDeleteModeOn.value = !_isDeleteModeOn.value;
    if (!_isDeleteModeOn.value) {
      _selectedTasks.clear();
    }
    context.read<TasksCubit>().getAllTasks();
  }

  _handleSelectedTask(
      BuildContext context, Task task, List<Task> selectedTasks) {
    selectedTasks.where((element) => element.id == task.id).isEmpty
        ? selectedTasks.add(task)
        : selectedTasks.remove(
            selectedTasks.firstWhere((element) => element.id == task.id));
    selectedTasks.isEmpty ? _toggleDeleteMode(context) : null;

    // to update the number of selected tasks for the delete mode widgets
    _selectedTasksNb.value = selectedTasks.length;
  }

  @override
  Widget build(BuildContext context) {
    // var selectedTasks = <Task>[];

    return Scaffold(
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'all tasks',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  DoubleValueListenableBuilder(
                    first: _isDeleteModeOn,
                    second: _selectedTasksNb,
                    builder: (context, first, second, child) =>
                        TaskDeleteModeWidgets(
                            isDeleteModeOn: first,
                            selectedTasks: _selectedTasks,
                            selectedTasksNb: second,
                            toggleDeleteMode: _toggleDeleteMode),
                  )
                ],
              ),
            ),
            BlocBuilder<TasksCubit, TasksState>(
              builder: (context, state) {
                if (state is InitialState) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is LoadingState) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is LoadedState) {
                  return Container(
                      child:
                          _buildTaskList(context, state.tasks, _selectedTasks));
                } else if (state is ErrorState) {
                  return const Center(
                    child: Text('error loading tasks'),
                  );
                } else {
                  return const Center(
                    child: Text('unknown error'),
                  );
                }
              },
            ),
          ],
        ),
        floatingActionButton: const TaskFloatingAddButton());
  }
}
