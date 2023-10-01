import 'package:daily_planner/features/task/domain/entities/task_entity.dart';
import 'package:daily_planner/features/task/presentation/cubit/task_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TaskList extends StatelessWidget {
  const TaskList({super.key});

  Widget _buildTaskList(List<Task> tasks) {
    return tasks.isEmpty
        ? const Text("No tasks yet")
        : ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(tasks[index].name),
                subtitle: Text(tasks[index].priority.toString()),
                // trailing: Checkbox(
                //   value: true,
                //   onChanged: (bool? value) {},
                // ),
              );
            },
          );
  }

  _showAddTaskDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Add Task'),
            content: const TextField(
              decoration: InputDecoration(hintText: 'task name'),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  // add task
                  context.read<TasksCubit>().createTask(
                      Task(name: 'New Task4', priority: Priority.normal));

                  Navigator.of(context).pop();
                },
                child: const Text('Add'),
              ),
              TextButton(
                onPressed: () {
                  // close the dialog
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BlocBuilder<TasksCubit, TasksState>(
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
              return Container(child: _buildTaskList(state.tasks));
            } else if (state is ErrorState) {
              return const Center(
                child: Text('Error loading tasks'),
              );
            } else {
              return const Center(
                child: Text('Unknown State'),
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskDialog(context),
        child: const Icon(Icons.add),
      ),
    );

    // return ListView.builder(
    //   itemCount: tasks.length,
    //   itemBuilder: (BuildContext context, int index) {
    //     return ListTile(
    //       title: Text(tasks[index].name),
    //       subtitle: Text(tasks[index].priority.toString()),
    //       trailing: Checkbox(
    //         value: true,
    //         onChanged: (bool? value) {
    //           // TODO: Implement task completion logic
    //         },
    //       ),
    //     );
    //   },
    // );
  }
}
