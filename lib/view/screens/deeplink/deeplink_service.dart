import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:tkd_app/main.dart';
import 'deeplinkscreen.dart';

class DeepLinkService {
  DeepLinkService._internal();
  static final DeepLinkService _instance = DeepLinkService._internal();
  factory DeepLinkService() => _instance;

  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _sub;
  String? _lastHandledLink;
  bool _isInitialized = false;
  bool isDeepLinkActive = false;

  Future<void> init() async {
    if (_isInitialized) return;
    _isInitialized = true;

    try {
      final Uri? initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        _handleUri(initialUri);
      }

      _sub = _appLinks.uriLinkStream.listen(
        (Uri uri) => _handleUri(uri),
        onError: (e) => debugPrint("Deep link stream error: $e"),
      );
    } catch (e) {
      debugPrint("Deep link init error: $e");
    }
  }

  void _handleUri(Uri uri) {
    final linkKey = uri.toString();
    if (_lastHandledLink == linkKey) return;
    _lastHandledLink = linkKey;

    final payload = _parse(uri);
    if (payload == null) {
      debugPrint("Invalid deep link format: $uri");
      return;
    }

    isDeepLinkActive = true;
    _navigateWhenReady(() {
      final nav = navigatorKey.currentState;
      if (nav == null) {
        debugPrint("Navigator not ready yet");
        return;
      }

      nav.pushReplacement(
        MaterialPageRoute(
          builder: (_) => DeepLink(id: payload.id, type: payload.type),
        ),
      );
    });
  }

  _Payload? _parse(Uri uri) {
    final id = uri.queryParameters['id'];
    if (id == null || id.isEmpty) return null;

    String type = uri.queryParameters['type']?.toLowerCase() ?? 'post';
    final segments = uri.pathSegments.map((e) => e.toLowerCase()).toList();
    final tkdIndex = segments.indexOf('tkd');
    if (tkdIndex != -1 && tkdIndex + 1 < segments.length) {
      type = segments[tkdIndex + 1];
    } else if (segments.isNotEmpty) {
      final last = segments.last;
      if (last == 'post' || last == 'quote' || last == 'tracking') {
        type = last;
      }
    }

    if (type != 'post' && type != 'quote' && type != 'tracking') {
      type = 'post';
    }

    return _Payload(id: id, type: type);
  }

  void _navigateWhenReady(VoidCallback action, {int attempt = 0}) {
    final nav = navigatorKey.currentState;
    if (nav != null) {
      action();
      return;
    }

    if (attempt >= 10) {
      debugPrint("Navigator not ready after retries");
      return;
    }

    Future.delayed(
      const Duration(milliseconds: 300),
      () => _navigateWhenReady(action, attempt: attempt + 1),
    );
  }

  void dispose() {
    _sub?.cancel();
    _isInitialized = false;
  }
}

class _Payload {
  final String id;
  final String type;
  const _Payload({required this.id, required this.type});
}
