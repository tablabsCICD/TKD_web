import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tkd_app/locator.dart';
import 'package:tkd_app/model/auth_api.dart';
import 'package:tkd_app/network/api_call.dart';
import 'package:tkd_app/network/geo_helper.dart';
import 'package:tkd_app/provider/auth_provider.dart';
import 'package:tkd_app/util/app_constants.dart';
import 'package:tkd_app/view/screens/bids/place_bid_deeplink.dart';
import 'package:tkd_app/view/screens/bids/show_bidds.dart';
import 'package:tkd_app/view/screens/dashboard/sharedPostDetailsScreen.dart';
import 'package:tkd_app/view/screens/menu_page.dart';
import 'package:tkd_app/view/screens/tracking/common_tracking_screen.dart';
import 'package:tkd_app/widgets/toast.dart';

import '../../../model/truck_load_model.dart';

class DeepLink extends StatefulWidget {
  final String id;
  final String type;
  const DeepLink({
    super.key,
    required this.type,
    required this.id,
  });

  @override
  State<DeepLink> createState() => _DeepLinkState();
}

class _DeepLinkState extends State<DeepLink> {
  final authProvider = locator<AuthProvider>();

  @override
  void initState() {
    super.initState();
    callApiPost();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Future<void> callApiPost() async {
    try {
      final User user = authProvider.userDetailList[0];
      final TruckLoad? load = await _fetchLoad(widget.id);
      if (load == null) {
        _goHomeWithToast("Error finding the load");
        return;
      }
      await _routeByType(load, user);
    } catch (e) {
      debugPrint("DeepLink Error => $e");
      _goHomeWithToast("Post is not available");
    }
  }

  Future<TruckLoad?> _fetchLoad(String postId) async {
    final urls = <String>[
      "${ApiConstant.BASE_URL}getGenericPostByPostId?postId=$postId",
      "${ApiConstant.BASE_URL}fullTruckLoad/$postId",
      "${ApiConstant.BASE_URL}fullTruckLoad?id=$postId",
    ];

    for (final url in urls) {
      try {
        debugPrint("DeepLink API URL => $url");
        final dynamic raw = await ApiHelper().ApiGetData(url);
        final TruckLoad? load = _parseLoad(raw);
        if (load != null) return load;
      } catch (e) {
        debugPrint("DeepLink fetch failed for $url => $e");
      }
    }
    return null;
  }

  TruckLoad? _parseLoad(dynamic raw) {
    dynamic decoded = raw;
    if (raw is String) {
      decoded = jsonDecode(raw);
    }

    if (decoded is Map<String, dynamic>) {
      if (decoded.containsKey('content') && decoded['content'] is List) {
        final List content = decoded['content'] as List;
        if (content.isNotEmpty && content.first is Map<String, dynamic>) {
          return TruckLoad.fromJson(content.first as Map<String, dynamic>);
        }
      }
      return TruckLoad.fromJson(decoded);
    }
    return null;
  }

  Future<void> _routeByType(TruckLoad load, User user) async {
    if (!mounted) return;

    final type = widget.type.toLowerCase();
    final isOwner = load.mobileNumber == user.mobileNumber;

    if (type == 'tracking') {
      await _openTracking(load);
      return;
    }

    if (type == 'post') {
      if (isOwner) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => ShowAllBids(id: widget.id)),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => SharedPostDetails(load)),
        );
      }
      return;
    }

    if (type == 'quote') {
      if (isOwner) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => ShowAllBids(id: widget.id)),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (_) => PlaceDeepBidScreen(truckLoad: load)),
        );
      }
      return;
    }

    _goHomeWithToast("Unsupported deep link type");
  }

  Future<void> _openTracking(TruckLoad load) async {
    if (kIsWeb) {
      await _showWebTrackingNotSupportedDialog();
      return;
    }

    final source = (load.source ?? '').trim();
    final destination = (load.destination ?? '').trim();
    if (source.isEmpty || destination.isEmpty) {
      _goHomeWithToast("Tracking is not available for this post");
      return;
    }

    final startCoords = await GeoHelper.getLatLngFromCity(source);
    final endCoords = await GeoHelper.getLatLngFromCity(destination);
    if (!mounted) return;
    if (startCoords == null || endCoords == null) {
      _goHomeWithToast("Unable to resolve route for tracking");
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => VehicleTrackingScreen(
          startLocation: LatLng(startCoords['lat']!, startCoords['lng']!),
          endLocation: LatLng(endCoords['lat']!, endCoords['lng']!),
          vehicleId: load.vehicleRegistrationNumber ?? "",
          driverNumber: "",
          postId: load.id,
        ),
      ),
    );
  }

  Future<void> _showWebTrackingNotSupportedDialog() async {
    if (!mounted) return;
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) {
        return AlertDialog(
          title: const Text("Tracking Not Supported"),
          content: const Text(
            "Driver tracking is not supported on web. "
            "From web we cannot get live latitude/longitude to track the vehicle.",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogCtx).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MenuPage(
                      userDetailList: authProvider.userDetailList,
                      selectedTab: "Home",
                    ),
                  ),
                );
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void _goHomeWithToast(String message) {
    if (!mounted) return;
    ToastMessage.show(context, message);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => MenuPage(
          userDetailList: authProvider.userDetailList,
          selectedTab: "Home",
        ),
      ),
    );
  }
}
