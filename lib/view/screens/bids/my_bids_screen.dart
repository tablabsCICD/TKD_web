import 'dart:convert';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';
import 'package:tkd_app/dialog/animated_custom_dialog.dart';
import 'package:tkd_app/dialog/my_dialog.dart';
import 'package:tkd_app/locator.dart';
import 'package:tkd_app/model/biding_user_model.dart';
import 'package:tkd_app/provider/auth_provider.dart';
import 'package:tkd_app/provider/bid_provider.dart';
import 'package:tkd_app/provider/localization_provider.dart';
import 'package:tkd_app/util/style.dart';
import 'package:tkd_app/view/base_widget/custom_textview.dart';
import 'package:tkd_app/view/base_widget/getLoader.dart';
import 'package:tkd_app/view/base_widget/home_base_widgets.dart';
import 'package:tkd_app/view/base_widget/utils.dart';
import 'package:tkd_app/view/localization/language_constrants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tkd_app/util/ResponsiveWidget.dart';
import 'package:tkd_app/util/color-resource.dart';
import '../../../util/app_constants.dart';

class MyBidsScreen extends StatefulWidget {
  final bidProvider = locator<BidProvider>();
  final authProvider = locator<AuthProvider>();

  MyBidsScreen({Key? key}) : super(key: key) {
    print('UserName : ${authProvider.userDetailList[0].userName.toString()}');
    bidProvider.getAllBidingList(authProvider.userDetailList[0].userName.toString(),0);
  }

  @override
  _MyBidsScreenState createState() => _MyBidsScreenState();
}

class _MyBidsScreenState extends State<MyBidsScreen> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: ColorResources.HOME_BG,
        child: ResponsiveWidget(
          desktop: WebScreenForBid(),
          mobile: WebScreenForBid(),
          tablet: WebScreenForBid(),
        ),
      ),
    );
  }
}

class WebScreenForBid extends StatefulWidget {
  @override
  _WebScreenForBidState createState() => _WebScreenForBidState();
}

class _WebScreenForBidState extends State<WebScreenForBid> {

  final langProvider = locator<LocalizationProvider>();
  final authProvider = locator<AuthProvider>();
  String? langCode;

  @override
  void initState() {
    super.initState();
    langCode = langProvider.selectedlangCode;
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<BidProvider>(
        builder: (context, model, child) => Container(
              margin: ResponsiveWidget.isDesktop(context)?EdgeInsets.symmetric(
                horizontal: 35,vertical: 10
              ):EdgeInsets.symmetric(
                  horizontal: 10,vertical: 10
              ),
              child: model.allBidingList.isEmpty && model.isLoading == false
            ? Container(
              alignment: Alignment.center,
            height: MediaQuery.of(context).size.height - 200,
            child: Center(child: Text(getTranslated('no_post', context)!,style: Style.heading,)))
            :Column(
                    children: [
                   model.allBidingList.isEmpty && model.isLoading ? SizedBox(height: MediaQuery.of(context).size.height/2.5,):Expanded(
                          child: StaggeredGridView.countBuilder(
                            crossAxisCount: ResponsiveWidget.isDesktop(context)
                                ? 3
                                : ResponsiveWidget.isMobile(context)
                                    ? 1
                                    : 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 12,
                            itemCount: model.allBidingList.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  // Navigator.push(context, MaterialPageRoute(builder: (builder)=> RequirementDetails(widget.loadTypeList[index])));
                                },
                                child: /*Card(
                                  elevation: 5,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10)),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: 140,
                                              height: 20,
                                              alignment: Alignment.center,
                                              decoration: new BoxDecoration(
                                                  color: model.allBidingList[index].mainTag ==
                                                          "Full load required"
                                                      ? ColorResources
                                                          .FULL_LOAD_REQUIRED
                                                      : model.allBidingList[index].mainTag ==
                                                              "Part load required"
                                                          ? ColorResources
                                                              .PART_LOAD_REQUIRED
                                                          : model.allBidingList[index].mainTag ==
                                                                  "Full load available"
                                                              ? ColorResources
                                                                  .FULL_LOAD_AVAILABLE
                                                              : ColorResources
                                                                  .PART_LOAD_AVAILABLE,
                                                  borderRadius: BorderRadius.only(
                                                      topLeft: Radius.circular(5),
                                                      bottomRight:
                                                          Radius.circular(10))),
                                              child: CustomText(model.allBidingList[index].mainTag.toString(),
                                                  style: TextStyle(fontSize: 12,fontFamily: 'RobotoMedium',color: model
                                                      .allBidingList[
                                                  index]
                                                      .mainTag ==
                                                      "Full load required"
                                                      ? ColorResources
                                                      .FLR_TEXT
                                                      : model
                                                      .allBidingList[
                                                  index]
                                                      .mainTag ==
                                                      "Part load required"
                                                      ? ColorResources
                                                      .PLR_TEXT
                                                      : model
                                                      .allBidingList[
                                                  index]
                                                      .mainTag ==
                                                      "Full load available"
                                                      ? ColorResources
                                                      .FLA_TEXT
                                                      : ColorResources
                                                      .PLA_TEXT)),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(right: 8.0),
                                              child: ConvertStringToDate(
                                                  model.allBidingList[index].postingTime.toString()),
                                            ),
                                          ],
                                        ),
                                        ListTile(
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 0, horizontal: 5),
                                          horizontalTitleGap: 5,
                                          minVerticalPadding: 0,
                                          leading: getImage(''),
                                             // model.truckLoadTypeList[index].companyLogo.toString()),
                                          title: langCode == 'en' ? Text(model.allBidingList[index].nameOfPerson.toString() == ''?
                                          model.allBidingList[index].reminderUserName.toString():model.allBidingList[index].nameOfPerson.toString(),
                                              style: titleTextStyle):CustomText(model.allBidingList[index].nameOfPerson.toString() == ''?
                                              model.allBidingList[index].reminderUserName.toString():model.allBidingList[index].nameOfPerson.toString(),
                                              style: titleTextStyle),
                                          subtitle: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              langCode == 'en' ? Text(model.allBidingList[index].companyName.toString(),
                                                  style: subTitleTextStyle):CustomText(model.allBidingList[index].companyName.toString(),
                                                  style: subTitleTextStyle),
                                              StarDisplay(
                                                  value:
                                                  model.allBidingList[index].ratings!.toInt()),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          alignment: Alignment.center,
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 45, vertical: 7),
                                          height: 30,
                                          decoration: new BoxDecoration(
                                              color: Color(0xfff0f0f0),
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(model.allBidingList[index].source.toString(),
                                                  style: TextStyle(
                                                      color: Colors.black54,
                                                      fontSize: 14,
                                                      fontFamily: 'RobotoSlab',
                                                      fontWeight: FontWeight.bold)),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Image.asset('assets/images/two_way_arrow.png',height: 15,width: 25,),
                                              SizedBox(
                                                width: 10,
                                              ),
                                               Text(model.allBidingList[index].destination.toString(),
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
                                          padding: const EdgeInsets.only(
                                              left: 10.0, right: 10,top: 5),
                                          child: langCode == 'en' ? Text(model.allBidingList[index].topicName.toString(),
                                              style: titilliumSemiBold):CustomText(
                                              model.allBidingList[index].topicName.toString(),
                                              style: titilliumSemiBold),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10.0, right: 10,top: 5),
                                          child: Row(
                                            children: [
                                              CustomText('Your Bid : ',
                                                  style: TextStyle(
                                                      color: ColorResources
                                                          .PRIMARY_COLOR,
                                                      fontWeight: FontWeight.bold)),
                                              CustomText(
                                                  model.allBidingList[index].amount
                                                      .toString(),
                                                  style: TextStyle(
                                                      color: ColorResources
                                                          .PRIMARY_COLOR,
                                                      fontWeight: FontWeight.bold)),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 5,
                                              left: 10.0, bottom: 10, right: 10),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                           // crossAxisAlignment: CrossAxisAlignment.stretch,
                                            children: [
                                              Text( model.allBidingList[index].content
                                                  .toString(),
                                                style: regularTextStyle,),

                                              InkWell(
                                                onTap: (){
                                                  showDialogs(model.allBidingList[index].bidingId,model,index);
                                                },
                                                child: Text( "Delete",
                                                  style: TextStyle(
                                                      color: ColorResources
                                                          .PRIMARY_COLOR,
                                                      fontWeight: FontWeight.bold),),
                                              ),
                                            ],
                                          ),
                                        ),
                                        *//*Divider(
                                          height: 1.5,
                                          thickness: 1.5,
                                        ),
                                        Container(
                                          margin: EdgeInsets.symmetric(vertical: 5),
                                          alignment: Alignment.center,
                                          child: ElevatedButton(
                                            onPressed: (){
                                              showDialog(
                                                  context: context,
                                                  builder: (_) =>
                                                  new CupertinoAlertDialog(
                                                    title: CustomText(
                                                        'Are you sure want to deleted your job?'),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        child: CustomText(
                                                            getTranslated(
                                                                'yes',
                                                                context)!,
                                                            style: TextStyle(
                                                                color:
                                                                ColorResources
                                                                    .RED)),
                                                        onPressed: () {
                                                          model
                                                              .deleteBid(model
                                                              .allBidingList[
                                                          index])
                                                              .then(
                                                                  (value) => {
                                                                showAnimatedDialog(
                                                                    context,
                                                                    MyDialog(
                                                                      icon: Icons.check,
                                                                      title: 'Bid Delete',
                                                                      description: 'Your bid deleted successfully',
                                                                      isFailed: false,
                                                                    ),
                                                                    dismissible: false,
                                                                    isFlip: false)
                                                              });
                                                          Navigator.of(
                                                              context)
                                                              .pop();
                                                        },
                                                      ),
                                                      TextButton(
                                                        child: CustomText(
                                                          getTranslated(
                                                              'no', context)!,
                                                          style: TextStyle(
                                                              color:
                                                              ColorResources
                                                                  .GREEN),
                                                        ),
                                                        onPressed: () {
                                                          Navigator.of(
                                                              context)
                                                              .pop();
                                                        },
                                                      ),
                                                    ],
                                                  ));
                                            },
                                            style: ElevatedButton.styleFrom(
                                              primary: Colors.red[200],
                                              onPrimary: Colors.white,
                                              elevation: 3,
                                            ),
                                            child: CustomText("Delete",style: Style.button,),
                                          ),
                                        ),*//*

                                      ],
                                    ),
                                  ),
                                ),*/
                                cardLoad(index, context, model.allBidingList[index], model)
                              );
                            },
                            physics: ScrollPhysics(),
                            shrinkWrap: true,
                            staggeredTileBuilder: (int index) =>
                                StaggeredTile.fit(1),
                          ),
                        ),
                      getLoader(model.isLoading)
                    ],
                  ),
            )
    );
  }

  cardLoad(int index, BuildContext context, BidingUser bids,BidProvider provider) {
    return Container(
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
                  Utils().mainTag(bids.mainTag)          ,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          Container(
            transform: Matrix4.translationValues(0.0, -20.0, 0.0),
            child: Column(
              children: [
                Text(
                  "Quote price",
                  style: TextStyle(
                    color: Color(0x99001E49),
                    fontSize: 10,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    fontWeight: FontWeight.w400,
                    height: 0,
                  ),
                ),
                Text(
                  '₹ ${bids.amount}',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    fontWeight: FontWeight.w600,
                    height: 0,
                  ),
                ),
              ],
            ),
          ),
          BaseWidget().routes(bids.source, bids.destination),
          SizedBox(
            height: 12,
          ),
          BaseWidget().heading1(bids.topicName, bids.postingTime.split(" ").first, bids.content!),
          BaseWidget().onlyBidButton((){
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Withdraw quote',style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    fontWeight: FontWeight.w600,
                  ),),
                  content: Text('Are you sure you want to withdraw this quote?',style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    fontWeight: FontWeight.w400,
                  ),),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                      },
                      child: Text('Cancel',style: TextStyle(color: ColorResources.THEME_COLOR, fontSize: 12,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontWeight: FontWeight.w600,),),
                    ),
                    TextButton(
                      onPressed: () {
                        provider
                            .deleteBid(provider
                            .allBidingList[
                        index])
                            .then(
                                (value) => {
                              showAnimatedDialog(
                                  context,
                                  MyDialog(
                                    icon: Icons.check,
                                    title: 'Quote Withdraw',
                                    description: 'Your quote deleted successfully',
                                    isFailed: false,
                                  ),
                                  dismissible: false,
                                  isFlip: false)
                            });
                        Navigator.of(
                            context)
                            .pop();
                      },
                      child: Text(
                        'Withdraw',
                        style: TextStyle(color: Colors.red, fontSize: 12,
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          fontWeight: FontWeight.w600,),
                      ),
                    ),
                  ],
                );
              },
            );

          })
        ],
      ),
    );
  }

  showDialogs(int id ,BidProvider model,int index){
    showDialog(
        context: context,
        builder: (_) =>
        new CupertinoAlertDialog(
          title: CustomText(
              'Do you want to delete account',
              style: TextStyle(
                color: ColorResources.BOTTOM_HEADING,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              )),
          actions: <Widget>[
            TextButton(

              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                    'Cancel',
                    style: TextStyle(
                        color:
                        ColorResources
                            .GREEN,
                        fontSize:
                        18)),
              ),
              onPressed: () {
                callDeleteBid(model.allBidingList[index].bidingId,model,index);
              },
            ),
            TextButton(
              child: Padding(
                padding:
                const EdgeInsets
                    .all(10.0),
                child: Text(
                    'Yes',
                    style: TextStyle(
                        color:
                        ColorResources
                            .RED,
                        fontSize:
                        18)),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ));


  }

  void callDeleteBid(int id ,BidProvider model,int index)async {

    String myUrl = ApiConstant.BID_TO_POST + '?id=$id';
    var req = await http.delete(Uri.parse(myUrl));
    json.decode(req.body);
   if(req.statusCode==200){
     model.allBidingList.removeAt(index);

   }
  }


}
