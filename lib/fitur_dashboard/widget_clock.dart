import 'dart:async';

import 'package:flutter/material.dart';

class ClockWidget extends StatefulWidget {
  const ClockWidget({Key? key}) : super(key: key);

  @override
  _ClockWidgetState createState() => _ClockWidgetState();
}

class _ClockWidgetState extends State<ClockWidget> {
  String _time = '';
  String _date = '';

  @override
  void initState() {
    super.initState();
    // Membuat pembaruan jam setiap detik
    _updateTimeAndDate();
    Timer.periodic(Duration(seconds: 1), (timer) {
      _updateTimeAndDate();
    });
  }

  void _updateTimeAndDate() {
    final now = DateTime.now();
    final formattedTime = "${now.hour}:${now.minute}:${now.second}";
    final formattedDate = "${now.day}/${now.month}/${now.year}";
    setState(() {
      _time = formattedTime;
      _date = formattedDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          _time,
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w900,
          ),
        ),
        Text(
          _date,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }
}

// void main() {
//   runApp(MaterialApp(
//     home: Scaffold(
//       appBar: AppBar(
//         title: Text('Clock and Date'),
//       ),
//       body: Center(
//         child: ClockWidget(),
//       ),
//     ),
//   ));
// }
