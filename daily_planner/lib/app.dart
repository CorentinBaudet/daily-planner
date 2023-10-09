import 'package:daily_planner/features/time_slot/domain/repositories/time_slot_base_repository.dart';
import 'package:daily_planner/features/time_slot/presentation/cubit/time_slot_cubit.dart';
import 'package:daily_planner/features/time_slot/presentation/pages/time_slot_page.dart';
import 'package:daily_planner/features/task/presentation/pages/task_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 10, // TODO improve this
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.calendar_today_rounded)),
              Tab(icon: Icon(Icons.format_list_bulleted_add)),
            ],
          ),
        ),
        body: TabBarView(children: [
          RepositoryProvider<TimeSlotBaseRepository>(
            create: (context) => TimeSlotFakeRepository(),
            child: BlocProvider(
                create: (context) => TimeSlotCubit(
                    repository: context.read<TimeSlotBaseRepository>()),
                child: TimeSlotPage()),
          ),
          TaskPage(),
        ]),
      ),
    );
  }
}
