import 'package:daily_planner/app.dart';
import 'package:daily_planner/features/block/presentation/widgets/intro_start_step.dart';
import 'package:flutter/material.dart';
import 'package:im_stepper/stepper.dart';

// import 'intro_page_model.dart';
// export 'intro_page_model.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({Key? key}) : super(key: key);

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  int activeStep = 0; // Initial step set to 5.

  int upperBound = 2; // upperBound MUST BE total number of icons minus 1.

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        automaticallyImplyLeading: false,
        title: const Text(
          'Welcome 👋',
          style: TextStyle(
            fontFamily: 'Outfit',
            color: Colors.white,
            fontSize: 22,
          ),
        ),
        centerTitle: false,
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Visibility(
              visible: false,
              child: IconStepper(
                icons: const [
                  Icon(Icons.waving_hand_rounded),
                  Icon(Icons.work_rounded),
                  Icon(Icons.access_alarm),
                ],

                // activeStep property set to activeStep variable defined above.
                activeStep: activeStep,

                // This ensures step-tapping updates the activeStep.
                onStepReached: (index) {
                  setState(() {
                    activeStep = index;
                  });
                },
              ),
            ),
            // header(),
            Expanded(
              // TODO content of the steps
              child: () {
                switch (activeStep) {
                  case 0:
                    return const IntroStartStep();
                  default:
                    return const Text('TODO');
                }
              }(),
            ),
            activeStep == 0
                ? nextButton()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      previousButton(),
                      activeStep == upperBound ? finishButton() : nextButton(),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  /// Returns the next button.
  Widget nextButton() {
    return ElevatedButton(
      onPressed: () {
        // Increment activeStep, when the next button is tapped. However, check for upper bound.
        if (activeStep < upperBound) {
          setState(() {
            activeStep++;
          });
        }
      },
      child: const Text('next'),
    );
  }

  /// Returns the previous button.
  Widget previousButton() {
    return ElevatedButton(
      onPressed: () {
        // Decrement activeStep, when the previous button is tapped. However, check for lower bound i.e., must be greater than 0.
        if (activeStep > 0) {
          setState(() {
            activeStep--;
          });
        }
      },
      child: const Text('prev'),
    );
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

  Widget finishButton() {
    return ElevatedButton(
      onPressed: () {
        // navigate to Home widget
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const Home(),
          ),
        );
      },
      child: const Text('finish'),
    );
  }
}
