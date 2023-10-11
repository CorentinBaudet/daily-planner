import 'package:daily_planner/features/time_slot/domain/repositories/time_slot_base_repository.dart';
import 'package:daily_planner/features/time_slot/presentation/cubit/time_slot_cubit.dart';
import 'package:daily_planner/features/time_slot/presentation/pages/time_slot_today_page.dart';
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
          backgroundColor: Theme.of(context).primaryColor,
          title: const Text('today'),
        ),
        body: TabBarView(children: [
          RepositoryProvider<TimeSlotBaseRepository>(
            create: (context) => TimeSlotFakeRepository(),
            child: BlocProvider(
                create: (context) => TimeSlotCubit(
                    repository: context.read<TimeSlotBaseRepository>()),
                child: TimeSlotTodayPage()),
          ),
          TaskPage(),
        ]),
        bottomNavigationBar: BottomAppBar(
          child: TabBar(
            isScrollable: false,
            physics: const NeverScrollableScrollPhysics(),
            tabs: [
              Tab(
                  icon: Icon(
                Icons.calendar_today_rounded,
                color: Theme.of(context).primaryColor,
              )),
              Tab(
                  icon: Icon(Icons.format_list_bulleted_add,
                      color: Theme.of(context).primaryColor)),
            ],
          ),
        ),
      ),
    );
  }
}
