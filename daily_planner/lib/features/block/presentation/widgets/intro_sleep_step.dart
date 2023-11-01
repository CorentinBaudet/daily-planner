import 'package:daily_planner/features/time_slot/domain/entities/time_slot_entity.dart';
import 'package:daily_planner/features/time_slot/presentation/widgets/time_slot_picker.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class IntroSleepStep extends StatefulWidget {
  TimeSlot sleepTimeSlot;

  IntroSleepStep({Key? key, required this.sleepTimeSlot}) : super(key: key);

  @override
  State<IntroSleepStep> createState() => _IntroSleepStepState();
}

class _IntroSleepStepState extends State<IntroSleepStep> {
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
              decoration: const BoxDecoration(
                color: Color(0xFFe8e9eb),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  const Expanded(
                    flex: 15,
                    child: SizedBox(
                      width: double.infinity,
                      height: double.infinity,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '😴',
                            style: TextStyle(
                              fontSize: 192,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: SizedBox(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'at which time\ndo you sleep ?',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: 'Readex Pro',
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0C7489),
                                letterSpacing: 0.5),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 24),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TimeSlotPicker(
                                  timeSlot: widget.sleepTimeSlot,
                                ),
                                const SizedBox(
                                  width: 16,
                                ),
                                TimeSlotPicker(
                                  timeSlot: widget.sleepTimeSlot,
                                  isEndTime: true,
                                ),
                              ],
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
          // ),
        ],
      ),
    );
  }
}
