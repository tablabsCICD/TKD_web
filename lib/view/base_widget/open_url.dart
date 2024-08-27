
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

openUrl(){
  try {
    launchUrl(Uri.parse("${"https://play.google.com/store/apps/details?id=" + "com.pdk.tkd"}"));
  } on PlatformException {
    launchUrl(Uri.parse("${"https://play.google.com/store/apps/details?id=" + "com.pdk.tkd"}"));
  } finally {
  }
}