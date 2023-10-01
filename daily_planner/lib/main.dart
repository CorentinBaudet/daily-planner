import 'package:daily_planner/features/task/domain/repositories/task_base_repository.dart';
import 'package:daily_planner/features/task/domain/repositories/task_local_storage_repository.dart';
import 'package:daily_planner/features/task/presentation/cubit/task_cubit.dart';
import 'package:daily_planner/features/task/presentation/pages/task_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Hive.openBox('my_tasks');

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
  //repository: RepositoryProvider.of<TaskFakeRepository>(context)
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<TaskBaseRepository>(
      create: (context) => TaskLocalStorageRepository(),
      child: BlocProvider(
        create: (context) => TasksCubit(
          repository: context.read<TaskBaseRepository>(),
        ),
        child: const MaterialApp(title: 'Morning', home: TaskList()
            // Scaffold(
            //   body: Center(
            //     child: TaskList(),
            ),
      ),
    );
    // ),
    // );
  }
}
