import 'dart:convert';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:number_pagination/number_pagination.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:staggered_grid_view_flutter/widgets/sliver.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';
import 'package:tkd_app/dialog/CustomCityListDialog.dart';
import 'package:tkd_app/dialog/animated_custom_dialog.dart';
import 'package:tkd_app/dialog/my_dialog.dart';
import 'package:tkd_app/dialog/share_dialog_box.dart';
import 'package:tkd_app/locator.dart';
import 'package:tkd_app/model/auth_api.dart';
import 'package:tkd_app/multi_select.dart';
import 'package:tkd_app/open_whatsapp.dart';
import 'package:tkd_app/provider/auth_provider.dart';
import 'package:tkd_app/provider/bid_provider.dart';
import 'package:tkd_app/provider/dashboard_provider.dart';
import 'package:tkd_app/provider/delete_interface.dart';
import 'package:tkd_app/provider/localization_provider.dart';
import 'package:tkd_app/share_data.dart';
import 'package:tkd_app/show_bid.dart';
import 'package:tkd_app/util/app_constants.dart';
import 'package:tkd_app/util/colors.dart';
import 'package:tkd_app/util/dynamic_translation.dart';
import 'package:tkd_app/util/style.dart';
import 'package:tkd_app/view/base_widget/app_constant.dart';
import 'package:tkd_app/view/base_widget/custom_search_city_feild.dart';
import 'package:tkd_app/view/base_widget/custom_textfeild.dart';
import 'package:tkd_app/view/base_widget/custom_textview.dart';
import 'package:tkd_app/view/base_widget/cutom_city_textfield.dart';
import 'package:tkd_app/view/base_widget/getImage.dart';
import 'package:tkd_app/view/base_widget/getLoader.dart';
import 'package:tkd_app/view/base_widget/home_base_widgets.dart';
import 'package:tkd_app/view/base_widget/utils.dart';
import 'package:tkd_app/view/localization/language_constrants.dart';
import 'package:tkd_app/view/screens/dashboard/create_requirement.dart';
import 'package:tkd_app/view/screens/dashboard/requirementDeatils.dart';
import 'package:tkd_app/view/screens/menu_page.dart';
import 'package:tkd_app/view/screens/my_routes/get_city_list.dart';
import 'package:tkd_app/widgets/dashboard_cards.dart';
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
import 'package:url_launcher/url_launcher.dart';

class DashBoardScreen extends StatefulWidget {
  final dashboardProvider = locator<DashboardProvider>();

  DashBoardScreen({Key? key}) : super(key: key) {
    dashboardProvider.getFullLoadTruckList("All","All");
  }

  @override
  _DashBoardScreenState createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen>{

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child:
      Container(
          color: ColorResources.HOME_BG,
          child: ResponsiveWidget(
            desktop: WebScreenDashBoard(),
            mobile: WebScreenDashBoard(),
            tablet: WebScreenDashBoard(),
          )),
    );
  }


}

class WebScreenDashBoard extends StatefulWidget {
  @override
  _WebScreenDashBoardState createState() => _WebScreenDashBoardState();
}

class _WebScreenDashBoardState extends State<WebScreenDashBoard>  implements DeletePostInf{
  final bidProvider = locator<BidProvider>();
  final authProvider = locator<AuthProvider>();
  TextEditingController bidAmtController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController sourceController = TextEditingController();
  TextEditingController destinationController = TextEditingController();
  TextEditingController filterController = TextEditingController();
  int counter = 0;
  var selectedPageNumber = 1;
  final dashboardProvider = locator<DashboardProvider>();
  ScrollController _scrollController = ScrollController();
  String? selectedFromCity = "All", selectedToCity = "All";
  final _formKey = GlobalKey<FormState>();
  final langProvider = locator<LocalizationProvider>();
  String? langCode;

  @override
  void initState() {
    super.initState();
    langCode = langProvider.selectedlangCode;
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        dashboardProvider.getFullLoadTruckList(selectedFromCity!,selectedToCity!,currentPage: selectedPageNumber);
        selectedPageNumber++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Consumer<DashboardProvider>(
      builder: (context, model, child) => Container(

          child: Column(children: [
            ResponsiveWidget.isDesktop(context)
                ? Container(
              height: 120,
              padding: ResponsiveWidget.isDesktop(context)
                  ? EdgeInsets.symmetric(horizontal: 35)
                  : EdgeInsets.symmetric(horizontal: 10),
              width: MediaQuery.of(context).size.width - 270,
              color: ColorResources.HOME_BG,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 40,
                    margin: EdgeInsets.fromLTRB(5,10,5,0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color:  Colors.white,
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          offset: Offset(0, 0),
                          blurRadius: 5,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    width: 350,
                    child: Padding(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomSearchCityTextField(
                            hintText: 'From',
                            controller: selectedFromCity!,
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return CustomCityListDialog(
                                        onTap: (String value) {
                                          setState(() {
                                            selectedFromCity = value;
                                          });
                                        });
                                  });
                            },
                          ),
                          Container(
                            height: 40,
                            width: 0.2,
                            color: Colors.grey[200],
                          ),
                          CustomSearchCityTextField(
                            hintText: 'To',
                            controller: selectedToCity!,
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return CustomCityListDialog(
                                        onTap: (String value) {
                                          setState(() {
                                            selectedToCity = value;
                                          });
                                        });
                                  });
                            },
                          ),
                          ElevatedButton(
                            onPressed: () {
                              model.getFullLoadTruckList(
                                  selectedFromCity!, selectedToCity!);
                              /*model.getSearchByNameList(
                                  '', selectedFromCity!, selectedToCity!);*/
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white, backgroundColor: Colors.black,
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(5))),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 0),
                              child: CustomText("Search",
                                  style: Style.button),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 60,
                    child: Row(
                      children: [
                        getCircularContainer(
                            "All Requirement", (selectedTab == "All Requirement"), 0),
                        getCircularContainer("Full Load Required",
                            (selectedTab == "Full Load Required"), 1),
                        getCircularContainer("Full Load Available",
                            (selectedTab == "Full Load Available"), 2),
                        getCircularContainer("Part Load Required",
                            (selectedTab == "Part Load Required"), 3),
                        getCircularContainer("Part Load Available",
                            (selectedTab == "Part Load Available"), 4),
                        getCircularContainer("General Post",
                            (selectedTab == "General Post"), 5),
                        /*InkWell(
                        onTap: () {
                          showAnimatedDialog(
                              context,
                              Dialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                child: Container(
                                  height: 350,
                                  width: 300,
                                  child: Padding(
                                    padding: EdgeInsets.all(16),
                                    child: Column(children: [
                                      CustomTextField(
                                          controller: nameController,
                                          hintText: getTranslated(
                                              'enter_name', context)!,
                                          textInputType: TextInputType.number),
                                      CustomTextField(
                                          controller: sourceController,
                                          hintText:
                                              getTranslated('source', context)!,
                                          textInputType: TextInputType.number),
                                      CustomTextField(
                                          controller: destinationController,
                                          hintText: getTranslated(
                                              'destination', context)!,
                                          textInputType: TextInputType.number),
                                      CustomButton(
                                          onTap: () {
                                            model.getSearchByNameList(
                                                nameController.text,
                                                sourceController.text,
                                                destinationController.text);
                                            Navigator.of(context).pop();
                                          },
                                          buttonText: getTranslated(
                                              'search_here', context)!)
                                    ]),
                                  ),
                                ),
                              ));
                        },
                        child: Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(60),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Image.asset(
                                'assets/images/filter.png',
                                height: 22,
                                width: 22,
                              ),
                            )),
                      ),*/
                        /*Container(
                        // height: 50,
                        margin: EdgeInsets.only(right: 10),
                        width: ResponsiveWidget.isDesktop(context)
                            ? 146
                            : screenSize.width / 4,
                        child: CustomButton(
                            onTap: () async {
                              String result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (builder) =>
                                          CreateRequirement('Full Load')));
                              print('in ${result} method');
                              if (result.contains('refresh')) {
                                print('out ${result} method');

                                model.getFullLoadTruckList();
                                setState(() {});
                              }
                            },
                            buttonText:
                                getTranslated('post_requirement', context)),
                      ),*/
                      ],
                    ),
                  ),
                ],
              ),
            )
                : Container(
              height: 105,
              width: MediaQuery.of(context).size.width,
              color: ColorResources.HOME_BG,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: 40,
                      width: ResponsiveWidget.isMobile(context)?screenSize.width : screenSize.width-200,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            offset: Offset(0, 0),
                            blurRadius: 5,
                            spreadRadius: 0,
                          ),
                        ],
                      ),

                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomSearchCityTextField(
                              hintText: 'From',
                              controller: selectedFromCity!,
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return CustomCityListDialog(
                                          onTap: (String value) {
                                            setState(() {
                                              selectedFromCity = value;
                                            });
                                          });
                                    });
                              },
                            ),
                            Container(
                              height: 40,
                              width: 0.2,
                              color: Colors.grey[200],
                            ),
                            CustomSearchCityTextField(
                              hintText: 'To',
                              controller: selectedToCity!,
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return CustomCityListDialog(
                                          onTap: (String value) {
                                            setState(() {
                                              selectedToCity = value;
                                            });
                                          });
                                    });
                              },
                            ),
                            ElevatedButton(
                              onPressed: () {
                                model.getFullLoadTruckList(
                                     selectedFromCity!, selectedToCity!);
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white, backgroundColor: Colors.black,
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                              ),
                              child: Container(
                                height: 30,
                                padding: EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 0),
                                child:
                                CustomText("SEARCH", style: Style.boardButton),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    Container(
                      height: 45,
                      color:ColorResources.HOME_BG,
                      padding: EdgeInsets.only(left: 5,top: 10),
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        children: [
                          getCircularContainer(
                              "All Loads", (selectedTab == "All Loads"), 0),
                          getCircularContainer("Full Load Required",
                              (selectedTab == "Full Load Required"), 1),
                          getCircularContainer("Full Load Available",
                              (selectedTab == "Full Load Available"), 2),
                          getCircularContainer("Part Load Required",
                              (selectedTab == "Part Load Required"), 3),
                          getCircularContainer("Part Load Available",
                              (selectedTab == "Part Load Available"), 4),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            model.truckLoadTypeList.isEmpty && model.isLoading == false
                ? Container(
                child: Container(
                    height: MediaQuery.of(context).size.height - 200,
                    child: Center(
                        child: Text(
                          getTranslated('no_post', context)!,
                          style: Style.heading,
                        ))))
                : model.truckLoadTypeList.isEmpty && model.isLoading ? SizedBox(height: MediaQuery.of(context).size.height/2.5,)
                : Expanded(
              child: Padding(
                padding: ResponsiveWidget.isDesktop(context)
                    ? EdgeInsets.symmetric(horizontal: 35)
                    : EdgeInsets.symmetric(horizontal: 10),
                child: StaggeredGridView.countBuilder(
                    controller: _scrollController,
                    physics: ScrollPhysics(),
                    staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
                    shrinkWrap: true,
                    crossAxisCount: ResponsiveWidget.isDesktop(context)
                        ? 3
                        : ResponsiveWidget.isMobile(context)
                        ? 1
                        : 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    itemCount: model.truckLoadTypeList.length,
                    itemBuilder: (context, index) {
                      print("Index: ${index}");
                      print("Date: ${model
                          .truckLoadTypeList[index]
                          .postingTime
                          .toString()}");
                      return model.truckLoadTypeList[index].type=="Advertisement"
                          ?getAdvCard(context,model.truckLoadTypeList[index])
                          :model.truckLoadTypeList[index].type=="General Post"
                          ?generalPost(model.truckLoadTypeList[index],context)
                      :AllCards().cardLoadHome(index,context,model.truckLoadTypeList[index],7271,this);
                    }),
              ),
            ),
            getLoader(model.isLoading)
            /*model.isFirstLoading ? getLoader(model.isLoading) :  showDialog(
          context: context,
          barrierColor: Colors.black38,
          barrierLabel: 'Label',
          barrierDismissible: true,
          builder: (BuildContext context) {
            return Center(
              child: Container(
                color: Colors.white,
                child: Material(
                    color: Colors.transparent,
                    child: getLoader(model.isFirstLoading)
                ),
              ),
            );
          },
        )*/
          ])),
    );
  }

  /*Widget getCard(TruckLoad load){
    return InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (builder) => RequirementDetails(
                      load)));
        },
        child: Card(
          // elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Container(
            // padding: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 0),
                    blurRadius: 5,
                    color: Color(0xffede8e0),
                  )
                ],
                color: Colors.white,
                borderRadius: BorderRadius.circular(10)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height:20,
                  child: Row(
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
                            color: model
                                .truckLoadTypeList[
                            index]
                                .mainTag ==
                                "Full load required"
                                ? ColorResources
                                .FULL_LOAD_REQUIRED
                                : model
                                .truckLoadTypeList[
                            index]
                                .mainTag ==
                                "Part load required"
                                ? ColorResources
                                .PART_LOAD_REQUIRED
                                : model
                                .truckLoadTypeList[
                            index]
                                .mainTag ==
                                "Full load available"
                                ? ColorResources
                                .FULL_LOAD_AVAILABLE
                                : ColorResources
                                .PART_LOAD_AVAILABLE,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomRight:
                                Radius.circular(15))),
                        child: CustomText(
                            load
                                .mainTag
                                .toString(),
                            style: TextStyle(
                                fontSize: 12,
                                fontFamily: 'RobotoMedium',
                                color: load
                                    .mainTag ==
                                    "Full load required"
                                    ? ColorResources.FLR_TEXT
                                    : load
                                    .mainTag ==
                                    "Part load required"
                                    ? ColorResources
                                    .PLR_TEXT
                                    : load
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
                              height: 3,
                            ),
                            load
                                .postingTime == null || load
                                .postingTime == ''?SizedBox.shrink(): ConvertStringToDate(load
                                .postingTime
                                .toString())

                          ],
                        ),
                      ),
                    ],
                  ),
                ),load.privatePost == 0 ?
                ListTile(
                  contentPadding: EdgeInsets.symmetric(
                      vertical: 0, horizontal: 20),
                  horizontalTitleGap: 13,
                  minVerticalPadding: 0,
                  leading: Stack(
                    children: [
                      getImage(model
                          .truckLoadTypeList[index]
                          .companyLogo
                          .toString()),
                      Positioned(
                        bottom: -7,
                        right: -5,
                        child: Image.asset(
                          load
                              .isPaid ==
                              30
                              ? 'assets/images/diamond.png'
                              : load
                              .isPaid ==
                              20
                              ? 'assets/images/gold_badge.png'
                              : load
                              .isPaid ==
                              0
                              ? 'assets/images/silver.png'
                              : 'assets/images/ruby_badge.png',
                          width: 24,
                          height: 24,
                        ),
                      )
                    ],
                  ),
                  trailing: StarDisplay(
                      value: model
                          .truckLoadTypeList[index]
                          .ratings!
                          .toInt()),
                  title: Row(
                    children: [
                      langCode == 'en'?Text(load
                          .toString(),
                          style: Style.title)
                          :CustomText(
                          load
                              .nameOfPerson
                              .toString(),
                          style: Style.title),
                      SizedBox(
                        width: 5,
                      ),
                      load
                          .isVerifiedByCompany ==
                          1
                          ? SizedBox.shrink()
                          : Tooltip(
                        message: "This user is verified by TKDost team",
                        child: Image.asset(
                          'assets/images/membership.png',
                          width: 14,
                          height: 14,
                        ),
                      )
                    ],
                  ),
                  subtitle:  Row(
                    children: [
                      langCode == 'en'?Text(load
                          .companyName
                          .toString(),
                          style: Style.subtitle)
                          :CustomText(
                          load
                              .companyName
                              .toString(),
                          style: Style.subtitle),
                      SizedBox(
                        width: 5,
                      ),
                      load
                          .isVerifiedByCompany ==
                          0
                          ? SizedBox.shrink()
                          : Tooltip(
                        message: "This user is verified by '${load
                            .companyName}'",
                        child: Image.asset(
                          'assets/images/shield.png',
                          width: 13,
                          height: 13,
                        ),
                      )
                    ],
                  ),
                ):SizedBox.shrink(),
                SizedBox(height: 10,),
                Container(
                  alignment: Alignment.center,
                  margin:
                  EdgeInsets.symmetric(horizontal: 20),
                  height: 30,
                  decoration: new BoxDecoration(
                      color: Color(0xFFF4F6F6),
                      borderRadius:
                      BorderRadius.circular(5)),
                  child: Row(
                    mainAxisAlignment:
                    MainAxisAlignment.center,
                    children: [
                      langCode == 'en'?Text(model
                          .truckLoadTypeList[index].source
                          .toString(),
                        style: Style.cityHeading,)
                          :CustomText(
                        model
                            .truckLoadTypeList[index].source
                            .toString(),
                        style: Style.cityHeading,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      // CustomText("to", style: Style.content),
                      *//* Image.asset(
                                            'assets/images/right-arrow.png',
                                            height: 15,
                                            width: 25,
                                          ),*//*
                      Icon(
                        Icons.arrow_circle_right_rounded,
                        color: Colors.grey,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      langCode == 'en'?Text(model.truckLoadTypeList[index]
                          .destination
                          .toString(),
                        style: Style.cityHeading,)
                          :CustomText(
                        model.truckLoadTypeList[index]
                            .destination
                            .toString(),
                        style: Style.cityHeading,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 7),
                  child: langCode == 'en'?Text( load
                      .topicName
                      .toString(),
                      style: Style.title)
                      :CustomText(
                      load
                          .topicName
                          .toString(),
                      style: Style.title),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20.0, bottom: 10, right: 20),
                  child: langCode == 'en'?Text( load
                      .toString(),
                    style: Style.content,)
                      :CustomText(
                    load
                        .toString(),
                    style: Style.content,
                  ),
                ),
                *//* Divider(
                                          height: 1.5,
                                          thickness: 1.5,
                                        ),*//*
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 9.0,horizontal: 21),
                  child: Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      model.truckLoadTypeList[index].privatePost == 0 ?Row(
                        children: [
                          InkWell(
                            onTap: () async {
                              openwhatsapp(
                                  context,
                                  load
                                      .mobileNumber
                                      .toString(),
                                  'Type : ${load.type}, \nSubject : ${load.content}, \nSource : ${load.source}, \nDestination : ${load.destination}'
                              );
                            },
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/chat.png',
                                  color: ColorResources
                                      .PRIMARY_COLOR,
                                  height: 15,
                                  width: 15,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  getTranslated("chat", context)!,
                                  style:
                                  Style.bottomHeading,
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          InkWell(
                            onTap: () async {
                              *//*share_data(
                                                      model.truckLoadTypeList[index]);*//*
                              showDialog(context: context,
                                  builder: (BuildContext context){
                                    return ShareDialogBox(
                                        model.truckLoadTypeList[index]
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
                                  color: ColorResources
                                      .PRIMARY_COLOR,
                                  height: 15,
                                  width: 15,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  getTranslated("share", context)!,
                                  style:
                                  Style.bottomHeading,
                                )
                              ],
                            ),
                          )
                        ],
                      ):SizedBox.shrink(),
                      ElevatedButton(
                        onPressed: () {
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
                                                            idOfPost:load.id,
                                                            email: authProvider.userDetailList[0].emailId,
                                                            amount: bidAmtController.text,
                                                            id: 0,
                                                            bidderUserName: authProvider.userDetailList[0].userName,
                                                            userName: authProvider.userDetailList[0].userName,
                                                            type: load.mainTag,
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
                          foregroundColor: Colors.white, backgroundColor: ColorResources.THEME_COLOR,
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.all(
                                  Radius.circular(5))),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 5, horizontal: 0),
                          child: CustomText("BID NOW",
                              style: Style.boardButton),
                        ),
                      ),
                    ],
                  ),
                ),
                *//*Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  showAnimatedDialog(
                                                      context,
                                                      Dialog(
                                                        shape:
                                                            RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10)),
                                                        child: Container(
                                                          height: 300,
                                                          width: 300,
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    16),
                                                            child: Column(
                                                                children: [
                                                                  Text(
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
                                                                        bidProvider.generateBid(
                                                                            mobile: authProvider
                                                                                .userDetailList[
                                                                            0]
                                                                                .mobileNumber,
                                                                            description: descriptionController
                                                                                .text,
                                                                            idOfPost: model
                                                                                .truckLoadTypeList[
                                                                                    index]
                                                                                .id,
                                                                            email: authProvider
                                                                                .userDetailList[
                                                                                    0]
                                                                                .emailId,
                                                                            amount: bidAmtController
                                                                                .text,
                                                                            id:
                                                                                0,
                                                                            bidderUserName: authProvider
                                                                                .userDetailList[
                                                                            0]
                                                                                .userName,
                                                                            userName: authProvider
                                                                                .userDetailList[
                                                                                    0]
                                                                                .userName,
                                                                            type: model
                                                                                .truckLoadTypeList[
                                                                            index]
                                                                                .mainTag
                                                                                ,
                                                                            loggedUserName: '${authProvider
                                                                                .userDetailList[0]
                                                                                .firstName} ${authProvider
                                                                                .userDetailList[0]
                                                                                .lastName}') .then((value) =>
                                                                        {
                                                                          showAnimatedDialog(
                                                                              context,
                                                                              MyDialog(
                                                                                icon: Icons.check,
                                                                                title:
                                                                                'Generate Bid',
                                                                                description:
                                                                                'Your Bid Created successfully',
                                                                                isFailed: false,
                                                                              ),
                                                                              dismissible: false,
                                                                              isFlip: false),
                                                                        });
                                                                        Navigator.of(
                                                                                context)
                                                                            .pop();
                                                                      },
                                                                      buttonText:
                                                                          "Submit")
                                                                ]),
                                                          ),
                                                        ),
                                                      ));
                                                },
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Image.asset('assets/images/bid.png',width: 15,height: 15,color: ColorResources.BOTTOM_HEADING,),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text(
                                                      getTranslated('bid', context)!,
                                                      style: Style.bottomHeading,
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                width: 1.5,
                                                height: 25,
                                                color: Colors.grey,
                                              ),
                                              InkWell(
                                                onTap: () async {
                                                  openwhatsapp(
                                                      context,
                                                      model
                                                          .truckLoadTypeList[
                                                              index]
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
                                                      color: ColorResources.BOTTOM_HEADING,
                                                      height: 14,
                                                      width: 14,
                                                    ),
                                                    SizedBox(
                                                      width: 10,
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
                                                height: 23,
                                                color: Colors.grey,
                                              ),
                                              InkWell(
                                                onTap: () async {
                                                  //share_data(widget.loadTypeList[index]);
                                                  Share.share(
                                                      model
                                                          .truckLoadTypeList[
                                                              index]
                                                          .sharableLink
                                                          .toString(),
                                                      subject: model
                                                          .truckLoadTypeList[
                                                              index]
                                                          .nameOfPerson
                                                          .toString());
                                                },
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
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
                                                    Text(
                                                      getTranslated('share', context)!,
                                                      style: Style.bottomHeading,
                                                    )
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        )*//*
              ],
            ),
          ),
        ));
  }*/


  Set<int>? selectedValues = [1, 2, 3, 4, 5].toSet();

  void _showMultiSelect(BuildContext context) async {
    final items = <MultiSelectDialogItem<int>>[
      MultiSelectDialogItem(1, 'All Requirements'),
      MultiSelectDialogItem(2, 'Required - Full load vehicle'),
      MultiSelectDialogItem(3, 'Required - Part load vehicle'),
      MultiSelectDialogItem(4, 'Available - Full load vehicle'),
      MultiSelectDialogItem(5, 'Available - Part load vehicle'),
    ];

    selectedValues = await showDialog<Set<int>>(
      context: context,
      builder: (BuildContext context) {
        return MultiSelectDialog(
          items: items,
          initialSelectedValues: selectedValues,
        );
      },
    );
    print(selectedValues!.length);
    print(selectedValues);
  }

  String getText(Set<int>? selectedValues) {
    int count = selectedValues!.length;
    String message = getTranslated('all_requirements', context)!;
    if (count == 5)
      return message;
    else
      return '${count} ' + getTranslated('requirements_selected', context)!;
  }

  var selectedTab = 'All Requirement';
  late List<int> selectedValuesList = <int>[];

  getCircularContainer(String title, bool isSelected, int i) {
    return Consumer<DashboardProvider>(
      builder: (context, model, child) => InkWell(
        onTap: () {
          setState(() {
            selectedTab = title;
            model.fla = false;
            model.flr = false;
            model.pla = false;
            model.plr = false;
            model.gp = false;

            if(selectedTab == 'Full Load Required'){
              model.flr = true;
            }
            if(selectedTab == 'Part Load Required'){
              model.plr = true;
            }
            if(selectedTab == 'Full Load Available'){
              model.fla = true;
            }
            if(selectedTab == 'Part Load Available'){
              model.pla = true;
            }
            if(selectedTab == 'General Post'){
              model.gp = true;
            }
            if(selectedTab == 'All Requirement'){
              model.pla = true;
              model.plr = true;
              model.fla = true;
              model.flr = true;
              model.gp = true;
            }
          });
          model.getFullLoadTruckList(selectedFromCity!,selectedToCity!);
          /* selectedValuesList.add(i);
          setState(() {
            isSelected = !isSelected;
            selectedTab = title;
            selectedValuesList.forEach((element) {
              if (element == 1) {
                model.flr = true;
              }
              if (element == 2) {
                model.plr = true;
              }
              if (element == 3) {
                model.fla = true;
              }
              if (element == 4) {
                model.pla = true;
              }
            });
            if (selectedTab == 'All Loads') {
              model.flr = true;
              model.fla = true;
              model.plr = true;
              model.pla = true;
            }
          });
          model.getFullLoadTruckList();*/
        },
        child: Card(
          margin: EdgeInsets.symmetric(horizontal: 2.7),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Container(
            height: ResponsiveWidget.isDesktop(context)?30:25,
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(vertical: 3, horizontal: 20),
            child: CustomText(
              title,
              style: isSelected?Style.filterSelectedHeading:Style.filterHeading,
              textAlign: TextAlign.center,
            ),
            decoration: BoxDecoration(
              color: isSelected ? ColorResources.PRIMARY_COLOR : Color(0xfff0f0f0),
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
      ),
    );
  }

  String getSendingData(TruckLoad truckLoadTypeList) {
    String type,text,subject,weight,source,des;
    type = 'Type : ${truckLoadTypeList.type} Subject : ${truckLoadTypeList.content} Source : ${truckLoadTypeList.source} Destination : ${truckLoadTypeList.deviceId}';
    return type;
  }

  imageLoad(TruckLoad load){
    if(load.postImages!.length==0){
      return    Column(
        children: [
          SizedBox(
            height: 0,
          ),

        ],
      );
    }else if(load.postImages!.length==1){
      return Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: CachedNetworkImage(
              imageUrl: load.postImages!.first,
              placeholder: (context, url) => SvgPicture.asset("assets/svg/logo.svg"),
              errorWidget: (context, url, error) => ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    "https://igps.net/wp-content/uploads/2018/08/shutterstock_711168088.jpg",
                    fit: BoxFit.fill,
                    width: 311,
                    height: 200,
                  )),
              fit: BoxFit.fill,
              width: 311,
              height: 200,
            ),
          ),
          SizedBox(
            height: 9,
          ),
        ],
      );
    }else{

      return Column(
        children: [
          Container(
              transform: Matrix4.translationValues(0.0, -25.0, 00),
              child: Container(
                  child: CarouselSlider(
                    options: CarouselOptions(
                      padEnds: false,
                      pageSnapping: false,
                      enableInfiniteScroll: false,
                    ),
                    items: load.postImages!
                        .map((item) => Container(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(child: imageLink(item!)),
                      ),
                    ))
                        .toList(),
                  ))),
          SizedBox(
            height: 9,
          ),
        ],
      );
    }

  }

  Widget imageLink(String link) {
    // return Container(
    //   width: 311,
    //   height: 200,
    //   decoration: ShapeDecoration(
    //     image: DecorationImage(
    //       image: NetworkImage(
    //           link),
    //       fit: BoxFit.fill,
    //     ),
    //     shape: RoundedRectangleBorder(
    //       borderRadius: BorderRadius.circular(12),
    //     ),
    //   ),
    // );

    return CachedNetworkImage(
      imageUrl: link,
      placeholder: (context, url) => SvgPicture.asset("assets/svg/logo.svg"),
      errorWidget: (context, url, error) => ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.network(
            "https://igps.net/wp-content/uploads/2018/08/shutterstock_711168088.jpg",
            fit: BoxFit.fill,
            width: 311,
            height: 200,
          )),
      fit: BoxFit.fill,
      width: 311,
      height: 200,
    );
  }

  getAdvCard(BuildContext context,TruckLoad load) {
    return Container(
      width: 335,
      // height: 255,
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
              width: 100,
              height: 18,
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: ShapeDecoration(
                color: Color(0xFFD9462A),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)),
              ),
              child: Center(
                child: Text(
                  load.type!,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 8),
          imageLoad(load),
          InkWell(
            onTap: ()async{
              final url = Uri.parse(
                'http://${load.website}',
              );
              //   final Uri url = Uri.parse('https://flutter.dev');
              if (!await launchUrl(url)) {
                throw Exception('Could not launch $url');
              }

              //  await  launchUrl(url);
            },
            child:  Container(
              padding: EdgeInsets.all(4),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                   load.companyName??'',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4),
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      load.website??'',
                      style: TextStyle(
                        color: Color(0x99001E49),
                        fontSize: 12,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )

        ],
      ),
    );
  }

  generalPost(TruckLoad truckLoad,BuildContext context) {
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
            offset: const Offset(0, 3),
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
            child: InkWell(
              onTap: () async {
                /*share_data(
                                                      model.truckLoadTypeList[index]);*/
                showDialog(context: context,
                    builder: (BuildContext context){
                      return ShareDialogBox(
                          truckLoad
                      );
                    }
                );

              },
              child:  SvgPicture.asset(
                'assets/images/share_icon.svg',

                height: 25,
                width: 25,
              ),
            )
          ),
          Container(
              transform: Matrix4.translationValues(0.0, -25.0, 00),
              child: BaseWidget().profile(truckLoad.companyLogo!, truckLoad.nameOfPerson!, truckLoad.companyName!,verify: truckLoad.isPaid!)),
           SizedBox(
             height: 10,
           ),
          Container(
              transform: Matrix4.translationValues(0.0, -25.0, 00),
              child:BaseWidget()
                  .heading(truckLoad.topicName!, truckLoad.content!) ,),
          Divider(),
          SizedBox(
            height: 5,
          ),

          BaseWidget().likeComment(truckLoad,context,likeCount: 0,commentCount: 0)
        ],
      ),
    );
  }

  /*Future<void> _showMyDialog(int index,int id,DashboardProvider myPostProvider) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title:  Text("Delete",style: TextStyle(fontFamily: AppConstant.FONTFAMILY,color: ThemeColor.theme_blue)),
          content:  SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("DeleteMsg",style: TextStyle(fontFamily: AppConstant.FONTFAMILY,color: ThemeColor.theme_blue),),

              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child:  Text("Delete",style: TextStyle(fontFamily: AppConstant.FONTFAMILY,color: ThemeColor.red)),
              onPressed: () {
                myPostProvider.deletePost(index,id,context);
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child:  Text("No",style: TextStyle(fontFamily: AppConstant.FONTFAMILY,color: ThemeColor.green)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }*/

  @override
  void deleteOwnPost(int postId, int index) {
    // TODO: implement deleteOwnPost

   
    //  _showMyDialog(index, postId,homeScreenProvider);
    

  }


}
