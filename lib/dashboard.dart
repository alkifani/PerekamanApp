import 'dart:isolate';

import 'package:blackboxalat/configure/constants.dart';
import 'package:blackboxalat/fitur_dashboard/dash_gyroscope.dart';
import 'package:blackboxalat/fitur_dashboard/dash_location.dart';
import 'package:blackboxalat/fitur_dashboard/dash_speed.dart';
import 'package:blackboxalat/fitur_dashboard/menu_pilihan.dart';
import 'package:blackboxalat/fitur_dashboard/speedometer/speed_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class DashboardApp extends StatefulWidget {
  const DashboardApp({super.key});

  @override
  State<DashboardApp> createState() => _DashboardAppState();
}

class _DashboardAppState extends State<DashboardApp> {

  @override
  void initState() {
    super.initState();
    // Set preferensi orientasi layar ke portraitUp dan portraitDown
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    // ObjectDetectionIsolate.runObjectDetectionIsolate();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      //backgroundColor: Colors.black,
      //backgroundColor: Color.fromRGBO(0, 51, 169, 100),
      // appBar: AppBar(
      //   title: Text('Dashboard'),
      // ),
      body: SafeArea(
        child: Row(
          children: <Widget> [
            //SizedBox(width: 5,),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 10,),
                  Text('Black-Box Tools',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(
                    height: 70,
                    width: 200,
                    child: Card(
                      color: wutama,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DashLocation(),
                      ),
                    ),
                  ),
                  SpeedDisplay(),
                  SizedBox(
                    height: 230,
                    width: 200,
                    child: Card(
                      color: wutama,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: DashTilt(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child:
              SpeedometerApp(), // Wrapping in Expanded
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MenuIconApp(),
              ],
            ),
            SizedBox(width: 10,)
          ],
        ),
      ),
    );
  }
}
