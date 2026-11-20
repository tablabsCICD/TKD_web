import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tkd_app/view/screens/tracking/vehicle_tracking.dart';

import '../../../util/colors.dart';

class WebVehicleTracking extends StatelessWidget {
  final LatLng startLocation;
  final LatLng endLocation;
  final int postId;


  const WebVehicleTracking({
    super.key,
    required this.startLocation,
    required this.endLocation,
    required this.postId,

  });

  @override
  Widget build(BuildContext context) {
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
        backgroundColor: ThemeColor.red,
      ),

      /// 🔥 SAME TRACKING WIDGET AS ANDROID
      body: VehicleTrackingWithTwoPolylines(
        startLocation: startLocation,
        endLocation: endLocation,

        postId: postId,
      ),
    );
  }
}
