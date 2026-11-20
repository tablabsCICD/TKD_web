
import 'dart:io';
import 'dart:typed_data';
import 'dart:html' as html;
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tkd_app/dialog/animated_custom_dialog.dart';
import 'package:tkd_app/dialog/my_dialog.dart';
import 'package:tkd_app/locator.dart';
import 'package:tkd_app/provider/auth_provider.dart';
import 'package:tkd_app/provider/gallery_provider.dart';
import 'package:tkd_app/util/ResponsiveWidget.dart';
import 'package:tkd_app/view/base_widget/custom_button.dart';
import 'package:tkd_app/view/base_widget/custom_textfeild.dart';
import 'package:tkd_app/view/screens/gallery/image_picker_helper.dart';
class CreateGalleryPost extends StatefulWidget {
  @override
  _CreateGalleryPostState createState() => _CreateGalleryPostState();
}

class _CreateGalleryPostState extends State<CreateGalleryPost> {
  final TextEditingController description = TextEditingController();
  final TextEditingController title = TextEditingController();
  final TextEditingController photo = TextEditingController();
  final authProvider = locator<AuthProvider>();
  final _formKey = GlobalKey<FormState>();
  File? imageFile;
  Uint8List? imageBytes;
  String? fileName;
  PlatformFile? objFile;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Consumer<GalleryProvider>(
        builder: (context, model, child) => Container(
          margin: _getMargin(context),
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.all(16.0),
            children: [
              CustomTextField(
                hintText: 'Click here to select Photo',
                controller: photo,
                textInputType: TextInputType.text,
                readOnly: true,
                onTap: () => pickFile(model),
              ),
              if (model.image != null)
        CachedNetworkImage(
        imageUrl: model.image!,
        placeholder: (context, url) => CircularProgressIndicator(),
        errorWidget: (context, url, error) => Icon(Icons.error), // Fallback in case of decoding issues
      )
        else
                const Text("No image selected", style: TextStyle(color: Colors.grey)),

              CustomTextField(
                hintText: 'Title',
                controller: title,
                textInputType: TextInputType.text,
                isValidator: true,
                validatorMsg: 'Title cannot be empty',
              ),
              CustomTextField(
                hintText: 'Additional Information',
                controller: description,
                textInputType: TextInputType.text,
                isValidator: false,
                validatorMsg: 'Description cannot be empty',
              ),

              CustomButton(
                onTap: () async {
                  if (_formKey.currentState!.validate()) {
                    final result = await model.postGallery(
                      topicName: title.text,
                      userId: authProvider.userDetailList[0].id.toString(),
                      imageFile: imageFile,
                      description: description.text,
                      imageFilePath: fileName,
                      imageBytes: imageBytes,
                      objectFile: objFile,
                    );

                    if (result) {
                      showAnimatedDialog(
                        context,
                        MyDialog(
                          icon: Icons.check,
                          title: 'New Post',
                          description: 'Your post submitted successfully',
                          isFailed: false,
                        ),
                        dismissible: false,
                        isFlip: false,
                      );
                      Navigator.of(context).pop();
                    } else {
                      // Handle post failure
                    }
                  }
                },
                buttonText: "Post Announcement",
              ),
            ],
          ),
        ),
      ),
    );
  }


  /// Function to pick an image file using HTML File Input
  Future<Map<String, dynamic>?> pickImageForWeb() async {
    try {
      // Create an input element for file selection
      final html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
      uploadInput.accept = 'image/*'; // Accept only image files
      uploadInput.click(); // Simulate a click to open file picker dialog

      // Wait for the user to select a file
      await uploadInput.onChange.first;

      if (uploadInput.files != null && uploadInput.files!.isNotEmpty) {
        // Get the selected file
        final html.File file = uploadInput.files!.first;

        // Read the file as bytes
        final html.FileReader reader = html.FileReader();
        reader.readAsArrayBuffer(file);
        await reader.onLoad.first;

        // Extract file data
        final Uint8List fileBytes = reader.result as Uint8List;
        final String fileName = file.name;

        return {
          "fileName": fileName,
          "fileBytes": fileBytes,
        };
      } else {
        print("No file selected.");
        return null;
      }
    } catch (e) {
      print("Error picking image: $e");
      return null;
    }
  }

  void pickFile(GalleryProvider model) async {
    try {
      final result = await ImagePickerHelper().pickAndUploadImage(context);

      if (result != null) {
        setState(() {
         photo.text = result;
        });
        model.setImage(result);
      }
    } catch (e) {
      print("File selection error: $e");
      // Optionally show an error to the user
    }
  }

  EdgeInsets _getMargin(BuildContext context) {
    if (ResponsiveWidget.isDesktop(context)) {
      return const EdgeInsets.symmetric(horizontal: 50, vertical: 10);
    } else if (ResponsiveWidget.isMobile(context)) {
      return const EdgeInsets.symmetric(horizontal: 20, vertical: 10);
    } else {
      return const EdgeInsets.symmetric(horizontal: 100, vertical: 10);
    }
  }
}
