import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/// Mobile only
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

/// Web only
import 'dart:html' as html;

class FileDownloader {
  static const String fileUrl =
      "https://s3.ap-south-1.amazonaws.com/tkd-images/1724739670774-full_truck_load_-_Copy.xlsx";

  static const String fileName = "full_truck_load.xlsx";

  static Future<void> downloadFile(BuildContext context) async {
    if (kIsWeb) {
      _downloadForWeb();
    } else {
      await _downloadForMobile(context);
    }
  }

  // ================= WEB =================

  static void _downloadForWeb() {
    final anchor = html.AnchorElement(href: fileUrl)
      ..setAttribute("download", fileName)
      ..style.display = "none";

    html.document.body!.append(anchor);
    anchor.click();
    anchor.remove();
  }

  // ================= MOBILE =================

  static Future<void> _downloadForMobile(BuildContext context) async {
    try {
      final response = await http.get(Uri.parse(fileUrl));

      if (response.statusCode != 200) {
        _showSnack(context, "Download failed");
        return;
      }

      Directory? directory;

      if (Platform.isAndroid) {
        directory = Directory("/storage/emulated/0/Download");
      } else if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
      }

      if (directory == null) {
        _showSnack(context, "Storage not available");
        return;
      }

      final filePath = "${directory.path}/$fileName";
      final file = File(filePath);

      await file.writeAsBytes(response.bodyBytes);

      OpenFile.open(filePath);
      _showSnack(context, "File downloaded successfully");
    } catch (e) {
      debugPrint("Download error: $e");
      _showSnack(context, "Something went wrong");
    }
  }

  static void _showSnack(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
