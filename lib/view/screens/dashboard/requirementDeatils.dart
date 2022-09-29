

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
import 'package:tkd_app/view/base_widget/custom_button.dart';
import 'package:tkd_app/view/base_widget/custom_textfeild.dart';
import 'package:tkd_app/view/base_widget/custom_textview.dart';
import 'package:tkd_app/view/base_widget/rating_star.dart';
import 'package:tkd_app/view/localization/language_constrants.dart';

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
      appBar: AppBar(
        backgroundColor: ColorResources.PRIMARY_COLOR,
        title: CustomText('Requirement Details'),),
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
  final _formKey = GlobalKey<FormState>();
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
              subtitle: langCode == 'en' ? Text( widget.truckLoad.companyName.toString(),
                  style: subTitleTextStyle):CustomText(
                  widget.truckLoad.companyName.toString(),
                  style: subTitleTextStyle),
              trailing: ConvertStringToDate(widget
                  .truckLoad.postingTime
                  .toString()),
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal: 45),
              height: 30,
              decoration: new BoxDecoration(
                  color: Color(0xffcacdd0),
                  borderRadius: BorderRadius.circular(5)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  langCode == 'en' ? Text(widget.truckLoad.source.toString(),
                    style: TextStyle(
                        color: Colors.black54,
                        fontSize: 14,
                        fontFamily: 'RobotoSlab',
                        fontWeight: FontWeight.bold),):CustomText(
                    widget.truckLoad.source.toString(),
                    style: TextStyle(
                        color: Colors.black54,
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
                        color: Colors.black54,
                        fontSize: 14,
                        fontFamily: 'RobotoSlab',
                        fontWeight: FontWeight.bold),):CustomText(
                    widget.truckLoad.destination
                        .toString(),
                    style: TextStyle(
                        color: Colors.black54,
                        fontSize: 14,
                        fontFamily: 'RobotoSlab',
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
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
                      CustomText('Type Of Payment', style: regularTextStyle),
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
                      langCode == 'en' ? Text(': ${widget.truckLoad.alterativeNumber.toString()}',
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
                      langCode == 'en' ? Text( ': ${widget.truckLoad.type.toString()}',
                        style: TextStyle(
                            color: ColorResources.PRIMARY_COLOR),):CustomText(
                        ': ${widget.truckLoad.type.toString()}',
                        style: TextStyle(
                            color: ColorResources.PRIMARY_COLOR),
                      ),
                      langCode == 'en' ? Text(': ${widget.truckLoad.typeOfPayment.toString()}',
                        style: TextStyle(
                            color: ColorResources.PRIMARY_COLOR),):CustomText(
                        ': ${widget.truckLoad.typeOfPayment.toString()}',
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
                              'Type : ${widget.truckLoad.type}, \nSubject : ${widget.truckLoad.content}, \nSource : ${widget.truckLoad.source}, \nDestination : ${widget.truckLoad.destination}');
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
                          showDialog(context: context,
                              builder: (BuildContext context){
                                return ShareDialogBox(
                                    widget.truckLoad
                                );
                              }
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
                      )
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
                      primary: Colors.black,
                      onPrimary: Colors.white,
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
            /*Consumer<BidProvider>(
              builder: (context, model, child) => ListView.builder(
                shrinkWrap: true,
                itemCount: model.receivedBidingList.length,
                itemBuilder: (context,index){
                  return Card(
                    elevation: 3,
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(model.receivedBidingList[index].loggedUserName.toString(),style: Style.selectedMenuHeading,),
                          Row(
                            children: [
                              CustomText('Bid Amount Is : ',
                                  style: TextStyle(
                                      color: ColorResources
                                          .PRIMARY_COLOR,
                                      fontWeight: FontWeight.bold)),
                              CustomText(
                                  model.receivedBidingList[index].amount
                                      .toString(),
                                  style: TextStyle(
                                      color: ColorResources
                                          .PRIMARY_COLOR,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                          Text(model.receivedBidingList[index].description.toString(),style: Style.selectedMenuHeading,),

                        ],
                      ),
                    ),
                  );
                },
              ),
            )*/
          ],
        ),
      ),
    );
  }
}
