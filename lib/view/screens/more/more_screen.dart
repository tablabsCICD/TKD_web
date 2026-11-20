// File: more_screen_clean.dart
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';
import 'package:tkd_app/dialog/animated_custom_dialog.dart';
import 'package:tkd_app/dialog/my_dialog.dart';
import 'package:tkd_app/dialog/share_dialog_box.dart';
import 'package:tkd_app/locator.dart';
import 'package:tkd_app/model/gallary_model.dart';
import 'package:tkd_app/model/job_model.dart';
import 'package:tkd_app/model/my_job_list.dart';
import 'package:tkd_app/model/own_genral_post.dart';
import 'package:tkd_app/model/pool_purchase_model.dart';
import 'package:tkd_app/model/truck_load_model.dart';
import 'package:tkd_app/multi_select.dart';
import 'package:tkd_app/network/api_call.dart';
import 'package:tkd_app/open_whatsapp.dart';
import 'package:tkd_app/provider/auth_provider.dart';
import 'package:tkd_app/provider/bid_provider.dart';
import 'package:tkd_app/provider/buy_sell_provider.dart';
import 'package:tkd_app/provider/dashboard_provider.dart';
import 'package:tkd_app/provider/delete_interface.dart';
import 'package:tkd_app/provider/gallery_provider.dart';
import 'package:tkd_app/provider/general_post_provider.dart';
import 'package:tkd_app/provider/job_provider.dart';
import 'package:tkd_app/provider/localization_provider.dart';
import 'package:tkd_app/provider/menu_provider.dart';
import 'package:tkd_app/provider/more_provider.dart';
import 'package:tkd_app/provider/pool_purchase_provider.dart';
import 'package:tkd_app/share_data.dart';
import 'package:tkd_app/util/ResponsiveWidget.dart';
import 'package:tkd_app/util/app_constants.dart';
import 'package:tkd_app/util/color-resource.dart';
import 'package:tkd_app/util/colors.dart';
import 'package:tkd_app/util/custom_text_style.dart';
import 'package:tkd_app/util/date_converter.dart';
import 'package:tkd_app/util/star_display.dart';
import 'package:tkd_app/util/style.dart';
import 'package:tkd_app/view/base_widget/all_cards.dart';
import 'package:tkd_app/view/base_widget/custom_button.dart';
import 'package:tkd_app/view/base_widget/custom_textfeild.dart';
import 'package:tkd_app/view/base_widget/custom_textview.dart';
import 'package:tkd_app/view/base_widget/getImage.dart';
import 'package:tkd_app/view/base_widget/getLoader.dart';
import 'package:tkd_app/view/base_widget/home_base_widgets.dart';
import 'package:tkd_app/view/base_widget/utils.dart';
import 'package:tkd_app/view/localization/language_constrants.dart';
import 'package:tkd_app/view/screens/gallery/gallary_feedback.dart';
import 'package:tkd_app/view/screens/gallery/gallery_screen.dart';
import 'package:tkd_app/view/screens/gallery/view_image-dialog.dart';
import 'package:tkd_app/view/screens/job/create_job.dart';
import 'package:tkd_app/view/screens/more/repeat_post_dialog.dart';
import 'package:tkd_app/view/screens/pool_purchase/pool_purchase_detail_screen.dart';
import 'package:tkd_app/view/screens/pool_purchase/pool_purches_screen.dart';
import 'package:tkd_app/widgets/dashboard_cards.dart';
import 'package:universal_html/html.dart' as html;
import 'package:http/http.dart' as http;

import '../../../model/discussion_model.dart';
import '../../../widgets/base_widgets.dart';
import '../menu_page.dart';

/// MoreScreen and related widgets (cleaned)
class MoreScreen extends StatefulWidget {
  final moreProvider = locator<MoreProvider>();
  final authProvider = locator<AuthProvider>();
  final generalPostProvider = locator<GeneralPostProvider>();

  MoreScreen({Key? key}) : super(key: key) {
    moreProvider.getOwnJobList(authProvider.userDetailList[0].id.toString());
    moreProvider.getOwnPostList(authProvider.userDetailList[0].id.toString());
   /* moreProvider.getPoolPurchaseList(
        authProvider.userDetailList[0].userName.toString());*/
    generalPostProvider.callGeneralPostApi();
   /* moreProvider.getGalleryList(authProvider.userDetailList[0].id.toString());
    moreProvider.getDiscussionList(
        authProvider.userDetailList[0].userName.toString());*/
  }

  @override
  _MoreScreenState createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  var selectedTab = 'Full Load';

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        backgroundColor: ThemeColor.baground,
        body: Consumer<MoreProvider>(
          builder: (context, model, child) => Container(
            child:  model.isMoreLoading && model.isMoreFirstLoading
                ? getLoader(true) // your existing loader (shows CircularProgressIndicator)
                : Column(
              children: [
                Container(
                  height: 62,
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: ResponsiveWidget.isDesktop(context)
                        ? EdgeInsets.symmetric(horizontal: 35, vertical: 15)
                        : EdgeInsets.symmetric(horizontal: 0, vertical: 15),
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      children: [
                        getCircularContainer("Full Load", (selectedTab == "Full Load")),
                        getCircularContainer("Part Load", (selectedTab == "Part Load")),
                        widget.authProvider.userDetailList[0].transporterOrAgent == 2 ||
                            widget.authProvider.userDetailList[0].transporterOrAgent == 3
                            ? SizedBox.shrink()
                            : getCircularContainer("Buy/Sell Vehicles", (selectedTab == "Buy/Sell Vehicles")),
                        getCircularContainer("General Post", (selectedTab == "General Post")),
                        getCircularContainer("Jobs", (selectedTab == "Jobs")),
                      ],
                    ),
                  ),
                ),

                /// CONTENT AREA - kept logic unchanged
                selectedTab == "Full Load"
                    ? Expanded(
                  child: Container(
                    color: ColorResources.HOME_BG,
                    child: model.isMoreFirstLoading?Container(
                      alignment: Alignment.center,
                      height: screenSize.height,
                      width: screenSize.width,
                      child:CircularProgressIndicator()):
                    model.myFullLoadTypeList.isEmpty
                        ? Container(
                        alignment: Alignment.center,
                        height: screenSize.height,
                        width: screenSize.width,
                        child: Text(getTranslated('no_post', context)!, style: Style.heading))
                        : ResponsiveWidget(
                      desktop: MyRequirementCard(model.myFullLoadTypeList),
                      mobile: MyRequirementCard(model.myFullLoadTypeList),
                      tablet: MyRequirementCard(model.myFullLoadTypeList),
                    ),
                  ),
                )
                    : selectedTab == "Part Load"
                    ? Expanded(
                  child: Container(
                    color: ColorResources.HOME_BG,
                    child:model.isMoreFirstLoading?Container(
                        alignment: Alignment.center,
                        height: screenSize.height,
                        width: screenSize.width,
                        child:CircularProgressIndicator()): model.myPartLoadTypeList.isEmpty
                        ? Container(
                        alignment: Alignment.center,
                        height: screenSize.height,
                        width: screenSize.width,
                        child: Text(getTranslated('no_post', context)!, style: Style.heading))
                        : ResponsiveWidget(
                      desktop: MyRequirementCard(model.myPartLoadTypeList),
                      mobile: MyRequirementCard(model.myPartLoadTypeList),
                      tablet: MyRequirementCard(model.myPartLoadTypeList),
                    ),
                  ),
                )
                    : selectedTab == "Buy/Sell Vehicles"
                    ? Expanded(
                  child: Container(
                    color: ColorResources.HOME_BG,
                    child: model.isMoreFirstLoading?Container(
                        alignment: Alignment.center,
                        height: screenSize.height,
                        width: screenSize.width,
                        child:CircularProgressIndicator()):model.myBuyVehicleList.isEmpty
                        ? Container(
                        alignment: Alignment.center,
                        height: screenSize.height,
                        width: screenSize.width,
                        child: Text(getTranslated('no_post', context)!, style: Style.heading))
                        : ResponsiveWidget(
                      desktop: MyBuySellCard(model.myBuyVehicleList),
                      mobile: MyBuySellCard(model.myBuyVehicleList),
                      tablet: MyBuySellCard(model.myBuyVehicleList),
                    ),
                  ),
                )
                    : selectedTab == "General Post"
                    ? Expanded(
                  child: Container(
                    color: ColorResources.HOME_BG,
                    child: model.isMoreFirstLoading?Container(
                        alignment: Alignment.center,
                        height: screenSize.height,
                        width: screenSize.width,
                        child:CircularProgressIndicator()):model.myBuyVehicleList.isEmpty
                        ? Container(
                        alignment: Alignment.center,
                        height: screenSize.height,
                        width: screenSize.width,
                        child: Text(getTranslated('no_post', context)!, style: Style.heading))
                        : ResponsiveWidget(
                      desktop: MyGeneralPostCard(),
                      mobile: MyGeneralPostCard(),
                      tablet: MyGeneralPostCard(),
                    ),
                  ),
                )
                    : selectedTab == "Jobs"
                    ? Expanded(
                  child: Container(
                    color: ColorResources.HOME_BG,
                    child: model.isMoreFirstLoading?Container(
                        alignment: Alignment.center,
                        height: screenSize.height,
                        width: screenSize.width,
                        child:CircularProgressIndicator()):model.myJobList.isEmpty
                        ? Container(
                        alignment: Alignment.center,
                        height: screenSize.height,
                        width: screenSize.width,
                        child: CustomText(getTranslated('no_post', context)!, style: Style.heading))
                        : ResponsiveWidget(
                      desktop: MyJobCard(model.myJobList),
                      mobile: MyJobCard(model.myJobList),
                      tablet: MyJobCard(model.myJobList),
                    ),
                  ),
                )
                    : selectedTab == "Announcement"
                    ? Expanded(
                  child: Container(
                    color: ColorResources.HOME_BG,
                    child: model.isMoreFirstLoading?Container(
                        alignment: Alignment.center,
                        height: screenSize.height,
                        width: screenSize.width,
                        child:CircularProgressIndicator()):model.myGalleryList.isEmpty
                        ? Container(
                        alignment: Alignment.center,
                        height: screenSize.height,
                        width: screenSize.width,
                        child: CustomText(getTranslated('no_post', context)!, style: Style.heading))
                        : ResponsiveWidget(
                      desktop: MyGallaryCard(model.myGalleryList),
                      mobile: MyGallaryCard(model.myGalleryList),
                      tablet: MyGallaryCard(model.myGalleryList),
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
                        child: Text(getTranslated('no_post', context)!, style: Style.heading))
                        : ResponsiveWidget(
                      desktop: MyDiscussionCard(listComment: model.discussionList, moreProvider: model),
                      mobile: MyDiscussionCard(listComment: model.discussionList, moreProvider: model),
                      tablet: MyDiscussionCard(listComment: model.discussionList, moreProvider: model),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  getCircularContainer(String title, bool isSelected) {
    return InkWell(
      onTap: () {
        setState(() {
          selectedTab = title;
        });
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 2.7),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Container(
          height: 30,
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
          child: CustomText(title, style: isSelected ? Style.filterSelectedHeading : Style.filterHeading, textAlign: TextAlign.center),
          decoration: BoxDecoration(
            color: isSelected ? ColorResources.RED : Color(0xffffffff),
            border: isSelected ? null : Border.all(color: Color(0xffd1ccc4)),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [BoxShadow(color: Colors.black12, offset: Offset(0, 0), blurRadius: 5, spreadRadius: 0)],
          ),
        ),
      ),
    );
  }
}

/// MyBuySellCard (cleaned - logic unchanged)
class MyBuySellCard extends StatefulWidget {
  final List<TruckLoad> buySellList;
  MyBuySellCard(this.buySellList);
  @override
  _MyBuySellCardState createState() => _MyBuySellCardState();
}

class _MyBuySellCardState extends State<MyBuySellCard> implements DeletePostInf {
  final buySellProvider = locator<BuySellProvider>();
  final authProvider = locator<AuthProvider>();
  final langProvider = locator<LocalizationProvider>();
  String? langCode;
  ScrollController _scrollController = ScrollController();
  var selectedPageNumber = 1;
  final moreProvider = locator<MoreProvider>();

  @override
  void initState() {
    super.initState();
    langCode = langProvider.selectedlangCode;
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        moreProvider.getOwnPostList(authProvider.userDetailList[0].id.toString(), currentPage: selectedPageNumber);
        selectedPageNumber++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MoreProvider>(
      builder: (context, model, child) => Container(
        margin: ResponsiveWidget.isDesktop(context) ? EdgeInsets.symmetric(horizontal: 35, vertical: 10) : EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          children: [
            widget.buySellList.isEmpty
                ? SizedBox(height: MediaQuery.of(context).size.height / 2.5)
                : Expanded(
              child: StaggeredGridView.countBuilder(
                crossAxisCount: ResponsiveWidget.isDesktop(context) ? 3 : ResponsiveWidget.isMobile(context) ? 1 : 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 12,
                itemCount: widget.buySellList.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {},
                    child: AllCards().cardSellBuyPost(index, context, widget.buySellList[index], this, userId: authProvider.userDetailList[0].id!),
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

  @override
  void deleteOwnPost(int postId, int index) {
    _showMyDialog(index, postId, moreProvider);
  }

  Future<void> _showMyDialog(int index, int id, MoreProvider provider) async {
    return showDialog(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: CustomText('Are you sure want to deleted your post?', style: Style.heading),
        actions: <Widget>[
          TextButton(
            child: CustomText(getTranslated('yes', context)!, style: Style.okButton),
            onPressed: () {
              provider.deleteBuySell(id, index).then((value) {
                showAnimatedDialog(context, MyDialog(icon: Icons.check, title: 'Post Delete', description: 'Your post deleted successfully', isFailed: false), dismissible: false, isFlip: false);
              });
              Navigator.of(context).pop();
            },
          ),
          TextButton(child: CustomText('no', style: Style.cancelButton), onPressed: () => Navigator.of(context).pop()),
        ],
      ),
    );
  }

  @override
  void rePost(TruckLoad truckLoad, bool isCityInterchange) {
    // TODO: implement rePost
  }
}

/// MyRequirementCard (cleaned)
class MyRequirementCard extends StatefulWidget {
  final List<TruckLoad> loadTypeList;
  MyRequirementCard(this.loadTypeList);
  @override
  _MyRequirementCardState createState() => _MyRequirementCardState();
}

class _MyRequirementCardState extends State<MyRequirementCard> implements DeletePostInf {
  final bidProvider = locator<BidProvider>();
  final authProvider = locator<AuthProvider>();
  final dashboardProvider = locator<DashboardProvider>();
  final moreProvider = locator<MoreProvider>();
  final langProvider = locator<LocalizationProvider>();
  String? langCode;
  ScrollController _scrollController = ScrollController();
  var selectedPageNumber = 1;

  @override
  void initState() {
    super.initState();
    langCode = langProvider.selectedlangCode;
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scroll_controller_max()) {
        moreProvider.getOwnPostList(authProvider.userDetailList[0].id.toString(), currentPage: selectedPageNumber);
        selectedPageNumber++;
      }
    });
  }

  double _scroll_controller_max() {
    try {
      return scroll_controller_value_max(scroll_controller: _scrollController);
    } catch (_) {
      return double.infinity;
    }
  }

  ScrollController scroll_controller_get() => _scrollController;

  double scroll_controller_value_max({required ScrollController scroll_controller}) =>
      scroll_controller.position.maxScrollExtent;

  @override
  Widget build(BuildContext context) {
    return Consumer<MoreProvider>(
      builder: (context, model, child) => Container(
        margin: ResponsiveWidget.isDesktop(context) ? EdgeInsets.symmetric(horizontal: 35, vertical: 10) : EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          children: [
            model.isMoreFirstLoading?CircularProgressIndicator():
            widget.loadTypeList.isEmpty
                ? SizedBox(height: MediaQuery.of(context).size.height / 2.5)
                : Expanded(
              child: StaggeredGridView.countBuilder(
                crossAxisCount: ResponsiveWidget.isDesktop(context) ? 3 : ResponsiveWidget.isMobile(context) ? 1 : 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 12,
                itemCount: widget.loadTypeList[0].partLoadOrNot == 0 ? model.myFullLoadTypeList.length : model.myPartLoadTypeList.length,
                itemBuilder: (context, index) {
                  final TruckLoad load = widget.loadTypeList[0].partLoadOrNot == 0 ? model.myFullLoadTypeList[index] : model.myPartLoadTypeList[index];
                  return InkWell(
                    onTap: () {
                    //  Navigator.push(context, MaterialPageRoute(builder: (builder) => RepeatDialogBox(model.myFullLoadTypeList[index])));
                    },
                    child: DashbordCards().cardLoadHome(index, context, load, authProvider.userDetailList[0].id!, this, dashboardProvider, true),
                  );
                },
                shrinkWrap: true,
                staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
              ),
            ),
            widget.loadTypeList.isEmpty ? SizedBox.shrink() : getLoader(model.isMoreLoading)
          ],
        ),
      ),
    );
  }

  @override
  void deleteOwnPost(int postId, int index) {
    _showMyDialog(index, postId, moreProvider);
  }

  Future<void> _showMyDialog(int index, int id, MoreProvider provider) async {
    return showDialog(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: CustomText('Are you sure want to deleted your post?', style: Style.title),
        actions: <Widget>[
          TextButton(
            child: CustomText(getTranslated('yes', context)!, style: Style.okButton),
            onPressed: () {
              provider.deleteFullLoad(id, index).then((value) {
                showAnimatedDialog(context, MyDialog(icon: Icons.check, title: 'Post Delete', description: 'Your post deleted successfully', isFailed: false), dismissible: false, isFlip: false);
              });
              Navigator.of(context).pop();
            },
          ),
          TextButton(child: CustomText('no', style: Style.cancelButton), onPressed: () => Navigator.of(context).pop()),
        ],
      ),
    );
  }

  @override
  void rePost(TruckLoad truckLoad, bool isCityInterchange) {
    // TODO: implement rePost
    _showRepostDialog(truckLoad, isCityInterchange);
  }

  Future<void> _showRepostDialog(
      TruckLoad truckLoad, bool isCityInterchange) async {
    return showDialog(
        context: context,
        builder: (_) => new CupertinoAlertDialog(
          title: CustomText(
            'Are you sure want to ${isCityInterchange ? "City Interchange and Re-submit" : "Re-submit"} your post?',
            style: Style.title,
          ),
          actions: <Widget>[
            TextButton(
              child: CustomText(getTranslated('yes', context)!,
                  style: Style.okButton),
              onPressed: () async {
                if (isCityInterchange) {
                  bool res = await dashboardProvider.interChnageSendPost(
                      context, truckLoad);
                 /* res == true
                      ? */showAnimatedDialog(
                      context,
                      MyDialog(
                        icon: Icons.check,
                        title: 'City Interchange Post',
                        description: 'Your post submitted successfully',
                        isFailed: false,
                      ),
                      dismissible: false,
                      isFlip: false);
                     /* : Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (builder) => MenuPage(
                            userDetailList:
                            authProvider.userDetailList,
                            selectedTab: "Package Change",
                          )));*/
                } else {
                  bool res = await dashboardProvider.reSendPost(
                      context, truckLoad);
                  if (res) {
                    showAnimatedDialog(
                        context,
                        MyDialog(
                          icon: Icons.check,
                          title: 'Re Submit Post',
                          description: 'Your post submitted successfully',
                          isFailed: false,
                        ),
                        dismissible: false,
                        isFlip: false);
                  }/* else {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (builder) => MenuPage(
                              userDetailList:
                              authProvider.userDetailList,
                              selectedTab: "Package Change",
                            )));
                  }*/
                }
              },
            ),
            TextButton(
              child: CustomText('no', style: Style.cancelButton),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ));
  }
}

/// MyGeneralPostCard (cleaned)
class MyGeneralPostCard extends StatefulWidget {
  final moreProvider = locator<MoreProvider>();
  final generalPostProvider = locator<GeneralPostProvider>();
  ScrollController _scrollController = ScrollController();
  var selectedPageNumber = 1;

  MyGeneralPostCard({Key? key}) : super(key: key) {
    _scroll_controller_add_listener();
  }

  void _scroll_controller_add_listener() {
    _scroll_controller_listener_ref()?.addListener(() {
      if (_scroll_controller_listener_ref()!.position.pixels == _scroll_controller_listener_ref()!.position.maxScrollExtent) {
        generalPostProvider.callGeneralPostApi(currentPage: selectedPageNumber);
        selectedPageNumber++;
      }
    });
  }

  ScrollController? _scroll_controller_listener_ref() => _scrollController;

  @override
  _MyGeneralPostCardState createState() => _MyGeneralPostCardState();
}

class _MyGeneralPostCardState extends State<MyGeneralPostCard> implements DeletePostInf {
  final authProvider = locator<AuthProvider>();
  final dashboardProvider = locator<DashboardProvider>();
  final moreProvider = locator<MoreProvider>();

  @override
  Widget build(BuildContext context) {
    return Consumer<GeneralPostProvider>(
      builder: (context, model, child) => Container(
        margin: ResponsiveWidget.isDesktop(context) ? EdgeInsets.symmetric(horizontal: 35, vertical: 10) : EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          children: [
            model.listOwnPost.isEmpty
                ? SizedBox(height: MediaQuery.of(context).size.height / 2.5)
                : Expanded(
              child: StaggeredGridView.countBuilder(
                crossAxisCount: ResponsiveWidget.isDesktop(context) ? 3 : ResponsiveWidget.isMobile(context) ? 1 : 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 12,
                itemCount: model.listOwnPost.length,
                itemBuilder: (context, index) {
                  return generalPost(model.listOwnPost[index], context, index);
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

  Widget generalPost(GernralPostOwnData generalPostOwnData, BuildContext context, int index) {
    return Container(
      width: 335,
      padding: EdgeInsets.all(12),
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        shadows: [BoxShadow(color: Color(0x114A5568), blurRadius: 8, offset: const Offset(0, 3), spreadRadius: 0)],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(child: HomeBaseWidget().heading(generalPostOwnData.title!, generalPostOwnData.description!)),
          SizedBox(height: 5),
          generalPostOwnData.images != null &&
              generalPostOwnData.images!.isNotEmpty &&
              generalPostOwnData.images![0] != null
              ? BaseWidget().image(context,
              image: (generalPostOwnData.images![0])):SizedBox(),
          SizedBox(height: 8),
          HomeBaseWidget().deleteMyPostButton((val) async {
            if (val == 10 || val == 1) {
              Future.delayed(Duration.zero, () => this.deleteOwnPost(generalPostOwnData.id!, index));
            }
            if (val == 3) {
              TruckLoad load = TruckLoad(
                id: 0,
                userId: authProvider.userDetailList[0].id,
                nameOfPerson: "${authProvider.userDetailList[0].firstName} ${authProvider.userDetailList[0].lastName}",
                companyName: authProvider.userDetailList[0].companyName,
                type: generalPostOwnData.typeName,
                postingTime: generalPostOwnData.typeName,
                tableName: generalPostOwnData.typeName,
                topicName: generalPostOwnData.typeName,
                content: generalPostOwnData.description,
                partLoadOrNot: 0,
                privatePost: 0,
                mainTag: generalPostOwnData.typeName,
                mobileNumber: authProvider.userDetailList[0].mobileNumber,
                source: '',
                deviceId: '',
                destination: '',
                estPrice: '',
                association: '',
                alterativeNumber: '',
                companyDetailsName: '',
                companyLogo: '',
                comment: [],
                companyRating: "4.5",
                dnd: 0,
                isPaid: 0,
                isVerifiedByCompany: authProvider.userDetailList[0].isUserVerifiedByCompany.toString(),
                likes: 0,
                makerName: '',
                loadWeight: '',
                mfgYear: '',
                modelName: '',
                otherDetails: '',
                postImages: [],
                ratings: 4.5,
                reminderUserName: '',
                sharableLink: '',
                transporterOrAgent: authProvider.userDetailList[0].transporterOrAgent,
                typeOfCargo: '',
                typeOfPayment: '',
                userList: '',
                vehicleSize: '',
                website: '',
              );

              await Utils().callShareFunction('', load, context);
            }
          })
        ],
      ),
    );
  }

  final generalPostProvider = locator<GeneralPostProvider>();

  @override
  void deleteOwnPost(int postId, int index) {
    _showMyDialog(index, postId, generalPostProvider);
  }

  Future<void> _showMyDialog(int index, int id, GeneralPostProvider provider) async {
    return showDialog(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: CustomText('Are you sure want to deleted your post?', style: Style.title),
        actions: <Widget>[
          TextButton(
            child: CustomText(getTranslated('yes', context)!, style: Style.okButton),
            onPressed: () {
              provider.deleteGeneralPost(id, index, context).then((value) {
                showAnimatedDialog(context, MyDialog(icon: Icons.check, title: 'Post Completed', description: 'Your post Completed successfully', isFailed: false), dismissible: false, isFlip: false);
              });
              Navigator.of(context).pop();
            },
          ),
          TextButton(child: CustomText('no', style: Style.cancelButton), onPressed: () => Navigator.of(context).pop()),
        ],
      ),
    );
  }

  @override
  void rePost(TruckLoad truckLoad, bool isCityInterchange) {
    _showRepostDialog(truckLoad, isCityInterchange);
  }

  Future<void> _showRepostDialog(
      TruckLoad truckLoad, bool isCityInterchange) async {

    return showDialog(
      context: context,
      builder: (dialogContext) => CupertinoAlertDialog(
        title: CustomText(
          'Are you sure want to ${isCityInterchange
              ? "City Interchange and Re-submit"
              : "Re-submit"} your post?',
          style: Style.title,
        ),
        actions: <Widget>[
          TextButton(
            child: CustomText(
              getTranslated('yes', context)!,
              style: Style.okButton,
            ),
            onPressed: () async {
              // Close confirmation dialog
              Navigator.of(dialogContext, rootNavigator: true).pop();

              if (isCityInterchange) {
                await moreProvider.interChnageSendPost(context, truckLoad);

                await _showSuccessDialog(
                  title: 'City Interchange Post',
                  description: 'Your post submitted successfully',
                );
              } else {
                await moreProvider.reSendPost(context, truckLoad);

                await _showSuccessDialog(
                  title: 'Re-submit Post',
                  description: 'Your post submitted successfully',
                );
              }
            },
          ),

          TextButton(
            child: CustomText('no', style: Style.cancelButton),
            onPressed: () =>
                Navigator.of(dialogContext, rootNavigator: true).pop(),
          ),
        ],
      ),
    );
  }

  Future<void> _showSuccessDialog({
    required String title,
    required String description,
  }) async {
    await showAnimatedDialog(
      context,
      MyDialog(
        icon: Icons.check,
        title: title,
        description: description,
        isFailed: false,
      ),
      dismissible: false,
      isFlip: false,
    );

    // Close the success dialog
    Navigator.of(context, rootNavigator: true).pop();
  }



}

/// MyGallaryCard (cleaned)
class MyGallaryCard extends StatefulWidget {
  final List<Gallery> gallaryList;
  MyGallaryCard(this.gallaryList);
  @override
  _MyGallaryCardState createState() => _MyGallaryCardState();
}

class _MyGallaryCardState extends State<MyGallaryCard> {
  final langProvider = locator<LocalizationProvider>();
  String? langCode;
  final moreProvider = locator<MoreProvider>();

  @override
  void initState() {
    super.initState();
    langCode = langProvider.selectedlangCode;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MoreProvider>(
      builder: (context, model, child) => Container(
        margin: ResponsiveWidget.isDesktop(context) ? EdgeInsets.symmetric(horizontal: 35, vertical: 10) : EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          children: [
            widget.gallaryList.isEmpty
                ? SizedBox(height: MediaQuery.of(context).size.height / 2.5)
                : Expanded(
              child: StaggeredGridView.countBuilder(
                crossAxisCount: ResponsiveWidget.isDesktop(context) ? 3 : ResponsiveWidget.isMobile(context) ? 1 : 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 12,
                itemCount: widget.gallaryList.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 5,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                            horizontalTitleGap: 5,
                            minVerticalPadding: 0,
                            leading: getImage(widget.gallaryList[index].profilePicture.toString()),
                            title: langCode == 'en' ? Text(widget.gallaryList[index].firstName.toString(), style: Style.title) : CustomText(widget.gallaryList[index].firstName.toString(), style: Style.title),
                            subtitle: langCode == 'en' ? Text(widget.gallaryList[index].topicName.toString(), style: Style.subtitle) : CustomText(widget.gallaryList[index].topicName.toString(), style: Style.subtitle),
                            trailing: ConvertStringToDate(widget.gallaryList[index].date.toString()),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                            child: InkWell(
                              onTap: () async {
                                await showDialog(context: context, builder: (_) => ImageDialog(widget.gallaryList[index].image!));
                              },
                              child: Container(
                                height: 100,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  image: DecorationImage(image: NetworkImage('${widget.gallaryList[index].image}'), fit: BoxFit.cover),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0, bottom: 10, right: 10),
                            child: langCode == 'en' ? Text(widget.gallaryList[index].description.toString(), style: Style.content) : CustomText(widget.gallaryList[index].description.toString(), style: Style.content),
                          ),
                          Divider(height: 1.5, thickness: 1.5),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                InkWell(
                                  onTap: () {
                                    _showMultiSelect(context, widget.gallaryList[index]);
                                  },
                                  child: Row(
                                    children: [
                                      Icon(Icons.feedback, color: ColorResources.PRIMARY_COLOR, size: 16),
                                      SizedBox(width: 10),
                                      CustomText('Feedback', style: Style.bottomHeading)
                                    ],
                                  ),
                                ),
                                Container(width: 1.5, height: 30, color: Colors.grey),
                                InkWell(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (_) => CupertinoAlertDialog(
                                        title: CustomText('Are you sure want to deleted your post?', style: Style.heading),
                                        actions: <Widget>[
                                          TextButton(
                                            child: CustomText(getTranslated('yes', context)!, style: Style.okButton),
                                            onPressed: () {
                                              moreProvider.deleteGallery(widget.gallaryList[index]).then((value) {
                                                showAnimatedDialog(context, MyDialog(icon: Icons.check, title: 'Post Delete', description: 'Your post deleted successfully', isFailed: false), dismissible: false, isFlip: false);
                                              });
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          TextButton(child: CustomText('no', style: Style.cancelButton), onPressed: () => Navigator.of(context).pop()),
                                        ],
                                      ),
                                    );
                                  },
                                  child: Row(
                                    children: [
                                      Icon(Icons.delete, color: ColorResources.PRIMARY_COLOR, size: 16),
                                      SizedBox(width: 10),
                                      CustomText(getTranslated('delete', context)!, style: Style.bottomHeading)
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

  Set<int>? selectedValues = [1].toSet();

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
        return GallaryFeedbackDialog(items: items, initialSelectedValues: selectedValues, obj: object);
      },
    );
  }
}

/// MyPoolPurchaseCard (kept logic)
class MyPoolPurchaseCard extends StatefulWidget {
  final List<PoolPurchase> myPoolPurchaseList;
  MyPoolPurchaseCard(this.myPoolPurchaseList);
  @override
  _MyPoolPurchaseCardState createState() => _MyPoolPurchaseCardState();
}

class _MyPoolPurchaseCardState extends State<MyPoolPurchaseCard> {
  final poolPurchaseProvider = locator<PoolPurchaseProvider>();
  final moreProvider = locator<MoreProvider>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.HOME_BG,
      body: Consumer<MoreProvider>(
        builder: (context, model, child) => Container(
          margin: ResponsiveWidget.isDesktop(context) ? EdgeInsets.symmetric(horizontal: 35, vertical: 10) : EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            children: [
              widget.myPoolPurchaseList.isEmpty ? SizedBox(height: MediaQuery.of(context).size.height / 2.5) : Expanded(
                  child: StaggeredGridView.countBuilder(
                    crossAxisCount: ResponsiveWidget.isDesktop(context) ? 3 : ResponsiveWidget.isMobile(context) ? 1 : 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 12,
                    itemCount: widget.myPoolPurchaseList.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (builder) => PoolPurchaseDetailsScreen(widget.myPoolPurchaseList[index])));
                        },
                        child: Card(
                          elevation: 5,
                          child: Container(
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 7), child: CustomText(widget.myPoolPurchaseList[index].purchaseItem.toString(), style: Style.title)),
                                Padding(padding: const EdgeInsets.only(left: 10.0, bottom: 10, right: 10), child: CustomText(widget.myPoolPurchaseList[index].description.toString(), style: Style.subtitle)),
                                Divider(height: 1.5, thickness: 1.5),
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      InkWell(
                                        onTap: () async {
                                          var shareData = {"title": widget.myPoolPurchaseList[index].agentName, "text": widget.myPoolPurchaseList[index].mobileNumber, "url": 'link'};
                                          try {
                                            await html.window.navigator.share(shareData);
                                          } catch (e) {
                                            print(e);
                                          }
                                        },
                                        child: Row(children: [Image.asset('assets/images/share.png', color: ColorResources.PRIMARY_COLOR, height: 14, width: 14), SizedBox(width: 10), Text(getTranslated('share', context)!, style: Style.bottomHeading)]),
                                      ),
                                      Container(width: 1.5, height: 30, color: Colors.grey),
                                      InkWell(
                                        onTap: () {
                                          openwhatsapp(context, widget.myPoolPurchaseList[index].mobileNumber.toString(), 'please contact for more details');
                                        },
                                        child: Row(children: [Image.asset('assets/images/chat.png', color: ColorResources.PRIMARY_COLOR, height: 14, width: 14), SizedBox(width: 10), Text(getTranslated('chat', context)!, style: Style.bottomHeading)]),
                                      ),
                                      Container(width: 1.5, height: 30, color: Colors.grey),
                                      InkWell(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (_) => CupertinoAlertDialog(
                                              title: CustomText('Are you sure want to deleted your post?', style: Style.heading),
                                              actions: <Widget>[
                                                TextButton(
                                                  child: CustomText(getTranslated('yes', context)!, style: Style.okButton),
                                                  onPressed: () {
                                                    model.deletePoolPurchase(widget.myPoolPurchaseList[index]).then((value) {
                                                      showAnimatedDialog(context, MyDialog(icon: Icons.check, title: 'Post Delete', description: 'Your post deleted successfully', isFailed: false), dismissible: false, isFlip: false);
                                                    });
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                                TextButton(child: CustomText(getTranslated('no', context)!, style: Style.cancelButton), onPressed: () => Navigator.of(context).pop()),
                                              ],
                                            ),
                                          );
                                        },
                                        child: Row(children: [Icon(Icons.delete, color: ColorResources.PRIMARY_COLOR, size: 16), SizedBox(width: 10), CustomText("Delete", style: Style.bottomHeading)]),
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

/// MyJobCard (cleaned)
class MyJobCard extends StatefulWidget {
  final List<MyJobData> jobList;
  MyJobCard(this.jobList);
  @override
  _MyJobCardState createState() => _MyJobCardState();
}

class _MyJobCardState extends State<MyJobCard> implements DeletePostInf {
  final authProvider = locator<AuthProvider>();
  final moreProvider = locator<MoreProvider>();

  @override
  Widget build(BuildContext context) {
    return Consumer<MoreProvider>(
      builder: (context, model, child) => Container(
        margin: ResponsiveWidget.isDesktop(context) ? EdgeInsets.symmetric(horizontal: 35, vertical: 10) : EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          children: [
            Expanded(
              child: StaggeredGridView.countBuilder(
                physics: ScrollPhysics(),
                crossAxisCount: ResponsiveWidget.isDesktop(context) ? 3 : ResponsiveWidget.isMobile(context) ? 1 : 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 12,
                itemCount: widget.jobList.length,
                itemBuilder: (context, index) {
                  return cardMyJobPost(index, context, widget.jobList[index], this, model, userId: authProvider.userDetailList[0].id!);
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

  Widget cardMyJobPost(int index, BuildContext context, MyJobData myJobPost, DeletePostInf postDelete, MoreProvider model, {int userId = 0}) {
    return Container(
      width: 335,
      padding: EdgeInsets.all(12),
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        shadows: [BoxShadow(color: Color(0x114A5568), blurRadius: 8, offset: Offset(0, 3), spreadRadius: 0)],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Align(alignment: Alignment.topRight, child: Container(width: 100, height: 18, padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2), decoration: ShapeDecoration(color: Color(0xFFd35e61), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))), child: Center(child: Text(myJobPost.postJob!.type!, style: TextStyle(color: Colors.white, fontSize: 8, fontFamily: GoogleFonts.poppins().fontFamily, fontWeight: FontWeight.w600))))),
        SizedBox(height: 8),
        HomeBaseWidget().heading(myJobPost.postJob!.jobDescription!.isEmpty ? "" : myJobPost.postJob!.topicName!, myJobPost.postJob!.jobDescription!),
        SizedBox(height: 8),
        HomeBaseWidget().deleteMyPostButton((val) async {
          if (val == 10 || val == 1) {
            Future.delayed(Duration.zero, () => _showMyDialog(index, myJobPost, model));
          }
          if (val == 3) {
            String description = "'Type : ${myJobPost.postJob!.type!}, \\nSubject : ${myJobPost.postJob!.jobDescription}, \\nPost Title : ${myJobPost.postJob!.jobDescription}, \\nLink : https://api.tkdost.com/postJob/?id=${myJobPost.postJob!.id}'";
          }
        })
      ]),
    );
  }

  Future<void> _showMyDialog(int index, MyJobData myJobData, MoreProvider provider) async {
    return showDialog(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: CustomText('Are you sure want to deleted your post?', style: Style.title),
        actions: <Widget>[
          TextButton(child: CustomText(getTranslated('yes', context)!, style: Style.okButton), onPressed: () { provider.deleteJob(myJobData).then((value) { showAnimatedDialog(context, MyDialog(icon: Icons.check, title: 'Post Delete', description: 'Your post deleted successfully', isFailed: false), dismissible: false, isFlip: false); }); Navigator.of(context).pop(); }),
          TextButton(child: CustomText('no', style: Style.cancelButton), onPressed: () => Navigator.of(context).pop()),
        ],
      ),
    );
  }

  @override
  void deleteOwnPost(int postId, int index) {}
  @override
  void rePost(TruckLoad truckLoad, bool isCityInterchange) {}
}

/// MyDiscussionCard (cleaned)
class MyDiscussionCard extends StatefulWidget {
  final List<DiscussionContent> listComment;
  final MoreProvider moreProvider;
  const MyDiscussionCard({Key? key, required this.listComment, required this.moreProvider}) : super(key: key);
  @override
  State<StatefulWidget> createState() => MyDiscussionState(listComment, moreProvider);
}

class MyDiscussionState extends State<MyDiscussionCard> {
  List<DiscussionContent> discussionList;
  MoreProvider moreProvider;
  MyDiscussionState(this.discussionList, this.moreProvider);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StaggeredGridView.countBuilder(
        physics: ScrollPhysics(),
        crossAxisCount: ResponsiveWidget.isDesktop(context) ? 3 : ResponsiveWidget.isMobile(context) ? 1 : 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 12,
        itemCount: discussionList.length,
        itemBuilder: (context, index) => InkWell(onTap: () {}, child: Card(elevation: 5, child: listCard(index))),
        shrinkWrap: true,
        staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
      ),
    );
  }

  Widget listCard(int index) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        ListTile(
          leading: getImage(discussionList[index].profilePicture.toString()),
          title: CustomText('${discussionList[index].firstName.toString()} ${discussionList[index].lastName.toString()}', style: Style.title),
          subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [CustomText(discussionList[index].companyName.toString(), style: Style.subtitle)]),
          trailing: Text(discussionList[index].loggedTime.toString(), style: Style.date),
        ),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0), child: Text(discussionList[index].topic.toString(), style: Style.title, overflow: TextOverflow.ellipsis, softWrap: true, maxLines: 2)),
        Padding(padding: EdgeInsets.only(left: 20.0, bottom: 10, right: 20, top: 5), child: Text(discussionList[index].description.toString(), maxLines: 4, style: Style.content, overflow: TextOverflow.ellipsis)),
        cardDivider(),
        Padding(padding: EdgeInsets.fromLTRB(20, 10, 20, 10), child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [InkWell(onTap: () => showDeleteDialog(context, index), child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.delete, color: ColorResources.PRIMARY_COLOR, size: 16), SizedBox(width: 10), Text(getTranslated("delete", context)!, style: Style.cancelButton)]))])),
        cardDivider(),
        SizedBox(height: 14),
        Padding(padding: EdgeInsets.fromLTRB(20, 0, 20, 0), child: Text("${discussionList[index].totalComments} Comment", style: Style.date)),
        SizedBox(height: 5),
      ]),
    );
  }

  Widget cardDivider() {
    return Padding(padding: EdgeInsets.fromLTRB(20, 0, 20, 0), child: Divider(height: 1.5, thickness: 1.5));
  }

  showDeleteDialog(context, index) {
    showDialog(context: context, builder: (_) => CupertinoAlertDialog(title: CustomText('Are you sure want to deleted your post?', style: Style.title), actions: <Widget>[
      TextButton(child: Text(getTranslated('yes', context)!, style: Style.okButton), onPressed: () => callDelete(index)),
      TextButton(child: Text(getTranslated('no', context)!, style: Style.cancelButton), onPressed: () => Navigator.of(context).pop())
    ]));
  }

  void callDelete(index) async {
    ApiHelper apiHelper = ApiHelper();
    var response = await apiHelper.ApiDeleteData(ApiConstant.GET_DISCUSSION + "?id=${discussionList[index].id}");
    if (response.statusCode == 200) {
      discussionList.removeAt(index);
      Navigator.pop(context);
      setState(() {});
      moreProvider.discussionList.removeAt(index);
    }
  }
}
