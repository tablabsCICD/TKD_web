import 'dart:ui';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';
import 'package:tkd_app/dialog/received_bids_dialog.dart';
import 'package:tkd_app/locator.dart';
import 'package:tkd_app/model/my_bids.dart';
import 'package:tkd_app/provider/auth_provider.dart';
import 'package:tkd_app/provider/bid_provider.dart';
import 'package:tkd_app/provider/localization_provider.dart';
import 'package:tkd_app/provider/more_provider.dart';
import 'package:tkd_app/util/colors.dart';
import 'package:tkd_app/util/images.dart';
import 'package:tkd_app/util/style.dart';
import 'package:tkd_app/view/base_widget/app_constant.dart';
import 'package:tkd_app/view/base_widget/utils.dart';
import 'package:tkd_app/view/localization/language_constrants.dart';
import 'package:tkd_app/view/screens/menu_page.dart';
import 'package:tkd_app/widgets/base_widgets.dart';
import 'package:tkd_app/widgets/toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tkd_app/model/truck_load_model.dart';
import 'package:tkd_app/util/ResponsiveWidget.dart';
import 'package:tkd_app/util/color-resource.dart';


class ReceivedBidsScreen extends StatefulWidget {
  final moreProvider = locator<MoreProvider>();
  final authProvider = locator<AuthProvider>();
  final bidProvider = locator<BidProvider>();

  ReceivedBidsScreen({Key? key}) : super(key: key) {
    print('UserName : ${authProvider.userDetailList[0].userName.toString()}');
    bidProvider.getReceivedBidingList();
  }

  @override
  _ReceivedBidsScreenState createState() => _ReceivedBidsScreenState();
}

class _ReceivedBidsScreenState extends State<ReceivedBidsScreen> {

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
  final bidProvider = locator<BidProvider>();
  final authProvider = locator<AuthProvider>();
  String? langCode;

  @override
  void initState() {
    super.initState();
    langCode = langProvider.selectedlangCode;
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery
        .of(context)
        .size;
//    TruckLoad truckLoad = dashboardProvider.truckLoadTypeList[0];
    return Consumer<BidProvider>(
      builder: (context, model, child) =>
          Container(
            margin: ResponsiveWidget.isDesktop(context) ? EdgeInsets.symmetric(
                horizontal: 35, vertical: 10
            ) : EdgeInsets.symmetric(
                horizontal: 10, vertical: 10
            ),
            child: Column(
              children: [
                model.ownBidPostList.isEmpty ? SizedBox(height: MediaQuery
                    .of(context)
                    .size
                    .height / 2.5, child: Container(
                    alignment: Alignment.center,
                    height: screenSize.height,
                    width: screenSize.width,
                    child: Text(
                        getTranslated(
                            'no_post', context)!,
                        style: Style.heading)),) :
                Expanded(
                    child: StaggeredGridView.countBuilder(
                      crossAxisCount: ResponsiveWidget.isDesktop(context)
                          ? 3
                          : ResponsiveWidget.isMobile(context)
                          ? 1
                          : 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 12,
                      itemCount: model.ownBidPostList.length,

                      itemBuilder: (context, i) {
                        return Padding(
                          padding: EdgeInsets.only(
                              bottom: 12, left: 20, right: 20),
                          child: iteamMyPost(model.ownBidPostList[i], i),);
                      },
                      shrinkWrap: true,
                      staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
                    )),
              ],
            ),
          ),
    );
  }

  iteamMyPost(PostBidData postBidData, int index) {
    return Container(
      width: 335,
      // height: 417.h,
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
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Container(
              width: 130,
              height: 18,
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: ShapeDecoration(
                color: Color(0xFF2C8FEA),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)),
              ),
              child: Center(
                child: Text(
                  postBidData.genericCardsDto!.mainTag!,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontFamily: GoogleFonts
                        .poppins()
                        .fontFamily,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 8,),
          BaseWidget().headingWithoutDate(
              postBidData.genericCardsDto!.topicName!,
              postBidData.genericCardsDto!.content!),
          SizedBox(height: 8,),
          BaseWidget().routes(postBidData.genericCardsDto!.source!,
              postBidData.genericCardsDto!.destination!),
          SizedBox(height: 8,),
          iteams(postBidData, index),
          SizedBox(height: 8,),
          BaseWidget().showBidButton((val) async {
            if (val == 0) {
              if (postBidData.bidings!.length > 0) {
                //showBootomSheet(context,postBidData.bidings);
                authProvider.userDetailList[0].isPaid == 0 ? Navigator
                    .pushReplacement(
                    context, MaterialPageRoute(builder: (builder) => MenuPage(
                  userDetailList: authProvider.userDetailList,
                  selectedTab: "Package Change",))) : showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return ReceivedBidsDialogBox(
                          postBidData.bidings!
                      );
                    }
                );
              } else {
                ToastMessage.show(context, "There are no bids to show ");
              }
            }
            if (val == 3) {
              String description = "${postBidData.genericCardsDto!.mobileNumber
                  .toString()}'Type : ${postBidData.genericCardsDto!
                  .type}, \nSubject : ${postBidData.genericCardsDto!
                  .content}, \nSource : ${postBidData.genericCardsDto!
                  .source}, \nDestination : ${postBidData.genericCardsDto!
                  .destination}, \nLink : https://api.tkdost.com/bids/?id=${postBidData
                  .genericCardsDto!.id}'";
              TruckLoad truckLoad = TruckLoad(
                  id: postBidData.genericCardsDto!.id,
                  userId: postBidData.genericCardsDto!.userId,
                  type: postBidData.genericCardsDto!.type,
                  postingTime: postBidData.genericCardsDto!.postingTime,
                  companyName: postBidData.genericCardsDto!.companyName,
                  nameOfPerson: postBidData.genericCardsDto!.nameOfPerson,
                  content: postBidData.genericCardsDto!.content,
                  topicName: postBidData.genericCardsDto!.topicName,
                  tableName: postBidData.genericCardsDto!.tableName,
                  partLoadOrNot: postBidData.genericCardsDto!.partLoadOrNot,
                  sharableLink: postBidData.genericCardsDto!.sharableLink,
                  deviceId: postBidData.genericCardsDto!.deviceId,
                  ratings: postBidData.genericCardsDto!.ratings,
                  mobileNumber: postBidData.genericCardsDto!.mobileNumber,
                  source: postBidData.genericCardsDto!.source,
                  destination: postBidData.genericCardsDto!.destination,
                  mainTag: postBidData.genericCardsDto!.mainTag,
                  privatePost: postBidData.genericCardsDto!.privatePost,
                  dnd: postBidData.genericCardsDto!.dnd,
                  vehicleSize: postBidData.genericCardsDto!.vehicleSize,
                  association: '',
                  isPaid: int.parse(postBidData.genericCardsDto!.isPaid.toString()),
                  website: postBidData.genericCardsDto!.website,
                  companyDetailsName: postBidData.genericCardsDto!.companyName);
              await Utils().callShareFunction(description, truckLoad, context);
            }
          }, true)


        ],
      ),
    );
  }

  iteams(PostBidData postBidData, int index) {
    if (postBidData.bidings!.length == 0) {
      return Container();
    } else {
      if (postBidData.bidings!.length == 1) {
        return iteamBid(postBidData.bidings![0], true, index);
      } else if (postBidData.bidings!.length == 2) {
        List<Widget>list = [
          iteamBid(postBidData.bidings![0], false, index),
          iteamBid(postBidData.bidings![1], true, index)];
        return Column(
          children: list,
        );
      } else {
        List<Widget>list = [
          iteamBid(postBidData.bidings![0], false, index),
          iteamBid(postBidData.bidings![1], false, index),
          iteamBid(postBidData.bidings![2], true, index)];
        return Column(
          children: list,
        );
      }
    }
  }

  iteamBid(Bidings bidings, bool isLast, int index) {
    return Container(
      width: 311,
      //  height: 69.h,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: isLast ? Colors.white : Color(0x332C363F),
          ),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  BaseWidget().getImage(
                      bidings.profileImage != null ? bidings.profileImage! : "",
                      height: 28, width: 28)
                  ,
                  SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  bidings.firstName! + " " + bidings.lastName!,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 10,
                                    fontFamily: AppConstant.FONTFAMILY,
                                    fontWeight: FontWeight.w600,
                                    height: 0,
                                  ),
                                ),
                                SizedBox(width: 4),
                                Visibility(
                                  visible: bidings.isPaid != 0 ? true : false,
                                  child: Container(
                                    width: 12,
                                    height: 12,
                                    clipBehavior: Clip.antiAlias,
                                    decoration: BoxDecoration(),
                                    child: Stack(
                                      children: [
                                        SvgPicture.asset(Images.verified)
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: Text(
                              bidings.companyName!,
                              style: TextStyle(
                                color: Color(0x99001E49),
                                fontSize: 10,
                                fontFamily: AppConstant.FONTFAMILY,
                                fontWeight: FontWeight.w400,
                                height: 0,
                              ),
                            ),
                          ),
                          Container(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '₹ ${bidings.bidings!.amount!}',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontFamily: AppConstant.FONTFAMILY,
                                    fontWeight: FontWeight.w600,
                                    height: 0,

                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 8),
          Container(
            width: 38,
            height: 38,
            decoration: ShapeDecoration(
              color: Colors.white.withOpacity(0.07999999821186066),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    // widget.provider.deleteBid(index, bidings);
                    Utils().callFunction(
                        context, "${bidings.bidings!.mobileNumber}");
                  }
                  , child: Container(
                  width: 22,
                  height: 22,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 22,
                        height: 22,
                        child: Stack(children: [
                          SvgPicture.asset(
                            Images.call_white, color: ThemeColor.theme_blue,
                            height: 25,
                            width: 25,)

                        ]),
                      ),
                    ],
                  ),
                ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


}
