import 'package:daily_planner/features/task/domain/repositories/task_base_repository.dart';
import 'package:daily_planner/features/task/presentation/pages/task_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<TaskBaseRepository>(
          create: (context) => TaskFakeRepository(),
        ),
        // RepositoryProvider<RepositoryB>(
        //   create: (context) => RepositoryB(),
        // ),
        // RepositoryProvider<RepositoryC>(
        //   create: (context) => RepositoryC(),
        // ),
      ],
      child: const MaterialApp(
        home: Scaffold(
          body: Center(
            child: TaskList(),
            // Text('Hello World!'),
          ),
        ),
      ),
    );
  }
}
