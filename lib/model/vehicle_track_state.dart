import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tkd_app/model/vehicle_cluster_item.dart';

class VehicleTrackState {
  final String vehicleId;

  final List<LatLng> rawPoints = [];
  final List<LatLng> snappedPoints = [];

  LatLng? lastPosition;
  double speed = 0;

  bool followCamera = false;
  bool reachedDestination = false;

  VehicleTrackState(this.vehicleId);

  VehicleStatus get status =>
      speed > 1 ? VehicleStatus.moving : VehicleStatus.idle;
}
