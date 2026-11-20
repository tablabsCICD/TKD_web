import 'dart:ui';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:tkd_app/locator.dart';
import 'package:tkd_app/model/auth_api.dart';
import 'package:tkd_app/model/organization_model.dart';
import 'package:tkd_app/provider/auth_provider.dart';
import 'package:tkd_app/provider/org_provider.dart';
import 'package:tkd_app/util/ResponsiveWidget.dart';
import 'package:tkd_app/util/color-resource.dart';
import 'package:tkd_app/util/style.dart';
import 'package:tkd_app/view/base_widget/custom_button.dart';
import 'package:tkd_app/view/base_widget/custom_textfeild.dart';
import 'package:tkd_app/view/base_widget/open_url.dart';
import 'package:tkd_app/view/screens/company/company_menu_page.dart';
import 'package:tkd_app/view/screens/menu_page.dart';
import 'otp_screen.dart';
import 'registration_screen_1.dart';
import 'package:universal_html/html.dart' as html;

class ImageCarousel{
  String image1;
  String image2;
  String title;
  String subTitle;

  ImageCarousel(this.image1, this.image2, this.title, this.subTitle);
}

class Login_Screen extends StatefulWidget {
  bool fromLink=false;
  String postId;
  String linkType;
  Login_Screen({Key? key,this.fromLink=false,this.postId="0",this.linkType="post"}) : super(key: key) {
  }
  @override
  _Login_ScreenState createState() => _Login_ScreenState();
}


class _Login_ScreenState extends State<Login_Screen> {
  TextEditingController mobileController = new TextEditingController();
  bool visitingFlag = true;
  List<User> userDetailList = [];
  final authProvider = locator<AuthProvider>();
  final orgProvider = locator<OrgProvider>();
  bool companyLogin=false,userLogin=true;
  List<Organization> orgList = [];
  final _formKey = GlobalKey<FormState>();

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
    super.initState();
  }

  loginOrHome() async{
    visitingFlag = (await authProvider.getVisitingFlag())!;
    if(visitingFlag == true){
      int? empid = await authProvider.getEmpId();
      if(empid != null){
        userDetailList = await authProvider.getUserDetails(empid);
        Navigator.push(context, MaterialPageRoute(builder: (builder)=>MenuPage(userDetailList: userDetailList,selectedTab: "Board",)));
      }
    }
  }

  companyLoginOrHome() async{
    visitingFlag = (await orgProvider.getCompanyVisitingFlag())!;
    print("visiting flag "+ visitingFlag.toString());
    if(visitingFlag == true){
      int? orgId = await orgProvider.getCompanyOrgId();
      print("visiting flag Id "+ orgId.toString());
      if(orgId != null){
        orgList  = await orgProvider.getCompanyDetails(orgId);
        Navigator.push(context, MaterialPageRoute(builder: (builder)=>CompanyMenuPage(orgList[0])));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AuthProvider>(
        builder: (context, model, child) =>
            Container(
              child: ResponsiveWidget.isMobile(context)
                  ? Stack(children: [
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
                      getCart(model),
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
                            colors: [Colors.white, ColorResources.HOME_BG])),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 30.0),
                      child: SvgPicture.asset(
                        'assets/svg/logo.svg',
                        height: 100,
                        width: 150,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: getCart(model),
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
                                      style: Style.aleaready),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                InkWell(
                                  onTap:(){
                                    String url = "https://s3.ap-south-1.amazonaws.com//tkd-images/profileImages//1713253757588-1711368168541-termsadnCondition_(1).pdf";
                                    html.window.open(url,"_blank"/*,"_self"*/);

                                  },
                                  child: Text("Terms & Conditions",
                                      style: Style.aleaready),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                InkWell(
                                  onTap:(){
                                    String url = "https://s3.ap-south-1.amazonaws.com//tkd-images/profileImages//1713253703520-1711368127989-privacyPolicy_(1).pdf";
                                    html.window.open(url,"_blank"/*,"_self"*/);

                                  },
                                  child: Text("Privacy Policy",
                                      style: Style.aleaready),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
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
                                      style: Style.aleaready),
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
                                    )),
                                SizedBox(
                                  width: 20,
                                ),
                                InkWell(
                                  onTap: (){
                                    openUrl();
                                  },
                                  child: Image.asset(
                                    'assets/images/bitmap.png',
                                    height: 36,
                                    width: 120,
                                  ),
                                )
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

  getCart(AuthProvider model) {
    final orgProvider = locator<OrgProvider>();
    return Container(
      padding: EdgeInsets.symmetric(vertical: 30),
      height: 400,
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
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Sign In",
                style: Style.loginHeading,textAlign: TextAlign.center),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: CustomTextField(
                hintText: 'Enter Mobile Number',
                controller: mobileController,
                textInputType: TextInputType.number,
                isPhoneNumber: true,
              ),
            ),

            Container(
              width: MediaQuery.of(context).size.width,
              padding:
              const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
              child: userLogin == true? CustomButton(
                  onTap:() async {
                    if (_formKey.currentState!.validate()) {
                      var result = await  model.sendOtp(mobileController.text);
                      print(result);
                      if(result["responseCode"]=='3001'){
                        Navigator.push(context,
                            MaterialPageRoute(builder: (builder) => OTP_Screen(mobileController.text,companyLogin: false,fromLink:widget.fromLink,postId: widget.postId,linkType: widget.linkType,)));
                      }
                      else{
                        print(result['response']);
                        showSimpleNotification(
                            Text(result['response'],style: TextStyle(color: Colors.white),),
                            background: Colors.black
                        );
                      }
                    }},
                  buttonText: 'SEND OTP'):
              CustomButton(

                  onTap:() async {
                    print("FromLink::::${widget.fromLink} && postId:::::${widget.postId}");
                    var result = await  orgProvider.sendOtpByOrgId(mobileController.text);
                    if(result["Status"]=='Success'){
                      Navigator.push(context,
                          MaterialPageRoute(builder: (builder) => OTP_Screen(mobileController.text,companyLogin: true,fromLink: false,)));
                    }
                    else{
                      print(result['errorMessage']);
                      showSimpleNotification(
                          Text(result['errorMessage'],style: TextStyle(color: Colors.white),),
                          background: Colors.black
                      );
                    }
                  },
                  buttonText: 'SEND OTP'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("New user?",
                  style: Style.newheading,textAlign: TextAlign.center,),
                InkWell(
                  onTap: (){
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (builder) => RegistrationScreen1()));
                  },
                  child: Text(" Register here",
                      style: Style.aleaready,textAlign: TextAlign.center),
                ),
              ],
            ),


          ],
        ),
      ),
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
              int index = carouselImages.indexOf(i);
              return Builder(
                  builder:(BuildContext context){
                    return Container(
                        height: MediaQuery.of(context).size.height*0.30,
                        width: MediaQuery.of(context).size.width,
                        child: index < 3?Stack(
                            children: [
                             /* Align(
                                alignment: Alignment.center,
                                child: Container(
                                    height: 500,
                                    width: MediaQuery.of(context).size.width / 4,
                                    alignment: Alignment.center,
                                    child: Padding(
                                      padding: const EdgeInsets.only(bottom: 20.0),
                                      child: SvgPicture.asset(
                                        carouselImages[index].image2,
                                        height: 72,
                                        width: 222,
                                      ),
                                    )),
                              ),*/
                              Align(
                                alignment: Alignment.center,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      carouselImages[index].image1,
                                      height: 224,
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
