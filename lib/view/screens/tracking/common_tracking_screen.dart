import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tkd_connect/screen/tracking/vehicle_tracking.dart';
import 'package:tkd_connect/screen/tracking/web_vehicle_tracking.dart';

class VehicleTrackingScreen extends StatelessWidget {
  final LatLng startLocation;
  final LatLng endLocation;
  final String vehicleId;
  final String driverNumber;
  final int? postId;

  const VehicleTrackingScreen({
    super.key,
    required this.startLocation,
    required this.endLocation,
    required this.vehicleId,
    required this.driverNumber,
    required this.postId,
  });

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return WebVehicleTracking(
        startLocation: startLocation,
        endLocation: endLocation,
      );
    }

    return VehicleTrackingWithTwoPolylines(
      startLocation: startLocation,
      endLocation: endLocation,
      vehicleId: vehicleId,
      driverNumber: driverNumber,
      postId: postId,
    );
  }
}
