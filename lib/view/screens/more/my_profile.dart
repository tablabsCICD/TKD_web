import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:tkd_app/dialog/CustomCityListDialog.dart';
import 'package:tkd_app/dialog/CustomStateListDialog.dart';
import 'package:tkd_app/dialog/animated_custom_dialog.dart';
import 'package:tkd_app/dialog/my_dialog.dart';
import 'package:tkd_app/locator.dart';
import 'package:tkd_app/model/auth_api.dart';
import 'package:tkd_app/provider/auth_provider.dart';
import 'package:tkd_app/util/ResponsiveWidget.dart';
import 'package:tkd_app/util/color-resource.dart';
import 'package:tkd_app/util/colors.dart';
import 'package:tkd_app/util/style.dart';
import 'package:tkd_app/view/base_widget/app_constant.dart';
import 'package:tkd_app/view/base_widget/appbar.dart';
import 'package:tkd_app/view/base_widget/custom_button.dart';
import 'package:tkd_app/view/base_widget/custom_textfeild.dart';
import 'package:tkd_app/view/base_widget/custom_textview.dart';
import 'package:tkd_app/view/base_widget/cutom_city_textfield.dart';
import 'package:tkd_app/view/base_widget/getImage.dart';
import 'package:tkd_app/view/localization/language_constrants.dart';
import 'package:tkd_app/view/screens/more/edit_profile.dart';
import 'package:tkd_app/view/screens/my_routes/get_city_list.dart';
import 'package:tkd_app/view/screens/my_routes/get_state_list.dart';
import 'package:universal_html/js.dart';

import '../../base_widget/border_button.dart';
import '../../base_widget/utils.dart';

class MyProfile extends StatefulWidget {
  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  TextEditingController organizationController = TextEditingController();
  TextEditingController memberController = new TextEditingController();
  TextEditingController addressController = new TextEditingController();
  TextEditingController firstNameController = new TextEditingController();
  TextEditingController mobileController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController websiteController = new TextEditingController();
  TextEditingController lastNameController = new TextEditingController();
  TextEditingController companyNameController = new TextEditingController();
  String? selectedCity, selectedState;
  final authProvider = locator<AuthProvider>();

  @override
  void initState() {
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
     authProvider.getUserDetails(authProvider.userDetailList[0].id!);
    return Scaffold(
    //  appBar: AppBarCommon(context,title: 'My Profile').appBar(),
      backgroundColor: ThemeColor.baground,
      body: Consumer<AuthProvider>(
        builder: (context, model, child) => Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              Stack(
                children: [
                  model.userDetailList[0].companyLogo.toString() == ""
                      ? Icon(
                    Icons.account_circle,
                    size: 100,
                    color: Colors.grey,
                  )
                      : Container(
                      width: 100.0,
                      height: 100.0,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              fit: BoxFit.fill,
                              image: new NetworkImage(model
                                  .userDetailList[0].companyLogo
                                  .toString())))),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: InkWell(
                      onTap: () {
                        pickFile(model);
                      },
                      child: Container(
                        width: 25.0,
                        height: 25.0,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.black),
                        child: Icon(
                          Icons.camera_alt_outlined,
                          size: 15,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
            //  UserNameWithKyc()
            //,
              CustomText(
                '${model.userDetailList[0].companyName.toString()}',
                style: Style.menuHeading,
              ),
              SizedBox(
                height: 10,
              ),
              // model.userDetailList[0].isPaid == 0
              //     ? getMyPlanCard(
              //     context,
              //     'silver_plan',
              //     'plan_msg',
              //     'Free',
              //     'assets/images/silver.png',
              //     Color(0xff3d3d3d),
              //     Color(0xff9a9a9a))
              //     : model.userDetailList[0].isPaid == 10
              //     ? getMyPlanCard(
              //     context,
              //     'gold_plan',
              //     'plan_msg',
              //     '1,000',
              //     'assets/images/gold.png',
              //     Color(0xffde8b02),
              //     Color(0xfffacf5a))
              //     : model.userDetailList[0].isPaid == 20
              //     ? getMyPlanCard(
              //     context,
              //     'ruby_plan',
              //     'plan_msg',
              //     '2,000',
              //     'assets/images/platinum.png',
              //     Color(0xffab34e0),
              //     Color(0xff8fabff))
              //     : getMyPlanCard(
              //     context,
              //     'diamond_plan',
              //     'plan_msg',
              //     '3,000',
              //     'assets/images/diamond.png',
              //     Color(0xff0087ba),
              //     Color(0xff10c9d9)),
              selectedPlan(model.userDetailList[0]),
              SizedBox(
                height: 20,
              ),
              Divider(
                height: 1.5,
                thickness: 1.5,
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding:
                const EdgeInsets.only(left: 20.0, bottom: 10, right: 20),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          'Email_Id',
                          style: Style.title,
                        ),
                        SizedBox(height: 30,),
                        CustomText('Mobile Number', style: Style.title),
                        SizedBox(height: 30,),
                        //CustomText('Alternate Number', style: Style.title),
                        //SizedBox(height: 20,),
                        CustomText('Address', style: Style.title),
                        //   Text('User Type', style: Style.title),
                      ],
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            ': ${model.userDetailList[0].emailId.toString()}',

                            style:
                            TextStyle(color: ColorResources.PRIMARY_COLOR),
                          ),
                          SizedBox(height: 30,),
                          CustomText(
                            ': ${model.userDetailList[0].mobileNumber.toString()}',
                            style:
                            TextStyle(color: ColorResources.PRIMARY_COLOR),
                          ),
                          SizedBox(height: 30,),


                          CustomText(
                            ': ${model.userDetailList[0].companyAddress.toString()}',
                            style:
                            TextStyle(color: ColorResources.PRIMARY_COLOR),
                          ),

                          /* Text(
                            ': ${userDetailList.city.toString()}',
                            style: TextStyle(
                                color: ColorResources.PRIMARY_COLOR),
                          ),*/
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height:15,
              ),
              Center(
                child: kIsWeb?ElevatedButton(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Edit Profile Info',style: TextStyle(color: Colors.white),),
                  ),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: ColorResources.THEME_COLOR,
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.all(Radius.circular(5))),
                  ),
                  onPressed: () {
                    if(kIsWeb){
                      showDailog(context,authProvider);
                      //   Navigator.push(
                      //     context,
                      //     MaterialPageRoute(builder: (context) => EditProfileScreen()),
                      //   );
                    }else{
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => EditProfileScreen()),
                      );
                    }

                  },
                ):SizedBox(),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: kIsWeb?SizedBox() :BorderButton(
        buttonText: 'Edit Profile Info',
        onTap: () {
          if(kIsWeb){
            showDailog(context,authProvider);
          //   Navigator.push(
          //     context,
          //     MaterialPageRoute(builder: (context) => EditProfileScreen()),
          //   );
          }else{
            Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditProfileScreen()),
                );
          }

        },
      ),
    );
  }

  showDailog(BuildContext context,model){
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: Container(
              padding: ResponsiveWidget.isDesktop(context)
                  ? EdgeInsets.only(
                  left: 10, top: 10, right: 10, bottom: 10)
                  : EdgeInsets.symmetric(
                  horizontal: 0, vertical: 10),
              margin: ResponsiveWidget.isDesktop(context)
                  ? EdgeInsets.only(
                  top: 10,
                  left: 250,
                  right: 250,
                  bottom: 10)
                  : EdgeInsets.all(0),
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black,
                        offset: Offset(0, 10),
                        blurRadius: 10),
                  ]),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                          BorderRadius.circular(50)),
                      child: IconButton(
                        icon: Icon(
                          Icons.close,size: 18,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(20),
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: Icon(
                                  Icons.arrow_back_ios,
                                  size: 30,
                                  color: Colors.black,
                                )),
                            SizedBox(
                              width: 10,
                            ),
                            CustomText('Edit Profile',
                                style: Style.heading),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        CustomTextField(
                          hintText: 'First Name',
                          controller: firstNameController,
                          textInputType: TextInputType.number,
                          isValidator: false,
                        ),
                        CustomTextField(
                          hintText: 'Last Name',
                          controller: lastNameController,
                          textInputType:
                          TextInputType.emailAddress,
                          isValidator: false,
                        ),
                        CustomTextField(
                          hintText: 'Mobile Number',
                          controller: mobileController,
                          textInputType: TextInputType.number,
                        ),
                        CustomTextField(
                          hintText: 'Enter Email Id',
                          controller: emailController,
                          textInputType: TextInputType.number,
                        ),
                        CustomTextField(
                          hintText: 'Company Name',
                          controller: companyNameController,
                          textInputType: TextInputType.text,
                        ),
                        CustomTextField(
                          hintText: 'Company Website',
                          controller: websiteController,
                          textInputType: TextInputType.text,
                        ),
                        /* CustomTextField(
                                          hintText: 'Member Name',
                                          controller: memberController,
                                          textInputType: TextInputType.text,
                                        ),*/
                        CustomTextField(
                          hintText: 'Address',
                          controller: addressController,
                          textInputType: TextInputType.text,
                        ),
                        CustomCityTextField(
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
                        CustomButton(
                            onTap: () async {
                              var result = await model
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
                ],
              ),
            ),
          );
        });
  }

  getMyPlanCard(BuildContext context, String plan, String planDetails,
      String price, String image, Color color1, Color color2) {
    return Column(
      children: [
        Card(
          elevation: 0,
          child: Container(
            height: 40,
            width: 130,
            alignment: Alignment.center,
           // padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              gradient: LinearGradient(
                colors: [color1, color2],
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  image,
                  height: 20,
                  width: 20,
                ),
                SizedBox(width: 8,),
                CustomText(
                  getTranslated(plan, context)!,
                  style: Style.planTitle,


                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 2,
        ),
        CustomText(
          price,
          style: Style.menuHeading,
        ),
      ],
    );
  }

  PlatformFile? objFile;
  File? imagefile;
  Uint8List? imageBytes;
  String? fileName;

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
        //imagefile = File(result.files.first.name);
        imageBytes = result.files.first.bytes;
        print(fileName);
        model.setImage(fileName);
        model.updateProfilePicture(model.userDetailList[0].id.toString(),
            imageFilePath: fileName,
            imageBytes: imageBytes,
            objectFile: objFile);
      } catch (ex) {
        throw Exception("Exception Occurred ${ex.toString()}");
      }
    }
  }

  UserNameWithKyc() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [

        CustomText(
          '${authProvider.userDetailList[0].firstName.toString()} ${authProvider.userDetailList[0].lastName.toString()}',
          style: Style.profilename,
        ),
        SizedBox(width: 3,),
        Padding(
          padding:  EdgeInsets.only(top: 2.0),
          child: DecoratedBox(

            decoration:  BoxDecoration(color: authProvider.userDetailList[0].aadharCard!.isEmpty==false && authProvider.userDetailList[0].panCardForVerification!.isEmpty==false ?ColorResources.GREEN:ColorResources.RED,borderRadius: BorderRadius.circular(10)),
            child:  Padding(
              padding: const EdgeInsets.all(2.0),
              child:authProvider.userDetailList[0].aadharCard!.isEmpty==false && authProvider.userDetailList[0].panCardForVerification!.isEmpty==false ? Text(' KYC Done ',style: Style.boardButton1):Text(' KYC Pending ',style: Style.boardButton1),
            ),
          ),
        )
      ],
    );

  }



  selectedPlan(User user){
    return  Container(
      transform: Matrix4.translationValues(0.0, -10.0, 0.0),
      // width: 36.w,
      // height: 12.h,
      padding: EdgeInsets.symmetric(horizontal: 4),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            Utils().getSelectedPackageImage(user!.isPaid!),
            height: 8,
            width: 8,
          ),
          SizedBox(width: 4,),
          Text(
            Utils().getSelectedPackageName(user.isPaid!),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 8,
              fontFamily: AppConstant.FONTFAMILY

            ),
          ),
        ],
      ),
    );
  }


}
