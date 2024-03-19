import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:number_pagination/number_pagination.dart';
import 'package:provider/provider.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';
import 'package:tkd_app/dialog/animated_custom_dialog.dart';
import 'package:tkd_app/dialog/my_dialog.dart';
import 'package:tkd_app/dialog/share_dialog_box.dart';
import 'package:tkd_app/locator.dart';
import 'package:tkd_app/model/truck_load_model.dart';
import 'package:tkd_app/open_whatsapp.dart';
import 'package:tkd_app/provider/buy_sell_provider.dart';
import 'package:tkd_app/provider/job_provider.dart';
import 'package:tkd_app/provider/localization_provider.dart';
import 'package:tkd_app/share_data.dart';
import 'package:tkd_app/util/ResponsiveWidget.dart';
import 'package:tkd_app/util/color-resource.dart';
import 'package:tkd_app/util/colors.dart';
import 'package:tkd_app/util/custom_text_style.dart';
import 'package:http/http.dart' as http;
import 'package:tkd_app/util/date_converter.dart';
import 'package:tkd_app/util/star_display.dart';
import 'package:tkd_app/util/style.dart';
import 'package:tkd_app/view/base_widget/custom_textview.dart';
import 'package:tkd_app/view/base_widget/getImage.dart';
import 'package:tkd_app/view/base_widget/getLoader.dart';
import 'package:tkd_app/view/localization/language_constrants.dart';
import 'package:tkd_app/view/screens/buy_sell/buy_sell_details_screen.dart';
import 'package:tkd_app/view/screens/buy_sell/create_new_post.dart';
import 'package:tkd_app/view/screens/dashboard/requirementDeatils.dart';

import 'package:universal_html/html.dart' as html;

class BuySellVehicles extends StatefulWidget {
  final buySellProvider = locator<BuySellProvider>();

  BuySellVehicles({Key? key}) : super(key: key) {
    buySellProvider.getBuyVehicles();
    buySellProvider.getSellVehicles();
  }

  @override
  _BuySellVehiclesState createState() => _BuySellVehiclesState();
}

class _BuySellVehiclesState extends State<BuySellVehicles> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: ColorResources.HOME_BG,
      body: Container(
        child: Column(
          children: [
            Container(
              height: 60,
              color: ThemeColor.baground,
              child: Padding(
                padding: ResponsiveWidget.isDesktop(context)?EdgeInsets.symmetric(horizontal: 35,vertical: 10):EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                child: Row(
                  children: [
                    getCircularContainer("Buy Vehicles",(selectedTab == "Buy Vehicles")),
                    getCircularContainer("Sell Vehicles",(selectedTab == "Sell Vehicles")),
                  ],
                ),
              ),
            ),
            selectedTab == "Buy Vehicles"
                ? Expanded(
                  child: Container(
              color: ColorResources.HOME_BG,
              child: ResponsiveWidget(
                  desktop: BuyCard(),
                  mobile: BuyCard(),
                  tablet: BuyCard(),
              ),
            ),
            )
            :Expanded(
              child: Container(
                color: ColorResources.HOME_BG,
                child: ResponsiveWidget(
                  desktop: SellCard(),
                  mobile: SellCard(),
                  tablet: SellCard(),
                ),
              ),
            ),
          ],
        ),
      )
    );
  }

  var selectedTab = 'Buy Vehicles';

  getCircularContainer(String title, bool isSelected) {
    return InkWell(
      onTap: (){
        setState(() {
          selectedTab = title;
        });
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 2.7),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Container(
          height: 30,
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: 5,horizontal: 20),
          child: CustomText(title,style: isSelected?Style.filterSelectedHeading:Style.filterHeading,textAlign: TextAlign.center,),
          decoration: BoxDecoration(
            color: isSelected? ColorResources.RED :Color(0xffe6e0d7),
            border: isSelected? null : Border.all(color: Color(0xffd1ccc4)),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                offset: Offset(0, 0),
                blurRadius: 5,
                spreadRadius: 0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BuyCard extends StatefulWidget {
  @override
  _BuyCardState createState() => _BuyCardState();
}

class _BuyCardState extends State<BuyCard> {
  var selectedPageNumber = 1;
  ScrollController _scrollController = ScrollController();
  final buySellProvider = locator<BuySellProvider>();

  final langProvider = locator<LocalizationProvider>();
  String? langCode;


  @override
  void initState() {
    super.initState();
    langCode = langProvider.selectedlangCode;
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        buySellProvider.getBuyVehicles(currentPage: selectedPageNumber);
        selectedPageNumber++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BuySellProvider>(
      builder: (context, model, child) => Container(
        margin: EdgeInsets.all(10),
        child: Column(
          children: [
            model.buyVehicleList.isEmpty && model.isLoadingForBuyVehicles == false
                ? Expanded(
                child: Container(
                    height: MediaQuery.of(context).size.height - 200,
                    child: Center(child: Text(getTranslated('no_post', context)!,style: Style.heading,))))
                : model.buyVehicleList.isEmpty && model.isLoadingForBuyVehicles ? SizedBox(height: MediaQuery.of(context).size.height/2.5,)
                : Expanded(
                    child: StaggeredGridView.countBuilder(
                    controller: _scrollController,
                    physics: ScrollPhysics(),
                    crossAxisCount: ResponsiveWidget.isDesktop(context)
                        ? 3
                        : ResponsiveWidget.isMobile(context)
                            ? 1
                            : 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 12,
                    itemCount: model.buyVehicleList.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (builder) => BuySellDetailsScreen(
                                      model.buyVehicleList[index])));
                        },
                        child: Card(
                          elevation: 5,
                          child: Container(
                          //  padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ListTile(
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 5),
                                  horizontalTitleGap: 5,
                                  minVerticalPadding: 0,
                                  leading: getImage(model
                                      .buyVehicleList[index].companyLogo
                                      .toString()),
                                  title: langCode == 'en' ? Text( model.buyVehicleList[index].nameOfPerson
                                      .toString(),
                                      style: Style.title):CustomText(
                                      model.buyVehicleList[index].nameOfPerson
                                          .toString(),
                                      style: Style.title),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      langCode == 'en' ? Text( model
                                          .buyVehicleList[index].companyName
                                          .toString(),
                                          style: Style.subtitle):CustomText(
                                          model
                                              .buyVehicleList[index].companyName
                                              .toString(),
                                          style: Style.subtitle),
                                      StarDisplay(
                                          value: model
                                              .buyVehicleList[index].ratings!
                                              .toInt()),
                                    ],
                                  ),
                                  trailing: ConvertStringToDate(model
                                      .buyVehicleList[index].postingTime
                                      .toString()),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0, vertical: 10),
                                  child: langCode == 'en' ? Text( model.buyVehicleList[index].topicName
                                      .toString(),
                                      style: Style.contentHeading):CustomText(
                                      model.buyVehicleList[index].topicName
                                          .toString(),
                                      style: Style.contentHeading),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10.0, bottom: 10, right: 10),
                                  child: Row(
                                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            getTranslated('v_model', context)!,
                                            style: Style.vehicleLable,
                                          ),
                                          Text(
                                              getTranslated(
                                                  'v_brand', context)!,
                                              style: Style.vehicleLable),
                                          Text(getTranslated('price', context)!,
                                              style: Style.vehicleLable),
                                        ],
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          langCode == 'en' ? Text(': ${model.buyVehicleList[index].modelName.toString()}',
                                              style: Style.vehicleData):CustomText(
                                              ': ${model.buyVehicleList[index].modelName.toString()}',
                                              style: Style.vehicleData),
                                          langCode == 'en' ? Text(': ${model.buyVehicleList[index].makerName.toString()}',
                                              style: Style.vehicleData):CustomText(
                                              ': ${model.buyVehicleList[index].makerName.toString()}',
                                              style: Style.vehicleData),
                                          langCode == 'en' ? Text(': ${priceText(model.buyVehicleList[index].estPrice.toString())}',
                                              style: Style.vehicleData):CustomText(
                                              ': ${priceText(model.buyVehicleList[index].estPrice.toString())}',
                                              style: Style.vehicleData),
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
                                  padding: const EdgeInsets.symmetric(vertical: 5.0,horizontal: 9),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      InkWell(
                                        onTap: () async {
                                          showDialog(context: context,
                                              builder: (BuildContext context){
                                                return ShareDialogBox(
                                                    model.buyVehicleList[index]
                                                );
                                              }
                                          );

                                        },
                                        child: Row(
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
                                                style: Style.bottomHeading)
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width: 1.5,
                                        height: 30,
                                        color: Colors.grey,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          openwhatsapp(
                                              context,
                                              model.buyVehicleList[index]
                                                  .mobileNumber
                                                  .toString(),
                                              'Type : ${model.buyVehicleList[index].type}, \nSubject : ${model.buyVehicleList[index].content}');
                                        },
                                        child: Row(
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
                                                style: Style.bottomHeading)
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width: 1.5,
                                        height: 30,
                                        color: Colors.grey,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          showDialog(
                                              context: context,
                                              builder: (_) =>
                                                  new CupertinoAlertDialog(
                                                    title: CustomText(
                                                        'Contact Number : ${model.buyVehicleList[index].mobileNumber}',
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
                                                "Call",
                                                style: Style.bottomHeading)
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    //  physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
                  )),
            getLoader(model.isLoadingForBuyVehicles)
          ],
        ),
      ),
    );
  }

  String priceText(String price){
    price = '${formNum(
      price.replaceAll(',', ''),
    )}';
    return price;
  }

  String formNum(String s) {
    return NumberFormat.decimalPattern().format(
      int.parse(s),
    );
  }
}

class SellCard extends StatefulWidget {
  @override
  _SellCardState createState() => _SellCardState();
}

class _SellCardState extends State<SellCard> {
  var selectedPageNumber1 = 1;
  ScrollController _scrollController = ScrollController();
  final buySellProvider = locator<BuySellProvider>();

  final langProvider = locator<LocalizationProvider>();
  String? langCode;


  @override
  void initState() {
    super.initState();
    langCode = langProvider.selectedlangCode;
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        buySellProvider.getSellVehicles(currentPage: selectedPageNumber1);
        selectedPageNumber1++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BuySellProvider>(
      builder: (context, model, child) => Container(
        margin: EdgeInsets.all(10),
        child: Column(
          children: [
            model.sellVehicleList.isEmpty && model.isLoadingForSellVehicles == false

                ? Expanded(
                child: Container(
                    height: MediaQuery.of(context).size.height - 200,
                    child: Center(child: Text(getTranslated('no_post', context)!,style: Style.heading,))))
                : model.sellVehicleList.isEmpty && model.isLoadingForSellVehicles ? SizedBox(height: MediaQuery.of(context).size.height/2.5,)
                : Expanded(
                    child: StaggeredGridView.countBuilder(
                    controller: _scrollController,
                    physics: ScrollPhysics(),
                    crossAxisCount: ResponsiveWidget.isDesktop(context)
                        ? 3
                        : ResponsiveWidget.isMobile(context)
                            ? 1
                            : 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 12,
                    itemCount: model.sellVehicleList.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (builder) => BuySellDetailsScreen(
                                      model.sellVehicleList[index])));
                        },
                        child: Card(
                          elevation: 5,
                          child: Container(
                           // padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ListTile(
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 5),
                                  horizontalTitleGap: 5,
                                  minVerticalPadding: 0,
                                  leading: getImage(model
                                      .sellVehicleList[index].companyLogo
                                      .toString()),
                                  title: CustomText(
                                      model.sellVehicleList[index].nameOfPerson
                                          .toString(),
                                      style: Style.title),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CustomText(
                                          model.sellVehicleList[index]
                                              .companyName
                                              .toString(),
                                          style: Style.subtitle),
                                      StarDisplay(
                                          value: model
                                              .sellVehicleList[index].ratings!
                                              .toInt()),
                                    ],
                                  ),
                                  trailing: ConvertStringToDate(model
                                      .sellVehicleList[index].postingTime
                                      .toString()),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0, vertical: 10),
                                  child: CustomText(
                                      model.sellVehicleList[index].topicName
                                          .toString(),
                                      style: Style.contentHeading),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10.0, bottom: 10, right: 10),
                                  child: Row(
                                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            getTranslated('v_model', context)!,
                                            style: Style.vehicleLable,
                                          ),
                                          Text(
                                              getTranslated(
                                                  'v_brand', context)!,
                                              style: Style.vehicleLable),
                                          Text(getTranslated('price', context)!,
                                              style: Style.vehicleLable),
                                        ],
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          CustomText(
                                              ': ${model.sellVehicleList[index].modelName.toString()}',
                                              style: Style.vehicleData),
                                          CustomText(
                                              ': ${model.sellVehicleList[index].makerName.toString()}',
                                              style: Style.vehicleData),
                                          CustomText(
                                              ': ${priceText(model.sellVehicleList[index].estPrice.toString())}',
                                              style: Style.vehicleData),
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
                                  padding: const EdgeInsets.symmetric(vertical: 5.0,horizontal: 9),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      InkWell(
                                        onTap: () async {
                                          showDialog(context: context,
                                              builder: (BuildContext context){
                                                return ShareDialogBox(
                                                    model.sellVehicleList[index]
                                                );
                                              }
                                          );
                                        },
                                        child: Row(
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
                                      Container(
                                        width: 1.5,
                                        height: 30,
                                        color: Colors.grey,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          openwhatsapp(
                                              context,
                                              model.sellVehicleList[index]
                                                  .mobileNumber
                                                  .toString(),
                                              'please contact for more details');
                                        },
                                        child: Row(
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
                                      Container(
                                        width: 1.5,
                                        height: 30,
                                        color: Colors.grey,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          showDialog(
                                              context: context,
                                              builder: (_) =>
                                                  new CupertinoAlertDialog(
                                                    title: CustomText(
                                                        'Contact Number : ${model.sellVehicleList[index].mobileNumber}',
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
                                              "Call",
                                              style: Style.bottomHeading,
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    //  physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
                  )),
            getLoader(model.isLoadingForSellVehicles),
          ],
        ),
      ),
    );
  }

  String priceText(String price){
    price = '${formNum(
      price.replaceAll(',', ''),
    )}';
    return price;
  }

  String formNum(String s) {
    return NumberFormat.decimalPattern().format(
      int.parse(s),
    );
  }

}
