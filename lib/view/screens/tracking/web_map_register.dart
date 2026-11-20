import 'package:flutter/foundation.dart';

/// IMPORTANT:
/// dart:html + dart:ui_web MUST be used together
/// and ONLY in web-specific files
///
/// This file MUST NOT be imported in mobile code.

import 'dart:html' as html;
import 'dart:ui_web' as ui_web;

void registerWebMap(String mapUrl) {
  if (!kIsWeb) return;

  ui_web.platformViewRegistry.registerViewFactory(
    'google-map',
        (int viewId) {
      final iframe = html.IFrameElement()
        ..width = '100%'
        ..height = '100%'
        ..src = mapUrl
        ..style.border = 'none';

      return iframe;
    },
  );
}
