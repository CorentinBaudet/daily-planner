import 'package:daily_planner/features/task/domain/entities/task_entity.dart';
import 'package:daily_planner/features/task/domain/usecases/task_usecases.dart';
import 'package:daily_planner/features/task/presentation/cubit/task_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TimeSlotBottomDrawer extends StatelessWidget {
  const TimeSlotBottomDrawer({super.key});

  Widget _buildTaskList(BuildContext context, List<Task> tasks) {
    tasks = TaskUseCases().sortTasks(tasks);

    return tasks.isEmpty
        ? Center(child: const Text("no tasks yet"))
        : Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (BuildContext context, int index) {
                return Text(tasks[index].name);
                // TaskListTile(
                //   task: tasks[index],
                //   onChecked: () => _handleCheckedTask(context, tasks[index]),
                //   onLongPress: (() => _toggleDeleteMode(context)),
                //   isDeleteModeOn: _isDeleteModeOn.value,
                //   onSelected: (task) =>
                //       _handleSelectedTask(context, task, selectedTasks),
                // );
              },
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(32.0),
          topRight: Radius.circular(32.0),
        ),
        color: Colors.blue.shade200,
      ),
      child: Column(
        // mainAxisSize: MainAxisSize.min,
        // crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          // Container(
          //   height: 36,
          // ),

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

          // SizedBox(
          //     height: (56 * 6).toDouble(),
          //     child: Container(
          //         decoration: const BoxDecoration(
          //           borderRadius: BorderRadius.only(
          //             topLeft: Radius.circular(16.0),
          //             topRight: Radius.circular(16.0),
          //           ),
          //           // color: Color(0xff344955),
          //         ),
          //         child: Stack(
          //           alignment: const Alignment(0, 0),
          //           // overflow: Overflow.visible,
          //           children: <Widget>[
          //             Positioned(
          //               top: -36,
          //               child: Container(
          //                 decoration: BoxDecoration(
          //                     borderRadius:
          //                         const BorderRadius.all(Radius.circular(50)),
          //                     border: Border.all(
          //                         color: Color(0xff232f34), width: 10)),
          //               ),
          //             ),
          //             Positioned(
          //               child: ListView(
          //                 physics: const NeverScrollableScrollPhysics(),
          //                 children: const <Widget>[Text("test")],
          //               ),
          //             )
          //           ],
          //         ))),
          // Container(
          //   height: 56,
          //   color: const Color(0xff4a6572),
          // )
        ],
      ),
    );
  }
}
