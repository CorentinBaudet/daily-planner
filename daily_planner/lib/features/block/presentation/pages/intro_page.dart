import 'package:daily_planner/app.dart';
import 'package:daily_planner/features/block/presentation/widgets/intro_sleep_step.dart';
import 'package:daily_planner/features/block/presentation/widgets/intro_start_step.dart';
import 'package:daily_planner/features/block/presentation/widgets/intro_work_step.dart';
import 'package:daily_planner/features/task/domain/entities/priority_entity.dart';
import 'package:daily_planner/features/task/domain/entities/task_entity.dart';
import 'package:daily_planner/features/block/domain/entities/block_entity.dart';
import 'package:daily_planner/features/block/domain/entities/work_block_entity.dart';
import 'package:daily_planner/features/time_slot/domain/usecases/time_slot_usecases.dart';
import 'package:daily_planner/features/time_slot/presentation/cubit/time_slot_cubit.dart';
import 'package:daily_planner/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:im_stepper/stepper.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({Key? key}) : super(key: key);

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  int activeStep = 0; // Initial step set to 5.
  int upperBound = 2; // upperBound MUST BE total number of icons minus 1.

  Block sleepBlock = Block(
      startTime: DateTime(DateTime.now().year, DateTime.now().month,
              DateTime.now().day, 23, 0)
          .troncateDateTime(),
      endTime: DateTime(DateTime.now().year, DateTime.now().month,
              DateTime.now().day, 8, 0)
          .troncateDateTime(),
      subject: 'sleep 💤');

  WorkBlock workBlock = WorkBlock(
    startTime: DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day, 9, 0)
        .troncateDateTime(),
    endTime: DateTime(DateTime.now().year, DateTime.now().month,
            DateTime.now().day, 10, 30)
        .troncateDateTime(),
    subject: 'deep work 🧠',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      // backgroundColor: const Color(0xFFe8e9eb),
      backgroundColor: const Color(0xFFEAE0D5),
      // appBar: AppBar(
      //   backgroundColor: Theme.of(context).primaryColor,
      //   automaticallyImplyLeading: false,
      //   title: const Text(
      //     'Welcome 👋',
      //     style: TextStyle(
      //       fontFamily: 'Outfit',
      //       color: Colors.white,
      //       fontSize: 22,
      //     ),
      //   ),
      //   centerTitle: false,
      //   elevation: 2,
      // ),
      body: Column(
        children: [
          // header(),

          // pages content
          Expanded(
            flex: 8,
            child: () {
              switch (activeStep) {
                case 0:
                  return const IntroStartStep();
                case 1:
                  return IntroSleepStep(sleepTimeSlot: sleepBlock);
                case 2:
                  return IntroWorkStep(workTimeSlot: workBlock);
                default:
                  return const IntroStartStep();
              }
            }(),
          ),

          // footer with navigation buttons
          Expanded(
            flex: 2,
            child: Column(
              children: [
                DotStepper(
                  dotCount: 3,
                  dotRadius: 6,
                  spacing: 8,
                  indicatorDecoration: IndicatorDecoration(
                    color: Theme.of(context).primaryColor,
                    strokeColor: Theme.of(context).primaryColor,
                  ),
                  // activeStep property set to activeStep variable defined above.
                  activeStep: activeStep,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 48.0),
                  child: activeStep == 0
                      ? nextButton()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            previousButton(),
                            activeStep == upperBound
                                ? finishButton()
                                : nextButton(),
                          ],
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Returns the previous button.
  Widget previousButton() {
    return ElevatedButton(
      style: ButtonStyle(
        fixedSize: MaterialStateProperty.all(const Size(120, 44)),
        elevation: MaterialStateProperty.all(2),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
        ),
      ),
      child: const Text('prev',
          style: TextStyle(fontFamily: 'Readex Pro', fontSize: 16)),
      onPressed: () {
        // Decrement activeStep, when the previous button is tapped. However, check for lower bound i.e., must be greater than 0.
        if (activeStep > 0) {
          setState(() {
            activeStep--;
          });
        }
      },
    );
  }

  /// Returns the next button.
  Widget nextButton() {
    return ElevatedButton(
      style: ButtonStyle(
        fixedSize: MaterialStateProperty.all(const Size(120, 44)),
        elevation: MaterialStateProperty.all(2),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
        ),
        backgroundColor: MaterialStateColor.resolveWith(
            (states) => Theme.of(context).primaryColor),
      ),
      child: const Icon(
        Icons.arrow_forward_rounded,
        size: 28,
        color: Colors.white,
      ),
      onPressed: () {
        // TODO ? check if the sleep time slot is valid

        // Increment activeStep, when the next button is tapped. However, check for upper bound.
        if (activeStep < upperBound) {
          setState(() {
            activeStep++;
          });
        }
      },
    );
  }

  Widget finishButton() {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateColor.resolveWith(
            (states) => Theme.of(context).primaryColor),
        foregroundColor: const MaterialStatePropertyAll(Colors.white),
        fixedSize: MaterialStateProperty.all(const Size(120, 44)),
        elevation: MaterialStateProperty.all(2),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
        ),
      ),
      child: const Text('finish',
          style: TextStyle(fontFamily: 'Readex Pro', fontSize: 16)),
      onPressed: () {
        // create the sleep and deep work time slots
        _createDefaultData();

        // navigate to Home widget
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const Home(),
          ),
        );
      },
    );
  }

  _createDefaultData() async {
    // check if the work time slot is valid
    if (!TimeSlotUseCases.isValidTimeSlot(workBlock)) {
      // show error message with snack bar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'invalid time slot',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.red.shade300),
          ),
        ),
      );
      return;
    }

    // create the sleep time slot
    context.read<TimeSlotCubit>().createTimeSlot(sleepBlock);

    // create the default task
    context.read<TimeSlotCubit>().createTimeSlot(Task.unplanned(
          subject: 'setup your everyday blocks 🔧',
          priority: Priority.normal,
        ));
    // if (!context.mounted) {
    //   return; // to avoid using build context across asynchronous gap
    // }

    // create the deep work time slot
    // (workTimeSlot.event as WorkBlock).taskId = id;
    context.read<TimeSlotCubit>().createTimeSlot(workBlock);
  }
}

  /// Returns the header wrapping the header text.
  // Widget header() {
  //   return Container(
  //     decoration: BoxDecoration(
  //       color: Colors.orange,
  //       borderRadius: BorderRadius.circular(5),
  //     ),
  //     child: Row(
  //       children: [
  //         Padding(
  //           padding: const EdgeInsets.all(8.0),
  //           child: Text(
  //             headerText(),
  //             style: TextStyle(
  //               color: Colors.black,
  //               fontSize: 20,
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Returns the header text based on the activeStep.
  // String headerText() {
  //   switch (activeStep) {
  //     case 1:
  //       return 'Welcome';

  //     case 2:
  //       return 'Focus';

  //     case 3:
  //       return 'Sleep';

  //     default:
  //       return 'Welcome';
  //   }
  // }

