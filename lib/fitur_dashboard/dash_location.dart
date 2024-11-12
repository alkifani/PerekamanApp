import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:io';

class DashLocation extends StatefulWidget {
  @override
  _DashLocationState createState() => _DashLocationState();
}

class _DashLocationState extends State<DashLocation> {
  String _locationMessage = "";
  bool _shouldRecordLocation = true; //false;
  late StreamSubscription<Position> _positionStreamSubscription;

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
    //_startStatusCheck();
    _startLocationUpdates(); //untuk update lokasi
  }

  @override
  void dispose() {
    _positionStreamSubscription.cancel();
    super.dispose();
  }

  Future<String> _getStatusFilePath() async {
    // final Directory? directory = await getExternalStorageDirectory();
    // final String folderPath = join(directory!.path, 'Alat CO-SENSE');
    Directory generalDownloadDir = Directory('/storage/emulated/0/Download');
    final String folderPath = join(generalDownloadDir.path, 'Alat CO-SENSE');
    return join(folderPath, 'status.txt');
  }

  Future<void> _startStatusCheck() async {
    while (true) {
      try {
        final statusFilePath = await _getStatusFilePath();
        final File statusFile = File(statusFilePath);

        if (await statusFile.exists()) {
          final status = await statusFile.readAsString();

          if (status == '1') {
            if (!_shouldRecordLocation) {
              _shouldRecordLocation = true; // Set the flag to record location
              // _startLocationUpdates();
            }
          } else {
            if (_shouldRecordLocation) {
              _shouldRecordLocation = false; // Set the flag to stop recording location
              // _positionStreamSubscription?.cancel();
            }
          }
        }
      } catch (e) {
        print("Error reading status file: $e");
      }

      await Future.delayed(Duration(seconds: 2));
    }
  }

  Future<void> _checkLocationPermission() async {
    if (await Permission.location.isGranted &&
        await Permission.storage.isGranted) {
      _startLocationUpdates();
    } else {
      await Permission.location.request();
      await Permission.storage.request();
      if (await Permission.location.isGranted &&
          await Permission.storage.isGranted) {
        _startLocationUpdates();
      } else {
        setState(() {
          _locationMessage = "";
        });
      }
    }
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

  Future<void> _getCurrentLocation(Position position) async {
    // final Directory? directory = await getExternalStorageDirectory();
    // final String folderPath = join(directory!.path, 'Alat CO-SENSE');
    Directory generalDownloadDir = Directory('/storage/emulated/0/Download');
    final String folderPath = join(generalDownloadDir.path, 'Alat CO-SENSE');
    final String filePath = join(folderPath, 'location_data.csv');

    await _createFolderIfNotExists(folderPath);
    await _createFileIfNotExists(filePath);

    final String latitude = position.latitude.toString();
    final String longitude = position.longitude.toString();
    final String timestamp = DateTime.now().toLocal().toString().substring(0, 19);
    final String csvData = '$timestamp, $latitude, $longitude';

    final File file = File(filePath);
    await file.writeAsString('$csvData\n', mode: FileMode.append);

    setState(() {
      _locationMessage = "Latitude: $latitude\nLongitude: $longitude";
    });

  }

  void _startLocationUpdates() {
    _positionStreamSubscription = Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 2, // Minimum distance (in meters) for updates
      ),
    ).listen((Position position) {
      if (_shouldRecordLocation) {
        _getCurrentLocation(position);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          _locationMessage,
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.left,
        ),
      ],
    );
  }
}
