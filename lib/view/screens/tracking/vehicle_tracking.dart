import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import '../../../model/tracking_response.dart';
import '../../../util/app_constants.dart';
import '../../../util/colors.dart';
import '../../base_widget/app_constant.dart';

class VehicleTrackingWithTwoPolylines extends StatefulWidget {
  final LatLng startLocation;
  final LatLng endLocation;
  final int? postId;

  const VehicleTrackingWithTwoPolylines({
    super.key,
    required this.startLocation,
    required this.endLocation,
    required this.postId,
  });

  @override
  State<VehicleTrackingWithTwoPolylines> createState() =>
      _VehicleTrackingWithTwoPolylinesState();
}

class _VehicleTrackingWithTwoPolylinesState
    extends State<VehicleTrackingWithTwoPolylines> {
  GoogleMapController? _mapController;

  final Set<Polyline> _polylines = {};
  final Set<Marker> _markers = {};
  final List<LatLng> _coveredPath = [];

  Timer? _timer;
  BitmapDescriptor? _truckIcon;

  LatLng? _lastVehiclePosition;

  bool _isFetching = false;
  bool _isAnimating = false;
  bool _isInitialRouteDrawn = false;
  bool _followVehicle = true;
  bool _hasReachedDestination = false;

  static const double _destinationThresholdMeters = 50;

  // ================= INIT =================

  @override
  void initState() {
    super.initState();

    _addMarkers();
    _loadTruckIcon();
    _addPlannedRoute();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchVehicleLocation();
    });

    _timer = Timer.periodic(
      const Duration(seconds: 30),
          (_) => _fetchVehicleLocation(),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // ================= ICON =================

  Future<void> _loadTruckIcon() async {
    if (kIsWeb) {
      // ✅ WEB: default marker only
      _truckIcon = BitmapDescriptor.defaultMarker;
      return;
    }

   /* // ✅ ANDROID / IOS
    final data = await rootBundle.load('assets/images/truck.png');
    final codec = await instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: 80,
      targetHeight: 80,
    );
    final fi = await codec.getNextFrame();
    final bytes =
    (await fi.image.toByteData(format: ImageByteFormat.png))!
        .buffer
        .asUint8List();

    _truckIcon = BitmapDescriptor.fromBytes(bytes);*/
  }

  // ================= FETCH =================

  Future<void> _fetchVehicleLocation() async {
    if (_isFetching || _isAnimating || _hasReachedDestination) return;
    _isFetching = true;

    try {
      final res = await http.get(
        Uri.parse(ApiConstant.GET_LATLNG(widget.postId)),
      );

      if (res.statusCode == 200) {
        final json = jsonDecode(res.body);
        final tracking = TrackingResponse.fromJson(json);

        if (tracking.data != null && tracking.data!.isNotEmpty) {
          if (!_isInitialRouteDrawn) {
            _coveredPath.clear();

            for (final p in tracking.data!) {
              final point = LatLng(
                double.parse(p.latitude!),
                _normalizeLng(double.parse(p.longitude!)),
              );

              if (_coveredPath.isEmpty ||
                  !_isSamePoint(_coveredPath.last, point)) {
                _coveredPath.add(point);
              }
            }

            _lastVehiclePosition = _coveredPath.last;

            setState(() {
              _polylines.add(
                Polyline(
                  polylineId: const PolylineId("covered"),
                  color: Colors.blue,
                  width: 5,
                  points: List.from(_coveredPath),
                ),
              );

              _markers.add(
                Marker(
                  markerId: const MarkerId("vehicle"),
                  position: _lastVehiclePosition!,
                  icon: _truckIcon!,
                ),
              );
            });

            _isInitialRouteDrawn = true;
            _isFetching = false;
            return;
          }

          final last = tracking.data!.last;
          final newPos = LatLng(
            double.parse(last.latitude!),
            _normalizeLng(double.parse(last.longitude!)),
          );

          final distance =
          _calculateDistanceMeters(newPos, widget.endLocation);

          if (distance <= _destinationThresholdMeters) {
            _handleReachedDestination(newPos);
            _isFetching = false;
            return;
          }

          if (_lastVehiclePosition != null &&
              !_isSamePoint(_lastVehiclePosition!, newPos)) {
            _coveredPath.add(newPos);
            _trimPolyline();

            setState(() {
              _polylines.removeWhere(
                      (p) => p.polylineId.value == "covered");
              _polylines.add(
                Polyline(
                  polylineId: const PolylineId("covered"),
                  color: Colors.blue,
                  width: 5,
                  points: List.from(_coveredPath),
                ),
              );
            });
          }


          _lastVehiclePosition = newPos;
          _updateVehicleLocation(newPos);
        }
      }
    } catch (e) {
      debugPrint("❌ Tracking error: $e");
    }

    _isFetching = false;
  }

  // ================= DESTINATION =================

  void _handleReachedDestination(LatLng pos) {
    if (_hasReachedDestination) return;
    _hasReachedDestination = true;

    _timer?.cancel();

    setState(() {
      _markers.removeWhere(
              (m) => m.markerId == const MarkerId("vehicle"));
      _markers.add(
        Marker(
          markerId: const MarkerId("vehicle"),
          position: pos,
          icon: _truckIcon!,
        ),
      );
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Vehicle reached destination 🚩")),
    );
  }

  // ================= ANIMATION =================

  void _updateVehicleLocation(LatLng newPos) {
    if (_truckIcon == null || _isAnimating) return;
    _isAnimating = true;

    final oldMarker = _markers.firstWhere(
          (m) => m.markerId == const MarkerId("vehicle"),
    );

    final oldPos = oldMarker.position;
    final bearing = _getBearing(oldPos, newPos);

    const steps = 25;
    int i = 0;

    Timer.periodic(const Duration(milliseconds: 40), (t) {
      i++;
      final pos = LatLng(
        oldPos.latitude +
            (newPos.latitude - oldPos.latitude) * (i / steps),
        oldPos.longitude +
            (newPos.longitude - oldPos.longitude) * (i / steps),
      );

      setState(() {
        _markers.remove(oldMarker);
        _markers.add(
          Marker(
            markerId: const MarkerId("vehicle"),
            position: pos,
            icon: _truckIcon!,
            rotation: bearing,
          ),
        );
      });

      if (_followVehicle) {
        _mapController?.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: pos,
              zoom: 16,
              bearing: bearing,
            ),
          ),
        );
      }

      if (i >= steps) {
        t.cancel();
        _isAnimating = false;
      }
    });
  }

  // ================= HELPERS =================

  double _normalizeLng(double lng) {
    while (lng > 180) lng -= 360;
    while (lng < -180) lng += 360;
    return lng;
  }

  bool _isSamePoint(LatLng a, LatLng b) {
    return (a.latitude - b.latitude).abs() < 0.00001 &&
        (a.longitude - b.longitude).abs() < 0.00001;
  }

  void _trimPolyline() {
    const maxPoints = 500;
    if (_coveredPath.length > maxPoints) {
      _coveredPath.removeRange(
          0, _coveredPath.length - maxPoints);
    }

    _polylines
      ..removeWhere((p) => p.polylineId.value == "covered")
      ..add(
        Polyline(
          polylineId: const PolylineId("covered"),
          color: Colors.blue,
          width: 5,
          points: List.from(_coveredPath),
        ),
      );
  }

  double _getBearing(LatLng start, LatLng end) {
    final lat1 = start.latitude * pi / 180;
    final lat2 = end.latitude * pi / 180;
    final dLon = (end.longitude - start.longitude) * pi / 180;
    final y = sin(dLon) * cos(lat2);
    final x =
        cos(lat1) * sin(lat2) -
            sin(lat1) * cos(lat2) * cos(dLon);
    return (atan2(y, x) * 180 / pi + 360) % 360;
  }

  double _calculateDistanceMeters(LatLng a, LatLng b) {
    const r = 6371000;
    final dLat = (b.latitude - a.latitude) * pi / 180;
    final dLon = (b.longitude - a.longitude) * pi / 180;
    final lat1 = a.latitude * pi / 180;
    final lat2 = b.latitude * pi / 180;

    final h = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1) * cos(lat2) *
            sin(dLon / 2) * sin(dLon / 2);

    return 2 * r * asin(sqrt(h));
  }

  void _addMarkers() {
    _markers.addAll([
      Marker(
        markerId: const MarkerId("start"),
        position: widget.startLocation,
        icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueGreen),
      ),
      Marker(
        markerId: const MarkerId("end"),
        position: widget.endLocation,
        icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueRed),
      ),
    ]);
  }

  Future<void> _addPlannedRoute() async {
    const apiUrl =
        "https://routes.googleapis.com/directions/v2:computeRoutes";

    final body = {
      "origin": {
        "location": {
          "latLng": {
            "latitude": widget.startLocation.latitude,
            "longitude": widget.startLocation.longitude,
          }
        }
      },
      "destination": {
        "location": {
          "latLng": {
            "latitude": widget.endLocation.latitude,
            "longitude": widget.endLocation.longitude,
          }
        }
      },
      "travelMode": "DRIVE",
    };

    try {
      final res = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          "X-Goog-Api-Key": AppConstant.GOOGLE_KEY,
          "X-Goog-FieldMask": "routes.polyline.encodedPolyline",
        },
        body: jsonEncode(body),
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final encoded =
        data["routes"][0]["polyline"]["encodedPolyline"];

        final points = _decodePolyline(encoded);

        setState(() {
          _polylines.add(
            Polyline(
              polylineId: const PolylineId("planned"),
              color: Colors.red,
              width: 5,
              points: points,
            ),
          );
        });
      }
    } catch (e) {
      debugPrint("❌ Planned route error: $e");
    }
  }

  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> polyline = [];
    int index = 0;
    int lat = 0;
    int lng = 0;

    while (index < encoded.length) {
      int b;
      int shift = 0;
      int result = 0;

      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);

      int dlat = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lat += dlat;

      shift = 0;
      result = 0;

      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);

      int dlng = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lng += dlng;

      polyline.add(
        LatLng(
          lat / 1E5,
          lng / 1E5,
        ),
      );
    }

    return polyline;
  }

  // ================= UI =================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Vehicle Tracking"),
        backgroundColor: ThemeColor.red,
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: widget.startLocation,
          zoom: 12,
        ),
        markers: _markers,
        polylines: _polylines,
        onMapCreated: (c) => _mapController = c,
        onCameraMoveStarted: () => _followVehicle = false,
      ),
    );
  }
}
