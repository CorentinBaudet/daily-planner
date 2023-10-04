import 'package:daily_planner/features/task/domain/entities/task_entity.dart';
import 'package:daily_planner/features/task/presentation/cubit/task_cubit.dart';
import 'package:daily_planner/features/task/presentation/widgets/task_floating_add_button.dart';
import 'package:daily_planner/features/task/presentation/widgets/task_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: must_be_immutable
class TaskList extends StatelessWidget {
  final _isDeleteModeOn = ValueNotifier<bool>(false);
  var selectedTasks = List<Task>.empty(growable: true);

  TaskList({super.key});

  Widget _buildTaskList(BuildContext context, List<Task> tasks) {
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
                  onSelected: (task) => _handleSelectedTask(task),
                );
              },
            ),
          );
  }

  _toggleDeleteMode(BuildContext context) {
    _isDeleteModeOn.value = !_isDeleteModeOn.value;
    context.read<TasksCubit>().getAllTasks();
  }

  _handleSelectedTask(Task task) {
    if (selectedTasks.contains(task)) {
      selectedTasks.remove(task);
    } else {
      selectedTasks.add(task);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  ValueListenableBuilder<bool>(
                      valueListenable: _isDeleteModeOn,
                      builder: (context, value, child) {
                        return Visibility(
                          visible: _isDeleteModeOn.value,
                          child: IconButton(
                              iconSize: 20,
                              onPressed: () {
                                for (var task in selectedTasks) {
                                  context.read<TasksCubit>().deleteTask(task);
                                }
                                selectedTasks.clear();
                                _toggleDeleteMode(context);
                              },
                              icon: const Icon(Icons.delete_rounded)),
                        );
                      })
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
                  return Container(child: _buildTaskList(context, state.tasks));
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
