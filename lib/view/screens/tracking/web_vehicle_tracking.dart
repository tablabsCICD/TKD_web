import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tkd_connect/constant/app_constant.dart';

class WebVehicleTracking extends StatelessWidget {
  final LatLng startLocation;
  final LatLng endLocation;

  const WebVehicleTracking({
    super.key,
    required this.startLocation,
    required this.endLocation,
  });

  @override
  Widget build(BuildContext context) {
    final mapUrl =
        "https://www.google.com/maps/embed/v1/directions"
        "?key=${AppConstant.GOOGLE_KEY}"
        "&origin=${startLocation.latitude},${startLocation.longitude}"
        "&destination=${endLocation.latitude},${endLocation.longitude}"
        "&mode=driving";

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Vehicle Tracking',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.red,
      ),
      body: HtmlElementView(
        viewType: 'google-map',
      ),
    );
  }
}
