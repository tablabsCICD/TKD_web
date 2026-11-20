import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';
import 'package:tkd_app/dialog/CustomCityListDialog.dart';
import 'package:tkd_app/dialog/CustomStateListDialog.dart';
import 'package:tkd_app/model/language_model.dart';
import 'package:tkd_app/provider/auth_provider.dart';
import 'package:tkd_app/provider/localization_provider.dart';
import 'package:tkd_app/util/ResponsiveWidget.dart';
import 'package:tkd_app/util/app_constants.dart';
import 'package:tkd_app/util/color-resource.dart';
import 'package:tkd_app/util/style.dart';
import 'package:tkd_app/view/base_widget/custom_button.dart';
import 'package:tkd_app/view/base_widget/custom_textfeild.dart';
import 'package:tkd_app/view/base_widget/custom_textview.dart';
import 'package:tkd_app/view/base_widget/cutom_city_textfield.dart';
import 'package:tkd_app/view/localization/language_constrants.dart';
import '../../base_widget/app_constant.dart';
import 'login_screen.dart';
import 'otp_screen.dart';

import 'dart:html' as html;

class RegistrationScreen2 extends StatefulWidget {
  String firstName, lastName, email, selctedType, mobileNumber,adharCard,panCard;

  RegistrationScreen2(this.firstName, this.lastName, this.email,
      this.mobileNumber,this.adharCard, this.panCard,this.selctedType);

  @override
  _RegistrationScreen2State createState() => _RegistrationScreen2State();
}

class _RegistrationScreen2State extends State<RegistrationScreen2> {
  TextEditingController firstNameController = new TextEditingController();
  TextEditingController lastNameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController companyController = new TextEditingController();
  TextEditingController mobileController = new TextEditingController();
  TextEditingController memberController = new TextEditingController();
  TextEditingController websiteController = new TextEditingController();
  TextEditingController addressController = new TextEditingController();
  TextEditingController langController = new TextEditingController();
  String? selectedCity = 'Pune', selectedState = 'Maharastra';
  bool agree = false;
  String countryValue = "";
  String stateValue = "";
  String cityValue = "";
  String address = "";
  String selectedLang = 'English';
  static List<LanguageModel> languages = [
    LanguageModel(
        imageUrl: '',
        languageName: 'English',
        countryCode: 'US',
        languageCode: 'en',
        isSelected: true),
    LanguageModel(
        imageUrl: '',
        languageName: 'हिंदी',
        countryCode: 'IN',
        languageCode: 'hi',
        isSelected: false),
    LanguageModel(
        imageUrl: '',
        languageName: 'मराठी',
        countryCode: 'IN',
        languageCode: 'mr',
        isSelected: false),
    LanguageModel(
        imageUrl: '',
        languageName: 'ಕನ್ನಡ',
        countryCode: 'IN',
        languageCode: 'kn',
        isSelected: false),
    LanguageModel(imageUrl: '', languageName: 'മലയാളം', countryCode: 'IN', languageCode: 'ml',isSelected: false),
    LanguageModel(imageUrl: '', languageName: 'తెలుగు', countryCode: 'IN', languageCode: 'te',isSelected: false),
    LanguageModel(imageUrl: '', languageName: 'தமிழ்', countryCode: 'IN', languageCode: 'ta',isSelected: false),
  ];

  var _current = 0;
  List<ImageCarousel> carouselImages = [
    ImageCarousel('assets/images/man_01.png','assets/images/truck_01.png',"Grow your business","Multiply you business by getting vehicles at\n the right price at the right time.Also, do'nt loose any\n business which is not in your regular route of operations."),
    ImageCarousel('assets/images/man_01.png','assets/images/truck_01.png',"Grow your own business","Multiply you business by getting vehicles at\n the right price at the right time.Also, do'nt loose any\n business which is not in your regular route of operations."),
    ImageCarousel('assets/images/man_01.png','assets/images/truck_01.png',"Grow your tkd business","Multiply you business by getting vehicles at\n the right price at the right time.Also, do'nt loose any\n business which is not in your regular route of operations."),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    langController.text = "English";
  }
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
                      //  getDetails(),
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
    return Consumer<AuthProvider>(
      builder: (context, model, child) => Container(
        padding: ResponsiveWidget.isMobile(context)
            ? EdgeInsets.all(10):EdgeInsets.only(left: 30, right: 30, bottom: 20),
        height: 650,
        width: ResponsiveWidget.isMobile(context)
            ? MediaQuery.of(context).size.width - 100
            : MediaQuery.of(context).size.width / 3.9,
        margin: EdgeInsets.only(left: MediaQuery.of(context).size.width / 10),
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
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(height:30),
               /* Center(
                  child: SvgPicture.asset(
                    'assets/svg/logo.svg',
                    height: 50,
                    width: 100,
                  ),
                ),
                SizedBox(height:20),*/
                CustomTextField(
                  hintText: 'Company Name',
                  controller: companyController,
                  textInputType: TextInputType.text,
                  isValidator: false,
                ),
               /* CustomTextField(
                  hintText: 'Member Name',
                  controller: memberController,
                  textInputType: TextInputType.text,
                ),*/
                CustomTextField(
                  hintText: 'Company Website',
                  controller: websiteController,
                  textInputType: TextInputType.text,
                  isValidator: false,
                ),
                CustomCityTextField(
                  label: 'Select State',
                  value: selectedState!,
                  onTap: () {
                    showDialog(context: context,
                        builder: (BuildContext context){
                          return CustomStateListDialog(
                            onTap : (String value){
                              setState(() {
                                selectedState = value;
                              });
                            }
                          );
                        }
                    ) ;

                  /*  Navigator.push(context,
                            MaterialPageRoute(builder: (context) => GetStateList()))
                        .then((value) {
                      if (value.toString().isNotEmpty && value != null) {
                        selectedState = value[0];
                        setState(() {});
                      }
                    });
                    setState(() {});*/
                  },
                ),
                CustomCityTextField(
                  label: 'Select City',
                  value: selectedCity!,
                  onTap: () {
                    showDialog(context: context,
                        builder: (BuildContext context){
                          return CustomCityListDialog(
                              onTap : (String value){
                                setState(() {
                                  selectedCity = value;
                                });
                              }
                          );
                        }
                    ) ;
                  },
                ),
                CustomTextField(
                  hintText: 'Company Address',
                  controller: addressController,
                  textInputType: TextInputType.text,
                  isValidator: false,
                ),
                CustomCityTextField(
                  label: 'Select Language',
                  value: langController.text,
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Container(
                            child: AlertDialog(
                              title: Center(
                                  child: CustomText(
                                "Select a language",
                                style: Style.title,
                              )),
                              content: Container(
                                width: 340,
                                height: 220,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20)),
                                padding: EdgeInsets.fromLTRB(0, 10, 10, 0),
                                child: Column(children: [
                                  CustomText(
                                    "Select your preferred language for using TKDost",
                                    style: Style.subtitle,
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Expanded(
                                    child: StaggeredGridView.countBuilder(
                                      physics: ScrollPhysics(),
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 12,
                                      itemCount: languages.length,
                                      itemBuilder: (context, index) {
                                        return InkWell(
                                          onTap: () {
                                            setState(() {
                                              ApiConstant.languages[index].isSelected = !ApiConstant.languages[index].isSelected;
                                              ApiConstant.languages.forEach((element) {
                                                if (element.languageCode != ApiConstant.languages[index].languageCode) {
                                                  element.isSelected = false;
                                                }
                                              });
                                              if (ApiConstant.languages[index].isSelected == true) {
                                                selectedLang = ApiConstant.languages[index]
                                                    .languageName
                                                    .toString();
                                                selectedLang == 'हिंदी'
                                                    ? index = 1
                                                    : selectedLang == 'मराठी'
                                                        ? index = 2
                                                        : selectedLang == 'ಕನ್ನಡ'
                                                            ? index = 3
                                                    : selectedLang == 'മലയാളം'
                                                    ? index = 4
                                                    :selectedLang == 'తెలుగు'
                                                    ? index = 5
                                                    : selectedLang == 'தமிழ்'
                                                    ? index = 6
                                                    : index = 0;
                                                Provider.of<LocalizationProvider>(
                                                        context,
                                                        listen: false)
                                                    .setLanguage(Locale(
                                                  ApiConstant.languages[index]
                                                      .languageCode!,
                                                  ApiConstant
                                                      .languages[index].countryCode,
                                                ));
                                              }
                                            });
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            padding:
                                                EdgeInsets.symmetric(vertical: 5),
                                            decoration: BoxDecoration(
                                                color: ApiConstant.languages[index]
                                                            .isSelected ==
                                                        true
                                                    ? ColorResources.PRIMARY_COLOR
                                                    : Colors.white,
                                                border: Border.all(
                                                    color: ColorResources
                                                        .PRIMARY_COLOR),
                                                borderRadius:
                                                    BorderRadius.circular(25)),
                                            child: Text(
                                                ApiConstant.languages[index]
                                                    .languageName
                                                    .toString(),
                                                style: TextStyle(color:ApiConstant.languages[index]
                                                    .isSelected ==
                                                    false
                                                    ? ColorResources.PRIMARY_COLOR
                                                    : Colors.white)),
                                          ),
                                        );
                                      },
                                      shrinkWrap: true,
                                      staggeredTileBuilder: (int index) =>
                                          StaggeredTile.fit(1),
                                    ),
                                  ),
                                ]),
                              ),
                              actions: [
                                Container(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.white, backgroundColor: Colors.black,
                                      elevation: 3,
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5))),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Skip'),
                                  ),
                                  padding: EdgeInsets.only(bottom: 30),
                                ),
                                Container(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.white, backgroundColor: Colors.black,
                                      elevation: 3,
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5))),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        langController.text = selectedLang;
                                      });
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Proceed'),
                                  ),
                                  padding: EdgeInsets.only(bottom: 30),
                                )
                              ],
                            ),
                          );
                        });


                  },
                ),
                Row(
                  children: [
                    Material(
                      child: Checkbox(
                        activeColor: ColorResources.PRIMARY_COLOR,
                        checkColor: ColorResources.WHITE,
                        value: agree,
                        onChanged: (value) {
                          setState(() {
                            agree = value ?? false;
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          html.window.open(
                              AppConstant().TERMS_AND_CONDITION,
                              "_blank" /*,"_self"*/);
                        },
                        child: CustomText(
                          'I have read and accept terms and conditions',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: ColorResources.PRIMARY_COLOR,
                              decoration: TextDecoration.underline),
                        ),
                      ),
                    )
                  ],
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10.0, horizontal: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomButton(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          buttonText: 'BACK'),
                      CustomButton(
                          onTap: () {
                          if (_formKey.currentState!.validate()) {
                            agree ? _saveUserInfo(model) : showDialog(
                                context: context,
                                builder: (_) => new CupertinoAlertDialog(
                                  title: CustomText(
                                      'Please accept terms and condition',
                                      style: TextStyle(
                                          color: ColorResources.BOTTOM_HEADING,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),

                                  actions: <Widget>[
                                    TextButton(
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Text(getTranslated('ok', context)!,
                                            style: TextStyle(
                                                color: Colors.red, fontSize: 18)),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),

                                  ],
                                ));}
                          },
                          buttonText: 'GET OTP'),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already Member?",
                        style: Style.newheading),
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
                        // Navigator.pushReplacement(context,
                        //     MaterialPageRoute(builder: (builder) => MenuPage()));
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
      ),
    );
  }

  dialogCallback(String value){

  }

  // getDetails() {
  //   return Container(
  //     height: 500,
  //     width: MediaQuery.of(context).size.width / 2,
  //     margin: EdgeInsets.only(right: MediaQuery.of(context).size.width / 10),
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
  //                 height: 36,
  //                 width: 120,
  //               ),
  //             )
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  _saveUserInfo(AuthProvider model) {
    model.saveTestingUser(
        aadharCard: widget.adharCard,
        alternativeNumber: '',
        city: selectedCity,
        companyAddress: addressController.text,
        companyId: 0,
        companyLogo: '',
        companyName: companyController.text,
        country: '',
        deviceId: '',
        emailId: widget.email,
        firstName: widget.firstName,
        id: 1,
        idOfMainBranch: 1,
        isPaid: 0,
        isUserVerifiedByCompany: 0,
        landlineNumber: 0,
        lastName: widget.lastName,
        loggedTime: '',
        loggedUserName: '',
        mainBranch: 0,
        mobileNumber: int.parse(widget.mobileNumber),
        numberOfTimesRating: 0,
        os: '',
        otp: '',
        paidStartDate: '',
        password: '',
        panCardForVerification: widget.panCard,
        preferredRouresEntered: 0,
        profilePicture: '',
        rating: 0,
        transporterOrAgent: widget.selctedType == AppConstant().BUSINESS_TYPE_AGENT
            ? 0
            : widget.selctedType == AppConstant().BUSINESS_TYPE_TRANSPORTER
                ? 1
                : widget.selctedType == AppConstant().BUSINESS_TYPE_MANUFACTURER
                    ? 2
                    : 3,
        verified: 0,
        state: selectedState,
        userName: '',
        validTill: '',
        website: websiteController.text);
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (builder) => OTP_Screen(
                  widget.mobileNumber,
                  companyLogin: false,
              fromLink: false,
                )));
  }


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
}
