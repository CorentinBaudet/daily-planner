import 'package:flutter/material.dart';

class IntroStartStep extends StatefulWidget {
  const IntroStartStep({Key? key}) : super(key: key);

  @override
  State<IntroStartStep> createState() => _IntroStartStepState();
}

class _IntroStartStepState extends State<IntroStartStep>
    with TickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  // final animationsMap = {
  //   'containerOnPageLoadAnimation1': AnimationInfo(
  //     trigger: AnimationTrigger.onPageLoad,
  //     effects: [
  //       VisibilityEffect(duration: 1.ms),
  //       FadeEffect(
  //         curve: Curves.easeInOut,
  //         delay: 0.ms,
  //         duration: 400.ms,
  //         begin: 0,
  //         end: 1,
  //       ),
  //       ScaleEffect(
  //         curve: Curves.easeInOut,
  //         delay: 0.ms,
  //         duration: 400.ms,
  //         begin: Offset(3, 3),
  //         end: Offset(1, 1),
  //       ),
  //     ],
  //   ),
  //   'containerOnPageLoadAnimation2': AnimationInfo(
  //     trigger: AnimationTrigger.onPageLoad,
  //     effects: [
  //       VisibilityEffect(duration: 300.ms),
  //       FadeEffect(
  //         curve: Curves.easeInOut,
  //         delay: 300.ms,
  //         duration: 300.ms,
  //         begin: 0,
  //         end: 1,
  //       ),
  //       ScaleEffect(
  //         curve: Curves.bounceOut,
  //         delay: 300.ms,
  //         duration: 300.ms,
  //         begin: Offset(0.6, 0.6),
  //         end: Offset(1, 1),
  //       ),
  //     ],
  //   ),
  //   'textOnPageLoadAnimation1': AnimationInfo(
  //     trigger: AnimationTrigger.onPageLoad,
  //     effects: [
  //       VisibilityEffect(duration: 350.ms),
  //       FadeEffect(
  //         curve: Curves.easeInOut,
  //         delay: 350.ms,
  //         duration: 400.ms,
  //         begin: 0,
  //         end: 1,
  //       ),
  //       MoveEffect(
  //         curve: Curves.easeInOut,
  //         delay: 350.ms,
  //         duration: 400.ms,
  //         begin: Offset(0, 30),
  //         end: Offset(0, 0),
  //       ),
  //     ],
  //   ),
  //   'textOnPageLoadAnimation2': AnimationInfo(
  //     trigger: AnimationTrigger.onPageLoad,
  //     effects: [
  //       VisibilityEffect(duration: 400.ms),
  //       FadeEffect(
  //         curve: Curves.easeInOut,
  //         delay: 400.ms,
  //         duration: 400.ms,
  //         begin: 0,
  //         end: 1,
  //       ),
  //       MoveEffect(
  //         curve: Curves.easeInOut,
  //         delay: 400.ms,
  //         duration: 400.ms,
  //         begin: Offset(0, 30),
  //         end: Offset(0, 0),
  //       ),
  //     ],
  //   ),
  //   'rowOnPageLoadAnimation': AnimationInfo(
  //     trigger: AnimationTrigger.onPageLoad,
  //     effects: [
  //       VisibilityEffect(duration: 300.ms),
  //       FadeEffect(
  //         curve: Curves.easeInOut,
  //         delay: 300.ms,
  //         duration: 600.ms,
  //         begin: 0,
  //         end: 1,
  //       ),
  //       ScaleEffect(
  //         curve: Curves.bounceOut,
  //         delay: 300.ms,
  //         duration: 600.ms,
  //         begin: Offset(0.6, 0.6),
  //         end: Offset(1, 1),
  //       ),
  //     ],
  //   ),
  // };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      // backgroundColor: Colors.white,
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              child: Container(
            width: double.infinity,
            height: 500,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xff4B39EF),
                  Color(0xffFF5963),
                  Color(0xffEE8B60),
                ],
                stops: [0, 0.5, 1],
                begin: AlignmentDirectional(-1, -1),
                end: AlignmentDirectional(1, 1),
              ),
            ),
            child: Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0x00FFFFFF), Colors.white],
                  stops: [0, 1],
                  begin: AlignmentDirectional(0, -1),
                  end: AlignmentDirectional(0, 1),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    child: const Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8),
                        child: Icon(
                          Icons.waving_hand_rounded,
                          size: 100,
                          color: Colors.white,
                        )
                        // Image.network(
                        //   'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/f-f-templates-q1-23-fbcr63/assets/ax4fvwjz7awx/@4xff_badgeDesign_dark_small.png',
                        //   width: 100,
                        //   height: 100,
                        //   fit: BoxFit.cover,
                        // ),
                        ),
                  ),
                  const Text(
                    'Welcome!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Readex Pro',
                      fontSize: 16,
                    ),
                  ),
                  const Text(
                    'Thanks for joining! Before we start, let\'s know a bit about you 😉',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Readex Pro',
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          )),
          // Padding(
          //     padding: EdgeInsetsDirectional.fromSTEB(16, 24, 16, 44),
          //     child: Row(
          //       mainAxisSize: MainAxisSize.max,
          //       children: [
          //         Expanded(
          //           child: Align(
          //             alignment: AlignmentDirectional(0.00, 0.00),
          //             child: Padding(
          //               padding: EdgeInsetsDirectional.fromSTEB(0, 0, 8, 16),
          //               child: ElevatedButton(
          //                 onPressed: () {
          //                   print('Button pressed ...');
          //                 },
          //                 child: Text('Get Started'),
          //                 // options: FFButtonOptions(
          //                 //   width: 230,
          //                 //   height: 52,
          //                 //   padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
          //                 //   iconPadding:
          //                 //       EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
          //                 //   color: FlutterFlowTheme.of(context)
          //                 //       .secondaryBackground,
          //                 //   textStyle: FlutterFlowTheme.of(context).bodyLarge,
          //                 //   elevation: 0,
          //                 //   borderSide: BorderSide(
          //                 //     color: FlutterFlowTheme.of(context).alternate,
          //                 //     width: 2,
          //                 //   ),
          //                 //   borderRadius: BorderRadius.circular(12),
          //                 // ),
          //               ),
          //             ),
          //           ),
          //         ),
          //         Expanded(
          //           child: Align(
          //             alignment: AlignmentDirectional(0.00, 0.00),
          //             child: Padding(
          //               padding: EdgeInsetsDirectional.fromSTEB(8, 0, 0, 16),
          //               child: ElevatedButton(
          //                 onPressed: () {
          //                   print('Button pressed ...');
          //                 },
          //                 child: Text('My Account'),
          //                 // options: FFButtonOptions(
          //                 //   width: 230,
          //                 //   height: 52,
          //                 //   padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
          //                 //   iconPadding:
          //                 //       EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
          //                 //   color: FlutterFlowTheme.of(context).primary,
          //                 //   textStyle: FlutterFlowTheme.of(context)
          //                 //       .titleSmall
          //                 //       .override(
          //                 //         fontFamily: 'Readex Pro',
          //                 //         color: Colors.white,
          //                 //       ),
          //                 //   elevation: 3,
          //                 //   borderSide: BorderSide(
          //                 //     color: Colors.transparent,
          //                 //     width: 1,
          //                 //   ),
          //                 //   borderRadius: BorderRadius.circular(12),
          //                 // ),
          //               ),
          //             ),
          //           ),
          //         ),
          //       ],
          //     )),
        ],
      ),
    );
  }
}
