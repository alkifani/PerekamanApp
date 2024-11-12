import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:io';

class DashTilt extends StatefulWidget {
  @override
  _DashTiltState createState() => _DashTiltState();
}

class _DashTiltState extends State<DashTilt> {
  String _sensorData = "";
  String _accelerometerData = "";
  String _gyroscopeData = "";
  bool _sensorUpdating = false;
  bool _shouldRecordSensorData = true ; //false;
  StreamSubscription<GyroscopeEvent>? _gyroscopeSubscription;
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;

  @override
  void initState() {
    super.initState();
    _startSensorStreams();
    //_startStatusCheck();
  }

  Future<void> _startStatusCheck() async {
    while (true) {
      try {
        final statusFilePath = await _getStatusFilePath();
        final File statusFile = File(statusFilePath);

        if (await statusFile.exists()) {
          final status = await statusFile.readAsString();

          if (status == '1') {
            if (!_shouldRecordSensorData) {
              _shouldRecordSensorData = true; // Set flag to record sensor data
            }
          } else {
            _shouldRecordSensorData = false; // Set flag to stop recording sensor data
          }
        }
      } catch (e) {
        print("Error reading status file: $e");
      }

      await Future.delayed(Duration(seconds: 2));
    }
  }

  Future<String> _getStatusFilePath() async {
    // final Directory? directory = await getExternalStorageDirectory();
    // final String folderPath = join(directory!.path, 'Alat CO-SENSE');
    Directory generalDownloadDir = Directory('/storage/emulated/0/Download');
    final String folderPath = join(generalDownloadDir.path, 'Alat CO-SENSE');
    return join(folderPath, 'status.txt');
  }

  void _startSensorStreams() {
    _gyroscopeSubscription = gyroscopeEvents.listen((GyroscopeEvent gyroscopeEvent) {
      if (_shouldRecordSensorData) {

      Timer(Duration(seconds: 5), () {
        setState(() {
          _gyroscopeData =
          "X: ${gyroscopeEvent.x.toStringAsFixed(3)}\nY: ${gyroscopeEvent.y.toStringAsFixed(3)}\nZ: ${gyroscopeEvent.z.toStringAsFixed(3)}";
        });
        // _sensorUpdating = false;
        _sensorUpdating = true;
      });

      _saveSensorData("gyro", gyroscopeEvent);}
    });

    _accelerometerSubscription = accelerometerEvents.listen((AccelerometerEvent accelerometerEvent) {
      if (_shouldRecordSensorData) {

      Timer(Duration(seconds: 5), () {
        setState(() {
          _accelerometerData =
          "X: ${accelerometerEvent.x.toStringAsFixed(3)}\nY: ${accelerometerEvent.y.toStringAsFixed(3)}\nZ: ${accelerometerEvent.z.toStringAsFixed(3)}";
        });
        // _sensorUpdating = false;
        _sensorUpdating = true;
      });

      _saveSensorData("accel", accelerometerEvent);}
    });
  }

  Future<void> _saveSensorData(String sensorType, dynamic event) async {
    // final Directory? directory = await getExternalStorageDirectory();
    // final String folderPath = join(directory!.path, 'Alat CO-SENSE');
    final Directory generalDownloadDir = Directory('/storage/emulated/0/Download');
    final String folderPath = join(generalDownloadDir.path, 'Alat CO-SENSE');
    final String filePath = join(folderPath, 'sensor_data.csv');

    await _createFolderIfNotExists(folderPath);
    await _createFileIfNotExists(filePath);

    final String timestamp = DateTime.now().toLocal().toString().substring(0, 19);
    final String accelData = "${event.x.toStringAsFixed(5)}, ${event.y.toStringAsFixed(5)}, ${event.z.toStringAsFixed(5)}";
    final String gyroData = "${event.x.toStringAsFixed(5)}, ${event.y.toStringAsFixed(5)}, ${event.z.toStringAsFixed(5)}";
    // final String accelData = "accel: -X: ${event.x.toStringAsFixed(2)}, Y: ${event.y.toStringAsFixed(2)}, Z: ${event.z.toStringAsFixed(2)}";
    // final String gyroData = "gyro: -X: ${event.x.toStringAsFixed(2)}, Y: ${event.y.toStringAsFixed(2)}, Z: ${event.z.toStringAsFixed(2)}";

    final String csvData = '$timestamp, $accelData, $gyroData';

    final File file = File(filePath);
    await file.writeAsString('$csvData\n', mode: FileMode.append);
  }


  Future<void> _createFolderIfNotExists(String folderPath) async {
    final Directory folder = Directory(folderPath);
    if (!await folder.exists()) {
      await folder.create(recursive: true);
    }
  }

  Future<void> _createFileIfNotExists(String filePath) async {
    final File file = File(filePath);
    if (!await file.exists()) {
      await file.create();
    }
  }

  @override
  void dispose() {
    // _gyroscopeSubscription?.cancel();
    // _accelerometerSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Accelerometer',
          style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
        ),
        Text(
          _accelerometerData, // Menampilkan data accelerometer
          style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold), // Warna teks untuk accelerometer
          textAlign: TextAlign.left,
        ),
        SizedBox(height: 10,),
        Text('Gyroscope',
          style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
        ),
        Text(
          _gyroscopeData, // Menampilkan data gyroscope
          style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold), // Warna teks untuk gyroscope
          textAlign: TextAlign.left,
        ),
        // Text(
        //   _sensorData,
        //   style: TextStyle(fontSize: 16, color: Colors.orange),
        //   textAlign: TextAlign.center,
        // ),
      ],
    );
  }
}


// void main() {
//   runApp(MaterialApp(
//     home: Scaffold(
//       appBar: AppBar(
//         title: Text('Menu Icon App'),
//       ),
//       body: Center(
//         child: DashTilt(),
//       ),
//     ),
//   ));
// }