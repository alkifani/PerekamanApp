
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'dart:async';

class SpeedDisplay extends StatefulWidget {
  @override
  _SpeedDisplayState createState() => _SpeedDisplayState();
}

class _SpeedDisplayState extends State<SpeedDisplay> {

  double _currentSpeed = 0.0;
  StreamController<double> _velocityUpdatedStreamController =
  StreamController<double>();
  String _filePath = "";
  bool _isWritingToFile = false;
  // Isolate? _objectDetectionIsolate;

  StreamSubscription<Position>? _positionStreamSubscription;
  GeolocatorPlatform locator = GeolocatorPlatform.instance;

  @override
  void initState() {
    super.initState();
    _startLocationStream();
    _getSpeedFilePath().then((path) {
      setState(() {
        _filePath = path;
      });
    });
  }

  Future<String> _getStatusFilePath() async {
    // final Directory? directory = await getExternalStorageDirectory();
    // final String folderPath = join(directory!.path, 'Alat CO-SENSE');
      Directory generalDownloadDir = Directory('/storage/emulated/0/Download');
      final String folderPath = join(generalDownloadDir.path, 'Alat CO-SENSE');
    return join(folderPath, 'status.txt');
  }

  Future<void> _updateStatusFile(String status) async {
    final statusFilePath = await _getStatusFilePath();
    final File statusFile = File(statusFilePath);

    try {
      await statusFile.writeAsString(status);
    } catch (e) {
      print("Error updating status file: $e");
    }
  }

  Future<String> _getSpeedFilePath() async {
    // final Directory? directory = await getExternalStorageDirectory();
    // final String folderPath = join(directory!.path, 'Alat CO-SENSE');
    final Directory generalDownloadDir = Directory('/storage/emulated/0/Download');
    final String folderPath = join(generalDownloadDir.path, 'Alat CO-SENSE');
    return join(folderPath, 'speed_data.csv');
  }

  void _startLocationStream() {
    _positionStreamSubscription = locator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 2, // Minimum distance (in meters) for updates
      ),
    ).listen((Position position) {
      _onAccelerate(position.speed);
      _saveSpeedToFile(_currentSpeed.toStringAsFixed(2));
    });
  }

  // // Fungsi untuk menghentikan object detection
  // void _stopObjectDetectionIsolate() {
  //   if (_objectDetectionIsolate != null) {
  //     _objectDetectionIsolate!.kill(priority: Isolate.immediate);
  //   }
  // }


  void _onAccelerate(double speed) {
    locator.getCurrentPosition().then(
          (Position updatedPosition) {
        final velocity = (speed + updatedPosition.speed) / 2;
        _velocityUpdatedStreamController.add(velocity);
        setState(() {
          _currentSpeed = velocity * 3.6; // konversi dari m/s ke km/h
        });

        //Jika kecepatan di atas 2 km/jam, simpan data ke file speed_data.csv
        if (_currentSpeed > 5) {
          _saveSpeedToFile(_currentSpeed.toStringAsFixed(2));
          _isWritingToFile = true; // Set to true when writing data
        } else {
          _isWritingToFile = false; // Set to false when not writing data
        }

        //Jika kecepatan di atas 2 km/jam, ubah nilai pada file status.txt menjadi 1
        if (_currentSpeed > 5) {
          _updateStatusFile('1');
          // runObjectDetectionInBackground(); // menjalankan object detection di background
        } else {
          _updateStatusFile('0');
          // _stopObjectDetectionIsolate(); // Panggil metode untuk menghentikan Isolate object detection
        }
      },
    );
  }

  Future<void> _saveSpeedToFile(String speedData) async {
    if (_isWritingToFile) {
      final File file = File(_filePath);

      // // Check if the file does not have a header, add CSV header
      // if (!await file.exists()) {
      //   await file.writeAsString('Timestamp,Speed (km/h)\n', mode: FileMode.append);
      // }

      final String timestamp = DateTime.now().toLocal().toString().substring(0, 19);
      final String csvData = '$timestamp, $speedData';

      await file.writeAsString('$csvData\n', mode: FileMode.append);
    }
  }

  @override
  void dispose() {
    _velocityUpdatedStreamController.close();
    _positionStreamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // Text(
          //   'Current Speed: ${_currentSpeed.toStringAsFixed(2)} km/h',
          //   style: TextStyle(
          //     fontSize: 16,
          //     color: Colors.orange,
          //   ),
          // ),
        ],
      ),
    );
  }
}
