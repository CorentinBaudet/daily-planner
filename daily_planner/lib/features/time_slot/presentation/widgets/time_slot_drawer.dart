import 'package:daily_planner/features/task/domain/entities/task_entity.dart';
import 'package:daily_planner/features/task/domain/usecases/task_usecases.dart';
import 'package:daily_planner/features/task/presentation/cubit/task_cubit.dart'
    as task_cubit;
import 'package:daily_planner/features/time_slot/domain/entities/time_slot_entity.dart';
import 'package:daily_planner/features/time_slot/presentation/cubit/time_slot_cubit.dart'
    as time_slot_cubit;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: must_be_immutable
class TimeSlotDrawer extends StatefulWidget {
  bool isTaskListVisible = false;
  final VoidCallback onClosing;

  TimeSlotDrawer(
      {super.key, required this.isTaskListVisible, required this.onClosing});

  @override
  State<TimeSlotDrawer> createState() => _TimeSlotDrawerState();
}

class _TimeSlotDrawerState extends State<TimeSlotDrawer> {
  Widget _buildTaskList(BuildContext context, List<Task> tasks) {
    tasks = TaskUseCases().sortTasks(tasks);

    return tasks.isEmpty
        ? const Center(child: Text("no tasks yet"))
        : Flexible(
            fit: FlexFit.tight,
            child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              itemCount: tasks.length,
              itemBuilder: (BuildContext context, int index) {
                return DrawerTile(task: tasks[index]);
              },
              separatorBuilder: (context, index) => const SizedBox(height: 8),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Visibility(
        visible: widget.isTaskListVisible,
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: 175,
          ),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(32.0),
              bottomLeft: Radius.circular(32.0),
            ),
            color: Colors.grey.shade100,
          ),
          height: MediaQuery.of(context)
              .size
              .height, // height of the body TODO: improve
          padding: const EdgeInsets.only(top: 24, left: 24, right: 24),
          child: Column(
            children: <Widget>[
              Row(children: [
                IconButton(
                  icon: const Icon(Icons.arrow_forward_ios_rounded),
                  padding: null,
                  onPressed: () {
                    // close the container
                    setState(() {
                      widget.isTaskListVisible = false;
                    });
                    widget.onClosing();
                  },
                )
              ]),
              const SizedBox(height: 16),
              BlocBuilder<task_cubit.TasksCubit, task_cubit.TasksState>(
                builder: (context, state) {
                  if (state is task_cubit.InitialState) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is task_cubit.LoadingState) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is task_cubit.LoadedState) {
                    return Container(
                        child: _buildTaskList(context, state.tasks));
                  } else if (state is task_cubit.ErrorState) {
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
        ),
      ),
    );
  }
}

class DrawerTile extends StatelessWidget {
  final Task task;

  const DrawerTile({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<time_slot_cubit.TimeSlotCubit>().createTimeSlot(TimeSlot(
            startTime: TaskUseCases().troncateCreationTime(DateTime(
                    DateTime.now().year,
                    DateTime.now().month,
                    DateTime.now().day,
                    14)
                .add(const Duration(days: 1))),
            duration: 60,
            content: task,
            createdAt: TaskUseCases().troncateCreationTime(DateTime.now())));

        // remove the task from the list
        // TODO
      },
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 0.5),
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
        child: ListTile(
          title: Text(task.name, style: const TextStyle(fontSize: 14)),
          trailing: task.priority == Priority.high
              ? const Padding(
                  padding: EdgeInsets.all(0.0),
                  child: Text(
                    '!',
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                )
              : null,
        ),
      ),
    );

    // LongPressDraggable<Task>(
    //   data: task,
    //   dragAnchorStrategy: pointerDragAnchorStrategy,
    //   feedback: DraggingTile(dragKey: GlobalKey(), drawerTile: this),
    //   child: Container(
    //     height: 56,
    //     decoration: BoxDecoration(
    //       border: Border.all(color: Colors.black, width: 0.5),
    //       borderRadius: const BorderRadius.all(Radius.circular(8)),
    //     ),
    //     child: ListTile(
    //       title: Text(task.name, style: const TextStyle(fontSize: 14)),
    //       trailing: task.priority == Priority.high
    //           ? const Padding(
    //               padding: EdgeInsets.all(0.0),
    //               child: Text(
    //                 '!',
    //                 style: TextStyle(
    //                     color: Colors.red,
    //                     fontSize: 16,
    //                     fontWeight: FontWeight.bold),
    //               ),
    //             )
    //           : null,
    //     ),
    //   ),
    // );
  }
}

// class DraggingTile extends StatelessWidget {
//   final GlobalKey dragKey;
//   final DrawerTile drawerTile;
//   const DraggingTile(
//       {super.key, required this.dragKey, required this.drawerTile});

//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }
