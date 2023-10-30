import 'package:flutter/material.dart';

class IntroWorkStep extends StatefulWidget {
  const IntroWorkStep({Key? key}) : super(key: key);

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
              width: double.infinity,
              height: 500,
              decoration: const BoxDecoration(
                color: Color(0xFFA8DCD9),
              ),
              child: Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0x00FFFFFF),
                      Colors.white,
                    ],
                    stops: [0, 1],
                    begin: AlignmentDirectional(0, -1),
                    end: AlignmentDirectional(0, 1),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.sizeOf(context).height * 0.66,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  'https://cdn3d.iconscout.com/3d/premium/thumb/focus-6048933-4997123.png?f=webp',
                                  width: double.infinity,
                                  height: 400,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Expanded(
                      flex: 1,
                      child: SizedBox(
                        width: double.infinity,
                        height: double.infinity,
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              'what is your\nbest time to focus?',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Outfit',
                                color: Colors.black,
                                fontSize: 28,
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                              child: Text(
                                'being efficient at work is a matter of context and environment',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: 'Readex Pro',
                                    color: Colors.black,
                                    fontSize: 14),
                              ),
                            ),
                            // TODO move the rest to the stepper widget

                            // Padding(
                            //   padding:
                            //       const EdgeInsetsDirectional.fromSTEB(0, 8, 0, 0),
                            //   child: Text(
                            //     'ooo',
                            //     style:
                            //         FlutterFlowTheme.of(context).bodyMedium,
                            //   ),
                            // ),
                            // Padding(
                            //   padding: EdgeInsetsDirectional.fromSTEB(
                            //       16, 32, 16, 16),
                            //   child: Row(
                            //     mainAxisSize: MainAxisSize.max,
                            //     mainAxisAlignment:
                            //         MainAxisAlignment.spaceAround,
                            //     crossAxisAlignment: CrossAxisAlignment.center,
                            //     children: [
                            //       FFButtonWidget(
                            //         onPressed: () {
                            //           print('Button pressed ...');
                            //         },
                            //         text: 'Back',
                            //         options: FFButtonOptions(
                            //           width: 120,
                            //           height: 44,
                            //           padding: EdgeInsetsDirectional.fromSTEB(
                            //               0, 0, 0, 0),
                            //           iconPadding:
                            //               EdgeInsetsDirectional.fromSTEB(
                            //                   0, 0, 0, 0),
                            //           color: FlutterFlowTheme.of(context)
                            //               .primary,
                            //           textStyle: FlutterFlowTheme.of(context)
                            //               .titleSmall
                            //               .override(
                            //                 fontFamily: 'Readex Pro',
                            //                 color: Colors.white,
                            //               ),
                            //           elevation: 2,
                            //           borderRadius: BorderRadius.circular(32),
                            //         ),
                            //       ),
                            //       FFButtonWidget(
                            //         onPressed: () {
                            //           print('Button pressed ...');
                            //         },
                            //         text: '==>',
                            //         options: FFButtonOptions(
                            //           width: 120,
                            //           height: 44,
                            //           padding: EdgeInsetsDirectional.fromSTEB(
                            //               0, 0, 0, 0),
                            //           iconPadding:
                            //               EdgeInsetsDirectional.fromSTEB(
                            //                   0, 0, 0, 0),
                            //           color: FlutterFlowTheme.of(context)
                            //               .primary,
                            //           textStyle: FlutterFlowTheme.of(context)
                            //               .titleSmall
                            //               .override(
                            //                 fontFamily: 'Readex Pro',
                            //                 color: Colors.white,
                            //               ),
                            //           elevation: 2,
                            //           borderRadius: BorderRadius.circular(32),
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
