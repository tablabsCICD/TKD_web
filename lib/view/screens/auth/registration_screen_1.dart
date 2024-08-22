import 'dart:typed_data';
import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:tkd_app/provider/auth_provider.dart';
import 'package:tkd_app/util/ResponsiveWidget.dart';
import 'package:tkd_app/util/color-resource.dart';
import 'package:tkd_app/util/style.dart';
import 'package:tkd_app/view/base_widget/custom_button.dart';
import 'package:tkd_app/view/base_widget/custom_dropdown_list.dart';
import 'package:tkd_app/view/base_widget/custom_textfeild.dart';
import 'package:tkd_app/view/screens/auth/registration_screen_3.dart';
import 'package:universal_html/html.dart';
import 'login_screen.dart';
import 'registration_screen_2.dart';

class RegistrationScreen1 extends StatefulWidget {
  @override
  _RegistrationScreen1State createState() => _RegistrationScreen1State();
}

class _RegistrationScreen1State extends State<RegistrationScreen1> {
  TextEditingController firstNameController = new TextEditingController();
  TextEditingController lastNameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController businessController = new TextEditingController();
  TextEditingController mobileController = new TextEditingController();
  TextEditingController memberController = new TextEditingController();
  TextEditingController websiteController = new TextEditingController();
  TextEditingController stateController = new TextEditingController();
  TextEditingController cityController = new TextEditingController();
  TextEditingController addressController = new TextEditingController();
  TextEditingController aadharController = TextEditingController();
  TextEditingController panController = TextEditingController();
  var selectedPostType = ' ';
  String? selectedFromCity = '', selectedToCity = "";
  File? imagefile;
  Uint8List? imageBytes;
  String? fileName;
  List<String> itemList = <String>[
    'Agent/Broker',
    'Transporter',
    'Packers and Movers',
    'Manufacturer/Distributor/Trade',
  ];

  var _current = 0;
  List<ImageCarousel> carouselImages = [
    ImageCarousel('assets/images/man_01.png','assets/images/truck_01.png',"Grow your business","Multiply you business by getting vehicles at\n the right price at the right time.Also, do'nt loose any\n business which is not in your regular route of operations."),
    ImageCarousel('assets/images/man_01.png','assets/images/truck_01.png',"Grow your own business","Multiply you business by getting vehicles at\n the right price at the right time.Also, do'nt loose any\n business which is not in your regular route of operations."),
    ImageCarousel('assets/images/man_01.png','assets/images/truck_01.png',"Grow your tkd business","Multiply you business by getting vehicles at\n the right price at the right time.Also, do'nt loose any\n business which is not in your regular route of operations."),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: ResponsiveWidget.isMobile(context)
            ? Stack(children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: NetworkImage('assets/images/truck.png'),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      getCart(),
                    ],
                  ),
                ),
              ])
            : Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: [0.5, 0.5],
                            colors: [Colors.white, ColorResources.HOME_BG])
                    ),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(top:20.0),
                      child: SvgPicture.asset(
                        'assets/svg/logo.svg',
                        height: 90,
                        width: 120,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: getCart(),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: getDetails(),
                  ),
                ],
              ),
      ),
    );
  }

  final _formKey = GlobalKey<FormState>();

  getCart() {
    return Container(
      padding: ResponsiveWidget.isMobile(context)
          ? EdgeInsets.all(10)
          : EdgeInsets.only(left: 30, right: 30, bottom: 20),
      height: 650,
      width: ResponsiveWidget.isMobile(context)
          ? MediaQuery.of(context).size.width - 50
          : ResponsiveWidget.isDesktop(context)
              ? MediaQuery.of(context).size.width / 4.0
              : MediaQuery.of(context).size.width / 3,
      margin: ResponsiveWidget.isMobile(context)
          ? EdgeInsets.all(0)
          : ResponsiveWidget.isDesktop(context)
              ? EdgeInsets.only(left: MediaQuery.of(context).size.width / 8)
              : EdgeInsets.only(left: MediaQuery.of(context).size.width / 10),
      decoration: BoxDecoration(
        color: ColorResources.WHITE,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 5.0,
            spreadRadius: 2.0,
          ),
        ],
      ),
      child: Consumer<AuthProvider>(
        builder: (context, model, child) => Form(
          key: _formKey,
          child: ListView(
            children: [
              SizedBox(height:30),
              Center(
                child: SvgPicture.asset(
                  'assets/svg/logo.svg',
                  height: 50,
                  width: 100,
                ),
              ),
              SizedBox(height:20),
              Center(
                child: Text("Sign Up",
                    style: TextStyle(
                      fontFamily: 'RobotoSlab',
                      color: Colors.black,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.normal,
                    )),
              ),
              SizedBox(height:20),
              CustomTextField(
                hintText: 'Enter First Name',
                controller: firstNameController,
                textInputType: TextInputType.text,
                validatorMsg: 'Please enter your first name',
                isValidator: true,
                isName: true,
              ),
              CustomTextField(
                hintText: 'Enter Last Name',
                controller: lastNameController,
                textInputType: TextInputType.text,
                validatorMsg: 'Please enter your last name',
                isValidator: true,
                isName: true,
              ),
              CustomTextField(
                hintText: 'Enter Email',
                controller: emailController,
                textInputType: TextInputType.emailAddress,
                validatorMsg: 'Please enter your email',
                isValidator: true,
                isEmail: true,
              ),
              CustomTextField(
                hintText: 'Enter Mobile Number',
                controller: mobileController,
                isPhoneNumber: true,
                textInputType: TextInputType.number,
                isValidator: true,
              ),
              Visibility(
                visible: false,
                child: CustomTextField(
                hintText: 'Click to upload Aadhar Card',
                controller: aadharController,
                textInputType: TextInputType.text,
                readOnly: true,
                onTap: () async {
                  var doc = await pickFile(model).then((value){
                    print("In pickfile response");
                    print(value);
                  });
                  print(doc);
                },
              ),
              ),
              Visibility(
                visible: false,
                child: CustomTextField(
                hintText: 'Click to upload Pan Card',
                controller: panController,
                textInputType: TextInputType.text,
                readOnly: true,
                onTap: () async {
                  var doc = await pickPanCard(model).then((value){
                    print("In pickfile response");
                    print(value);
                  });
                  print(doc);
                },
              )),
              CustomDropdownList(
                hintText: "Select Type",
                items: itemList,
                selectedType: selectedPostType,
                onChange: (String value) {
                  setState(() {
                    selectedPostType = value;
                  });
                },
              ),
              selectedPostType == 'Shipper/Manufacturer/Distributor'
                  ? CustomTextField(
                      hintText: 'Type Of Business',
                      controller: businessController,
                      textInputType: TextInputType.number,
                    )
                  : SizedBox.shrink(),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 0.0, horizontal: 15),
                child: CustomButton(
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                     //   model.postProfilePicture('2880',imageFilePath: fileName,imageBytes:  imageBytes,objectFile: objFile);
                        selectedPostType == 'Agent' ||
                                selectedPostType == 'Transporter'
                            ? Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (builder) => RegistrationScreen3(
                                        firstNameController.text,
                                        lastNameController.text,
                                        emailController.text,
                                        mobileController.text,
                                        model.uploadedAadhar,
                                        model.uploadedPan,
                                        selectedPostType)))
                            : Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (builder) => RegistrationScreen2(
                                        firstNameController.text,
                                        lastNameController.text,
                                        emailController.text,
                                        mobileController.text,
                                        model.uploadedAadhar,
                                        model.uploadedPan,
                                        selectedPostType)));
                      }
                    },
                    buttonText: 'NEXT'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already Member?",
                      style:Style.newheading),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (builder) => Login_Screen()));
                    },
                    child: Text("Login Here",
                        style: Style.aleaready),
                  ),
                ],
              ),
              /* Row(
                //  mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Continue as a?",
                    style: Style.newheading,textAlign: TextAlign.center,),
                  InkWell(
                    onTap: (){
                      */ /*Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (builder) => MenuPage()));*/ /*
                    },
                    child: Text(" Guest",
                        style: Style.aleaready,textAlign: TextAlign.center),
                  ),
                ],
              )*/
            ],
          ),
        ),
      ),
    );
  }

  // getDetails() {
  //   return Container(
  //     height: 500,
  //     width: MediaQuery.of(context).size.width / 2,
  //     margin: ResponsiveWidget.isMobile(context)
  //         ? EdgeInsets.all(0)
  //         : ResponsiveWidget.isDesktop(context)
  //             ? EdgeInsets.only(right: MediaQuery.of(context).size.width / 19)
  //             : EdgeInsets.only(right: MediaQuery.of(context).size.width / 21),
  //     // margin: EdgeInsets.only(right: MediaQuery.of(context).size.width / 10),
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text("Your transport\nsearch ends here",
  //             style: TextStyle(
  //               fontFamily: 'PlayfairDisplay',
  //               color: Color(0xff202020),
  //               fontSize: 58,
  //               fontWeight: FontWeight.w900,
  //               fontStyle: FontStyle.normal,
  //               letterSpacing: 0,
  //             )),
  //         SizedBox(
  //           height: 50,
  //         ),
  //         new Text("* Suspendisse dapibus dui et leo rutrum",
  //             style: TextStyle(
  //               fontFamily: 'Roboto',
  //               color: Color(0xff000000),
  //               fontSize: 16,
  //               fontWeight: FontWeight.w300,
  //               fontStyle: FontStyle.normal,
  //               letterSpacing: -0.3,
  //             )),
  //         SizedBox(
  //           height: 16,
  //         ),
  //         new Text("* Lorem ipsum dolor sit amet",
  //             style: TextStyle(
  //               fontFamily: 'Roboto',
  //               color: Color(0xff000000),
  //               fontSize: 16,
  //               fontWeight: FontWeight.w300,
  //               fontStyle: FontStyle.normal,
  //               letterSpacing: -0.3,
  //             )),
  //         SizedBox(
  //           height: 16,
  //         ),
  //         new Text("* Quisque nec dui eleifend, tincidunt lectsectetur",
  //             style: TextStyle(
  //               fontFamily: 'Roboto',
  //               color: Color(0xff000000),
  //               fontSize: 16,
  //               fontWeight: FontWeight.w300,
  //               fontStyle: FontStyle.normal,
  //               letterSpacing: -0.3,
  //             )),
  //         SizedBox(
  //           height: 16,
  //         ),
  //         new Text("* Nunc non posuere sapien",
  //             style: TextStyle(
  //               fontFamily: 'Roboto',
  //               color: Color(0xff000000),
  //               fontSize: 16,
  //               fontWeight: FontWeight.w300,
  //               fontStyle: FontStyle.normal,
  //               letterSpacing: -0.3,
  //             )),
  //         SizedBox(
  //           height: 16,
  //         ),
  //         new Text("* Donec tincidunt odio in augue ornare",
  //             style: TextStyle(
  //               fontFamily: 'Roboto',
  //               color: Color(0xff000000),
  //               fontSize: 16,
  //               fontWeight: FontWeight.w300,
  //               fontStyle: FontStyle.normal,
  //               letterSpacing: -0.3,
  //             )),
  //         SizedBox(
  //           height: 50,
  //         ),
  //         Column(
  //           children: [
  //             Text("Android App Available On",
  //                 style: TextStyle(
  //                   fontFamily: 'RobotoSlab',
  //                   color: Colors.black,
  //                   fontSize: 14,
  //                   fontWeight: FontWeight.w400,
  //                   fontStyle: FontStyle.normal,
  //                 )),
  //             SizedBox(
  //               width: 20,
  //             ),
  //             InkWell(
  //               onTap: () {
  //                 openUrl();
  //               },
  //               child: Image.asset(
  //                 'assets/images/bitmap.png',
  //                 height: 50,
  //                 width: 100,
  //               ),
  //             )
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }
  int index = -1;
  getDetails(){
    return Container(
      height: 400,
      width: MediaQuery.of(context).size.width / 3,
      margin: EdgeInsets.only(left: MediaQuery.of(context).size.width / 10),
      child: Stack(
        children: [
          CarouselSlider(
            options: CarouselOptions(
              height: 500.0,
              aspectRatio: 16/9,
              enlargeCenterPage: false,
              viewportFraction: 1.0,
              initialPage: 0,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 3),
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              scrollDirection: Axis.horizontal,
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                });
              },
            ),
            items: carouselImages.map((i){
              index++;
              return Builder(
                  builder:(BuildContext context){
                    return Container(
                        height: MediaQuery.of(context).size.height*0.30,
                        width: MediaQuery.of(context).size.width,
                        child: index < 3?Stack(
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: Container(
                                    height: 500,
                                    width: MediaQuery.of(context).size.width / 4,
                                    alignment: Alignment.center,
                                    child: Padding(
                                      padding: const EdgeInsets.only(bottom: 20.0),
                                      child: Image.asset(
                                        carouselImages[index].image2,
                                        height: 72,
                                        width: 222,
                                      ),
                                    )),
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      carouselImages[index].image1,
                                      height: 234,
                                      width: 120,
                                    ),
                                    Text(carouselImages[index].title,
                                        style: Style.splashheading),
                                    new Text(
                                      carouselImages[index].subTitle,
                                      style: Style.splashContent,textAlign: TextAlign.center,),
                                  ],
                                ),
                              ),
                            ]):getWidget()
                    );
                  }
              );
            }).toList(),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: carouselImages.map((i) {
                int index = carouselImages.indexOf(i);
                return Container(
                  width: 6.0,
                  height: 6.0,
                  margin: EdgeInsets.symmetric(
                      vertical: 6.0, horizontal: 4.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _current == index
                        ? ColorResources.PRIMARY_COLOR
                        : ColorResources.DOT_COLOR,
                  ),
                );
              }).toList(),
            ),
          )
        ],
      ),
    );

  }
  getWidget() {
    index=0;
    return SizedBox.shrink();
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
