import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:daily_planner/features/time_slot/presentation/widgets/time_slot_drawer.dart';
import 'package:daily_planner/features/time_slot/presentation/widgets/time_slot_tomorrow_planning.dart';
import 'package:daily_planner/features/time_slot/presentation/cubit/time_slot_cubit.dart';

class TimeSlotTomorrowPage extends StatelessWidget {
  TimeSlotTomorrowPage({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final _isTaskListVisible = ValueNotifier<bool>(false);

  // switch back _isTaskListVisible to false when the drawer is closed
  void drawerClosingCallBack() {
    _isTaskListVisible.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: const Text('tomorrow'),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: BlocBuilder<TimeSlotCubit, TimeSlotState>(
                  builder: (context, state) {
                if (state is InitialState) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is LoadingState) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is LoadedState) {
                  return Column(
                    children: [
                      TimeSlotTomorrowPlanning(
                          context: context, timeSlots: state.timeSlots),
                    ],
                  );
                } else if (state is ErrorState) {
                  return const Center(
                    child: Text('error loading planning'),
                  );
                } else {
                  return const Center(
                    child: Text('unknown error'),
                  );
                }
              }),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
            heroTag: 'show_task_list',
            child: const Icon(Icons.edit_rounded),
            onPressed: () {
              _isTaskListVisible.value = !_isTaskListVisible.value;
            }),
      ),
      // TODO : open the drawer automatically when the page is loaded (with a tiny delay)
      // TODO : make the drawer takes the height of the calendar
      Positioned(
          right: 0,
          child: ValueListenableBuilder(
            valueListenable: _isTaskListVisible,
            builder: (context, value, child) {
              return value
                  ? Animate(
                      effects: const [
                        // animate a slide in effect
                        SlideEffect(
                          // set a curve and duration for the animation
                          curve: Curves.ease,
                          duration: Duration(milliseconds: 200),
                          // set begin offset to slide in from the right
                          begin: Offset(1, 0),
                          // set end offset to default to 0,0
                          end: Offset.zero,
                        ),
                      ],
                      child: TimeSlotDrawer(
                          isTaskListVisible: value,
                          onClosing: drawerClosingCallBack),
                    )
                  : const SizedBox();
            },
          )),
    ]);
  }
}
