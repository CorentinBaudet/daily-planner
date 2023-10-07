import 'package:daily_planner/features/task/presentation/pages/task_page.dart';
import 'package:flutter/material.dart';

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
          const Center(child: Text('Plan tomorrow')),
          TaskList(),
        ]),
      ),
    );
  }
}
