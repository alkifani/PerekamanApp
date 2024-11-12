import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class Speedometer extends StatelessWidget {
  const Speedometer({
    Key? key,
    required this.gaugeBegin,
    required this.gaugeEnd,
    required this.velocity,
    required this.maxVelocity,
    required this.velocityUnit,
  }) : super(key: key);

  final double gaugeBegin;
  final double gaugeEnd;
  final double? velocity;
  final double? maxVelocity;
  final String velocityUnit;

  @override
  Widget build(BuildContext context) {
    final TextStyle _annotationTextStyle = TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    );

    final List<GaugePointer> pointers = [];
//https://help.syncfusion.com/flutter/radial-gauge/marker-pointer --> dokumentasi
    if (maxVelocity != null) {
      pointers.add(
        // NeedlePointer(
        //   value: maxVelocity!,
        //   needleLength: 0.95,
        //   enableAnimation: true,
        //   animationType: AnimationType.ease,
        //   needleStartWidth: 1.5,
        //   needleEndWidth: 6,
        //   needleColor: Colors.white54,
        //   knobStyle: const KnobStyle(knobRadius: 0.09),
        // ),
        MarkerPointer(
          value: velocity!,
          //needleLength: 0.95,
          enableAnimation: true,
          animationType: AnimationType.ease,
          //needleStartWidth: 1.5,
          //needleEndWidth: 6,
          //needleColor: Colors.red,
          //knobStyle: const KnobStyle(knobRadius: 0.09),
          markerHeight: 50,
          markerWidth: 25,
          elevation: 5,
          markerType: MarkerType.image,
          imageUrl: 'assets/images/icon_speed.png',
        ),
      );
    }

    if (velocity != null) {
      pointers.add(
        MarkerPointer(
          value: velocity!,
          //needleLength: 0.95,
          enableAnimation: true,
          animationType: AnimationType.ease,
          //needleStartWidth: 1.5,
          //needleEndWidth: 6,
          //needleColor: Colors.red,
          //knobStyle: const KnobStyle(knobRadius: 0.09),
          markerHeight: 50,
          markerWidth: 25,
          elevation: 5,
          markerType: MarkerType.image,
          imageUrl: 'assets/images/icon_speed.png',
        ),
          // MarkerPointer(
          //     value: 60, markerHeight: 20, markerWidth: 20, elevation: 4)
      );
    }

    final String velocityText = velocity?.toStringAsFixed(2) ?? 'N/A';

    return SfRadialGauge(
      axes: <RadialAxis>[
        RadialAxis(
          startAngle: 180, endAngle: 60,
          radiusFactor: 0.5,
          axisLineStyle: const AxisLineStyle(
            thicknessUnit: GaugeSizeUnit.factor,
            thickness: 0.05,
            //dashArray: <double>[5,5]
          ),
          majorTickStyle: const MajorTickStyle(
            length: 10,
            thickness: 4,
            color: Colors.white,
          ),
          minorTickStyle: const MinorTickStyle(
            length: 5,
            thickness: 5,
            color: Colors.white,
          ),
          axisLabelStyle: const GaugeTextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
          ranges: <GaugeRange>[
            GaugeRange(
              startValue: gaugeBegin,
              endValue: gaugeEnd,
              sizeUnit: GaugeSizeUnit.factor,
              startWidth: 0.03,
              endWidth: 0.03,
              color: Colors.black,

              // gradient: const SweepGradient(
              //   colors: <Color>[Colors.green, Colors.yellow, Colors.red],
              //   stops: <double>[0.0, 0.5, 1],
              // ),

            ),

          ],
        ),
        RadialAxis(
          startAngle: 180, endAngle: 60,
          minimum: gaugeBegin,
          maximum: gaugeEnd,
          interval: 15,
          maximumLabels: 5,
          labelOffset: 20,
          axisLineStyle: const AxisLineStyle(
            thicknessUnit: GaugeSizeUnit.factor,
            thickness: 0.05,
              //dashArray: <double>[5,5]
          ),
          majorTickStyle: const MajorTickStyle(
            length: 10,
            thickness: 4,
            color: Colors.black,
          ),
          minorTickStyle: const MinorTickStyle(
            length: 5,
            thickness: 5,
            color: Colors.black,
          ),
          axisLabelStyle: const GaugeTextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
          ranges: <GaugeRange>[
            GaugeRange(
              startValue: gaugeBegin,
              endValue: gaugeEnd,
              sizeUnit: GaugeSizeUnit.factor,
              startWidth: 0.03,
              endWidth: 0.03,
              color: Colors.black,
              // gradient: const SweepGradient(
              //   colors: <Color>[Colors.green, Colors.yellow, Colors.red],
              //   stops: <double>[0.0, 0.5, 1],
              // ),
            ),
          ],
          pointers: pointers,
          annotations: <GaugeAnnotation>[
            if (velocity != null)
              GaugeAnnotation(
                widget: Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: <Widget>[
                    Text(
                      velocityText,
                      style: _annotationTextStyle.copyWith(fontSize: 35),
                    ),
                    const SizedBox(width: 5),
                    Text(velocityUnit, style: _annotationTextStyle.copyWith(fontSize: 15)),
                    // const SizedBox(width: 5),
                    // Text(velocityUnit, style: _annotationTextStyle),
                  ],
                ),
                angle: 0,
                //positionFactor: 0.8,
              ),
          ],
        ),
      ],
    );
  }
}
