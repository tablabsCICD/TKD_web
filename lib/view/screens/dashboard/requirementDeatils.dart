

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:tkd_app/dialog/animated_custom_dialog.dart';
import 'package:tkd_app/dialog/my_dialog.dart';
import 'package:tkd_app/dialog/share_dialog_box.dart';
import 'package:tkd_app/locator.dart';
import 'package:tkd_app/model/truck_load_model.dart';
import 'package:tkd_app/open_whatsapp.dart';
import 'package:tkd_app/provider/auth_provider.dart';
import 'package:tkd_app/provider/bid_provider.dart';
import 'package:tkd_app/provider/localization_provider.dart';
import 'package:tkd_app/share_data.dart';
import 'package:tkd_app/util/ResponsiveWidget.dart';
import 'package:tkd_app/util/color-resource.dart';
import 'package:tkd_app/util/custom_text_style.dart';
import 'package:tkd_app/util/date_converter.dart';
import 'package:tkd_app/util/star_display.dart';
import 'package:tkd_app/util/style.dart';
import 'package:tkd_app/view/base_widget/appbar.dart';
import 'package:tkd_app/view/base_widget/custom_button.dart';
import 'package:tkd_app/view/base_widget/custom_textfeild.dart';
import 'package:tkd_app/view/base_widget/custom_textview.dart';
import 'package:tkd_app/view/base_widget/rating_star.dart';
import 'package:tkd_app/view/localization/language_constrants.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../base_widget/getImage.dart';

class RequirementDetails extends StatefulWidget {
  TruckLoad truckLoad;
 // RequirementDetails(this.truckLoad);

  final bidProvider = locator<BidProvider>();

  RequirementDetails(this.truckLoad,{Key? key}) : super(key: key) {
    bidProvider.getReceivedBidingList(truckLoad.mainTag!, truckLoad.id!);
  }

  @override
  _RequirementDetailsState createState() => _RequirementDetailsState();
}

class _RequirementDetailsState extends State<RequirementDetails> {
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
    return Scaffold(
      appBar: AppBarCommon(context, title: "Requirement Details").appBar(),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: ResponsiveWidget.isMobile(context)
            ? getCart()
            : Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage('assets/images/truck.png'),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: getCart(),
            ),

          ],
        ),
      ),

    );
  }
  final _formKey = GlobalKey<FormState>();
  getCart(){
    return Container(
      height: MediaQuery.of(context).size.height,
      width: ResponsiveWidget.isMobile(context) ? MediaQuery.of(context).size.width : MediaQuery.of(context).size.width/2,
      child: ListView(
        shrinkWrap: true,
        children: [
         ListTile(
            contentPadding:
            EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            horizontalTitleGap: 0,
            minVerticalPadding: 0,
            leading: Stack(
              children: [
                getImage(widget.truckLoad.companyLogo.toString()),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Image.asset(
                    widget.truckLoad.isPaid == 30
                        ? 'assets/images/diamond.png'
                        : widget.truckLoad.isPaid == 20
                        ? 'assets/images/gold_badge.png'
                        : 'assets/images/ruby_badge.png',
                    width: 15,
                    height: 20,
                  ),
                )
              ],
            ),
            title: Row(
              children: [
                langCode == 'en' ? Text( widget.truckLoad.nameOfPerson
                    .toString(),
                    style: titleTextStyle):CustomText(
                    widget.truckLoad.nameOfPerson
                        .toString(),
                    style: titleTextStyle),
                SizedBox(
                  width: 10,
                ),
                widget.truckLoad.isVerifiedByCompany ==
                    null
                    ? Image.asset(
                  'assets/images/membership.png',
                  width: 15,
                  height: 15,
                )
                    : Image.asset(
                  'assets/images/membership.png',
                  width: 15,
                  height: 15,
                )
              ],
            ),
            subtitle: langCode == 'en' ? Text( widget.truckLoad.companyName.toString(),
                style: subTitleTextStyle):CustomText(
                widget.truckLoad.companyName.toString(),
                style: subTitleTextStyle),

   //   trailing: ConvertStringToDate(widget.truckLoad.postingTime.toString()),
          ),
          SizedBox(height: 20,),
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
                langCode == 'en' ? Text(widget.truckLoad.source.toString(),
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: 'RobotoSlab',
                      fontWeight: FontWeight.bold),):CustomText(
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
                Image.asset('assets/images/two_way_arrow.png',height: 15,width: 25,),
                SizedBox(
                  width: 10,
                ),
                langCode == 'en' ? Text( widget.truckLoad.destination
                    .toString(),
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: 'RobotoSlab',
                      fontWeight: FontWeight.bold),):CustomText(
                  widget.truckLoad.destination
                      .toString(),
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: 'RobotoSlab',
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 10.0, vertical: 7),
            child: langCode == 'en' ? Text(widget.truckLoad.topicName.toString(),
                style: titilliumSemiBold):CustomText(
                widget.truckLoad.topicName.toString(),
                style: titilliumSemiBold),
          ),
          SizedBox(height: 5,),
          Padding(
            padding: const EdgeInsets.only(
                left: 10.0, bottom: 10, right: 10),
            child: langCode == 'en' ? Text(widget.truckLoad.content.toString(),
              style: regularTextStyle,):CustomText(
              widget.truckLoad.content.toString(),
              style: regularTextStyle,
            ),
          ),
          SizedBox(height: 19.5,),
          Divider(
            height: 1,
            thickness: 1,
          ),
          SizedBox(height: 19.5,),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 10.0, vertical: 7),
            child: CustomText(
                'Other Details',
                style: Style.appsubtitle),
          ),
          SizedBox(height: 10.5,),
          Padding(
            padding: const EdgeInsets.only(
                left: 10.0, bottom: 20, right: 10),
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
                    SizedBox(height: 16,),
                    CustomText('Vehicle Size', style: regularTextStyle),
                    SizedBox(height: 16,),
                    CustomText('User Verify', style: regularTextStyle),
                    SizedBox(height: 16,),
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
                     Text(': ${widget.truckLoad.mobileNumber.toString()}',
                      style: TextStyle(
                          color: ColorResources.PRIMARY_COLOR),),
                    SizedBox(
                      height: 16,
                    ),
                    Text(': ${widget.truckLoad.vehicleSize.toString()}',
                      style: TextStyle(
                          color: ColorResources.PRIMARY_COLOR),),
                    SizedBox(
                      height: 16,
                    ),
                    Text( widget.truckLoad.isVerifiedByCompany ==
                        1?': Not Verified User ':': Verified by TKDost team',
                      style: TextStyle(
                          color: ColorResources.PRIMARY_COLOR),),
                    SizedBox(
                      height: 16,
                    ),
                    Text(': ${widget.truckLoad.typeOfPayment.toString()}',
                      style: TextStyle(
                          color: ColorResources.PRIMARY_COLOR),),
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
                        openwhatsapp(
                            context,
                            widget
                                .truckLoad
                                .mobileNumber
                                .toString(),
                            'Type : ${widget.truckLoad.type}, \nSubject : ${widget.truckLoad.content}, \nSource : ${widget.truckLoad.source}, \nDestination : ${widget.truckLoad.destination}, \nLink : https://api.tkdost.com/bids/?id=${widget.truckLoad.id}');
                      },
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.center,
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
                          Text(getTranslated("chat", context)!,
                            style: Style.bottomHeading,
                          )
                        ],
                      ),
                    ),
                    SizedBox(width: 10,),
                    InkWell(
                      onTap: () async {
                        Share.share(
                            widget
                                .truckLoad
                                .mobileNumber
                                .toString()+'Type : ${widget.truckLoad.type}, \nSubject : ${widget.truckLoad.content}, \nSource : ${widget.truckLoad.source}, \nDestination : ${widget.truckLoad.destination}, \nLink : https://api.tkdost.com/bids/?id=${widget.truckLoad.id}'
                        );

                      },
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.center,
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
                    SizedBox(width: 10,),
                    InkWell(
                      onTap: () {
                        launch("tel:${ widget
                            .truckLoad.mobileNumber}"

                        );
                      },
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/call.png',
                            color: ColorResources
                                .PRIMARY_COLOR,
                            height: 15,
                            width: 15,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            ("Call")!,
                            style:
                            Style.bottomHeading,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: (){
                    showAnimatedDialog(
                        context,
                        Dialog(
                          shape:
                          RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius
                                  .circular(
                                  10)),
                          child: Form(
                            key: _formKey,
                            child: Container(
                              height: 350,
                              width: 300,
                              child: Stack(
                                children: [
                                  Padding(
                                    padding:
                                    EdgeInsets.all(16),
                                    child: Column(
                                        children: [
                                          CustomText(
                                            'Place Your Bid',
                                            style: TextStyle(
                                                fontSize:
                                                18,
                                                fontWeight:
                                                FontWeight
                                                    .bold),
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          CustomTextField(
                                              controller:
                                              bidAmtController,
                                              hintText:
                                              "Enter Your Bid Amount",
                                              isDigits:true,
                                              textInputType:
                                              TextInputType
                                                  .number),
                                          CustomTextField(
                                              controller:
                                              descriptionController,
                                              hintText:
                                              "Comments/Descriptions",
                                              textInputType:
                                              TextInputType
                                                  .number),
                                          CustomButton(
                                              onTap: () {
                                                if (_formKey.currentState!.validate()) {

                                                  bidProvider
                                                      .generateBid(
                                                      mobile:
                                                      authProvider.userDetailList[0].mobileNumber,
                                                      description: descriptionController.text,
                                                      idOfPost: widget.truckLoad.id,
                                                      email: authProvider.userDetailList[0].emailId,
                                                      amount: bidAmtController.text,
                                                      id: 0,
                                                      bidderUserName: authProvider.userDetailList[0].userName,
                                                      userName: authProvider.userDetailList[0].userName,
                                                      type: widget.truckLoad.mainTag,
                                                      loggedUserName: '${authProvider.userDetailList[0].firstName} ${authProvider.userDetailList[0].lastName}')
                                                      .then((value) => {
                                                    showAnimatedDialog(
                                                        context,
                                                        MyDialog(
                                                          icon: Icons.check,
                                                          title: 'Generate Bid',
                                                          description: 'Your Bid Created successfully',
                                                          isFailed: false,
                                                        ),
                                                        dismissible: false,
                                                        isFlip: false),
                                                  });
                                                  Navigator.of(
                                                      context)
                                                      .pop();
                                                }},
                                              buttonText:
                                              "Submit")
                                        ]),
                                  ),
                                  Positioned(
                                    top: 10,
                                    right: 10,
                                    child: IconButton(
                                      icon: Icon(Icons.close,size: 18,),
                                      onPressed: (){
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
                    foregroundColor: Colors.white, backgroundColor: Colors.black,
                    elevation: 3,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 5,horizontal: 0),
                    child: CustomText("Bid Now",
                        style: Style.button),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 1.5,
            thickness: 1.5,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Center(child: RatingStar()),
          ),

        ],
      ),
    );
  }
}
