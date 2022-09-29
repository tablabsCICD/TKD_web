
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tkd_app/dialog/animated_custom_dialog.dart';
import 'package:tkd_app/dialog/my_dialog.dart';
import 'package:tkd_app/locator.dart';
import 'package:tkd_app/provider/auth_provider.dart';
import 'package:tkd_app/provider/gallery_provider.dart';
import 'package:tkd_app/util/ResponsiveWidget.dart';
import 'package:tkd_app/util/color-resource.dart';
import 'package:tkd_app/view/base_widget/custom_button.dart';
import 'package:tkd_app/view/base_widget/custom_textfeild.dart';
import 'package:tkd_app/view/base_widget/custom_textview.dart';

class CreateGalleryPost extends StatefulWidget {
  @override
  _CreateGalleryPostState createState() => _CreateGalleryPostState();
}

class _CreateGalleryPostState extends State<CreateGalleryPost> {

  TextEditingController description = TextEditingController();
  TextEditingController title = TextEditingController();
  TextEditingController photo = TextEditingController();
  final authProvider = locator<AuthProvider>();
  File? imagefile;
  Uint8List? imageBytes;
  String? fileName;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Consumer<GalleryProvider>(
        builder: (context, model, child) =>
            Container(
              margin: ResponsiveWidget.isDesktop(context)? EdgeInsets.symmetric(horizontal: 50,vertical: 10):ResponsiveWidget.isMobile(context)?EdgeInsets.symmetric(horizontal: 20,vertical: 10):EdgeInsets.symmetric(horizontal: 100,vertical: 10),
              child: ListView(
                shrinkWrap: true,
                children: [
                  CustomTextField(
                    hintText: 'Click here to select Photo',
                    controller: photo,
                    textInputType: TextInputType.text,
                    readOnly: true,
                    onTap: (){
                      pickFile(model);
                    },
                  ),
                  //    model.image != null?Image.network(model.image!,height: 100,width: 100,):SizedBox.shrink(),

                  CustomTextField(
                    hintText: 'Title',
                    controller: title,
                    textInputType: TextInputType.text,
                  ),
                  CustomTextField(
                    hintText: 'Additional Information',
                    controller: description,
                    textInputType: TextInputType.text,
                   ),

                  CustomButton(onTap: ()async {
                    if (_formKey.currentState!.validate()) {
                      var result = model.postGallery(topicName: title.text,userId: authProvider.userDetailList[0].id.toString(),
                          imageFile: imagefile,description: description.text,imageFilePath: fileName,
                          imageBytes:  imageBytes,objectFile: objFile).then((value) => {
                        showAnimatedDialog(
                            context,
                            MyDialog(
                              icon: Icons.check,
                              title:
                              'New Post',
                              description:
                              'Your post submitted successfully',
                              isFailed: false,
                            ),
                            dismissible: false,
                            isFlip: false),
                      });
                      if(result) {
                        Navigator.of(context).pop();
                      }}
                  },
                      buttonText: "Post Announcement")
                ],
              ),
            ),
      ),
    );
    /*return Scaffold(
      backgroundColor: ColorResources.HOME_BG,
      appBar: AppBar(
        title: CustomText('New Announcement',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
        backgroundColor: ColorResources.PRIMARY_COLOR,
      ),
      body: Form(
        key: _formKey,
        child: Consumer<GalleryProvider>(
          builder: (context, model, child) =>
              Container(
                margin: ResponsiveWidget.isDesktop(context)? EdgeInsets.symmetric(horizontal: 200,vertical: 10):ResponsiveWidget.isMobile(context)?EdgeInsets.symmetric(horizontal: 20,vertical: 10):EdgeInsets.symmetric(horizontal: 100,vertical: 10),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                   CustomTextField(
                      hintText: 'Click here to select Photo',
                      controller: photo,
                      textInputType: TextInputType.text,
                     readOnly: true,
                     onTap: (){
                        pickFile(model);
                     },
                    ),
               //    model.image != null?Image.network(model.image!,height: 100,width: 100,):SizedBox.shrink(),

                    CustomTextField(
                      hintText: 'Title',
                      controller: title,
                      textInputType: TextInputType.text,
                    ),
                    CustomTextField(
                      hintText: 'Additional Information',
                      controller: description,
                      textInputType: TextInputType.text,
                      isValidator: false,
                    ),

                    CustomButton(onTap: (){
    if (_formKey.currentState!.validate()) {
                      model.postGallery(topicName: title.text,userId: authProvider.userDetailList[0].id.toString(),imageFile: imagefile,description: description.text,imageFilePath: fileName,imageBytes:  imageBytes,objectFile: objFile);
                      Navigator.of(context).pop();}
                    },
                        buttonText: "Post Announcement")
                  ],
                ),
              ),
        ),
      ),
    );*/
  }

  PlatformFile? objFile;
  pickFile(GalleryProvider model) async {

    var result = await FilePicker.platform.pickFiles(
      withReadStream:true, // this will return PlatformFile object with read stream
    );
    if (result != null) {
      setState(() {
        objFile = result.files.single;
      });
      try {
        fileName = result.files.first.name;
        print(result.files.first.toString());
        imagefile = File(result.files.first.name);
        imageBytes = result.files.first.bytes;
        print(fileName);
        photo.text = fileName!;
        model.setImage(fileName);

      } catch (ex) {
        throw Exception("Exception Occurred ${ex.toString()}");
      }
    }
    //pick file from device
  /*  FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      try {
        fileName = result.files.first.name;
        print(result.files.first.toString());
        imagefile = File(result.files.first.name);
        imageBytes = result.files.first.bytes;
        print(fileName);
      //  print(result.files.first.path);
        photo.text = fileName!;
        model.setImage(fileName);

      } catch (ex) {
        throw Exception("Exception Occurred ${ex.toString()}");
      }
    }*/
  }
}
