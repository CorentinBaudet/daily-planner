import 'package:daily_planner/features/task/domain/entities/task_entity.dart';
import 'package:daily_planner/features/task/presentation/bloc/task_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TaskList extends StatelessWidget {
  // final List<Task> tasks;

  // TaskList({required this.tasks});
  const TaskList({super.key});

  Widget _buildTaskList(List<Task> tasks) {
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text(tasks[index].name),
          subtitle: Text(tasks[index].priority.toString()),
          trailing: Checkbox(
            value: true,
            onChanged: (bool? value) {},
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TasksCubit, TasksState>(
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
          return _buildTaskList(state.tasks);
        } else if (state is ErrorState) {
          return const Center(
            child: Text('Error'),
          );
        } else {
          return const Center(
            child: Text('Unknown State'),
          );
        }
      },
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
