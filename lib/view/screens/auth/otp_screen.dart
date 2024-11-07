import 'dart:async';
import 'dart:ui';
import 'dart:html' as html;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:overlay_support/overlay_support.dart';

import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:provider/provider.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';
import 'package:tkd_app/locator.dart';
import 'package:tkd_app/model/organization_model.dart';
import 'package:tkd_app/model/shared_post_model.dart';
import 'package:tkd_app/provider/auth_provider.dart';
import 'package:tkd_app/provider/dashboard_provider.dart';
import 'package:tkd_app/provider/org_provider.dart';
import 'package:tkd_app/util/ResponsiveWidget.dart';
import 'package:tkd_app/util/color-resource.dart';
import 'package:tkd_app/util/style.dart';
import 'package:tkd_app/view/base_widget/custom_button.dart';
import 'package:tkd_app/view/base_widget/open_url.dart';
import 'package:tkd_app/view/screens/bids/deeplinkscreen.dart';
import 'package:tkd_app/view/screens/company/company_menu_page.dart';
import 'package:tkd_app/view/screens/dashboard/sharedPostDetailsScreen.dart';
import 'login_screen.dart';
import 'package:tkd_app/view/screens/menu_page.dart';


class OTP_Screen extends StatefulWidget {
  String mobileNumber;
  String postId;
  bool companyLogin,fromLink;
  final authProvider = locator<AuthProvider>();

  OTP_Screen(this.mobileNumber,{ Key? key,required this.companyLogin,required this.fromLink,this.postId="0"}) : super(key: key) {
    authProvider.startTimer();
  }

 // OTP_Screen(this.mobileNumber,{ required this.companyLogin});

  @override
  OTP_ScreenState createState() => OTP_ScreenState();
}

class OTP_ScreenState extends State<OTP_Screen> {
  TextEditingController otpController = new TextEditingController();
  var onTapRecognizer;
  final orgProvider = locator<OrgProvider>();
  final authProvider = locator<AuthProvider>();
  String? _deviceId;
  final dashboardProvider = locator<DashboardProvider>();

  Future<void> initPlatformState() async {
    String? deviceId;
    try {
      deviceId = await PlatformDeviceId.getDeviceId;
    } on PlatformException {
      deviceId = 'Failed to get deviceId.';
    }
    if (!mounted) return;
    setState(() {
      _deviceId = deviceId;
      print("deviceId->$_deviceId");
    });
  }

  TextEditingController textEditingController = TextEditingController();
  String otp = "";

  late StreamController<ErrorAnimationType> errorController;

  bool hasError = false;
  String currentText = "";
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  var _current = 0;
  List<ImageCarousel> carouselImages = [
    ImageCarousel('assets/svg/intro_one.svg','assets/svg/intro_one.svg',"India's Transport Marketplace",
        "Connect with verified shippers and carriers across India for reliable and efficient logistics."
            +"\nFull Truck Load Shipping Across India"+
            "\nDedicated Transport"),
    ImageCarousel('assets/svg/intro_two.svg','assets/svg/intro_two.svg',
        "Find Instant Truck Load Online",
        "Find and secure available loads quickly, optimizing trips and reducing empty returns.\nMaximize Savings \nExpert Handling."),
    ImageCarousel('assets/svg/intro_three.svg','assets/svg/intro_three.svg',"Find Load for you Trucks Online","Keep your trucks moving and profitable with real-time load availability tailored to your routes and preferences.\nFast and Reliable."),
  ];

  @override
  void initState() {
    onTapRecognizer = TapGestureRecognizer()
      ..onTap = () {
        Navigator.pop(context);
      };
    errorController = StreamController<ErrorAnimationType>();
    initPlatformState();
    super.initState();
  }

  @override
  void dispose() {
    errorController.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AuthProvider>(
        builder: (context, model, child) =>
        Container(
          child: ResponsiveWidget.isMobile(context)
            ?Stack(children: [
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [0.5, 0.5],
                      colors: [Colors.white, ColorResources.HOME_BG])),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //  getDetails(),
                  getCard(model),

                ],
              ),
            ),
          ])
            :Stack(
              children: [
                Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [
                          0.5,
                          0.5
                        ],
                        colors: [
                          Colors.white,
                          ColorResources.HOME_BG
                        ]
                    )
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: SvgPicture.asset('assets/svg/logo.svg',height: 100,width: 150,),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: getCard(model),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: getDetails(),
              ),
              Positioned(
                bottom: 50,
                left: 50,
                right: 50,
                child: Column(
                  children: [
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            InkWell(
                              onTap:(){
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text("About Us"),
                                        content: Container(
                                            width: 450,
                                            child: Text("To Provide a platform for the Indian transport Industry on cost effective"
                                                "basis to connect for fast and relaible information to our users,"
                                                "registered users and paid users on Pan India basis. Our company TKD Communication LLP started it'\s operation"
                                                " in the year 2017 under different entity offering SMS service for the needy Transporter who were facing problems in Transport Industry."
                                                "\nAfter 2 years of Research in Transport Sector we now TKD Communication LLP has launched website "
                                                "and Android Play Store App to further bridge Gap between Transporter, Truck Owners and Agents.")
                                        ),
                                        actions: [
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              foregroundColor: Colors.white, backgroundColor: Colors.black,
                                              elevation: 3,
                                              shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                                            ),
                                            onPressed: () { Navigator.of(context).pop(); },
                                            child: Text('Ok'),
                                          )
                                        ],
                                      );});
                              },
                              child: Text("About Us",
                                  style: Style.aleaready
                              ),
                            ),
                            SizedBox(width: 20,),
                            InkWell(
                              onTap: (){
                                String url = "https://s3.ap-south-1.amazonaws.com//tkd-images/profileImages//1713253757588-1711368168541-termsadnCondition_(1).pdf";
                                html.window.open(url,"_blank"/*,"_self"*/);
                              },
                              child: Text("Terms And Conditions",
                                  style: Style.aleaready
                              ),
                            ),
                            SizedBox(width: 20,),
                            InkWell(
                              onTap: (){
                                String url = "https://s3.ap-south-1.amazonaws.com//tkd-images/profileImages//1713253703520-1711368127989-privacyPolicy_(1).pdf";
                                html.window.open(url,"_blank"/*,"_self"*/);
                               // html.window.open('https://tkdtermsandconditions.s3.ap-south-1.amazonaws.com/termsconditions.html',"_blank"/*,"_self"*/);
                              },
                              child: Text("Privacy Policy",
                                  style: Style.aleaready
                              ),
                            ),


                            SizedBox(width: 20,),
                            InkWell(
                              onTap:(){
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Container(
                                        child: AlertDialog(
                                          title: Text("Contact Us"),
                                          content: Container(
                                              width: 350,
                                              height: 420,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(height: 10,),
                                                  Text('Email : ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                                                  SizedBox(height: 10,),
                                                  InkWell(
                                                    onTap: () async {
                                                      var shareData = {
                                                        "title": "Email",
                                                        "text": "For Contact",
                                                        "url": "loadTypeList.sharableLink",
                                                      };
                                                      try{
                                                        await html.window.navigator.share(shareData);
                                                      }catch(e){
                                                        print(e);
                                                      }
                                                    },
                                                    child: Card(
                                                      child: Container(
                                                          width: 320,
                                                          child: Padding(
                                                            padding: const EdgeInsets.symmetric(horizontal: 18.0,vertical: 10),
                                                            child: Text("tkdcommunications@gmail.com",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: Colors.orange),),
                                                          )),
                                                    ),
                                                  ),
                                                  SizedBox(height: 10,),
                                                  InkWell(
                                                    onTap: () async {
                                                      var shareData = {
                                                        "title": "Email",
                                                        "text": "For Contact",
                                                        "url": "",
                                                      };
                                                      try{
                                                        await html.window.navigator.share(shareData);
                                                      }catch(e){
                                                        print(e);
                                                      }
                                                    },
                                                    child: Card(
                                                      child: Container(
                                                        width: 320,
                                                        child: Padding(
                                                          padding: const EdgeInsets.symmetric(horizontal: 18.0,vertical: 10),
                                                          child: Text("contact@tkdcommunity.com",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: Colors.orange),),
                                                        ),
                                                      ),
                                                    ),
                                                  ), SizedBox(height: 18,),
                                                  Text('Support Mobile : ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                                                  SizedBox(height: 10,),
                                                  InkWell(
                                                    onTap: () async {
                                                      var shareData = {
                                                        "title": "Email",
                                                        "text": "For Contact",
                                                        "url": "loadTypeList.sharableLink",
                                                      };
                                                      try{
                                                        await html.window.navigator.share(shareData);
                                                      }catch(e){
                                                        print(e);
                                                      }
                                                    },
                                                    child: Card(
                                                      child: Container(
                                                          width: 320,
                                                          child: Padding(
                                                            padding: const EdgeInsets.symmetric(horizontal: 18.0,vertical: 10),
                                                            child: Text("+91 8123006888",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: Colors.orange),),
                                                          )),
                                                    ),
                                                  ),
                                                  SizedBox(height: 10,),
                                                  InkWell(
                                                    onTap: () async {
                                                      var shareData = {
                                                        "title": "Mobile Number",
                                                        "text": "For Contact",
                                                        "url": "",
                                                      };
                                                      try{
                                                        await html.window.navigator.share(shareData);
                                                      }catch(e){
                                                        print(e);
                                                      }
                                                    },
                                                    child: Card(
                                                      child: Container(
                                                        width: 320,
                                                        child: Padding(
                                                          padding: const EdgeInsets.symmetric(horizontal: 18.0,vertical: 10),
                                                          child: Text("+91 8123004666",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: Colors.orange),),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(height: 16,),
                                                  Center(child: Text("Technology Partner",style: TextStyle(fontWeight: FontWeight.normal,fontSize: 12,color: Colors.grey),)),
                                                  SizedBox(height: 10,),
                                                  Center(child: Text("Tablabs Technologies Pvt. Ltd.",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: Colors.blueGrey),)),

                                                ],
                                              )
                                          ),
                                          actions: [
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                foregroundColor: Colors.white, backgroundColor: Colors.black,
                                                elevation: 3,
                                                shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                                              ),
                                              onPressed: () { Navigator.of(context).pop(); },
                                              child: Text('Ok'),
                                            )
                                          ],
                                        ),
                                      );});
                              },
                              child: Text("Contact Us",
                                  style: Style.aleaready
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text("Available On",
                                style: TextStyle(
                                  fontFamily: 'RobotoSlab',
                                  color: Colors.grey,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.normal,
                                )
                            ),
                            SizedBox(width: 20,),
                            InkWell(
                                onTap: (){
                                  openUrl();
                                },
                                child: Image.asset('assets/images/bitmap.png',height: 36,width: 120,))
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  SharedPostModel? truckLoad;
  getCard(AuthProvider model) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      height: 410,
      width: ResponsiveWidget.isMobile(context)?MediaQuery.of(context).size.width-50:
      ResponsiveWidget.isDesktop(context)?355:MediaQuery.of(context).size.width / 3,
      margin: ResponsiveWidget.isMobile(context)?EdgeInsets.all(0):ResponsiveWidget.isDesktop(context)?EdgeInsets.only(right: MediaQuery.of(context).size.width / 5):EdgeInsets.only(right: MediaQuery.of(context).size.width / 8),
      decoration: BoxDecoration(
        color: ColorResources.WHITE,
        border: Border.all(width: 1,color: Color(0xffe8e1d8)),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 30.0,
            spreadRadius: 0.0,
          ),
        ],
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                height: 32,
                width: 32,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: ColorResources.TEXTFEILD_COLOR,
                    shape: BoxShape.circle
                ),
                child: GestureDetector(
                  onTap: (){
                    Navigator.of(context).pop();
                  },
                  child: Icon(Icons.arrow_back_outlined)),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 30),
              child: progress(),
            )
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 30.0,left: 20,right:20 ,top:65),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Text("Enter OTP",
                      style: Style.loginHeading
                  ),
                ),
                /*Text("03 out of 03 attempts left",
                    style: TextStyle(
                      fontFamily: 'RobotoSlab',
                      color: Colors.grey,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.normal,
                    )
                ),*/
                Form(
                  key: formKey,
                  child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0),
                      child: PinCodeTextField(
                        appContext: context,
                        pastedTextStyle: TextStyle(
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.bold,
                        ),
                        length: 6,
                        obscureText: true,
                        obscuringCharacter: '*',
                        // animationType: AnimationType.fade,
                        validator: (v) {
                          if (v!.length < 6 || v.isEmpty) {
                            return "*Please fill up all the cells properly";
                          } else {
                            return null;
                          }
                        },
                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          borderRadius: BorderRadius.circular(5),
                          fieldHeight: ResponsiveWidget.isMobile(context)?40:40,
                          fieldWidth: ResponsiveWidget.isMobile(context)?35:40,
                          //activeFillColor:
                        //  hasError ? Colors.white : Colors.white,
                        ),
                        cursorColor: Colors.black,
                        textStyle: TextStyle(fontSize: 20, height: 1.6),
                        errorAnimationController: errorController,
                        controller: textEditingController,
                        keyboardType: TextInputType.number,
                        boxShadows: [
                          BoxShadow(
                            offset: Offset(0, 1),
                            color: Colors.black12,
                          )
                        ],
                        onCompleted: (v) {
                          setState(() {
                            currentText = v;
                          });
                        },

                        onChanged: (value) {
                          print(value);
                        },
                        beforeTextPaste: (text) {
                          print("Allowing to paste $text");
                          return true;
                        },
                      )),
                ),

              //  attemptText(),
                resendOTP(),

                /*Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Resend OTP",
                        style: TextStyle(
                          fontFamily: 'RobotoSlab',
                          color: Color(0xffea6935),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          decoration: TextDecoration.underline,
                        )
                    ),
                    Text("00:39",
                        style: TextStyle(
                          fontFamily: 'RobotoSlab',
                          color: Colors.grey,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.normal,
                        )
                    ),
                  ],
                ),*/
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 0),
                  child: widget.companyLogin == true ? Consumer<OrgProvider>(
                    builder: (context, model, child) => CustomButton(
                        onTap:() async {
                          print(currentText);
                          Organization result =  await orgProvider.verifyOtpByOrgId(widget.mobileNumber, currentText, _deviceId!);
                          print("result : "+result.id.toString());
                          if(result != null)
                          {
                            model.setCompanyVisitingFlag(true);
                           /* print(result);
                            print(result[0].id);*/
                            model.setCompanyOrgId(result.id!);
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder)=>CompanyMenuPage(result)));
                          }else
                            print(result);
                        },
                        buttonText: 'LOGIN'),
                  )
                      :CustomButton(
                      buttonText: 'LOGIN',
                      onTap:() async {
                        print(currentText);
                         var result =  await model.verifyOtp(widget.mobileNumber, currentText, _deviceId!);
                         if(result != 'Please enter valid OTP')
                          {
                            /*if(Provider.of<RouteProvider>(context).dummyRouteList.length != 0 ){
                              Provider.of<RouteProvider>(context).dummyRouteList.forEach((element) {
                                Provider.of<RouteProvider>(context).routeList.add(
                                    Provider.of<RouteProvider>(context).createRoute(
                                        userName : model.userDetailList[0].userName,source: element.source,destination: element.destination,
                                        id: 1,userId: model.userDetailList[0].id));
                              });
                              print("Dummy Route List Length : "+Provider.of<RouteProvider>(context).dummyRouteList.length.toString());
                              Provider.of<RouteProvider>(context).dummyRouteList = [];
                              print("Route List Length : "+Provider.of<RouteProvider>(context).routeList.length.toString());
                            }*/

                            model.setVisitingFlag(true);
                            print(result);
                            print(model.userDetailList[0].id);
                            model.setEmpId(model.userDetailList[0].id!);
                            print(model.userDetailList[0].userName);
                            print("OTP IS  :::::: "+model.userDetailList[0].otp.toString());
                            model.setUserName(model.userDetailList[0].userName!);
                            widget.fromLink==false?Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder)=>MenuPage(userDetailList: model.userDetailList,selectedTab: "Board",))):{
                              print("FromLink::::${widget.fromLink} && postId:::::${widget.postId}"),
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (builder) =>
                                          DeepLink(id: widget.postId)))
                            };
                          }else {
                           showSimpleNotification(
                               Text(result,style: TextStyle(color: Colors.white),),
                               background: Colors.black
                           );
                           /*Fluttertoast.showToast(
                               msg: result,
                               toastLength: Toast.LENGTH_SHORT,
                               gravity: ToastGravity.CENTER,
                               timeInSecForIosWeb: 1,
                               backgroundColor: Colors.red,
                               textColor: Colors.white,
                               fontSize: 16.0
                           );}*/
                         }
                      },
                    ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("New User? ",
                        style: Style.newheading,textAlign: TextAlign.center,
                    ),
                    Text("Register Here",
                        style: Style.aleaready,textAlign: TextAlign.center,
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  attemptText() {
    return Container(
      margin: EdgeInsets.only(right: 20),
      child: Align(
        alignment: Alignment.centerRight,
        child: Text(
          '${"Attempts"} 00/03',
          textAlign: TextAlign.right,
          style: TextStyle(
            color: Colors.black,
            fontSize: 12,
            fontFamily: GoogleFonts.poppins().fontFamily,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }

  progress() {
    return Consumer<AuthProvider>(
      builder: (context, provider, child) {
        return Column(
          children: [
            SimpleCircularProgressBar(
              progressStrokeWidth: 4,
              size: 40,
              backStrokeWidth: 2,
              maxValue: 60,
              animationDuration: 60,
              progressColors: [Colors.amber],
              backColor: Colors.grey,
              mergeMode: true,
              onGetText: (double value) {
                return Text(
                  '${provider.timeRemaning}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: ColorResources.THEME_COLOR,
                    fontSize: 10,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    fontWeight: FontWeight.w400,
                  ),
                );
              },
            ),
            SizedBox(height: 10,),
            mobileNumber(),
          ],
        );
      },
    );
  }

  mobileNumber() {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: "OTP sent to",
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontFamily: GoogleFonts.poppins().fontFamily,
              fontWeight: FontWeight.w400,
            ),
          ),
          TextSpan(
            text: ' +91 ${widget.mobileNumber}',
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontFamily: GoogleFonts.poppins().fontFamily,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  resendOTP() {
    return Consumer<AuthProvider>(
      builder: (context, provider, child) {
        return Container(
          width: 335,
          height: 24,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Haven’t received OTP?",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    InkWell(
                      onTap: (){
                        provider.onClickResend(context,widget.mobileNumber);
                      },
                      child: Text(
                        " Resend OTP",
                        style: TextStyle(
                          color:provider.resendButtonEnble?ColorResources.RED:Colors.black26,
                          fontSize: 14,
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
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
              viewportFraction: 0.8,
              initialPage: 0,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 3),
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: true,
              scrollDirection: Axis.horizontal,
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                });
              },
            ),
            items: carouselImages.map((i){
              int index = carouselImages.indexOf(i);
              return Builder(
                  builder:(BuildContext context){
                    return Container(
                        height: MediaQuery.of(context).size.height*0.30,
                        width: MediaQuery.of(context).size.width,
                        child: index < 3?Stack(
                            children: [
                              /*Container(
                                  height: 500,
                                  width: MediaQuery.of(context).size.width / 4,
                                  alignment: Alignment.center,
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 20.0),
                                    child: SvgPicture.asset(
                                      carouselImages[index].image1,
                                      height: 72,
                                      width: 222,
                                    ),
                                  )),*/
                              Align(
                                alignment: Alignment.center,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      carouselImages[index].image1,
                                      height: 204,
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


 /* getDetails() {
    return Container(
      height: 500,
      width:  MediaQuery.of(context).size.width/3.5,
      margin: EdgeInsets.only(left: MediaQuery.of(context).size.width/10),
      child: Stack(
        children: [
          Container(
              height: 500,
              width:  MediaQuery.of(context).size.width/4,
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Image.asset('assets/images/truck_01.png',height: 72,width: 222,),
              )
          ),
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset('assets/images/man_01.png',height: 234,width: 120,),
                Text("Grow your business",
                    style: Style.splashheading,textAlign: TextAlign.center,
                ),
                new Text("Lorem ipsum dolor sit amet, consectetur adipiscing\nelit. Suspendisse arcu dui.",
                    style: Style.splashContent,textAlign: TextAlign.center,
                ),

              ],
            ),
          )
        ],
      ),
    );
  }
*/
}

