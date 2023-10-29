import 'package:daily_planner/app.dart';
import 'package:daily_planner/features/task/domain/repositories/task_base_repository.dart';
import 'package:daily_planner/features/task/domain/repositories/task_local_storage_repository.dart';
import 'package:daily_planner/features/task/presentation/cubit/task_cubit.dart';
import 'package:daily_planner/features/time_slot/domain/repositories/time_slot_base_repository.dart';
import 'package:daily_planner/features/time_slot/domain/repositories/time_slot_local_storage_repository.dart';
import 'package:daily_planner/features/time_slot/presentation/cubit/time_slot_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  await Hive.openBox('my_tasks');
  await Hive.openBox('my_time_slots');
  // await Hive.openBox('my_blocks');

  runApp(const MainApp());
  // TODO add tooltips to rounded buttons
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<TaskBaseRepository>(
          create: (context) => TaskLocalStorageRepository(),
        ),
        RepositoryProvider<TimeSlotBaseRepository>(
          create: (context) => TimeSlotLocalStorageRepository(),
        ),
        // RepositoryProvider<BlockBaseRepository>(
        //   create: (context) => BlockLocalStorageRepository(),
        // ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => TaskCubit(
              repository: context.read<TaskBaseRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => TimeSlotCubit(
              repository: context.read<TimeSlotBaseRepository>(),
            ),
          ),
          // BlocProvider(
          //   create: (context) => BlockCubit(
          //     repository: context.read<BlockBaseRepository>(),
          //   ),
          // )
        ],
        child: const App(),
      ),
    );
  }
}
