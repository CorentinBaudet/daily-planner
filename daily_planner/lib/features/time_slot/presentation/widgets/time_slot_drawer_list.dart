import 'package:daily_planner/features/task/domain/entities/task_entity.dart';
import 'package:daily_planner/features/task/domain/usecases/task_usecases.dart';
import 'package:daily_planner/features/task/presentation/cubit/task_cubit.dart';
import 'package:daily_planner/features/time_slot/presentation/widgets/time_slot_drawer_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TimeSlotDrawerList extends StatelessWidget {
  const TimeSlotDrawerList({super.key});

  Widget _buildTaskList(BuildContext context, List<Task> tasks) {
    tasks = TaskUseCases().getUnplannedTasks(tasks);
    tasks = TaskUseCases().sortTasks(tasks);

    return tasks.isEmpty
        ? const Center(
            child: Text("no tasks left",
                style: TextStyle(fontStyle: FontStyle.italic)))
        : ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: tasks.length,
            itemBuilder: (BuildContext context, int index) {
              return TimeSlotDrawerListTile(task: tasks[index]);
            },
          );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskCubit, TaskState>(
      builder: (context, state) {
        if (state is InitialState) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is LoadingState) {
          return const Padding(
            padding: EdgeInsets.only(top: 24),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state is LoadedState) {
          // we need expanded to indicate that the _buildTaskList should take the remaining space
          return Expanded(child: _buildTaskList(context, state.tasks));
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
    );
  }
}
