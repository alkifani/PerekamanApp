import 'package:blackboxalat/logo_app.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart'; // Import paket SystemChrome
import 'package:permission_handler/permission_handler.dart'; // Import paket permission_handler
import 'package:path_provider/path_provider.dart';
import 'dart:io';

// late List<CameraDescription> cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive, overlays: []);
  // cameras = await availableCameras();

  // Set preferensi orientasi layar ke landscape
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
    // DeviceOrientation.portraitUp,
    // DeviceOrientation.portraitDown,
  ]);

  // await Permission.location.isGranted;
  // await Permission.location.request();
  // await Permission.storage.isGranted;
  // await Permission.storage.request();

  // // Memeriksa dan meminta izin lokasi
  // LocationPermission locationPermission = await Geolocator.checkPermission();
  // if (locationPermission == LocationPermission.denied ||
  //     locationPermission == LocationPermission.deniedForever ||
  //     locationPermission == LocationPermission.whileInUse) {
  //   locationPermission = await Geolocator.requestPermission();
  // }
  //
  // // Memeriksa dan meminta izin penyimpanan
  // PermissionStatus storagePermission = await Permission.storage.status;
  // if (!storagePermission.isGranted) {
  //   storagePermission = await Permission.storage.request();
  // }

  // switch (locationPermission) {
  //   case LocationPermission.deniedForever:
  //     runApp(const NoPermissionApp(hasCheckedPermissions: false));
  //     break;
  //
  //   case LocationPermission.always:
  //   case LocationPermission.whileInUse:
  //     runApp(const ObjectDetector());
  //     break;
  //
  //   case LocationPermission.denied:
  //   case LocationPermission.unableToDetermine:
  //     runApp(const NoPermissionApp(hasCheckedPermissions: false));
  // }

  Map<Permission, PermissionStatus> statuses = await [
    Permission.location,
    Permission.storage,
    // Permission.camera,
    Permission.manageExternalStorage,
    Permission.phone,
    Permission.accessMediaLocation,
    Permission.locationWhenInUse,
    Permission.sensors,
    Permission.appTrackingTransparency,
    Permission.nearbyWifiDevices,
    Permission.bluetooth,
    Permission.bluetoothConnect,
    Permission.bluetoothScan,
    Permission.bluetoothAdvertise,
  ].request();
  print(statuses[Permission.location]);
  print(statuses[Permission.storage]);
  // print(statuses[Permission.camera]);

  // Mengecek dan membuat folder "Alat CO-SENSE" jika belum ada
  final Directory generalDownloadDir = Directory('/storage/emulated/0/Download');
  String coSenseFolderPath = ''; // Definisikan di luar blok if
  if (generalDownloadDir != null) {
    final String coSenseFolderName = 'Alat CO-SENSE';
    coSenseFolderPath = '${generalDownloadDir.path}/$coSenseFolderName';

    if (!(await Directory(coSenseFolderPath).exists())) {
      await Directory(coSenseFolderPath).create();
    }
  }
  // final Directory? directory = await getExternalStorageDirectory();
  // String coSenseFolderPath = ''; // Definisikan di luar blok if
  // if (directory != null) {
  //   final String coSenseFolderName = 'Alat CO-SENSE';
  //   coSenseFolderPath = '${directory.path}/$coSenseFolderName';
  //
  //   if (!(await Directory(coSenseFolderPath).exists())) {
  //     await Directory(coSenseFolderPath).create();
  //   }
  // }

  // Mengecek dan membuat berkas "status.txt" jika belum ada
  final String statusFilePath = '$coSenseFolderPath/status.txt';
  final File statusFile = File(statusFilePath);

  // Mengecek dan membuat berkas "speed_data.csv" jika belum ada
  final String speedFilePath = '$coSenseFolderPath/speed_data.csv';
  final File speedFile = File(speedFilePath);

  // Mengecek dan membuat berkas "location_data.csv" jika belum ada
  final String locationFilePath = '$coSenseFolderPath/location_data.csv';
  final File locationFile = File(locationFilePath);

  // Mengecek dan membuat berkas "sensor_data.csv" jika belum ada
  final String sensorFilePath = '$coSenseFolderPath/sensor_data.csv';
  final File sensorFile = File(sensorFilePath);

  // Mengecek dan membuat berkas "distance_data.csv" jika belum ada
  final String DistanceFilePath = '$coSenseFolderPath/distance_data.csv';
  final File DistanceFile = File(DistanceFilePath);

  if (!(await statusFile.exists())) {
    await statusFile.create();
    await statusFile.writeAsString('0'); // Isi awal status.txt dengan "0"
  }

  if (!(await speedFile.exists())) {
    await speedFile.create();
    //await speedFile.writeAsString('0'); // Isi awal status.txt dengan "0"
  }

  if (!(await locationFile.exists())) {
    await locationFile.create();
    //await locationFile.writeAsString('0 , 0'); // Isi awal status.txt dengan "0"
  }

  if (!(await sensorFile.exists())) {
    await sensorFile.create();
    //await sensorFile.writeAsString('0, 0, 0, 0, 0, 0,'); // Isi awal status.txt dengan "0"
  }

  if (!(await DistanceFile.exists())) {
    await DistanceFile.create();
  }

  runApp(const MyApp());
  // runApp(const ObjectDetector());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Black-Box Tools',
      themeMode: ThemeMode.system,
      home: LogoApp(),
    );
  }
}


