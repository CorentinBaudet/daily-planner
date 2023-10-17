import 'package:daily_planner/features/block/presentation/pages/block_page.dart';
import 'package:daily_planner/features/time_slot/presentation/pages/time_slot_today_page.dart';
import 'package:daily_planner/features/task/presentation/pages/task_page.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: TabBarView(children: [
          const TimeSlotTodayPage(),
          TaskPage(),
          const BlockPage()
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
