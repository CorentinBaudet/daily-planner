import 'package:daily_planner/constants/theme.dart';
import 'package:daily_planner/features/block/presentation/pages/block_page.dart';
import 'package:daily_planner/features/block/presentation/pages/intro_page.dart';
import 'package:daily_planner/features/time_slot/presentation/cubit/time_slot_cubit.dart';
import 'package:daily_planner/features/time_slot/presentation/pages/time_slot_today_page.dart';
import 'package:daily_planner/features/task/presentation/pages/task_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App extends StatelessWidget {
  const App({super.key});

  // TODO improve this : can't base the result on the time slots in case the user deletes all of them
  bool isNewUser(BuildContext context) {
    if (context.read<TimeSlotCubit>().repository.getTimeSlots().isEmpty) {
      return true;
    }
    return false;
  }

// TODO define the theme
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daily Planner',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.getAppTheme(),
      home: isNewUser(context) ? const IntroPage() : const Home(),
    );
  }
}

class Home extends StatelessWidget {
  const Home({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: TabBarView(
            children: [const TimeSlotTodayPage(), TaskPage(), BlockPage()]),
        bottomNavigationBar: BottomAppBar(
          height: 60,
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
                  icon: Icon(Icons.add_task_rounded,
                      color: Theme.of(context).primaryColor)),
              Tab(
                  icon: Icon(Icons.timelapse_rounded,
                      color: Theme.of(context).primaryColor)),
            ],
          ),
        ),
      ),
    );
  }
}
