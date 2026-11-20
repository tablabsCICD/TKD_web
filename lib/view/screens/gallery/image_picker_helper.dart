import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:html' as html; // For web support
import 'dart:io' as io;

import '../../../util/app_constants.dart'; // Update with your constants path

class ImagePickerHelper {
  final ImagePicker _picker = ImagePicker();

  /// Function to pick and upload an image
  Future<String?> pickAndUploadImage(BuildContext context) async {
    const String apiUrl = "https://api.tkdost.com/tkd2/api/uploadImages";

    try {
      // Platform check for Web
      if (kIsWeb) {
        html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
        uploadInput.accept = 'image/*';
        uploadInput.click();

        final completer = Completer<html.File?>();
        uploadInput.onChange.listen((event) {
          if (uploadInput.files != null && uploadInput.files!.isNotEmpty) {
            completer.complete(uploadInput.files!.first);
          } else {
            completer.complete(null);
          }
        });

        final html.File? webFile = await completer.future;

        if (webFile == null) {
          print("No file selected on web.");
          return null;
        }

        final reader = html.FileReader();
        reader.readAsArrayBuffer(webFile);
        await reader.onLoad.first;

        final Uint8List fileBytes = reader.result as Uint8List;

        var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
        request.headers.addAll({"accept": "*/*", "Content-Type": "multipart/form-data"});

        request.files.add(http.MultipartFile.fromBytes(
          'profilePicture',
          fileBytes,
          filename: webFile.name,
        ));

        final response = await request.send();

        if (response.statusCode == 200) {
          var responseBody = await response.stream.bytesToString();
          var jsonResponse = json.decode(responseBody);
          return jsonResponse; // Adjust the key based on your API response
        } else {
          print("Failed to upload image on web: ${response.reasonPhrase}");
          return null;
        }
      } else {
        // Show Bottom Sheet for source selection on mobile
        ImageSource? source = await _showImageSourceDialog(context);
        if (source == null) {
          print("Image selection cancelled.");
          return null;
        }

        // Pick an image
        final XFile? pickedFile = await _picker.pickImage(
          source: source,
          maxWidth: 1024,
          maxHeight: 1024,
          imageQuality: 85,
        );

        if (pickedFile == null) {
          print("No image selected.");
          return null;
        }

        io.File imageFile = io.File(pickedFile.path);

        // Create a Multipart Request
        var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
        request.headers.addAll({"accept": "*/*", "Content-Type": "multipart/form-data"});

        request.files.add(await http.MultipartFile.fromPath(
          'profilePicture',
          imageFile.path,
        ));

        // Send the request
        final response = await request.send();

        if (response.statusCode == 200) {
          var responseBody = await response.stream.bytesToString();
          var jsonResponse = json.decode(responseBody);
          return jsonResponse; // Adjust the key based on your API response
        } else {
          print('Failed to upload image: ${response.reasonPhrase}');
          return null;
        }
      }
    } catch (e) {
      print("Error picking or uploading image: $e");
      return null;
    }
  }

  /// Helper function to show a bottom dialog for image source selection
  Future<ImageSource?> _showImageSourceDialog(BuildContext context) async {
    return showModalBottomSheet<ImageSource>(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Camera'),
                onTap: () => Navigator.pop(context, ImageSource.camera),
              ),
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Gallery'),
                onTap: () => Navigator.pop(context, ImageSource.gallery),
              ),
            ],
          ),
        );
      },
    );
  }}