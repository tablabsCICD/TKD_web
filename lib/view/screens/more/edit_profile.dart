import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tkd_app/util/color-resource.dart';
import 'package:tkd_app/view/base_widget/appbar.dart';
import 'package:tkd_app/view/base_widget/custom_dropdown_list.dart';
import 'package:tkd_app/view/base_widget/utils.dart';

import '../../../dialog/CustomCityListDialog.dart';
import '../../../dialog/CustomStateListDialog.dart';
import '../../../dialog/animated_custom_dialog.dart';
import '../../../dialog/my_dialog.dart';
import '../../../locator.dart';
import '../../../provider/auth_provider.dart';
import '../../../util/ResponsiveWidget.dart';
import '../../../util/style.dart';
import '../../base_widget/custom_button.dart';
import '../../base_widget/custom_textfeild.dart';
import '../../base_widget/custom_textview.dart';
import '../../base_widget/cutom_city_textfield.dart';
import '../../base_widget/edit_box.dart';
import '../../base_widget/upload_text.dart';

class EditProfileScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return EditProfileState();
  }

}

class EditProfileState extends State<EditProfileScreen>{

  TextEditingController organizationController = TextEditingController();
  TextEditingController memberController = new TextEditingController();
  TextEditingController addressController = new TextEditingController();
  TextEditingController firstNameController = new TextEditingController();
  TextEditingController mobileController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController websiteController = new TextEditingController();
  TextEditingController lastNameController = new TextEditingController();
  TextEditingController companyNameController = new TextEditingController();
  TextEditingController aadharController = TextEditingController();
  TextEditingController panController = TextEditingController();
  TextEditingController transpoterOrAgentController = TextEditingController();
  String? selectedCity, selectedState;
  Uint8List? imageBytes;
  final authProvider = locator<AuthProvider>();
  String? fileName;
  @override
  void initState() {
    // TODO: implement initState
    authProvider.getUserDetails(authProvider.userDetailList[0].id!);
    firstNameController.text =
        authProvider.userDetailList[0].firstName.toString();
    lastNameController.text =
        authProvider.userDetailList[0].lastName.toString();
    mobileController.text =
        authProvider.userDetailList[0].mobileNumber.toString();
    emailController.text = authProvider.userDetailList[0].emailId.toString();
    companyNameController.text =
        authProvider.userDetailList[0].companyName.toString();
    addressController.text =
        authProvider.userDetailList[0].companyAddress.toString();
    websiteController.text = authProvider.userDetailList[0].website.toString();
    memberController.text = '';
    selectedCity = authProvider.userDetailList[0].city.toString();
    selectedState = authProvider.userDetailList[0].state.toString();
    panController.text=authProvider.userDetailList[0].panCardForVerification.toString();
    aadharController.text=authProvider.userDetailList[0].aadharCard.toString();
    transpoterOrAgentController.text = Utils().getTranport(authProvider.userDetailList[0].transporterOrAgent!);
    super.initState();
  }

  List<String> itemList = <String>[
    'Agent/Broker',
    'Transporter',
    'Packers and Movers',
    'Manufacturer/Distributor/Trade',
  ];
  var selectedPostType = ' ';

  @override
  Widget build(BuildContext context) {
   return Scaffold(

      appBar: AppBarCommon(context, title: "Edit Profile").appBar(),
      backgroundColor: ColorResources.PROFILE_BG,
      body:  Container(
        padding: EdgeInsets.only(left: 20,right: 20,top: 10),
        child: ListView(
          shrinkWrap: true,
          children: [

            CustomTextBoxField(
              hintText: 'First Name',
              controller: firstNameController,
              textInputType: TextInputType.number,
              isValidator: false,

            ),
            CustomTextBoxField(
              hintText: 'Last Name',
              controller: lastNameController,
              textInputType:
              TextInputType.emailAddress,
              isValidator: false,
            ),
            CustomTextBoxField(
              readOnly: true,
              hintText: 'Mobile Number',
              controller: mobileController,
              textInputType: TextInputType.number,
            ),
            CustomTextBoxField(
              readOnly: true,
              hintText: 'Enter Email Id',
              controller: emailController,
              textInputType: TextInputType.number,
            ),
            CustomTextBoxField(
              hintText: 'Company Name',
              controller: companyNameController,
              textInputType: TextInputType.text,
            ),
            CustomTextBoxField(
              hintText: 'Company Website',
              controller: websiteController,
              textInputType: TextInputType.text,
            ),
            CustomDropdownList(
              hintText: "Select Type",
              items: itemList,
              selectedType: selectedPostType,
              onChange: (String value) {
                setState(() {
                  selectedPostType = value;
                  transpoterOrAgentController.text = selectedPostType;
                });
              },
            ),
            CustomTextBoxField(
              hintText: 'Address',
              controller: addressController,
              textInputType: TextInputType.text,
            ),
            CustomCityTextField(
              isFromProfile: true,
              hintText: 'Select State',
              controller: selectedState!,
              onTap: () {
                showDialog(
                    context: context,
                    builder:
                        (BuildContext context) {
                      return CustomStateListDialog(
                          onTap: (String value) {
                            setState(() {
                              selectedState = value;
                            });
                          });
                    });
              },
            ),
            CustomCityTextField(
              isFromProfile: true,
              hintText: 'Select City',
              controller: selectedCity!,
              onTap: () {
                showDialog(
                    context: context,
                    builder:
                        (BuildContext context) {
                      return CustomCityListDialog(
                          onTap: (String value) {
                            setState(() {
                              selectedCity = value;
                            });
                          });
                    });
              },
            ),
            Visibility(
              visible: authProvider.userDetailList[0].aadharCard!.isEmpty==false?false:true,
              child: UploadTextField(
                hintText: 'Click to upload Aadhar Card',
                controller: aadharController,
                textInputType: TextInputType.text,
                readOnly: true,
                onTap: () async {
                  var doc = await pickFile(authProvider).then((value){
                    print("In pickfile response");
                    print(value);
                  });
                },
              ),
            ),
            Visibility(
              visible: authProvider.userDetailList[0].panCardForVerification!.isEmpty==false?false:true,
              child: UploadTextField(
                hintText: 'Click to upload Pan Card',
                controller: panController,
                textInputType: TextInputType.text,
                readOnly: true,
                onTap: () async {
                  var doc = await pickPanCard(authProvider).then((value){
                    print("In pickfile response");
                    print(value);
                  });
                },
              ),
            ),


            CustomButton(
                onTap: () async {
                  var result = await authProvider
                      .updateUser(
                    firstName:
                    firstNameController
                        .text,
                    lastName:
                    lastNameController.text,
                    mobileNumber: int.parse(
                        mobileController.text),
                    emailId:
                    emailController.text,
                    companyName:
                    companyNameController
                        .text,
                    companyAddress:
                    addressController.text,
                    state: selectedState,
                    city: selectedCity,
                    website:
                    websiteController.text,
                    aadharCard: aadharController.text,
                    panCardForVerification: panController.text,
                    transporterOrAgent: transpoterOrAgentController.text == "Agent/Broker"
                        ? 0
                        : transpoterOrAgentController.text == "Transporter"
                        ? 1
                        : transpoterOrAgentController.text == "Packers and Movers"
                        ? 2
                        : 3,

                  )
                      .then((value) => {
                    showAnimatedDialog(
                        context,
                        MyDialog(
                          icon: Icons.check,
                          title:
                          'Edit Profile',
                          description:
                          'Your Profile Updated successfully',
                          isFailed: false,
                        ),
                        dismissible: false,
                        isFlip: false),
                  });
                  if(result) {
                    Navigator.of(context).pop();
                  }
                },
                buttonText: 'Save'),
          ],
        ),
      ),
    );

  }
  PlatformFile? objFile;
  pickFile(AuthProvider model) async {
    var result = await FilePicker.platform.pickFiles(
      withReadStream:
      true, // this will return PlatformFile object with read stream
    );
    if (result != null) {
      setState(() {
        objFile = result.files.single;
      });
      try {
        fileName = result.files.first.name;
        print(result.files.first.toString());
        // imagefile = File(result.files.first.name);
        imageBytes = result.files.first.bytes;
        print(fileName);
        aadharController.text = fileName!;
        model.setImage(fileName);
        var docs =  await model.uploadAadharCard(imageFilePath: fileName,imageBytes: imageBytes,objectFile: objFile);
        print(docs);
        return docs;
      } catch (ex) {
        throw Exception("Exception Occurred ${ex.toString()}");
      }
    }
  }

  pickPanCard(AuthProvider model) async {
    var result = await FilePicker.platform.pickFiles(
      withReadStream:
      true, // this will return PlatformFile object with read stream
    );
    if (result != null) {
      setState(() {
        objFile = result.files.single;
      });
      try {
        fileName = result.files.first.name;
        print(result.files.first.toString());
        // imagefile = File(result.files.first.name);
        imageBytes = result.files.first.bytes;
        print(fileName);
        panController.text = fileName!;
        model.setImage(fileName);
        var docs =  await model.uploadPanCard(imageFilePath: fileName,imageBytes: imageBytes,objectFile: objFile);
        print(docs);
        return docs;
      } catch (ex) {
        throw Exception("Exception Occurred ${ex.toString()}");
      }
    }
  }



}