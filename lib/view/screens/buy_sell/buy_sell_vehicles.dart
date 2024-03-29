import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
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
import 'package:tkd_app/provider/auth_provider.dart';
import 'package:tkd_app/provider/buy_sell_provider.dart';
import 'package:tkd_app/provider/delete_interface.dart';
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
import 'package:tkd_app/view/base_widget/all_cards.dart';
import 'package:tkd_app/view/base_widget/custom_textview.dart';
import 'package:tkd_app/view/base_widget/getImage.dart';
import 'package:tkd_app/view/base_widget/getLoader.dart';
import 'package:tkd_app/view/base_widget/home_base_widgets.dart';
import 'package:tkd_app/view/base_widget/utils.dart';
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
              height: 62,
              color: ThemeColor.baground,
              child: Padding(
                padding: ResponsiveWidget.isDesktop(context)?EdgeInsets.symmetric(horizontal: 35,vertical: 10):EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                child: Row(
                  children: [
                    getCircularContainer("Buy Vehicle",(selectedTab == "Buy Vehicle")),
                    getCircularContainer("Sell Vehicle",(selectedTab == "Sell Vehicle")),
                  ],
                ),
              ),
            ),
            selectedTab == "Buy Vehicle"
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

  var selectedTab = 'Buy Vehicle';

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
            color: isSelected? ColorResources.RED :Color(0xffffffff),
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

class _BuyCardState extends State<BuyCard> implements DeletePostInf{
  var selectedPageNumber = 1;
  ScrollController _scrollController = ScrollController();
  final buySellProvider = locator<BuySellProvider>();
  final authProvider = locator<AuthProvider>();
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
                        child:
                        AllCards().cardSellBuyPost(index,context,model.buyVehicleList[index],this,userId: authProvider.userDetailList[0].id!)
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

  @override
  void deleteOwnPost(int postId,int index,) {
    _showMyDialog(index, postId,buySellProvider);
  }


  Future<void> _showMyDialog(int index,int id,BuySellProvider provider) async {
    return   showDialog(
        context: context,
        builder: (_) =>
        new CupertinoAlertDialog(
          title: CustomText(
            'Are you sure want to deleted your post?',
            style: Style.title,
          ),
          actions: <Widget>[
            TextButton(
              child: CustomText(
                  getTranslated('yes',
                      context)!,
                  style:
                  Style.okButton),
              onPressed: () {
                provider
                    .deleteBuySell(
                    id,index,true)
                    .then((value) => {
                  showAnimatedDialog(
                      context,
                      MyDialog(
                        icon:
                        Icons.check,
                        title:
                        'Post Delete',
                        description:
                        'Your post deleted successfully',
                        isFailed:
                        false,
                      ),
                      dismissible:
                      false,
                      isFlip:
                      false)
                });
                Navigator.of(context)
                    .pop();
              },
            ),
            TextButton(
              child: CustomText('no',
                  style: Style
                      .cancelButton),
              onPressed: () {
                Navigator.of(context)
                    .pop();
              },
            ),
          ],
        ));
  }

  @override
  void rePost(TruckLoad truckLoad, bool isCityInterchange) {
    // TODO: implement rePost
  }


}



class SellCard extends StatefulWidget {
  @override
  _SellCardState createState() => _SellCardState();
}

class _SellCardState extends State<SellCard> implements DeletePostInf{
  var selectedPageNumber1 = 1;
  ScrollController _scrollController = ScrollController();
  final buySellProvider = locator<BuySellProvider>();
  final authProvider = locator<AuthProvider>();
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
                        child:AllCards().cardSellBuyPost(index,context,model.sellVehicleList[index],this,userId: authProvider.userDetailList[0].id!)

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

  @override
  void deleteOwnPost(int postId,int index,) {
    _showMyDialog(index, postId,buySellProvider);
  }


  Future<void> _showMyDialog(int index,int id,BuySellProvider provider) async {
    return   showDialog(
        context: context,
        builder: (_) =>
        new CupertinoAlertDialog(
          title: CustomText(
            'Are you sure want to deleted your post?',
            style: Style.title,
          ),
          actions: <Widget>[
            TextButton(
              child: CustomText(
                  getTranslated('yes',
                      context)!,
                  style:
                  Style.okButton),
              onPressed: () {
                provider
                    .deleteBuySell(
                    id,index,false)
                    .then((value) => {
                  showAnimatedDialog(
                      context,
                      MyDialog(
                        icon:
                        Icons.check,
                        title:
                        'Post Delete',
                        description:
                        'Your post deleted successfully',
                        isFailed:
                        false,
                      ),
                      dismissible:
                      false,
                      isFlip:
                      false)
                });
                Navigator.of(context)
                    .pop();
              },
            ),
            TextButton(
              child: CustomText('no',
                  style: Style
                      .cancelButton),
              onPressed: () {
                Navigator.of(context)
                    .pop();
              },
            ),
          ],
        ));
  }

  @override
  void rePost(TruckLoad truckLoad, bool isCityInterchange) {
    // TODO: implement rePost

  }


}
