import 'dart:convert';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
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
import 'package:tkd_app/view/base_widget/all_cards.dart';
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
import 'package:tkd_app/view/payment/razor_pay.dart';
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
              width: MediaQuery.of(context).size.width - 200,
              color: ThemeColor.baground,
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
                    width: 400,
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

                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white, backgroundColor: ColorResources.THEME_COLOR,
                              elevation: 1,
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
                    height: 62,
                    padding: EdgeInsets.symmetric(horizontal: 16,vertical: 12),
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      children: [
                        getCircularContainer(
                            "All Requirement", (selectedTab == "All Requirement"), 0),
                        getCircularContainer("Full Load Required",
                            (selectedTab == "Full Load Required"), 1),
                        getCircularContainer("Full Vehicle Required",
                            (selectedTab == "Full Vehicle Required"), 2),
                        getCircularContainer("Part Load Required",
                            (selectedTab == "Part Load Required"), 3),
                        getCircularContainer("Part Vehicle Required",
                            (selectedTab == "Part Vehicle Required"), 4),
                        getCircularContainer("General Post",
                            (selectedTab == "General Post"), 5),
                        getCircularContainer("Sell Buy Post",
                            (selectedTab == "Sell Buy Post"), 6),
                        getCircularContainer("Jobs",
                            (selectedTab == "Jobs"), 7),

                      ],
                    ),
                  ),
                ],
              ),
            )
                : Container(
              height: 105,
              width: MediaQuery.of(context).size.width,
              color:ThemeColor.baground,
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
                                foregroundColor: Colors.white, backgroundColor: ColorResources.THEME_COLOR,
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                              ),
                              child: Container(
                                height: 40,
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
                      height: 40,
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
                          getCircularContainer("Full Vehicle Required",
                              (selectedTab == "Full Vehicle Required"), 2),
                          getCircularContainer("Part Load Required",
                              (selectedTab == "Part Load Required"), 3),
                          getCircularContainer("Part Vehicle Required",
                              (selectedTab == "Part Vehicle Required"), 4),
                          getCircularContainer("Sell Buy Post",
                              (selectedTab == "Sell Buy Post"), 5),
                          getCircularContainer("Jobs",
                              (selectedTab == "Jobs"), 6),
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
                    height: MediaQuery.of(context).size.height - 300,
                    child: Center(
                        child: Text(
                          getTranslated('no_post', context)!,
                          style: Style.heading,
                        ))))
                : model.truckLoadTypeList.isEmpty && model.isLoading ? Container(
                child: Container(
                    height: MediaQuery.of(context).size.height - 300,
                    child: Center(
                        child: CircularProgressIndicator())))
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
                     : model.truckLoadTypeList[index].type=="Buy/Sell"
                          ?AllCards().cardSellBuyPost(index,context,model.truckLoadTypeList[index],this,userId: 0,isDashBoard: true)
                      :model.truckLoadTypeList[index].type=="Jobs"
                          ?AllCards().cardJobPost(index,context,model.truckLoadTypeList[index],this)
                          :model.truckLoadTypeList[index].type=="General Post"
                          ?DashbordCards().generalPost(model.truckLoadTypeList[index],context)
                      :DashbordCards().cardLoadHome(index,context,model.truckLoadTypeList[index],authProvider.userDetailList[0].id!,this,model,false);
                    }),
              ),
            ),
            model.truckLoadTypeList.isEmpty? SizedBox.shrink():getLoader(model.isLoading)

          ])),
    );
  }



  Set<int>? selectedValues = [1, 2, 3, 4, 5].toSet();



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
            model.buy_sell = false;
            model.jobs = false;
            if(selectedTab == 'Full Load Required'){
              model.flr = true;
            }
            if(selectedTab == 'Part Load Required'){
              model.plr = true;
            }
            if(selectedTab == 'Full Vehicle Required'){
              model.fla = true;
            }
            if(selectedTab == 'Part Vehicle Required'){
              model.pla = true;
            }
            if(selectedTab == 'General Post'){
              model.gp = true;
            }
            if(selectedTab == 'Sell Buy Post'){
              model.buy_sell = true;
            }
            if(selectedTab == 'Jobs'){
              model.jobs = true;
            }
            if(selectedTab == 'All Requirement'){
              model.pla = false;
              model.plr = false;
              model.fla = false;
              model.flr = false;
              model.gp = false;
              model.buy_sell = false;
              model.jobs = false;
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
              color: isSelected ? ColorResources.PRIMARY_COLOR : Color(0xffffffff),
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
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                  )),
              fit: BoxFit.fill,
              width: MediaQuery.of(context).size.width,
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

  /*cardSellBuyPost(int index, BuildContext context, TruckLoad load,DeletePostInf postDelete,{int userId=0}) {
    return Container(
      width: 335,
      // height: 255.h,
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
                color: Color(0xffd0a232),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)),
              ),
              child: Center(
                child: Text(
                  load.mainTag!,
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
          BaseWidget().profile(
              load.companyLogo!, load.nameOfPerson!, load.companyName!,
              verify: load.isPaid!),
          BaseWidget().headingWithDescription(load.topicName!, getDateObject(load.postingTime), load.mfgYear!,load.modelName!,load.estPrice!,false),
          SizedBox(height: 8),
          imageLoad(load),
          load.userId==userId ?BaseWidget().deleteButton((val) {
            if(val==10){

            }else{
              Utils().openMenu(val, load, context);
            }
          },false) :BaseWidget().getInTouchButton((val) {
            Utils().openMenu(val, load, context);
          })
        ],
      ),
    );
  }*/




  getDateObject(String? dateTime){
    try{
      DateTime formatedDate = DateTime.parse(dateTime!);
      // print(formatedDate);
      var date1 = DateFormat("yyyy-MM-dd").format(formatedDate);
      var todayDate = DateFormat("yyyy-MM-dd").format(DateTime.now());
      if(date1 == todayDate){
        date1 = DateFormat("H:mm").format(formatedDate);
      }
      return date1;
    }catch(e){
      return dateTime;
    }

  }



  getAdvCard(BuildContext context,TruckLoad load) {
    return GestureDetector(
      onTap: (){
       // print('the deds');
        showDialog(
          context: context,
          builder: (_) => imageDialog(load.companyName,load.postImages!.first,context,load),
        );


      },
      child: Container(
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
         //   SizedBox(height: 8),
            Text(
              load.companyName!,
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontFamily: GoogleFonts.poppins().fontFamily,
                fontWeight: FontWeight.bold,
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        Text(
                          load.mobileNumber.toString()??'',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
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
  void deleteOwnPost(int postId,int index,) {
    _showMyDialog(index, postId,dashboardProvider);
  }


  Future<void> _showMyDialog(int index,int id,DashboardProvider provider) async {
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
                    .deleteFullLoad(
                    id,index)
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


  Widget imageDialog(text, path, context,load) {
    return Dialog(
      backgroundColor: Colors.white,
      // elevation: 0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$text',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.close_rounded),
                  color: Colors.red,
                ),
              ],
            ),
          ),
          imageLoadAdd(load,context),
        ],
      ),
    );}



  imageLoadAdd(TruckLoad load,BuildContext context){
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
                    width: MediaQuery.of(context).size.width-100,
                    height: MediaQuery.of(context).size.height-100,
                  )),
              fit: BoxFit.fill,
              width: 500,
              height: 500,
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

  @override
  void rePost(TruckLoad truckLoad, bool isCityInterchange) {
    // TODO: implement rePost
    _showRepostDialog(truckLoad,isCityInterchange);
  }

  Future<void> _showRepostDialog(TruckLoad truckLoad, bool isCityInterchange) async {
    return   showDialog(
        context: context,
        builder: (_) =>
        new CupertinoAlertDialog(
          title: CustomText(
            'Are you sure want to ${isCityInterchange?"City Interchange and Re-submit":"Re-submit"} your post?',
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
                isCityInterchange? dashboardProvider.interChnageSendPost(context, truckLoad)
                    .then((value) => {
                  showAnimatedDialog(
                      context,
                      MyDialog(
                        icon:
                        Icons.check,
                        title:
                        'City Interchange Post',
                        description:
                        'Your post submitted successfully',
                        isFailed:
                        false,
                      ),
                      dismissible:
                      false,
                      isFlip:
                      false)
                })
                    :dashboardProvider.reSendPost(context, truckLoad)
                    .then((value) => {
                  showAnimatedDialog(
                      context,
                      MyDialog(
                        icon:
                        Icons.check,
                        title:
                        'Re Submit Post',
                        description:
                        'Your post submitted successfully',
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

}
