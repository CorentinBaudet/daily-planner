import 'package:daily_planner/features/task/domain/entities/task_entity.dart';
import 'package:daily_planner/features/task/domain/usecases/task_usecases.dart';
import 'package:daily_planner/features/task/presentation/cubit/task_cubit.dart';
import 'package:daily_planner/features/task/presentation/widgets/task_add_dialog.dart';
import 'package:daily_planner/features/task/presentation/widgets/task_delete_mode_widgets.dart';
import 'package:daily_planner/features/task/presentation/widgets/task_list_tile.dart';
import 'package:daily_planner/utils/double_value_listenable_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TaskPage extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _isDeleteModeOn = ValueNotifier<bool>(false);
  final _selectedTasks = List<Task>.empty(growable: true);
  final _selectedTasksNb = ValueNotifier<int>(0);

  TaskPage({super.key});

  Widget _buildTaskList(
      BuildContext context, List<Task> tasks, List<Task> selectedTasks) {
    tasks = TaskUseCases().getUndoneTasks(tasks);
    tasks = TaskUseCases().sortTasks(tasks);

    return tasks.isEmpty
        ? const Center(child: Text("no tasks yet"))
        : Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (BuildContext context, int index) {
                return TaskListTile(
                  task: tasks[index],
                  onChecked: () => _handleCheckedTask(context, tasks[index]),
                  onLongPress: (() => _toggleDeleteMode(context)),
                  isDeleteModeOn: _isDeleteModeOn.value,
                  onSelected: (task) =>
                      _handleSelectedTask(context, task, selectedTasks),
                );
              },
            ),
          );
  }

  _handleCheckedTask(BuildContext context, Task task) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: const Text('task completed'),
          action: SnackBarAction(
              label: 'undo',
              onPressed: () {
                // undo task completion
                task.isDone = false;
                // and reflect the change in the UI using the scaffold key to access the context
                // because the task's widget is not in the widget tree anymore
                _scaffoldKey.currentContext
                    ?.read<TasksCubit>()
                    .updateTask(task);
              })),
    );
  }

  _toggleDeleteMode(BuildContext context) {
    _isDeleteModeOn.value = !_isDeleteModeOn.value;
    if (!_isDeleteModeOn.value) {
      _selectedTasks.clear();
    }
    context.read<TasksCubit>().getTasks();
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
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: const Text('tasks'),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
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
        floatingActionButton: FloatingActionButton(
          // open dialog to add a new task
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => const TaskAddDialog(),
            );
          },
          child: const Icon(Icons.add),
        ));
  }
}
