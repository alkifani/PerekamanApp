//--> kode bisa scroll
// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:geolocator_platform_interface/geolocator_platform_interface.dart'; // Import LocationSettings
// import 'package:alat/menu_utama/speedometer/speedometer.dart';
//
//
// class DashScreen extends StatefulWidget {
//   const DashScreen({this.unit = 'm/s', Key? key}) : super(key: key);
//
//   final String unit;
//
//   @override
//   _DashScreenState createState() => _DashScreenState();
// }
//
// class _DashScreenState extends State<DashScreen> {
//   late StreamController<double?> _velocityUpdatedStreamController;
//   StreamSubscription<Position>? _positionSubscription; // Add this line
//
//   /// Geolocator is used to find velocity
//   GeolocatorPlatform locator = GeolocatorPlatform.instance;
//
//   /// Current Velocity in m/s
//   double? _velocity;
//
//   /// Highest recorded velocity so far in m/s.
//   double? _highestVelocity;
//
//   /// Velocity in m/s to km/hr converter
//   double mpstokmph(double mps) => mps * 18 / 5;
//
//   /// Velocity in m/s to miles per hour converter
//   double mpstomilesph(double mps) => mps * 85 / 38;
//
//   /// Relevant velocity in chosen unit
//   double? convertedVelocity(double? velocity) {
//     if (velocity == null) {
//       return null; // Return null if velocity is null
//     }
//
//     if (widget.unit == 'm/s') {
//       return velocity;
//     } else if (widget.unit == 'km/h') {
//       return mpstokmph(velocity);
//     } else if (widget.unit == 'miles/h') {
//       return mpstomilesph(velocity);
//     }
//
//     return velocity;
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _velocityUpdatedStreamController = StreamController<double?>();
//     _positionSubscription = locator.getPositionStream(
//       locationSettings: const LocationSettings(
//         accuracy: LocationAccuracy.bestForNavigation,
//       ),
//     ).listen((Position position) => _onAccelerate(position.speed));
//   }
//
//   /// Callback that runs when velocity updates, which in turn updates stream.
//   void _onAccelerate(double speed) {
//     locator.getCurrentPosition().then(
//           (Position updatedPosition) {
//         _velocity = (speed + updatedPosition.speed) / 2;
//         if (_highestVelocity == null || _velocity! > _highestVelocity!) {
//           _highestVelocity = _velocity;
//         }
//         _velocityUpdatedStreamController.add(_velocity);
//       },
//     );
//   }
//
//
//   @override
//   void dispose() {
//     // Cancel the subscription and close the stream controller
//     _positionSubscription?.cancel(); // Cancel the subscription
//     _velocityUpdatedStreamController.close();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     const double gaugeBegin = 0, gaugeEnd = 200;
//
//     return ListView(
//       scrollDirection: Axis.vertical,
//       children: <Widget>[
//         // StreamBuilder updates Speedometer when new velocity recieved
//         StreamBuilder<Object?>(
//           stream: _velocityUpdatedStreamController.stream,
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return
//                 Center(child: CircularProgressIndicator());
//             }
//
//             if (snapshot.hasError) {
//               return Text('Error: ${snapshot.error}');
//             }
//
//             final velocity = snapshot.data as double?;
//
//             if (velocity == null) {
//               return Text('No velocity data available.');
//             }
//
//             return Speedometer(
//               gaugeBegin: gaugeBegin,
//               gaugeEnd: gaugeEnd,
//               velocity: convertedVelocity(velocity),
//               maxVelocity: convertedVelocity(_highestVelocity),
//               velocityUnit: widget.unit,
//             );
//           },
//         ),
//       ],
//     );
//   }
// }


// Code tidak ush scroll

import 'dart:async';
import 'package:blackboxalat/fitur_dashboard/speedometer/speedometer.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geolocator_platform_interface/geolocator_platform_interface.dart';

class DashScreen extends StatefulWidget {
  const DashScreen({this.unit = 'm/s', Key? key}) : super(key: key);

  final String unit;

  @override
  _DashScreenState createState() => _DashScreenState();
}

class _DashScreenState extends State<DashScreen> {
  late StreamController<double?> _velocityUpdatedStreamController;
  StreamSubscription<Position>? _positionSubscription;

  GeolocatorPlatform locator = GeolocatorPlatform.instance;
  double? _velocity;
  double? _highestVelocity;

  double mpstokmph(double mps) => mps * 18 / 5;
  double mpstomilesph(double mps) => mps * 85 / 38;

  @override
  void initState() {
    super.initState();
    _velocityUpdatedStreamController = StreamController<double?>();
    _positionSubscription = locator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 2, // Minimum distance (in meters) for updates
      ),
    ).listen((Position position) => _onAccelerate(position.speed));
  }

  void _onAccelerate(double speed) async {
    Position updatedPosition = await locator.getCurrentPosition();
    _velocity = (speed + updatedPosition.speed) / 2;
    if (_highestVelocity == null || _velocity! > _highestVelocity!) {
      _highestVelocity = _velocity;
    }
    _velocityUpdatedStreamController.add(_velocity);
  }

  @override
  void dispose() {
    _positionSubscription?.cancel();
    _velocityUpdatedStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double gaugeBegin = 0, gaugeEnd = 200;

    // Mengambil lebar layar dengan menggunakan MediaQuery
    double screenWidth = MediaQuery.of(context).size.width;

    return Center(
      child: Container(
        width: screenWidth * 0.9, // Menggunakan 90% lebar layar
        child: StreamBuilder<double?>(
          stream: _velocityUpdatedStreamController.stream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }

            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            final velocity = snapshot.data;

            if (velocity == null) {
              return Text('No velocity data available.');
            }

            return Speedometer(
              gaugeBegin: gaugeBegin,
              gaugeEnd: gaugeEnd,
              velocity: convertedVelocity(velocity),
              maxVelocity: convertedVelocity(_highestVelocity),
              velocityUnit: widget.unit,
            );
          },
        ),
      ),
    );
  }

  double? convertedVelocity(double? velocity) {
    if (velocity == null) {
      return null;
    }

    if (widget.unit == 'm/s') {
      return velocity;
    } else if (widget.unit == 'km/h') {
      return mpstokmph(velocity);
    } else if (widget.unit == 'miles/h') {
      return mpstomilesph(velocity);
    }

    return velocity;
  }
}
