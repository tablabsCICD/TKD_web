

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tkd_app/dialog/animated_custom_dialog.dart';
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
import 'package:tkd_app/view/base_widget/custom_button.dart';
import 'package:tkd_app/view/base_widget/custom_textfeild.dart';
import 'package:tkd_app/view/base_widget/custom_textview.dart';
import 'package:tkd_app/view/base_widget/getImage.dart';
import 'package:tkd_app/view/base_widget/rating_star.dart';
import 'package:tkd_app/view/localization/language_constrants.dart';

class BuySellDetailsScreen extends StatefulWidget {
  TruckLoad truckLoad;
  BuySellDetailsScreen(this.truckLoad);

  @override
  _BuySellDetailsScreenState createState() => _BuySellDetailsScreenState();
}

class _BuySellDetailsScreenState extends State<BuySellDetailsScreen> {
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
      appBar: AppBar(
        backgroundColor: ColorResources.PRIMARY_COLOR,
        title: CustomText('Buy Sell Details'),),
      body: Container(
        child: ResponsiveWidget.isMobile(context)
            ? Stack(children: [
          Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fill,
                image: NetworkImage('assets/images/truck.png'),
              ),
            ),
            child: getCart()
          ),
        ])
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

  getCart(){
    return Container(
      width: ResponsiveWidget.isMobile(context) ? MediaQuery.of(context).size.width : MediaQuery.of(context).size.width/2,
      child: Card(
        color: Colors.transparent,
        elevation: 5,
        margin: EdgeInsets.all(10),
        child: ListView(
          children: [
            ListTile(
              contentPadding:
              EdgeInsets.symmetric(vertical: 0, horizontal: 5),
              horizontalTitleGap: 5,
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
              subtitle: langCode == 'en' ? Text(widget.truckLoad.companyName.toString(),
                  style: subTitleTextStyle):CustomText(
                  widget.truckLoad.companyName.toString(),
                  style: subTitleTextStyle),
              trailing: ConvertStringToDate(widget
                  .truckLoad.postingTime
                  .toString()),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 10.0, vertical: 7),
              child: langCode == 'en' ? Text(widget.truckLoad.topicName.toString(),
                  style: titilliumSemiBold):CustomText(
                  widget.truckLoad.topicName.toString(),
                  style: titilliumSemiBold),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 10.0, bottom: 10, right: 10),
              child: langCode == 'en' ? Text(widget.truckLoad.content.toString(),
                style: regularTextStyle,):CustomText(
                widget.truckLoad.content.toString(),
                style: regularTextStyle,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 10.0, bottom: 10, right: 10),
              child: langCode == 'en' ? Text( widget.truckLoad.content.toString(),
                style: regularTextStyle,):CustomText(
                widget.truckLoad.content.toString(),
                style: regularTextStyle,
              ),
            ),
            Divider(
              height: 1.5,
              thickness: 1.5,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 10.0, vertical: 7),
              child: CustomText(
                  'Other Details',
                  style: titilliumSemiBold),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 10.0, bottom: 10, right: 10),
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        'Email_Id',
                        style: regularTextStyle,
                      ),
                      CustomText('Alternate Number', style: regularTextStyle),
                      CustomText('Vehicle Size', style: regularTextStyle),
                      CustomText('User Type', style: regularTextStyle),
                    ],
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      langCode == 'en' ? Text(': ${widget.truckLoad.companyName.toString()}',
                        style: TextStyle(
                            color: ColorResources.PRIMARY_COLOR),):CustomText(
                        ': ${widget.truckLoad.companyName.toString()}',
                        style: TextStyle(
                            color: ColorResources.PRIMARY_COLOR),
                      ),
                      langCode == 'en' ? Text( ': ${widget.truckLoad.alterativeNumber.toString()}',
                        style: TextStyle(
                            color: ColorResources.PRIMARY_COLOR),):CustomText(
                        ': ${widget.truckLoad.alterativeNumber.toString()}',
                        style: TextStyle(
                            color: ColorResources.PRIMARY_COLOR),
                      ),
                      langCode == 'en' ? Text(': ${widget.truckLoad.vehicleSize.toString()}',
                        style: TextStyle(
                            color: ColorResources.PRIMARY_COLOR),):CustomText(
                        ': ${widget.truckLoad.vehicleSize.toString()}',
                        style: TextStyle(
                            color: ColorResources.PRIMARY_COLOR),
                      ),
                      langCode == 'en' ? Text(': ${widget.truckLoad.type.toString()}',
                        style: TextStyle(
                            color: ColorResources.PRIMARY_COLOR),):CustomText(
                        ': ${widget.truckLoad.type.toString()}',
                        style: TextStyle(
                            color: ColorResources.PRIMARY_COLOR),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Divider(
              height: 1.5,
              thickness: 1.5,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: () async {
                      showDialog(context: context,
                          builder: (BuildContext context){
                            return ShareDialogBox(
                                widget.truckLoad
                            );
                          }
                      );

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
                            style: Style.bottomHeading
                        )
                      ],
                    ),
                  ),

                  Container(
                    width: 1.5,
                    height: 30,
                    color: Colors.grey,
                  ),
                  InkWell(
                    onTap: () async {
                      openwhatsapp(context, widget.truckLoad.mobileNumber.toString(),   'Type : ${widget.truckLoad.type}, \nSubject : ${widget.truckLoad.content}');
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
                          style: Style.bottomHeading
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: 1.5,
                    height: 30,
                    color: Colors.grey,
                  ),
                  InkWell(
                    onTap: () async {
                      showDialog(
                          context: context,
                          builder: (_) =>
                          new CupertinoAlertDialog(
                            title: CustomText(
                                'Contact Number : ${widget.truckLoad.mobileNumber}',
                                style: TextStyle(
                                    color:
                                    ColorResources
                                        .BOTTOM_HEADING,
                                    fontSize: 18,
                                    fontWeight:
                                    FontWeight
                                        .bold)),
                            actions: <Widget>[
                              TextButton(
                                child: Padding(
                                  padding:
                                  const EdgeInsets
                                      .all(10.0),
                                  child: CustomText(
                                      "Ok",
                                      style: TextStyle(
                                          color:
                                          ColorResources
                                              .GREEN,
                                          fontSize:
                                          18)),
                                ),
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop();
                                },
                              ),
                            ],
                          ));
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
                          width: 10,
                        ),
                        CustomText(
                          'Call',
                          style: Style.bottomHeading
                        )
                      ],
                    ),
                  )
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
      ),
    );
  }
}
