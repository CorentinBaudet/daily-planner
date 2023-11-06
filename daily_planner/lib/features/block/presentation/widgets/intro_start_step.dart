import 'package:flutter/material.dart';

class IntroStartStep extends StatefulWidget {
  const IntroStartStep({Key? key}) : super(key: key);

  @override
  State<IntroStartStep> createState() => _IntroStartStepState();
}

class _IntroStartStepState extends State<IntroStartStep>
    with TickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Container(
              // decoration: const BoxDecoration(color: Color(0xFFe8e9eb)),
              decoration: const BoxDecoration(color: Color(0xFFEAE0D5)),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 8,
                    child: Container(
                      alignment: Alignment.center,
                      // decoration: const BoxDecoration(
                      //   color: Colors.transparent,
                      //   shape: BoxShape.circle,
                      // ),
                      child:
                          // const Icon(
                          //   Icons.waving_hand_rounded,
                          //   size: 128,
                          //   color: Colors.white,
                          // ),
                          const Text('👋', style: TextStyle(fontSize: 192)),
                    ),
                  ),
                  const Expanded(
                    flex: 2,
                    child: SizedBox(
                      width: double.infinity,
                      height: double.infinity,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            'welcome!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: 'Readex Pro',
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                // color: Color(0xFF0C7489),
                                letterSpacing: 0.5),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 16.0),
                            child: Text(
                              'thanks for joining us',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Readex Pro',
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Text(
                            'before we start, let\'s know a bit about you 😉',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Readex Pro',
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
