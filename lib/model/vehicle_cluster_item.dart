import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

enum VehicleStatus { moving, idle }


class VehicleClusterItem with ClusterItem {
  final String vehicleId;
  LatLng position;
  VehicleStatus status;

  VehicleClusterItem({
    required this.vehicleId,
    required this.position,
    required this.status,
  });

  @override
  LatLng get location => position;
}
