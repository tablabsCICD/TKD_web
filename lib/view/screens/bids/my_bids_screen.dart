import 'dart:convert';
import 'dart:ui';
import 'package:number_pagination/number_pagination.dart';
import 'package:provider/provider.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';
import 'package:tkd_app/dialog/animated_custom_dialog.dart';
import 'package:tkd_app/dialog/my_dialog.dart';
import 'package:tkd_app/locator.dart';
import 'package:tkd_app/model/bid_model.dart';
import 'package:tkd_app/multi_select.dart';
import 'package:tkd_app/open_whatsapp.dart';
import 'package:tkd_app/provider/auth_provider.dart';
import 'package:tkd_app/provider/bid_provider.dart';
import 'package:tkd_app/provider/dashboard_provider.dart';
import 'package:tkd_app/provider/localization_provider.dart';
import 'package:tkd_app/share_data.dart';
import 'package:tkd_app/show_bid.dart';
import 'package:tkd_app/util/style.dart';
import 'package:tkd_app/view/base_widget/custom_textfeild.dart';
import 'package:tkd_app/view/base_widget/custom_textview.dart';
import 'package:tkd_app/view/base_widget/getImage.dart';
import 'package:tkd_app/view/base_widget/getLoader.dart';
import 'package:tkd_app/view/localization/language_constrants.dart';
import 'package:tkd_app/view/screens/dashboard/requirementDeatils.dart';
import 'package:tkd_app/view/screens/menu_page.dart';
import 'package:universal_html/html.dart' as html;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:tkd_app/model/truck_load_model.dart';
import 'package:tkd_app/util/ResponsiveWidget.dart';
import 'package:tkd_app/util/color-resource.dart';
import 'package:tkd_app/util/custom_text_style.dart';
import 'package:tkd_app/util/date_converter.dart';
import 'package:tkd_app/util/star_display.dart';
import 'package:tkd_app/view/base_widget/custom_button.dart';
import 'package:tkd_app/view/screens/dashboard/allRequirement.dart';

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
 /* final authProvider = locator<AuthProvider>();
  final dashboardProvider = locator<DashboardProvider>();*/

  final langProvider = locator<LocalizationProvider>();
  String? langCode;

  @override
  void initState() {
    super.initState();
    langCode = langProvider.selectedlangCode;
  }
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
//    TruckLoad truckLoad = dashboardProvider.truckLoadTypeList[0];
    return Consumer<BidProvider>(
        builder: (context, model, child) => Container(
              margin: ResponsiveWidget.isDesktop(context)?EdgeInsets.symmetric(
                horizontal: 35,vertical: 10
              ):EdgeInsets.symmetric(
                  horizontal: 10,vertical: 10
              ),
              child: model.allBidingList.isEmpty && model.isLoading == false
            ? Expanded(
            child: Container(
              alignment: Alignment.center,
            height: MediaQuery.of(context).size.height - 200,
            child: Center(child: Text(getTranslated('no_post', context)!,style: Style.heading,))))
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
                                child: Card(
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
                                              langCode == 'en' ? Text(model.allBidingList[index].source.toString(),
                                                  style: TextStyle(
                                                      color: Colors.black54,
                                                      fontSize: 14,
                                                      fontFamily: 'RobotoSlab',
                                                      fontWeight: FontWeight.bold)):CustomText(
                                                model.allBidingList[index].source.toString(),
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
                                              langCode == 'en' ? Text(model.allBidingList[index].destination.toString(),
                                                  style: TextStyle(
                                                      color: Colors.black54,
                                                      fontSize: 14,
                                                      fontFamily: 'RobotoSlab',
                                                      fontWeight: FontWeight.bold)):CustomText(
                                                model.allBidingList[index].destination.toString(),
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
                                          child: langCode == 'en' ? Text( model.allBidingList[index].content
                                              .toString(),
                                            style: regularTextStyle,):CustomText(
                                            model.allBidingList[index].content
                                                .toString(),
                                            style: regularTextStyle,
                                          ),
                                        ),
                                        /*Divider(
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
                                        ),*/

                                      ],
                                    ),
                                  ),
                                ),
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
}
