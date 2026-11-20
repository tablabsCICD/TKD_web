/*
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:tkd_app/dialog/animated_custom_dialog.dart';
import 'package:tkd_app/dialog/my_dialog.dart';
import 'package:tkd_app/locator.dart';
import 'package:tkd_app/model/auth_api.dart';
import 'package:tkd_app/model/deep_link_load.dart';
import 'package:tkd_app/model/shared_post_model.dart';
import 'package:tkd_app/model/truck_load_model.dart';
import 'package:tkd_app/open_whatsapp.dart';
import 'package:tkd_app/provider/auth_provider.dart';
import 'package:tkd_app/provider/bid_provider.dart';
import 'package:tkd_app/provider/localization_provider.dart';
import 'package:tkd_app/util/ResponsiveWidget.dart';
import 'package:tkd_app/util/color-resource.dart';
import 'package:tkd_app/util/custom_text_style.dart';
import 'package:tkd_app/util/style.dart';
import 'package:tkd_app/view/base_widget/appbar.dart';
import 'package:tkd_app/view/base_widget/custom_button.dart';
import 'package:tkd_app/view/base_widget/custom_textfeild.dart';
import 'package:tkd_app/view/base_widget/custom_textview.dart';
import 'package:tkd_app/view/base_widget/rating_star.dart';
import 'package:tkd_app/view/base_widget/utils.dart';
import 'package:tkd_app/view/localization/language_constrants.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../base_widget/getImage.dart';
import '../menu_page.dart';

class SharedPostDetails extends StatefulWidget {
  TruckLoadDeepLink truckLoad;

  // RequirementDetails(this.truckLoad);

  final bidProvider = locator<BidProvider>();
  final authProvider = locator<AuthProvider>();

  SharedPostDetails(this.truckLoad, {Key? key}) : super(key: key) {
    //authProvider.getUserUsingUserName(truckLoad.loggedUserName!,'','','');
  }

  @override
  _SharedPostDetailsState createState() => _SharedPostDetailsState();
}

class _SharedPostDetailsState extends State<SharedPostDetails> {
  final bidProvider = locator<BidProvider>();
  final authProvider = locator<AuthProvider>();
  TextEditingController bidAmtController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController sourceController = TextEditingController();
  TextEditingController destinationController = TextEditingController();
  TextEditingController filterController = TextEditingController();
  final langProvider = locator<LocalizationProvider>();
  String? langCode;

  @override
  void initState() {
    super.initState();
    langCode = langProvider.selectedlangCode;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        int? empid = await authProvider.getEmpId();
        List<User> userDetailList = await authProvider.getUserDetails(empid!);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (builder) => MenuPage(
                      userDetailList: userDetailList,
                      selectedTab: "Home",
                    )));
        return false;
      },
      child: Scaffold(
        appBar: AppBarCommon(context, title: "Requirement Details")
            .appBarWithoutBackButton(),
        body: Container(
          color: Colors.white,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: ResponsiveWidget.isMobile(context)
              ? getCart()
              : Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          */
/* image: DecorationImage(
                    fit: BoxFit.fill,
                    image: NetworkImage('assets/images/truck.png'),
                  ),*//*

                          ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: getCart(),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  final _formKey = GlobalKey<FormState>();

  getCart() {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: ResponsiveWidget.isMobile(context)
          ? MediaQuery.of(context).size.width
          : MediaQuery.of(context).size.width / 2,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            shrinkWrap: true,
            children: [
              ListTile(
                contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                horizontalTitleGap: 0,
                minVerticalPadding: 0,
                leading: Stack(
                  children: [
                    getImage(widget.truckLoad.image.toString()),
                  ],
                ),
                title: Row(
                  children: [
                    langCode == 'en'
                        ? Text(
                            widget.truckLoad.transporterOrCustomerName.toString(),
                            style: titleTextStyle)
                        : CustomText(
                            widget.truckLoad.transporterOrCustomerName.toString(),
                            style: titleTextStyle),
                  ],
                ),
                subtitle: langCode == 'en'
                    ? Text(widget.truckLoad.emailId.toString(),
                        style: subTitleTextStyle)
                    : CustomText(widget.truckLoad.emailId.toString(),
                        style: subTitleTextStyle),

                //   trailing: ConvertStringToDate(widget.truckLoad.postingTime.toString()),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: 18),
                height: 30,
                decoration: new BoxDecoration(
                    color: Color(0xfff0f0f0),
                    borderRadius: BorderRadius.circular(5)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    langCode == 'en'
                        ? Text(
                            widget.truckLoad.source.toString(),
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontFamily: 'RobotoSlab',
                                fontWeight: FontWeight.bold),
                          )
                        : CustomText(
                            widget.truckLoad.source.toString(),
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontFamily: 'RobotoSlab',
                                fontWeight: FontWeight.bold),
                          ),
                    SizedBox(
                      width: 10,
                    ),
                    Image.asset(
                      'assets/images/two_way_arrow.png',
                      height: 15,
                      width: 25,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    langCode == 'en'
                        ? Text(
                            widget.truckLoad.destination.toString(),
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontFamily: 'RobotoSlab',
                                fontWeight: FontWeight.bold),
                          )
                        : CustomText(
                            widget.truckLoad.destination.toString(),
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontFamily: 'RobotoSlab',
                                fontWeight: FontWeight.bold),
                          ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 7),
                child: langCode == 'en'
                    ? Text(widget.truckLoad.typeOfCargo.toString(),
                        style: titilliumSemiBold)
                    : CustomText(widget.truckLoad.typeOfCargo.toString(),
                        style: titilliumSemiBold),
              ),
              SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0, bottom: 10, right: 10),
                child: langCode == 'en'
                    ? Text(
                        widget.truckLoad.otherDetails.toString(),
                        style: regularTextStyle,
                      )
                    : CustomText(
                        widget.truckLoad.otherDetails.toString(),
                        style: regularTextStyle,
                      ),
              ),
              SizedBox(
                height: 19.5,
              ),
              Divider(
                height: 1,
                thickness: 1,
              ),
              SizedBox(
                height: 19.5,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 7),
                child: CustomText('Other Details', style: Style.appsubtitle),
              ),
              SizedBox(
                height: 10.5,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0, bottom: 20, right: 10),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // CustomText(
                        //   'Email_Id',
                        //   style: regularTextStyle,
                        // ),
                        // SizedBox(height: 16,),
                        CustomText('Alternate Number', style: regularTextStyle),
                        SizedBox(
                          height: 16,
                        ),
                        CustomText('Vehicle Size', style: regularTextStyle),
                        SizedBox(
                          height: 16,
                        ),
                        CustomText('User Verify', style: regularTextStyle),
                        SizedBox(
                          height: 16,
                        ),
                        CustomText('Type Of Payment', style: regularTextStyle),
                      ],
                    ),
                    SizedBox(
                      width: 25,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Text(': ${widget.truckLoad.mobileNumber}',
                        //    style: TextStyle(
                        //        color: ColorResources.PRIMARY_COLOR),)
                        //  ,
                        //  SizedBox(
                        //    height: 16,
                        //  ),
                        Text(
                          ': ${widget.truckLoad.contactNumber.toString()}',
                          style: TextStyle(color: ColorResources.PRIMARY_COLOR),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Text(
                          ': ${widget.truckLoad.vehicleSize.toString()}',
                          style: TextStyle(color: ColorResources.PRIMARY_COLOR),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        */
/* Text( widget.truckLoad.isVerifiedByCompany ==
                            1?': Not Verified User ':': Verified by TKDost team',
                          style: TextStyle(
                              color: ColorResources.PRIMARY_COLOR),),
                        SizedBox(
                          height: 16,
                        ),*//*

                        Text(
                          ': ${widget.truckLoad.typeOfPayment.toString()}',
                          style: TextStyle(color: ColorResources.PRIMARY_COLOR),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Divider(
                height: 1,
                thickness: 1,
              ),
              Padding(
                padding: const EdgeInsets.all(9.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        InkWell(
                          onTap: () async {
                            Utils().openwhatsapp(
                                context,
                                widget.truckLoad.contactNumber!,
                                widget.truckLoad.otherDetails!);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/chat.png',
                                color: ColorResources.PRIMARY_COLOR,
                                height: 15,
                                width: 15,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                getTranslated("chat", context)!,
                                style: Style.bottomHeading,
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        InkWell(
                          onTap: () async {
                            TruckLoad truckLoad = new TruckLoad(
                                id: widget.truckLoad.id,
                                userId: 0,
                                type: widget.truckLoad.type,
                                postingTime: widget.truckLoad.postingTime,
                                companyName: '',
                                nameOfPerson:widget.truckLoad.transporterOrCustomerName,
                                content: widget.truckLoad.otherDetails,
                                topicName: widget.truckLoad.topicName,
                                tableName: widget.truckLoad.tableName,
                                partLoadOrNot: widget.truckLoad.partLoad,
                                sharableLink: '',
                                deviceId: '',
                                ratings: 5.0,
                                mobileNumber: widget.truckLoad.contactNumber,
                                source: widget.truckLoad.source,
                                destination: widget.truckLoad.destination,
                                mainTag: widget.truckLoad.mainTag,
                                privatePost: widget.truckLoad.privatePost,
                                dnd: widget.truckLoad.dnd,
                                vehicleSize: widget.truckLoad.vehicleSize,
                                association: '',
                                isPaid: widget.truckLoad.dnd,
                                website: '',
                                companyDetailsName: '');
                            Utils().callShareFunction(
                                widget.truckLoad.otherDetails!, truckLoad, context);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/share.png',
                                color: ColorResources.PRIMARY_COLOR,
                                height: 15,
                                width: 15,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                getTranslated("share", context)!,
                                style: Style.bottomHeading,
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        InkWell(
                          onTap: () async {
                            await Utils().callFunction(
                                context, "${widget.truckLoad.contactNumber}");
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/call.png',
                                color: ColorResources.PRIMARY_COLOR,
                                height: 15,
                                width: 15,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                ("Call")!,
                                style: Style.bottomHeading,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        showAnimatedDialog(
                            context,
                            Dialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Form(
                                key: _formKey,
                                child: Container(
                                  height: 350,
                                  width: 300,
                                  child: Stack(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(16),
                                        child: Column(children: [
                                          CustomText(
                                            'Place Your Bid',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          CustomTextField(
                                              controller: bidAmtController,
                                              hintText: "Enter Your Bid Amount",
                                              isDigits: true,
                                              textInputType: TextInputType.number),
                                          CustomTextField(
                                              controller: descriptionController,
                                              hintText: "Comments/Descriptions",
                                              textInputType: TextInputType.number),
                                          CustomButton(
                                              onTap: () {
                                                if (_formKey.currentState!
                                                    .validate()) {
                                                  bidProvider
                                                      .generateBid(context,
                                                          mobile: authProvider
                                                              .userDetailList[0]
                                                              .mobileNumber,
                                                          description:
                                                              descriptionController
                                                                  .text,
                                                          idOfPost:
                                                              widget.truckLoad.id,
                                                          email: authProvider
                                                              .userDetailList[0]
                                                              .emailId,
                                                          amount:
                                                              bidAmtController.text,
                                                          id: 0,
                                                          bidderUserName:
                                                              authProvider
                                                                  .userDetailList[0]
                                                                  .userName,
                                                          userName: authProvider
                                                              .userDetailList[0]
                                                              .userName,
                                                          type: widget
                                                              .truckLoad.mainTag,
                                                          loggedUserName:
                                                              '${authProvider.userDetailList[0].firstName} ${authProvider.userDetailList[0].lastName}')
                                                      .then((value) => {
                                                            showAnimatedDialog(
                                                                context,
                                                                MyDialog(
                                                                  icon: Icons.check,
                                                                  title:
                                                                      'Generate Bid',
                                                                  description:
                                                                      'Your Bid Created successfully',
                                                                  isFailed: false,
                                                                ),
                                                                dismissible: false,
                                                                isFlip: false),
                                                          });
                                                  Navigator.of(context).pop();
                                                }
                                              },
                                              buttonText: "Submit")
                                        ]),
                                      ),
                                      Positioned(
                                        top: 10,
                                        right: 10,
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.close,
                                            size: 18,
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ));
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.black,
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                        child: CustomText("Bid Now", style: Style.button),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 1.5,
                thickness: 1.5,
              ),

            ],
          ),
        ),
      ),
    );
  }
}
*/

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';
import 'package:tkd_app/dialog/animated_custom_dialog.dart';
import 'package:tkd_app/dialog/my_dialog.dart';
import 'package:tkd_app/locator.dart';
import 'package:tkd_app/model/auth_api.dart';
import 'package:tkd_app/model/deep_link_load.dart';
import 'package:tkd_app/model/shared_post_model.dart';
import 'package:tkd_app/model/truck_load_model.dart';
import 'package:tkd_app/open_whatsapp.dart';
import 'package:tkd_app/provider/auth_provider.dart';
import 'package:tkd_app/provider/bid_provider.dart';
import 'package:tkd_app/provider/localization_provider.dart';
import 'package:tkd_app/util/ResponsiveWidget.dart';
import 'package:tkd_app/util/color-resource.dart';
import 'package:tkd_app/util/colors.dart';
import 'package:tkd_app/util/custom_text_style.dart';
import 'package:tkd_app/util/style.dart';
import 'package:tkd_app/view/base_widget/appbar.dart';
import 'package:tkd_app/view/base_widget/custom_button.dart';
import 'package:tkd_app/view/base_widget/custom_textfeild.dart';
import 'package:tkd_app/view/base_widget/custom_textview.dart';
import 'package:tkd_app/view/base_widget/rating_star.dart';
import 'package:tkd_app/view/base_widget/utils.dart';
import 'package:tkd_app/view/localization/language_constrants.dart';
import 'package:tkd_app/widgets/base_widgets.dart';
import 'package:tkd_app/widgets/toast.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../base_widget/getImage.dart';
import '../menu_page.dart';

class SharedPostDetails extends StatefulWidget {
  TruckLoad truckLoad;

  // RequirementDetails(this.truckLoad);

  final bidProvider = locator<BidProvider>();
  final authProvider = locator<AuthProvider>();

  SharedPostDetails(this.truckLoad, {Key? key}) : super(key: key) {
    //authProvider.getUserUsingUserName(truckLoad.loggedUserName!,'','','');
  }

  @override
  _SharedPostDetailsState createState() => _SharedPostDetailsState();
}

class _SharedPostDetailsState extends State<SharedPostDetails> {
  final bidProvider = locator<BidProvider>();
  final authProvider = locator<AuthProvider>();
  TextEditingController bidAmtController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController sourceController = TextEditingController();
  TextEditingController destinationController = TextEditingController();
  TextEditingController filterController = TextEditingController();
  final langProvider = locator<LocalizationProvider>();
  String? langCode;

  @override
  void initState() {
    super.initState();
    langCode = langProvider.selectedlangCode;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        int? empid = await authProvider.getEmpId();
        List<User> userDetailList = await authProvider.getUserDetails(empid!);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (builder) => MenuPage(
                  userDetailList: userDetailList,
                  selectedTab: "Home",
                )));
        return false;
      },
      child: Scaffold(
        backgroundColor: ThemeColor.baground,
        appBar: AppBarCommon(context, title: "Requirement Details")
            .appBarWithoutBackButton(),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: ResponsiveWidget.isMobile(context)
              ? getCart()
              : Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  /* image: DecorationImage(
                    fit: BoxFit.fill,
                    image: NetworkImage('assets/images/truck.png'),
                  ),*/
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: getCart(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  final _formKey = GlobalKey<FormState>();

  getCart() {
    return Container(
        height: ResponsiveWidget.isMobile(context)
            ? MediaQuery.of(context).size.height
            : MediaQuery.of(context).size.height / 2,
        width: ResponsiveWidget.isMobile(context)
            ? MediaQuery.of(context).size.width
            : MediaQuery.of(context).size.width / 2,
        child: Container(
          width: 335,
          padding: EdgeInsets.all(12),
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            shadows: [
              BoxShadow(
                color: Color(0x114A5568),
                blurRadius: 8,
                offset: Offset(0, 3),
                spreadRadius: 0,
              )
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  width: 120,
                  height: 18,
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: ShapeDecoration(
                    color: Color(0xFF2C8FEA),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4)),
                  ),
                  child: Center(
                    child: Text(
                      Utils().mainTag(widget.truckLoad.mainTag!),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: widget.truckLoad.privatePost == 1 ? 10 : 5),
              widget.truckLoad.privatePost == 1
                  ? SizedBox.shrink()
                  : BaseWidget().profileWithUser(
                  '' ,widget.truckLoad.nameOfPerson!, widget.truckLoad.typeOfCargo!,
                  verify: 0,
                  transporterOrAgent: 0, ratings: widget.truckLoad.ratings??4.5,isJob: false,email: ''),
              BaseWidget().routes(widget.truckLoad.source!, widget.truckLoad.destination!),
              SizedBox(
                height: 12,
              ),
              BaseWidget().heading(
                  widget.truckLoad.topicName!, getDateObject(widget.truckLoad.postingTime), widget.truckLoad.otherDetails!),
              Text(
                "Vehicle Size : ${widget.truckLoad.vehicleSize}",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  fontWeight: FontWeight.normal,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Load Weight : ${widget.truckLoad.loadWeight}",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  fontWeight: FontWeight.normal,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Payment Type : ${widget.truckLoad.typeOfPayment}",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  fontWeight: FontWeight.normal,
                ),
              ),
              SizedBox(
                height: 20,
              ),
            BaseWidget().bidButton(widget.truckLoad, (val) {
              if (widget.truckLoad.dnd == 1) {
                ToastMessage.show(context, "This is DND Post");
              } else {
                TruckLoad truckLoad = new TruckLoad(
                    id: widget.truckLoad.id,
                    userId: 0,
                    type: widget.truckLoad.type,
                    postingTime: widget.truckLoad.postingTime,
                    companyName: '',
                    nameOfPerson:widget.truckLoad.nameOfPerson,
                    content: widget.truckLoad.otherDetails,
                    topicName: widget.truckLoad.topicName,
                    tableName: widget.truckLoad.tableName,
                    partLoadOrNot: widget.truckLoad.partLoadOrNot,
                    sharableLink: '',
                    deviceId: '',
                    ratings: 5.0,
                    mobileNumber: widget.truckLoad.mobileNumber,
                    source: widget.truckLoad.source,
                    destination: widget.truckLoad.destination,
                    mainTag: widget.truckLoad.mainTag,
                    privatePost: widget.truckLoad.privatePost,
                    dnd: widget.truckLoad.dnd,
                    vehicleSize: widget.truckLoad.vehicleSize,
                    association: '',
                    isPaid: widget.truckLoad.dnd,
                    website: '',
                    companyDetailsName: '');
                Utils().openMenu(val, truckLoad, context);
              }
            })
            ],
          ),
        )
    );
  }

  getDateObject(String? dateTime) {
    try {
      DateTime formatedDate = DateTime.parse(dateTime!);
      print(formatedDate);
      var date1 = DateFormat("yyyy-MM-dd").format(formatedDate);
      var todayDate = DateFormat("yyyy-MM-dd").format(DateTime.now());
      if (date1 == todayDate) {
        date1 = DateFormat("H:mm").format(formatedDate);
      }
      return date1;
    } catch (e) {
      return dateTime;
    }
  }
}
