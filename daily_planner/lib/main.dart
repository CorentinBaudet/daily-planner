import 'package:daily_planner/features/counter/presentation/cubit/counter_cubit.dart';
import 'package:daily_planner/features/counter/presentation/pages/counter_page.dart';
import 'package:daily_planner/features/task/domain/repositories/task_base_repository.dart';
import 'package:daily_planner/features/task/presentation/cubit/task_cubit.dart';
import 'package:daily_planner/features/task/presentation/pages/task_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  // @override
  // Widget build(BuildContext context) {
  //   return RepositoryProvider<TaskBaseRepository>(
  //     create: (context) => TaskFakeRepository(),
  //     child: BlocProvider(
  //       create: (context) => TasksCubit(
  //           repository: RepositoryProvider.of<TaskFakeRepository>(context)),
  //       child: const MaterialApp(
  //         home: Scaffold(
  //           body: Center(
  //             child: TaskList(),
  //             // Text('Hello World!'),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<TaskBaseRepository>(
      create: (context) => TaskFakeRepository(),
      lazy: false,
      child: BlocProvider(
        create: (context) => TasksCubit(
            repository: RepositoryProvider.of<TaskFakeRepository>(context)),
        child: const MaterialApp(
          home: Scaffold(
            body: Center(
              child: TaskList(),
              // Text('Hello World!'),
            ),
          ),
        ),
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return BlocProvider(
  //     create: ((context) => CounterCubit()),
  //     child: const MaterialApp(
  //       home: Scaffold(
  //         body: Center(
  //           child: CounterPage(),
  //           // Text('Hello World!'),
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
