import 'package:daily_planner/features/time_slot/domain/entities/time_slot_entity.dart';
import 'package:daily_planner/features/time_slot/presentation/widgets/time_slot_picker.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class IntroWorkStep extends StatefulWidget {
  TimeSlot workTimeSlot;

  IntroWorkStep({Key? key, required this.workTimeSlot}) : super(key: key);

  @override
  State<IntroWorkStep> createState() => _IntroWorkStepState();
}

class _IntroWorkStepState extends State<IntroWorkStep> {
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
              decoration:
                  // const BoxDecoration(
                  //   color: Color(0xFFe8e9eb),
                  const BoxDecoration(
                color: Color(0xFFEAE0D5),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  const Expanded(
                    flex: 7,
                    child: SizedBox(
                      width: double.infinity,
                      height: double.infinity,
                      // constraints: BoxConstraints(
                      //   maxHeight: MediaQuery.sizeOf(context).height * 0.66,
                      // ),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Flexible(
                          //   child: ClipRRect(
                          //     borderRadius: BorderRadius.circular(8),
                          //     child: Image.network(
                          //       'https://cdn3d.iconscout.com/3d/premium/thumb/focus-6048933-4997123.png?f=webp',
                          //       width: double.infinity,
                          //       height: 400,
                          //       fit: BoxFit.cover,
                          //     ),
                          //   ),
                          // ),
                          Text(
                            '🧠',
                            style: TextStyle(fontSize: 192),
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: SizedBox(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          const Text(
                            'what is your\nbest time to focus?',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Readex Pro',
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              // color: Color(0xFF0C7489),
                              letterSpacing: 0.5,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsetsDirectional.only(top: 16),
                            child: Text(
                              'being efficient at work is a matter of context and environment',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: 'Readex Pro',
                                  fontSize: 15,
                                  fontStyle: FontStyle.italic),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TimeSlotPicker(
                                  timeSlot: widget.workTimeSlot,
                                ),
                                const SizedBox(
                                  width: 16,
                                ),
                                TimeSlotPicker(
                                  timeSlot: widget.workTimeSlot,
                                  isEndTime: true,
                                ),
                              ],
                            ),
                          )
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
