import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:number_pagination/number_pagination.dart';
import 'package:provider/provider.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';
import 'package:tkd_app/dialog/animated_custom_dialog.dart';
import 'package:tkd_app/dialog/my_dialog.dart';
import 'package:tkd_app/dialog/share_dialog_box.dart';
import 'package:tkd_app/locator.dart';
import 'package:tkd_app/model/feedback_model.dart';
import 'package:tkd_app/model/pool_purchase_model.dart';
import 'package:tkd_app/model/truck_load_model.dart';
import 'package:http/http.dart' as http;
import 'package:tkd_app/open_whatsapp.dart';
import 'package:tkd_app/provider/more_provider.dart';
import 'package:tkd_app/provider/pool_purchase_provider.dart';
import 'package:tkd_app/share_data.dart';
import 'package:tkd_app/util/ResponsiveWidget.dart';
import 'package:tkd_app/util/color-resource.dart';
import 'package:tkd_app/util/custom_text_style.dart';
import 'package:tkd_app/util/style.dart';
import 'package:tkd_app/view/base_widget/custom_button.dart';
import 'package:tkd_app/view/base_widget/custom_textview.dart';
import 'package:tkd_app/view/base_widget/getLoader.dart';
import 'package:tkd_app/view/localization/language_constrants.dart';
import 'package:tkd_app/view/screens/pool_purchase/create_pool_purchase_post.dart';
import 'package:tkd_app/view/screens/pool_purchase/multi_select_menu.dart';
import 'package:tkd_app/view/screens/pool_purchase/pool_purchase_detail_screen.dart';
import 'package:universal_html/html.dart' as html;

class FeedbackScreen extends StatefulWidget {
  final moreProvider = locator<MoreProvider>();

  FeedbackScreen({Key? key}) : super(key: key) {
    moreProvider.getAllFeedBackList();
  }

  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery
        .of(context)
        .size;
    return DefaultTabController(
      length: 5,
      child: Scaffold(
          backgroundColor: ColorResources.HOME_BG,
          body: Consumer<MoreProvider>(
            builder: (context, model, child) =>
                Container(
                  child: Column(
                    children: [
                      Container(
                        height: 60,
                        width: MediaQuery
                            .of(context)
                            .size
                            .width,
                        color: Color(0xffede8e0),
                        child: Padding(
                          padding: ResponsiveWidget.isDesktop(context)
                              ? EdgeInsets.symmetric(
                              horizontal: 35, vertical: 15)
                              : EdgeInsets.symmetric(
                              horizontal: 0, vertical: 15),
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            children: [
                              getCircularContainer(
                                  "All Feedback", (selectedTab == "All Feedback")),
                              getCircularContainer(
                                  "Full Load", (selectedTab == "Full Load")),
                              getCircularContainer(
                                  "Part Load", (selectedTab == "Part Load")),
                              getCircularContainer("Buy/Sell",
                                  (selectedTab == "Buy/Sell")),
                              getCircularContainer("Gallery",
                                  (selectedTab == "Gallery")),
                            ],
                          ),
                        ),
                      ),
                      selectedTab == "Full Load"
                          ? Expanded(
                        child: Container(
                          color: ColorResources.HOME_BG,
                          child: model.fullLoadFeedbackList.isEmpty
                              ? Container(
                              alignment: Alignment.center,
                              height: screenSize.height,
                              width: screenSize.width,
                              child: Text(
                                  getTranslated('no_post', context)!,
                                  style: Style.heading))
                              : ResponsiveWidget(
                            desktop: FeedbackCard(
                                model.fullLoadFeedbackList),
                            mobile: FeedbackCard(
                                model.fullLoadFeedbackList),
                            tablet: FeedbackCard(
                                model.fullLoadFeedbackList),
                          ),
                        ),
                      )
                          : selectedTab == "Part Load"
                          ? Expanded(
                        child: Container(
                          color: ColorResources.HOME_BG,
                          child: model.partLoadFeedbackList.isEmpty
                              ? Container(
                              alignment: Alignment.center,
                              height: screenSize.height,
                              width: screenSize.width,
                              child: Text(
                                  getTranslated('no_post', context)!,
                                  style: Style.heading))
                              : ResponsiveWidget(
                            desktop: FeedbackCard(
                                model.partLoadFeedbackList),
                            mobile: FeedbackCard(
                                model.partLoadFeedbackList),
                            tablet: FeedbackCard(
                                model.partLoadFeedbackList),
                          ),
                        ),
                      )
                          : selectedTab == "Buy/Sell"
                          ? Expanded(
                        child: Container(
                          color: ColorResources.HOME_BG,
                          child: model.BuySellFeedbackList.isEmpty
                              ? Container(
                              alignment: Alignment.center,
                              height: screenSize.height,
                              width: screenSize.width,
                              child: Text(
                                  getTranslated(
                                      'no_post', context)!,
                                  style: Style.heading))
                              : ResponsiveWidget(
                            desktop: FeedbackCard(
                                model.BuySellFeedbackList),
                            mobile: FeedbackCard(
                                model.BuySellFeedbackList),
                            tablet: FeedbackCard(
                                model.BuySellFeedbackList),
                          ),
                        ),
                      )
                          : selectedTab == "Gallery"
                          ? Expanded(
                        child: Container(
                          color: ColorResources.HOME_BG,
                          child: model.galleryFeedbackList.isEmpty
                              ? Container(
                              alignment: Alignment.center,
                              height: screenSize.height,
                              width: screenSize.width,
                              child: CustomText(
                                  getTranslated(
                                      'no_post', context)!,
                                  style: Style.heading))
                              : ResponsiveWidget(
                            desktop: FeedbackCard(
                                model.galleryFeedbackList),
                            mobile: FeedbackCard(
                                model.galleryFeedbackList),
                            tablet: FeedbackCard(
                                model.galleryFeedbackList),
                          ),
                        ),
                      )
                          : Expanded(
                        child: Container(
                          color: ColorResources.HOME_BG,
                          child: model.feedbackList.isEmpty
                              ? Container(
                              alignment: Alignment.center,
                              height: screenSize.height,
                              width: screenSize.width,
                              child: CustomText(
                                  getTranslated(
                                      'no_post', context)!,
                                  style: Style.heading))
                              : ResponsiveWidget(
                            desktop: FeedbackCard(
                                model.feedbackList),
                            mobile: FeedbackCard(
                                model.feedbackList),
                            tablet: FeedbackCard(
                                model.feedbackList),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
          )),
    );
  }

  var selectedTab = 'All Feedback';

  getCircularContainer(String title, bool isSelected) {
    return InkWell(
      onTap: () {
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
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
          child: CustomText(
            title,
            style: Style.filterHeading,
            textAlign: TextAlign.center,
          ),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Color(0xffe6e0d7),
            border: isSelected ? null : Border.all(color: Color(0xffd1ccc4)),
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

class FeedbackCard extends StatefulWidget {
  List<FeedBack> feedbackList;
  FeedbackCard(this.feedbackList);

  @override
  _FeedbackCardState createState() => _FeedbackCardState();
}

class _FeedbackCardState extends State<FeedbackCard> {
  final moreProvider = locator<MoreProvider>();
  int selectedPageNumber = 1;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        moreProvider.getAllFeedBackList(currentPage: selectedPageNumber);
        selectedPageNumber++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: ColorResources.HOME_BG,
      body: Consumer<MoreProvider>(
        builder: (context, model, child) =>
            Container(
              // padding: ResponsiveWidget.isDesktop(context)?EdgeInsets.symmetric(horizontal: 35):EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  widget.feedbackList.isEmpty && model.isFeedbackLoading == false

                      ? Expanded(
                      child: Container(
                          height: MediaQuery.of(context).size.height - 200,
                          margin: ResponsiveWidget.isDesktop(context)?EdgeInsets.symmetric(horizontal: 35):EdgeInsets.symmetric(horizontal: 10),
                          child: Center(child: Text(getTranslated('no_post', context)!,style: Style.heading,))))
                      : widget.feedbackList.isEmpty && model.isFeedbackLoading ? SizedBox(height: MediaQuery.of(context).size.height/2.5,)
                      : Expanded(
                      child: Container(
                        margin: ResponsiveWidget.isDesktop(context)?EdgeInsets.symmetric(horizontal: 35):EdgeInsets.symmetric(horizontal: 10),
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
                          itemCount: widget.feedbackList.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: (){
                              /*  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (builder) =>
                                            PoolPurchaseDetailsScreen(model.feedbackList[index])));*/
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
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10.0, vertical: 7),
                                        child: CustomText(
                                            widget.feedbackList[index].type
                                                .toString(),
                                            style: Style.title),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10.0, bottom: 10, right: 10),
                                        child: CustomText(
                                          widget.feedbackList[index].feedbackDetails
                                              .toString(),
                                          style: Style.subtitle,
                                        ),
                                      ),
                                      Divider(
                                        height: 1.5,
                                        thickness: 1.5,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                          children: [
                                           /* InkWell(
                                              onTap: () async {
                                                showDialog(context: context,
                                                    builder: (BuildContext context){
                                                      return ShareDialogBox(
                                                          model.u[index]
                                                      );
                                                    }
                                                );
                                              },
                                              child: Row(
                                                children: [
                                                  Image.asset(
                                                    'assets/images/share.png',
                                                    color: ColorResources.PRIMARY_COLOR,
                                                    height: 14,
                                                    width: 14,
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
                                            ),*/
                                            InkWell(
                                              onTap: () {
                                                showDialog(
                                                    context: context,
                                                    builder: (_) =>
                                                    new CupertinoAlertDialog(
                                                      title: CustomText(
                                                          'Are you sure want to deleted your post?',
                                                          style: Style.heading),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          child: CustomText(
                                                              getTranslated(
                                                                  'yes', context)!,
                                                              style: Style.okButton),
                                                          onPressed: () {
                                                            model
                                                                .deleteFeedback(widget.feedbackList
                                                                [index])
                                                                .then((value) => {
                                                              showAnimatedDialog(
                                                                  context,
                                                                  MyDialog(
                                                                    icon: Icons
                                                                        .check,
                                                                    title:
                                                                    'Post Delete',
                                                                    description:
                                                                    'Your post deleted successfully',
                                                                    isFailed:
                                                                    false,
                                                                  ),
                                                                  dismissible:
                                                                  false,
                                                                  isFlip: false)
                                                            });
                                                            Navigator.of(context).pop();
                                                          },
                                                        ),
                                                        TextButton(
                                                          child: CustomText(
                                                            getTranslated(
                                                                'no', context)!,
                                                            style: Style.cancelButton,
                                                          ),
                                                          onPressed: () {
                                                            Navigator.of(context).pop();
                                                          },
                                                        ),
                                                      ],
                                                    ));
                                              },
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.delete,
                                                    color: ColorResources.PRIMARY_COLOR,
                                                    size: 16,
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  CustomText(getTranslated('delete', context)!,
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
                        ),
                      )),
                  getLoader(model.isFeedbackLoading)
                ],
              ),
            ),
      ),
    );
  }

  var selectedTab = 'All Feedback';
  getCircularContainer(String title, bool isSelected) {
    return Consumer<PoolPurchaseProvider>(
        builder: (context, model, child) =>InkWell(
          onTap: (){
            setState(() {
              selectedTab = title;
              model.vehicles = false;
              model.tyres = false;
              model.other = false;
              model.finance = false;
              model.insurance = false;
              model.body_building = false;
              if(selectedTab == 'Full Load'){
                model.vehicles = true;
              }
              if(selectedTab == 'Part Load'){
                model.tyres = true;
              }
              if(selectedTab == 'Gallery'){
                model.other = true;
              }
              if(selectedTab == 'Buy/Sell'){
                model.body_building = true;
              }
            });
            model.getFilteredData();
          },
          child: Card(
            margin: EdgeInsets.symmetric(horizontal: 5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Container(
              height: 30,
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(vertical: 8,horizontal: 20),
              child: CustomText(title,style: Style.filterHeading,textAlign: TextAlign.center,),
              decoration: BoxDecoration(
                color: isSelected? Colors.white :Color(0xffe6e0d7),
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
        ));
  }
}

