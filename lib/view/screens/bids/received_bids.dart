import 'dart:convert';
import 'dart:ui';
import 'package:flutter/rendering.dart';
import 'package:number_pagination/number_pagination.dart';
import 'package:provider/provider.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';
import 'package:tkd_app/dialog/animated_custom_dialog.dart';
import 'package:tkd_app/dialog/my_dialog.dart';
import 'package:tkd_app/dialog/received_bids_dialog.dart';
import 'package:tkd_app/locator.dart';
import 'package:tkd_app/model/bid_model.dart';
import 'package:tkd_app/multi_select.dart';
import 'package:tkd_app/open_whatsapp.dart';
import 'package:tkd_app/provider/auth_provider.dart';
import 'package:tkd_app/provider/bid_provider.dart';
import 'package:tkd_app/provider/dashboard_provider.dart';
import 'package:tkd_app/provider/localization_provider.dart';
import 'package:tkd_app/provider/more_provider.dart';
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
import 'package:tkd_app/view/screens/more/repeat_post_dialog.dart';
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

class ReceivedBidsScreen extends StatefulWidget {
  final moreProvider = locator<MoreProvider>();
  final authProvider = locator<AuthProvider>();
  final bidProvider = locator<BidProvider>();

  ReceivedBidsScreen({Key? key}) : super(key: key) {
    print('UserName : ${authProvider.userDetailList[0].userName.toString()}');
    moreProvider.getList(authProvider.userDetailList[0].userName.toString());
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
    return Consumer<MoreProvider>(
      builder: (context, model, child) => Container(
        margin: ResponsiveWidget.isDesktop(context)?EdgeInsets.symmetric(
            horizontal: 35,vertical: 10
        ):EdgeInsets.symmetric(
            horizontal: 10,vertical: 10
        ),
        child: Column(
          children: [
            model.myOwnPostList.isEmpty ? SizedBox(height: MediaQuery.of(context).size.height/2.5,):
            Expanded(
                child: StaggeredGridView.countBuilder(
                  crossAxisCount: ResponsiveWidget.isDesktop(context)
                      ? 3
                      : ResponsiveWidget.isMobile(context)
                      ? 1
                      : 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 12,
                  itemCount: model.myOwnPostList.length,
                  itemBuilder: (context, index) {
                    bidProvider.getReceivedBidingList(model.myOwnPostList[index].mainTag!, model.myOwnPostList[index].id!);
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (builder) => RequirementDetails(
                                    model.myOwnPostList[index])));
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
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 140,
                                    height: 20,
                                    alignment: Alignment.center,
                                    decoration: new BoxDecoration(
                                        color: model.myOwnPostList[index].mainTag ==
                                            "Full load required"
                                            ? ColorResources.FULL_LOAD_REQUIRED
                                            : model.myOwnPostList[index].mainTag ==
                                            "Part load required"
                                            ? ColorResources.PART_LOAD_REQUIRED
                                            : model.myOwnPostList[index]
                                            .mainTag ==
                                            "Full load available"
                                            ? ColorResources
                                            .FULL_LOAD_AVAILABLE
                                            : ColorResources
                                            .PART_LOAD_AVAILABLE,
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(5),
                                            bottomRight: Radius.circular(10))),
                                    child: CustomText(
                                        model.myOwnPostList[index].mainTag
                                            .toString(),
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontFamily: 'RobotoMedium',
                                            color: model.myOwnPostList[index]
                                                .mainTag ==
                                                "Full load required"
                                                ? ColorResources.FLR_TEXT
                                                : model.myOwnPostList[index]
                                                .mainTag ==
                                                "Part load required"
                                                ? ColorResources.PLR_TEXT
                                                : model.myOwnPostList[index]
                                                .mainTag ==
                                                "Full load available"
                                                ? ColorResources.FLA_TEXT
                                                : ColorResources.PLA_TEXT)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 5,
                                        ),
                                        ConvertStringToDate(model.myOwnPostList[index].postingTime
                                            .toString()),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        StarDisplay(
                                            value: model.myOwnPostList[index].ratings!
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
                                    getImage(model.myOwnPostList[index].companyLogo
                                        .toString()),
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: Image.asset(
                                        model.myOwnPostList[index].isPaid == 30
                                            ? 'assets/images/diamond.png'
                                            : model.myOwnPostList[index].isPaid ==
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
                                        model.myOwnPostList[index].nameOfPerson
                                            .toString(),
                                        style: Style.title),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    model.myOwnPostList[index]
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
                                    model.myOwnPostList[index].companyName
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
                                        model.myOwnPostList[index].source
                                            .toString(),
                                        style: Style.cityHeading),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Image.asset('assets/images/two_way_arrow.png',height: 15,width: 25,),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    CustomText(
                                        model.myOwnPostList[index].destination
                                            .toString(),
                                        style: Style.cityHeading),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 7),
                                child: langCode == 'en'?Text(model.myOwnPostList[index].topicName.toString(),
                                    style: Style.contentHeading)
                                    :CustomText(
                                    model.myOwnPostList[index].topicName.toString(),
                                    style: Style.contentHeading),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0, bottom: 10, right: 10),
                                child: langCode == 'en'?Text(model.myOwnPostList[index].content.toString(),
                                  style: Style.content,)
                                    :CustomText(
                                  model.myOwnPostList[index].content.toString(),
                                  style: Style.content,
                                ),
                              ),
                              Divider(
                                height: 1.5,
                                thickness: 1.5,
                              ),
                              /*Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      onTap: () async {
                                        openwhatsapp(
                                            context,
                                            model.myOwnPostList[index]
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
                                            color: ColorResources.PRIMARY_COLOR,
                                            height: 15,
                                            width: 15,
                                          ),
                                          SizedBox(
                                            width: ResponsiveWidget.isDesktop(context)? 10 : 5,
                                          ),
                                          Text(getTranslated('chat', context)!,
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
                                            new RepeatDialogBox(model.myOwnPostList[index]));
                                      },
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.repeat_one,
                                            color: ColorResources.PRIMARY_COLOR,
                                            size: 16,
                                          ),
                                          SizedBox(
                                            width: ResponsiveWidget.isDesktop(context)? 10 : 5,                                      ),
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
                                        _showMultiSelect(context,model.myOwnPostList[index]);
                                      },
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.feedback,
                                            color: ColorResources.PRIMARY_COLOR,
                                            size: 16,
                                          ),
                                          SizedBox(
                                            width: ResponsiveWidget.isDesktop(context)? 10 : 5,
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
                                                      getTranslated(
                                                          'yes', context)!,
                                                      style: Style.okButton),
                                                  onPressed: () {
                                                    model
                                                        .deleteFullLoad(
                                                        model.myOwnPostList[
                                                        index])
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
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.delete,
                                            color: ColorResources.PRIMARY_COLOR,
                                            size: 16,
                                          ),
                                          SizedBox(
                                            width: ResponsiveWidget.isDesktop(context)? 10 : 5,
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
                              Divider(
                                height: 1.5,
                                thickness: 1.5,
                              ),*/
                              Center(child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.black,
                                    onPrimary: Colors.white,
                                    elevation: 3,
                                    side: BorderSide(color: Colors.black, width: 2),
                                  ),
                                  onPressed: () {
                                    showDialog(context: context,
                                        builder: (BuildContext context){
                                          return ReceivedBidsDialogBox(
                                            model.myOwnPostList[index],
                                          );
                                        }
                                    );

                                  },
                                  child: CustomText("See Received Bids",style: Style.button),
                                )
                              )),
                              Divider(
                                height: 1.5,
                                thickness: 1.5,
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
    );
  }

  Set<int>? selectedValues = [1,].toSet();

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
