import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';
import 'package:tkd_app/dialog/animated_custom_dialog.dart';
import 'package:tkd_app/dialog/my_dialog.dart';
import 'package:tkd_app/dialog/share_dialog_box.dart';
import 'package:tkd_app/locator.dart';
import 'package:tkd_app/model/gallary_model.dart';
import 'package:tkd_app/model/job_model.dart';
import 'package:tkd_app/model/pool_purchase_model.dart';
import 'package:tkd_app/model/truck_load_model.dart';
import 'package:tkd_app/multi_select.dart';
import 'package:tkd_app/network/api_call.dart';
import 'package:tkd_app/open_whatsapp.dart';
import 'package:tkd_app/provider/auth_provider.dart';
import 'package:tkd_app/provider/bid_provider.dart';
import 'package:tkd_app/provider/buy_sell_provider.dart';
import 'package:tkd_app/provider/dashboard_provider.dart';
import 'package:tkd_app/provider/gallery_provider.dart';
import 'package:tkd_app/provider/job_provider.dart';
import 'package:tkd_app/provider/localization_provider.dart';
import 'package:tkd_app/provider/menu_provider.dart';
import 'package:tkd_app/provider/more_provider.dart';
import 'package:tkd_app/provider/pool_purchase_provider.dart';
import 'package:tkd_app/share_data.dart';
import 'package:tkd_app/util/ResponsiveWidget.dart';
import 'package:tkd_app/util/app_constants.dart';
import 'package:tkd_app/util/color-resource.dart';
import 'package:http/http.dart' as http;
import 'package:tkd_app/util/custom_text_style.dart';
import 'package:tkd_app/util/date_converter.dart';
import 'package:tkd_app/util/star_display.dart';
import 'package:tkd_app/util/style.dart';
import 'package:tkd_app/view/base_widget/custom_button.dart';
import 'package:tkd_app/view/base_widget/custom_textfeild.dart';
import 'package:tkd_app/view/base_widget/custom_textview.dart';
import 'package:tkd_app/view/base_widget/getImage.dart';
import 'package:tkd_app/view/base_widget/getLoader.dart';
import 'package:tkd_app/view/localization/language_constrants.dart';
import 'package:tkd_app/view/screens/buy_sell/buy_sell_details_screen.dart';
import 'package:tkd_app/view/screens/buy_sell/buy_sell_vehicles.dart';
import 'package:tkd_app/view/screens/buy_sell/create_new_post.dart';
import 'package:tkd_app/view/screens/dashboard/allRequirement.dart';
import 'package:tkd_app/view/screens/dashboard/create_requirement.dart';
import 'package:tkd_app/view/screens/dashboard/dashboard.dart';
import 'package:tkd_app/view/screens/dashboard/requirementDeatils.dart';
import 'package:tkd_app/view/screens/gallery/gallary_feedback.dart';
import 'package:tkd_app/view/screens/gallery/gallery_screen.dart';
import 'package:tkd_app/view/screens/gallery/view_image-dialog.dart';
import 'package:tkd_app/view/screens/job/create_job.dart';
import 'package:tkd_app/view/screens/more/repeat_post_dialog.dart';
import 'package:tkd_app/view/screens/pool_purchase/pool_purchase_detail_screen.dart';
import 'package:tkd_app/view/screens/pool_purchase/pool_purches_screen.dart';
import 'package:universal_html/html.dart' as html;

import '../../../model/discussion_model.dart';

class MoreScreen extends StatefulWidget {
  final moreProvider = locator<MoreProvider>();
  final authProvider = locator<AuthProvider>();

  MoreScreen({Key? key}) : super(key: key) {
    moreProvider
        .getOwnPostList(authProvider.userDetailList[0].userName.toString());
    moreProvider.getPoolPurchaseList(
        authProvider.userDetailList[0].userName.toString());
    moreProvider.getGalleryList(authProvider.userDetailList[0].id.toString());
    moreProvider
        .getDiscussionList(authProvider.userDetailList[0].userName.toString());
  }

  @override
  _MoreScreenState createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return DefaultTabController(
      length: 5,
      child: Scaffold(
          backgroundColor: ColorResources.HOME_BG,
          body: Consumer<MoreProvider>(
            builder: (context, model, child) => Container(
              child:model.isMoreLoading?getLoader(true): Column(
                children: [
                  Container(
                    height: 60,
                    width: MediaQuery.of(context).size.width,
                    color: Color(0xffede8e0),
                    child: Padding(
                      padding: ResponsiveWidget.isDesktop(context)
                          ? EdgeInsets.symmetric(horizontal: 35, vertical: 15)
                          : EdgeInsets.symmetric(horizontal: 0, vertical: 15),
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        children: [
                          getCircularContainer(
                              "Full Load", (selectedTab == "Full Load")),
                          getCircularContainer(
                              "Part Load", (selectedTab == "Part Load")),
                          widget.authProvider.userDetailList[0]
                                          .transporterOrAgent ==
                                      2 ||
                                  widget.authProvider.userDetailList[0]
                                          .transporterOrAgent ==
                                      3
                              ? SizedBox.shrink()
                              : getCircularContainer("Buy/Sell Vehicles",
                                  (selectedTab == "Buy/Sell Vehicles")),
                          widget.authProvider.userDetailList[0]
                                      .transporterOrAgent ==
                                  3
                              ? SizedBox.shrink()
                              : getCircularContainer("Announcement",
                                  (selectedTab == "Announcement")),
                          getCircularContainer(
                              "Discussion", (selectedTab == "Discussion"))
                        ],
                      ),
                    ),
                  ),
                  selectedTab == "Full Load"
                      ? Expanded(
                          child: Container(
                            color: ColorResources.HOME_BG,
                            child: model.myFullLoadTypeList.isEmpty
                                ? Container(
                                    alignment: Alignment.center,
                                    height: screenSize.height,
                                    width: screenSize.width,
                                    child: Text(
                                        getTranslated('no_post', context)!,
                                        style: Style.heading))
                                : ResponsiveWidget(
                                    desktop: MyRequirementCard(
                                        model.myFullLoadTypeList),
                                    mobile: MyRequirementCard(
                                        model.myFullLoadTypeList),
                                    tablet: MyRequirementCard(
                                        model.myFullLoadTypeList),
                                  ),
                          ),
                        )
                      : selectedTab == "Part Load"
                          ? Expanded(
                              child: Container(
                                color: ColorResources.HOME_BG,
                                child: model.myPartLoadTypeList.isEmpty
                                    ? Container(
                                        alignment: Alignment.center,
                                        height: screenSize.height,
                                        width: screenSize.width,
                                        child: Text(
                                            getTranslated('no_post', context)!,
                                            style: Style.heading))
                                    : ResponsiveWidget(
                                        desktop: MyRequirementCard(
                                            model.myPartLoadTypeList),
                                        mobile: MyRequirementCard(
                                            model.myPartLoadTypeList),
                                        tablet: MyRequirementCard(
                                            model.myPartLoadTypeList),
                                      ),
                              ),
                            )
                          : selectedTab == "Buy/Sell Vehicles"
                              ? Expanded(
                                  child: Container(
                                    color: ColorResources.HOME_BG,
                                    child: model.myBuyVehicleList.isEmpty
                                        ? Container(
                                            alignment: Alignment.center,
                                            height: screenSize.height,
                                            width: screenSize.width,
                                            child: Text(
                                                getTranslated(
                                                    'no_post', context)!,
                                                style: Style.heading))
                                        : ResponsiveWidget(
                                            desktop: MyBuySellCard(
                                                model.myBuyVehicleList),
                                            mobile: MyBuySellCard(
                                                model.myBuyVehicleList),
                                            tablet: MyBuySellCard(
                                                model.myBuyVehicleList),
                                          ),
                                  ),
                                )
                              : selectedTab == "Pool Purchase"
                                  ? Expanded(
                                      child: Container(
                                        color: ColorResources.HOME_BG,
                                        child: model.myPoolPurchaseList.isEmpty
                                            ? Container(
                                                alignment: Alignment.center,
                                                height: screenSize.height,
                                                width: screenSize.width,
                                                child: CustomText(
                                                    getTranslated(
                                                        'no_post', context)!,
                                                    style: Style.heading))
                                            : ResponsiveWidget(
                                                desktop: MyPoolPurchaseCard(
                                                    model.myPoolPurchaseList),
                                                mobile: MyPoolPurchaseCard(
                                                    model.myPoolPurchaseList),
                                                tablet: MyPoolPurchaseCard(
                                                    model.myPoolPurchaseList),
                                              ),
                                      ),
                                    )
                                  : selectedTab == "Announcement"
                                      ? Expanded(
                                          child: Container(
                                            color: ColorResources.HOME_BG,
                                            child: model.myGalleryList.isEmpty
                                                ? Container(
                                                    alignment: Alignment.center,
                                                    height: screenSize.height,
                                                    width: screenSize.width,
                                                    child: CustomText(
                                                        getTranslated('no_post',
                                                            context)!,
                                                        style: Style.heading))
                                                : ResponsiveWidget(
                                                    desktop: MyGallaryCard(
                                                        model.myGalleryList),
                                                    mobile: MyGallaryCard(
                                                        model.myGalleryList),
                                                    tablet: MyGallaryCard(
                                                        model.myGalleryList),
                                                  ),
                                          ),
                                        )
                                      : Expanded(
                                          child: Container(
                                            color: ColorResources.HOME_BG,
                                            child: model.discussionList.isEmpty
                                                ? Container(
                                                    alignment: Alignment.center,
                                                    height: screenSize.height,
                                                    width: screenSize.width,
                                                    child: Text(
                                                        getTranslated('no_post',
                                                            context)!,
                                                        style: Style.heading))
                                                : ResponsiveWidget(
                                                    desktop: MyDiscussionCard(
                                                      listComment:
                                                          model.discussionList,moreProvider: model,
                                                    ),
                                                    mobile: MyDiscussionCard(
                                                      listComment:
                                                          model.discussionList,moreProvider: model,
                                                    ),
                                                    tablet: MyDiscussionCard(
                                                      listComment:
                                                          model.discussionList,moreProvider: model,
                                                    ),
                                                  ),
                                          ),
                                        ),
                ],
              ),
            ),
          )),
    );
  }

  var selectedTab = 'Full Load';

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

class MyBuySellCard extends StatefulWidget {
  List<TruckLoad> buySellList;

  MyBuySellCard(this.buySellList);

  @override
  _MyBuySellCardState createState() => _MyBuySellCardState();
}

class _MyBuySellCardState extends State<MyBuySellCard> {
  final buySellProvider = locator<BuySellProvider>();

  final langProvider = locator<LocalizationProvider>();
  String? langCode;

  @override
  void initState() {
    super.initState();
    langCode = langProvider.selectedlangCode;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MoreProvider>(
      builder: (context, model, child) => Container(
        margin: ResponsiveWidget.isDesktop(context)
            ? EdgeInsets.symmetric(horizontal: 35, vertical: 10)
            : EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          children: [
            /*Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 10),
                      width: MediaQuery.of(context).size.width / 6,
                      child: model.buySellFlag == false ?CustomButton(
                          onTap: (){
                            model.setBuySellFlag(true);
                          },
                          buttonText: getTranslated('edit', context)):
                      CustomButton(
                          onTap: (){
                            model.setBuySellFlag(false);
                          },
                          buttonText: getTranslated('cancel', context))
                      ,
                    ),
                  ],
                ),*/
            widget.buySellList.isEmpty
                ? SizedBox(
                    height: MediaQuery.of(context).size.height / 2.5,
                  )
                : Expanded(
                    child: StaggeredGridView.countBuilder(
                    crossAxisCount: ResponsiveWidget.isDesktop(context)
                        ? 3
                        : ResponsiveWidget.isMobile(context)
                            ? 1
                            : 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 12,
                    itemCount: widget.buySellList.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (builder) => BuySellDetailsScreen(
                                      widget.buySellList[index])));
                        },
                        child: Card(
                          elevation: 5,
                          child: Container(
                            //padding: EdgeInsets.all(10),
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
                                  leading: getImage(widget
                                      .buySellList[index].companyLogo
                                      .toString()),
                                  title: langCode == 'en'
                                      ? Text(
                                          widget.buySellList[index].nameOfPerson
                                              .toString(),
                                          style: Style.title)
                                      : CustomText(
                                          widget.buySellList[index].nameOfPerson
                                              .toString(),
                                          style: Style.title),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      langCode == 'en'
                                          ? Text(
                                              widget.buySellList[index]
                                                  .companyName
                                                  .toString(),
                                              style: Style.subtitle)
                                          : CustomText(
                                              widget.buySellList[index]
                                                  .companyName
                                                  .toString(),
                                              style: Style.subtitle),
                                      StarDisplay(
                                          value: widget
                                              .buySellList[index].ratings!
                                              .toInt()),
                                    ],
                                  ),
                                  trailing: ConvertStringToDate(widget
                                      .buySellList[index].postingTime
                                      .toString()),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0, vertical: 10),
                                  child: langCode == 'en'
                                      ? Text(
                                          widget.buySellList[index].topicName
                                              .toString(),
                                          style: Style.contentHeading)
                                      : CustomText(
                                          widget.buySellList[index].topicName
                                              .toString(),
                                          style: Style.contentHeading),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10.0, bottom: 10, right: 10),
                                  child: langCode == 'en'
                                      ? Text(
                                          widget.buySellList[index].content
                                              .toString(),
                                          style: Style.content,
                                        )
                                      : CustomText(
                                          widget.buySellList[index].content
                                              .toString(),
                                          style: Style.content,
                                        ),
                                ),
                                /*Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10.0, bottom: 10, right: 10),
                                    child: Row(
                                      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              getTranslated('v_model', context)!,
                                              style: regularTextStyle,
                                            ),
                                            Text(getTranslated('v_brand', context)!, style: regularTextStyle),
                                            Text(getTranslated('price', context)!, style: regularTextStyle),
                                          ],
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              ': ${widget.buySellList[index].modelName.toString()}',
                                              style: TextStyle(
                                                  color: ColorResources.PRIMARY_COLOR),
                                            ),
                                            Text(
                                              ': ${widget.buySellList[index].makerName.toString()}',
                                              style: TextStyle(
                                                  color: ColorResources.PRIMARY_COLOR),
                                            ),
                                            Text(
                                              ': ${widget.buySellList[index].estPrice.toString()}',
                                              style: TextStyle(
                                                  color: ColorResources.PRIMARY_COLOR),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),*/
                                Divider(
                                  height: 1.5,
                                  thickness: 1.5,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      /* InkWell(
                                  onTap: () async {
                                    share_data(widget.buySellList[index]);
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
                                      Text(getTranslated('share', context)!,
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
                                          openwhatsapp(
                                              context,
                                              widget.buySellList[index]
                                                  .mobileNumber
                                                  .toString(),
                                              'please contact for more details');
                                        },
                                        child: Row(
                                          children: [
                                            Image.asset(
                                              'assets/images/chat.png',
                                              color:
                                                  ColorResources.PRIMARY_COLOR,
                                              height: 14,
                                              width: 14,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                                getTranslated('chat', context)!,
                                                style: Style.bottomHeading)
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width: 1.5,
                                        height: 30,
                                        color: Colors.grey,
                                      ),
                                      /* InkWell(
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (_) =>
                                        new RepeatDialogBox(widget.buySellList[index]));
                                  },
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.repeat_one,
                                        color: ColorResources.PRIMARY_COLOR,
                                        size: 16,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text('Repeat Post',
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
                                          _showMultiSelect(context,
                                              widget.buySellList[index]);
                                        },
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.feedback,
                                              color:
                                                  ColorResources.PRIMARY_COLOR,
                                              size: 16,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text('Feedback',
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
                                                        'Are you sure want to deleted your post?',
                                                        style: Style.heading),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        child: CustomText(
                                                            getTranslated('yes',
                                                                context)!,
                                                            style:
                                                                Style.okButton),
                                                        onPressed: () {
                                                          model
                                                              .deleteBuySell(
                                                                  widget.buySellList[
                                                                      index])
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
                                                        child: CustomText(
                                                          getTranslated(
                                                              'no', context)!,
                                                          style: Style
                                                              .cancelButton,
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
                                            Icon(
                                              Icons.delete,
                                              color:
                                                  ColorResources.PRIMARY_COLOR,
                                              size: 16,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            CustomText(
                                                getTranslated(
                                                    'delete', context)!,
                                                style: Style.bottomHeading)
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
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
          ],
        ),
      ),
    );
  }

  Set<int>? selectedValues = [
    1,
  ].toSet();

  void _showMultiSelect(BuildContext context, TruckLoad object) async {
    final items = <MultiSelectDialogItem<int>>[
      MultiSelectDialogItem(1, 'I RECEIVED VERY GOOD RESPONSE BY CALLS.'),
      MultiSelectDialogItem(2, 'I RECEIVED MANY BIDS.'),
      MultiSelectDialogItem(3, 'THANKS MY WORK WAS DONE.'),
      MultiSelectDialogItem(4, 'WE SAVED ON TRANSPORTATION.'),
      MultiSelectDialogItem(5, 'WE DID NOT GET ANY RESPONSE.'),
    ];

    selectedValues = await showDialog<Set<int>>(
      context: context,
      builder: (BuildContext context) {
        return MultiSelectDialog(
          items: items,
          initialSelectedValues: selectedValues,
          obj: object,
        );
      },
    );
    print(selectedValues!.length);
    print(selectedValues);
  }
}

class MyRequirementCard extends StatefulWidget {
  List<TruckLoad> loadTypeList;

  MyRequirementCard(this.loadTypeList);

  @override
  _MyRequirementCardState createState() => _MyRequirementCardState();
}

class _MyRequirementCardState extends State<MyRequirementCard> {
  final bidProvider = locator<BidProvider>();
  final authProvider = locator<AuthProvider>();
  final dashboardProvider = locator<DashboardProvider>();
  final moreProvider = locator<MoreProvider>();
  TextEditingController bidAmtController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController sourceController = TextEditingController();
  TextEditingController destinationController = TextEditingController();
  TextEditingController filterController = TextEditingController();

  void repeatPostEvent() {
    Future.delayed(Duration(seconds: 5), () {
      var result = dashboardProvider
          .savePost(
              mobile: authProvider.userDetailList[0].mobileNumber,
              destination: moreProvider.myFullLoadTypeList[0].destination,
              dnd: 0,
              email: authProvider.userDetailList[0].emailId,
              fullLoadChoice: moreProvider.myFullLoadTypeList[0].type,
              id: 0,
              instruction: moreProvider.myFullLoadTypeList[0].content,
              loadWeight: moreProvider.myFullLoadTypeList[0].vehicleSize,
              name: authProvider.userDetailList[0].userName,
              mainTag: moreProvider.myFullLoadTypeList[0].mainTag,
              os: '',
              otherDetails: moreProvider.myFullLoadTypeList[0].content,
              source: moreProvider.myFullLoadTypeList[0].source,
              partLoad: moreProvider.myFullLoadTypeList[0].type == 'Part Load'
                  ? 1
                  : 0,
              privatePost:
                  moreProvider.myFullLoadTypeList[0].privatePost == true
                      ? 1
                      : 0,
              rating: 5,
              customerName:
                  '${authProvider.userDetailList[0].firstName} ${authProvider.userDetailList[0].lastName}',
              type: moreProvider.myFullLoadTypeList[0].type,
              typeOfCargo: moreProvider.myFullLoadTypeList[0].topicName,
              typeOfPayment: moreProvider.myFullLoadTypeList[0].typeOfPayment,
              vehicleSize: moreProvider.myFullLoadTypeList[0].vehicleSize,
              userId: authProvider.userDetailList[0].id)
          .then((value) => {
                showAnimatedDialog(
                    context,
                    MyDialog(
                      icon: Icons.check,
                      title: 'New Post',
                      description: 'Your post submitted successfully',
                      isFailed: false,
                    ),
                    dismissible: false,
                    isFlip: false),
              });
    });
  }

  final langProvider = locator<LocalizationProvider>();
  String? langCode;

  @override
  void initState() {
    super.initState();
    langCode = langProvider.selectedlangCode;
    // repeatPostEvent();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Consumer<MoreProvider>(
      builder: (context, model, child) => Container(
        margin: ResponsiveWidget.isDesktop(context)
            ? EdgeInsets.symmetric(horizontal: 35, vertical: 10)
            : EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          children: [
            widget.loadTypeList.isEmpty
                ? SizedBox(
                    height: MediaQuery.of(context).size.height / 2.5,
                  )
                : Expanded(
                    child: StaggeredGridView.countBuilder(
                    crossAxisCount: ResponsiveWidget.isDesktop(context)
                        ? 3
                        : ResponsiveWidget.isMobile(context)
                            ? 1
                            : 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 12,
                    itemCount: widget.loadTypeList.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (builder) => RequirementDetails(
                                      widget.loadTypeList[index])));
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 140,
                                      height: 20,
                                      alignment: Alignment.center,
                                      decoration: new BoxDecoration(
                                          color: widget.loadTypeList[index]
                                                      .mainTag ==
                                                  "Full load required"
                                              ? ColorResources
                                                  .FULL_LOAD_REQUIRED
                                              : widget.loadTypeList[index]
                                                          .mainTag ==
                                                      "Part load required"
                                                  ? ColorResources
                                                      .PART_LOAD_REQUIRED
                                                  : widget.loadTypeList[index]
                                                              .mainTag ==
                                                          "Full load available"
                                                      ? ColorResources
                                                          .FULL_LOAD_AVAILABLE
                                                      : ColorResources
                                                          .PART_LOAD_AVAILABLE,
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(5),
                                              bottomRight:
                                                  Radius.circular(10))),
                                      child: CustomText(
                                          widget.loadTypeList[index].mainTag
                                              .toString(),
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontFamily: 'RobotoMedium',
                                              color: widget.loadTypeList[index]
                                                          .mainTag ==
                                                      "Full load required"
                                                  ? ColorResources.FLR_TEXT
                                                  : widget.loadTypeList[index]
                                                              .mainTag ==
                                                          "Part load required"
                                                      ? ColorResources.PLR_TEXT
                                                      : widget
                                                                  .loadTypeList[
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
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 5,
                                          ),
                                          ConvertStringToDate(widget
                                              .loadTypeList[index].postingTime
                                              .toString()),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          StarDisplay(
                                              value: widget
                                                  .loadTypeList[index].ratings!
                                                  .toInt()),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                ListTile(
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 5),
                                  horizontalTitleGap: 5,
                                  minVerticalPadding: 0,
                                  leading: Stack(
                                    children: [
                                      getImage(widget
                                          .loadTypeList[index].companyLogo
                                          .toString()),
                                      Positioned(
                                        bottom: 0,
                                        right: 0,
                                        child: Image.asset(
                                          widget.loadTypeList[index].isPaid ==
                                                  30
                                              ? 'assets/images/diamond.png'
                                              : widget.loadTypeList[index]
                                                          .isPaid ==
                                                      20
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
                                      CustomText(
                                          widget
                                              .loadTypeList[index].nameOfPerson
                                              .toString(),
                                          style: Style.title),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      widget.loadTypeList[index]
                                                  .isVerifiedByCompany ==
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
                                  subtitle: CustomText(
                                      widget.loadTypeList[index].companyName
                                          .toString(),
                                      style: Style.subtitle),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.symmetric(horizontal: 45),
                                  height: 30,
                                  decoration: new BoxDecoration(
                                      color: Color(0xfff0f0f0),
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CustomText(
                                          widget.loadTypeList[index].source
                                              .toString(),
                                          style: Style.cityHeading),
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
                                      CustomText(
                                          widget.loadTypeList[index].destination
                                              .toString(),
                                          style: Style.cityHeading),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0, vertical: 7),
                                  child: langCode == 'en'
                                      ? Text(
                                          widget.loadTypeList[index].topicName
                                              .toString(),
                                          style: Style.contentHeading)
                                      : CustomText(
                                          widget.loadTypeList[index].topicName
                                              .toString(),
                                          style: Style.contentHeading),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10.0, bottom: 10, right: 10),
                                  child: langCode == 'en'
                                      ? Text(
                                          widget.loadTypeList[index].content
                                              .toString(),
                                          style: Style.content,
                                        )
                                      : CustomText(
                                          widget.loadTypeList[index].content
                                              .toString(),
                                          style: Style.content,
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
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      InkWell(
                                        onTap: () async {
                                          openwhatsapp(
                                              context,
                                              widget.loadTypeList[index]
                                                  .mobileNumber
                                                  .toString(),
                                              'please contact for more details');
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              'assets/images/chat.png',
                                              color:
                                                  ColorResources.PRIMARY_COLOR,
                                              height: 15,
                                              width: 15,
                                            ),
                                            SizedBox(
                                              width: ResponsiveWidget.isDesktop(
                                                      context)
                                                  ? 10
                                                  : 5,
                                            ),
                                            Text(
                                              getTranslated('chat', context)!,
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
                                                  new RepeatDialogBox(widget
                                                      .loadTypeList[index]));
                                        },
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.repeat_one,
                                              color:
                                                  ColorResources.PRIMARY_COLOR,
                                              size: 16,
                                            ),
                                            SizedBox(
                                              width: ResponsiveWidget.isDesktop(
                                                      context)
                                                  ? 10
                                                  : 5,
                                            ),
                                            Text('Repeat Post',
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
                                          _showMultiSelect(context,
                                              widget.loadTypeList[index]);
                                        },
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.feedback,
                                              color:
                                                  ColorResources.PRIMARY_COLOR,
                                              size: 16,
                                            ),
                                            SizedBox(
                                              width: ResponsiveWidget.isDesktop(
                                                      context)
                                                  ? 10
                                                  : 5,
                                            ),
                                            Text('Feedback',
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
                                        onTap: () async {
                                          //share_data(widget.loadTypeList[index]);
                                          showDialog(
                                              context: context,
                                              builder: (_) =>
                                                  new CupertinoAlertDialog(
                                                    title: CustomText(
                                                      'Are you sure want to deleted your post?',
                                                      style: Style.heading,
                                                    ),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        child: Text(
                                                            getTranslated('yes',
                                                                context)!,
                                                            style:
                                                                Style.okButton),
                                                        onPressed: () {
                                                          model
                                                              .deleteFullLoad(
                                                                  widget.loadTypeList[
                                                                      index])
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
                                                        child: Text(
                                                            getTranslated(
                                                                'no', context)!,
                                                            style: Style
                                                                .cancelButton),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      ),
                                                    ],
                                                  ));
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.delete,
                                              color:
                                                  ColorResources.PRIMARY_COLOR,
                                              size: 16,
                                            ),
                                            SizedBox(
                                              width: ResponsiveWidget.isDesktop(
                                                      context)
                                                  ? 10
                                                  : 5,
                                            ),
                                            CustomText(
                                              "Delete",
                                              style: Style.bottomHeading,
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    //physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
                  )),
          ],
        ),
      ),
    );
  }

  Set<int>? selectedValues = [
    1,
  ].toSet();

  void _showMultiSelect(BuildContext context, TruckLoad object) async {
    final items = <MultiSelectDialogItem<int>>[
      MultiSelectDialogItem(1, 'I RECEIVED VERY GOOD RESPONSE BY CALLS.'),
      MultiSelectDialogItem(2, 'I RECEIVED MANY BIDS.'),
      MultiSelectDialogItem(3, 'THANKS MY WORK WAS DONE.'),
      MultiSelectDialogItem(4, 'WE SAVED ON TRANSPORTATION.'),
      MultiSelectDialogItem(5, 'WE DID NOT GET ANY RESPONSE.'),
    ];

    selectedValues = await showDialog<Set<int>>(
      context: context,
      builder: (BuildContext context) {
        return MultiSelectDialog(
          items: items,
          initialSelectedValues: selectedValues,
          obj: object,
        );
      },
    );
    print(selectedValues!.length);
    print(selectedValues);
  }
}

class MyGallaryCard extends StatefulWidget {
  List<Gallery> gallaryList;

  MyGallaryCard(this.gallaryList);

  @override
  _MyGallaryCardState createState() => _MyGallaryCardState();
}

class _MyGallaryCardState extends State<MyGallaryCard> {
  final langProvider = locator<LocalizationProvider>();
  String? langCode;

  @override
  void initState() {
    super.initState();
    langCode = langProvider.selectedlangCode;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MoreProvider>(
      builder: (context, model, child) => Container(
        margin: ResponsiveWidget.isDesktop(context)
            ? EdgeInsets.symmetric(horizontal: 35, vertical: 10)
            : EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          children: [
            widget.gallaryList.isEmpty
                ? SizedBox(
                    height: MediaQuery.of(context).size.height / 2.5,
                  )
                : Expanded(
                    child: StaggeredGridView.countBuilder(
                      crossAxisCount: ResponsiveWidget.isDesktop(context)
                          ? 3
                          : ResponsiveWidget.isMobile(context)
                              ? 1
                              : 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 12,
                      itemCount: widget.gallaryList.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 5,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
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
                                  leading: getImage(widget
                                      .gallaryList[index].profilePicture
                                      .toString()),
                                  title: langCode == 'en'
                                      ? Text(
                                          widget.gallaryList[index].firstName
                                              .toString(),
                                          style: Style.title)
                                      : CustomText(
                                          widget.gallaryList[index].firstName
                                              .toString(),
                                          style: Style.title),
                                  subtitle: langCode == 'en'
                                      ? Text(
                                          widget.gallaryList[index].topicName
                                              .toString(),
                                          style: Style.subtitle)
                                      : CustomText(
                                          widget.gallaryList[index].topicName
                                              .toString(),
                                          style: Style.subtitle),
                                  trailing: ConvertStringToDate(widget
                                      .gallaryList[index].date
                                      .toString()),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0, vertical: 10),
                                  child: InkWell(
                                    onTap: () async {
                                      await showDialog(
                                          context: context,
                                          builder: (_) => ImageDialog(widget
                                              .gallaryList[index].image!));
                                    },
                                    child: Container(
                                      height: 100,
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          //  fit: BoxFit.fill,
                                          image: NetworkImage(
                                              '${widget.gallaryList[index].image}'),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10.0, bottom: 10, right: 10),
                                  child: langCode == 'en'
                                      ? Text(
                                          widget.gallaryList[index].description
                                              .toString(),
                                          style: Style.content,
                                        )
                                      : CustomText(
                                          widget.gallaryList[index].description
                                              .toString(),
                                          style: Style.content,
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
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (_) =>
                                        new CupertinoAlertDialog(
                                          title: CustomText(
                                              'Are you sure want to repeat your post?',
                                              style: Style.heading),
                                          actions: <Widget>[
                                            TextButton(
                                              child: CustomText(
                                                  getTranslated(
                                                      'yes', context)!,
                                                  style: Style.okButton),
                                              onPressed: () {
                                                showDialog(
                                                    context: context,
                                                    builder: (_) => AlertDialog(
                                                      title: Text("Please Select Date and Time For Daily Repeat Post"),
                                                      content: Container(
                                                        height: ResponsiveWidget.isDesktop(context)
                                                            ?250
                                                            :300,
                                                        width: ResponsiveWidget.isMobile(context)?MediaQuery.of(context).size.width-100:ResponsiveWidget.isDesktop(context)?150:150,
                                                        child:Consumer<MoreProvider>(
                                                          builder: (context, model, child) => Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              TextFormField(
                                                                onTap: () {
                                                                  setState(() {
                                                                    model.selectDate(context, "From Date");
                                                                  });
                                                                },
                                                                controller: TextEditingController(text: model.resFromDateCnt),
                                                                validator: (value) {
                                                                  if (value == null || value.isEmpty) {
                                                                    return 'Please select date';
                                                                  }
                                                                  return null;
                                                                },
                                                                readOnly: true,
                                                                cursorColor: Colors.brown,
                                                                decoration: InputDecoration(
                                                                  hintText: 'Select From Date',
                                                                  labelText: 'From Date',
                                                                  labelStyle: TextStyle(
                                                                    color: Colors.brown,
                                                                    fontWeight: FontWeight.bold,
                                                                    fontSize: 22,
                                                                  ),
                                                                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                                                                  border: const OutlineInputBorder()
                                                                ),
                                                              ),
                                                              SizedBox(height: 16,),
                                                              TextFormField(
                                                                onTap: () {
                                                                  model.selectDate(context, "To Date");
                                                                },
                                                                controller: TextEditingController(text: model.resToDateCnt),
                                                                validator: (value) {
                                                                  if (value == null || value.isEmpty) {
                                                                    return 'Please select date';
                                                                  }
                                                                  return null;
                                                                },
                                                                readOnly: true,
                                                                cursorColor: Colors.brown,
                                                                decoration: InputDecoration(
                                                                  hintText: 'Select To Date',
                                                                  labelText: 'To Date',
                                                                  labelStyle: TextStyle(
                                                                    color: Colors.brown,
                                                                    fontWeight: FontWeight.bold,
                                                                    fontSize: 22,
                                                                  ),
                                                                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                                                                    border: const OutlineInputBorder()
                                                                ),
                                                              ),
                                                              SizedBox(height: 16,),
                                                              TextFormField(
                                                                onTap: () {
                                                                  model.selectTime(context, "RepeatTime");
                                                                },
                                                                controller: TextEditingController(text: model.TimeCnt),
                                                                autofocus: false,
                                                                readOnly: true,
                                                                validator: (value) {
                                                                  if (value == null || value.isEmpty) {
                                                                    return 'Please select time';
                                                                  }
                                                                  return null;
                                                                },
                                                                //autovalidate: true,
                                                                cursorColor: Colors.brown,
                                                                decoration: InputDecoration(
                                                                  hintText: 'Time',
                                                                  labelText: "Repeat Posting Time",
                                                                  labelStyle: TextStyle(
                                                                    color: Colors.brown,
                                                                    fontWeight: FontWeight.bold,
                                                                    fontSize: 22,
                                                                  ),
                                                                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                                                                    border: const OutlineInputBorder()
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      actions: [
                                                        ElevatedButton(
                                                          child: CustomText(
                                                            "Ok",
                                                          ),
                                                          onPressed: () {
                                                            Navigator.of(context).pop();
                                                          },
                                                        ),
                                                      ],
                                                ),
                                                );
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
                                        Icons.repeat_one,
                                        color: ColorResources.PRIMARY_COLOR,
                                        size: 16,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text('Repeat Post',
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
                                          _showMultiSelect(context,
                                              widget.gallaryList[index]);
                                        },
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.feedback,
                                              color:
                                                  ColorResources.PRIMARY_COLOR,
                                              size: 16,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            CustomText('Feedback',
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
                                                      'Are you sure want to deleted your post?',
                                                      style: Style.heading,
                                                    ),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        child: CustomText(
                                                            getTranslated('yes',
                                                                context)!,
                                                            style:
                                                                Style.okButton),
                                                        onPressed: () {
                                                          model
                                                              .deleteGallery(
                                                                  widget.gallaryList[
                                                                      index])
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
                                        },
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.delete,
                                              color:
                                                  ColorResources.PRIMARY_COLOR,
                                              size: 16,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            CustomText(
                                                getTranslated(
                                                    'delete', context)!,
                                                style: Style.bottomHeading)
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      shrinkWrap: true,
                      staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Set<int>? selectedValues = [
    1,
  ].toSet();

  void _showMultiSelect(BuildContext context, Gallery object) async {
    final items = <GallaryFeedbackDialogItem<int>>[
      GallaryFeedbackDialogItem(1, 'I RECEIVED VERY GOOD RESPONSE BY CALLS.'),
      GallaryFeedbackDialogItem(2, 'I RECEIVED MANY BIDS.'),
      GallaryFeedbackDialogItem(3, 'THANKS MY WORK WAS DONE.'),
      GallaryFeedbackDialogItem(4, 'WE SAVED ON TRANSPORTATION.'),
      GallaryFeedbackDialogItem(5, 'WE DID NOT GET ANY RESPONSE.'),
    ];

    selectedValues = await showDialog<Set<int>>(
      context: context,
      builder: (BuildContext context) {
        return GallaryFeedbackDialog(
          items: items,
          initialSelectedValues: selectedValues,
          obj: object,
        );
      },
    );
    print(selectedValues!.length);
    print(selectedValues);
  }
}

class MyPoolPurchaseCard extends StatefulWidget {
  List<PoolPurchase> myPoolPurchaseList;

  MyPoolPurchaseCard(this.myPoolPurchaseList);

  @override
  _MyPoolPurchaseCardState createState() => _MyPoolPurchaseCardState();
}

class _MyPoolPurchaseCardState extends State<MyPoolPurchaseCard> {
  final poolPurchaseProvider = locator<PoolPurchaseProvider>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.HOME_BG,
      body: Consumer<MoreProvider>(
        builder: (context, model, child) => Container(
          margin: ResponsiveWidget.isDesktop(context)
              ? EdgeInsets.symmetric(horizontal: 35, vertical: 10)
              : EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            children: [
              /*Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 10),
                        width: MediaQuery.of(context).size.width / 6,
                        child: model.poolPurchaseFlag == false ?CustomButton(
                            onTap: (){
                              model.setPoolPurchaseFlag(true);
                            },
                            buttonText: getTranslated('edit', context)):
                        CustomButton(
                            onTap: (){
                              model.setPoolPurchaseFlag(false);
                            },
                            buttonText: getTranslated('cancel', context))
                        ,
                      ),
                    ],
                  ),*/
              widget.myPoolPurchaseList.isEmpty
                  ? SizedBox(
                      height: MediaQuery.of(context).size.height / 2.5,
                    )
                  : Expanded(
                      child: StaggeredGridView.countBuilder(
                      crossAxisCount: ResponsiveWidget.isDesktop(context)
                          ? 3
                          : ResponsiveWidget.isMobile(context)
                              ? 1
                              : 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 12,
                      itemCount: widget.myPoolPurchaseList.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (builder) =>
                                        PoolPurchaseDetailsScreen(
                                            widget.myPoolPurchaseList[index])));
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
                                        widget.myPoolPurchaseList[index]
                                            .purchaseItem
                                            .toString(),
                                        style: Style.title),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10.0, bottom: 10, right: 10),
                                    child: CustomText(
                                      widget
                                          .myPoolPurchaseList[index].description
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
                                        InkWell(
                                          onTap: () async {
                                            var shareData = {
                                              "title": widget
                                                  .myPoolPurchaseList[index]
                                                  .agentName,
                                              "text": widget
                                                  .myPoolPurchaseList[index]
                                                  .mobileNumber,
                                              "url": 'link',
                                            };
                                            try {
                                              await html.window.navigator
                                                  .share(shareData);
                                            } catch (e) {
                                              print(e);
                                            }
                                          },
                                          child: Row(
                                            children: [
                                              Image.asset(
                                                'assets/images/share.png',
                                                color: ColorResources
                                                    .PRIMARY_COLOR,
                                                height: 14,
                                                width: 14,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                  getTranslated(
                                                      'share', context)!,
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
                                                widget.myPoolPurchaseList[index]
                                                    .mobileNumber
                                                    .toString(),
                                                'please contact for more details');
                                          },
                                          child: Row(
                                            children: [
                                              Image.asset(
                                                'assets/images/chat.png',
                                                color: ColorResources
                                                    .PRIMARY_COLOR,
                                                height: 14,
                                                width: 14,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                  getTranslated(
                                                      'chat', context)!,
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
                                                        'Are you sure want to deleted your post?',
                                                        style: Style.heading,
                                                      ),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          child: CustomText(
                                                              getTranslated(
                                                                  'yes',
                                                                  context)!,
                                                              style: Style
                                                                  .okButton),
                                                          onPressed: () {
                                                            model
                                                                .deletePoolPurchase(
                                                                    widget.myPoolPurchaseList[
                                                                        index])
                                                                .then(
                                                                    (value) => {
                                                                          showAnimatedDialog(
                                                                              context,
                                                                              MyDialog(
                                                                                icon: Icons.check,
                                                                                title: 'Post Delete',
                                                                                description: 'Your post deleted successfully',
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
                                                                  'no',
                                                                  context)!,
                                                              style: Style
                                                                  .cancelButton),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        ),
                                                      ],
                                                    ));
                                          },
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.delete,
                                                color: ColorResources
                                                    .PRIMARY_COLOR,
                                                size: 16,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              CustomText(
                                                "Delete",
                                                style: Style.bottomHeading,
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  /*  Divider(
                                      height: 1.5,
                                      thickness: 1.5,
                                    ),
                                    Center(
                                      child: CustomButton(
                                        onTap: (){
                                          showDialog(context: context, builder: (_) => new CupertinoAlertDialog(
                                            title: Text('Are you sure want to deleted your post?'),
                                            actions: <Widget>[
                                              TextButton(
                                                child: Text(getTranslated('yes', context)!,style: TextStyle(color: ColorResources.RED)),
                                                onPressed: (){
                                                  model.deletePoolPurchase(widget.myPoolPurchaseList[index])
                                                      .then((value) => {
                                                    showAnimatedDialog(
                                                        context,
                                                        MyDialog(
                                                          icon: Icons.check,
                                                          title: 'Post Delete',
                                                          description: 'Your post deleted successfully',
                                                          isFailed: false,
                                                        ),
                                                        dismissible: false,
                                                        isFlip: true)
                                                  });
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                              TextButton(
                                                child: Text('no',style: TextStyle(color: ColorResources.GREEN),),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                          ));
                                        },
                                        buttonText: getTranslated("delete",context),
                                      ),
                                    )*/
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
            ],
          ),
        ),
      ),
    );
  }
}

class MyJobCard extends StatefulWidget {
  MyJobCard(this.jobList);

  List<TruckLoad> jobList;

  @override
  _MyJobCardState createState() => _MyJobCardState();
}

class _MyJobCardState extends State<MyJobCard> {
  @override
  Widget build(BuildContext context) {
    return Consumer<MoreProvider>(
      builder: (context, model, child) => Container(
        margin: ResponsiveWidget.isDesktop(context)
            ? EdgeInsets.symmetric(horizontal: 35, vertical: 10)
            : EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          children: [
            /* Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  margin: EdgeInsets.only(right: 10),
                  width: MediaQuery.of(context).size.width / 6,
                  child: model.jobFlag == false ?CustomButton(
                      onTap: (){
                        model.setjobFlag(true);
                      },
                      buttonText: getTranslated('edit', context)):
                  CustomButton(
                      onTap: (){
                        model.setjobFlag(false);
                      },
                      buttonText: getTranslated('cancel', context))
                  ,
                ),
              ],
            ),*/
            Expanded(
              child: StaggeredGridView.countBuilder(
                physics: ScrollPhysics(),
                crossAxisCount: ResponsiveWidget.isDesktop(context)
                    ? 3
                    : ResponsiveWidget.isMobile(context)
                        ? 1
                        : 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 12,
                itemCount: widget.jobList.length,
                itemBuilder: (context, index) {
                  return Card(
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
                            leading: getImage(
                                widget.jobList[index].companyLogo.toString()),
                            title: CustomText(
                                widget.jobList[index].nameOfPerson.toString(),
                                style: Style.title),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                    widget.jobList[index].companyName
                                        .toString(),
                                    style: Style.subtitle),
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: StarDisplay(
                                      value: widget.jobList[index].ratings!
                                          .toInt()),
                                ),
                              ],
                            ),
                            trailing: ConvertStringToDate(
                                widget.jobList[index].postingTime.toString()),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 9),
                            child: CustomText(
                                widget.jobList[index].topicName.toString(),
                                style: Style.contentHeading),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 10.0, bottom: 10, right: 10),
                            child: CustomText(
                              widget.jobList[index].content.toString(),
                              style: Style.content,
                            ),
                          ),
                          Divider(
                            height: 1.5,
                            thickness: 1.5,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                InkWell(
                                  onTap: () async {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return ShareDialogBox(
                                              widget.jobList[index]);
                                        });
                                  },
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        'assets/images/share.png',
                                        color: ColorResources.BOTTOM_HEADING,
                                        height: 14,
                                        width: 14,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text('Share', style: Style.bottomHeading)
                                    ],
                                  ),
                                ),
                                Container(
                                  width: 1.5,
                                  height: 30,
                                  color: Colors.grey,
                                ),
                                InkWell(
                                  onTap: () {},
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        'assets/images/chat.png',
                                        color: ColorResources.BOTTOM_HEADING,
                                        height: 14,
                                        width: 14,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text('Chat', style: Style.bottomHeading)
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
                                                'Are you sure want to deleted your post?',
                                                style: Style.heading,
                                              ),
                                              actions: <Widget>[
                                                TextButton(
                                                  child: Text(
                                                      getTranslated(
                                                          'yes', context)!,
                                                      style: Style.okButton),
                                                  onPressed: () {
                                                    model
                                                        .deleteJob(widget
                                                            .jobList[index])
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
                                                  child: Text(
                                                      getTranslated(
                                                          'no', context)!,
                                                      style:
                                                          Style.cancelButton),
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
                                        color: ColorResources.BOTTOM_HEADING,
                                        size: 16,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        getTranslated('delete', context)!,
                                        style: Style.bottomHeading,
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                // physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyDiscussionCard extends StatefulWidget {
  final List<DiscussionContent> listComment;
  final MoreProvider moreProvider;

  const MyDiscussionCard({Key? key, required this.listComment,required this.moreProvider})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MyDiscussionState(listComment,moreProvider);
  }
}

class MyDiscussionState extends State<MyDiscussionCard> {
  List<DiscussionContent> discussionList;
  MoreProvider moreProvider;

  MyDiscussionState(this.discussionList,this.moreProvider);

  @override
  void initState() {}

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: StaggeredGridView.countBuilder(
      // controller: _scrollController,
      physics: ScrollPhysics(),
      crossAxisCount: ResponsiveWidget.isDesktop(context)
          ? 3
          : ResponsiveWidget.isMobile(context)
              ? 1
              : 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 12,
      itemCount: discussionList.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {},
          child: Card(
            elevation: 5,
            child: listCard(index),
          ),
        );
      },
      //  physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
    ));
  }

  Widget listCard(int index) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: getImage(discussionList[index].profilePicture.toString()),
            title: CustomText(
                '${discussionList[index].firstName.toString()} ${discussionList[index].lastName.toString()}',
                style: Style.title),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(discussionList[index].companyName.toString(),
                    style: Style.subtitle),
              ],
            ),
            trailing: Text(
              discussionList[index].loggedTime.toString(),
              style: Style.date,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            child: Text(
              discussionList[index].topic.toString(),
              style: Style.title,
              overflow: TextOverflow.ellipsis,
              softWrap: true,
              maxLines: 2,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20.0, bottom: 10, right: 20, top: 5),
            child: Text(
              discussionList[index].description.toString(),
              maxLines: 4,
              style: Style.content,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          cardDivider(),
          Padding(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () {
                    showDeleteDialog(context,index);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.delete,
                        color: ColorResources.PRIMARY_COLOR,
                        size: 16,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(getTranslated("delete", context)!,
                          style: Style.cancelButton)
                    ],
                  ),
                ),
              ],
            ),
          ),
          cardDivider(),
          SizedBox(
            height: 14,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Text(
              "${discussionList[index].totalComments} Comment",
              style: Style.date,
            ),
          ),
          SizedBox(
            height: 5,
          ),
        ],
      ),
    );
  }

  Widget cardDivider() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Divider(
        height: 1.5,
        thickness: 1.5,
      ),
    );
  }

  showDeleteDialog(context,index) {
    showDialog(
        context: context,
        builder: (_) => new CupertinoAlertDialog(
              title: CustomText(
                'Are you sure want to deleted your post?',
                style: Style.heading,
              ),
              actions: <Widget>[
                TextButton(
                  child: Text(getTranslated('yes', context)!,
                      style: Style.okButton),
                  onPressed: () {
                    // model
                    //     .deleteFullLoad(
                    //     widget.loadTypeList[
                    //     index])
                    //     .then((value) => {
                    //   showAnimatedDialog(
                    //       context,
                    //       MyDialog(
                    //         icon: Icons
                    //             .check,
                    //         title:
                    //         'Post Delete',
                    //         description:
                    //         'Your post deleted successfully',
                    //         isFailed:
                    //         false,
                    //       ),
                    //       dismissible:
                    //       false,
                    //       isFlip: false)
                    // });
                    // Navigator.of(context).pop();
                    callDelete(index);
                  },
                ),
                TextButton(
                  child: Text(getTranslated('no', context)!,
                      style: Style.cancelButton),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
  }

  void callDelete(index) async {
    APIHelper apiHelper=APIHelper();
    int status=await apiHelper.ApiDeleteData(AppConstants.GET_DISCUSSION+"?id=${discussionList[index].id}");
    if(status==200){

      discussionList.removeAt(index);
      Navigator.pop(context);
      setState(() {

      });
      moreProvider.discussionList.removeAt(index);
    }
  }
}
