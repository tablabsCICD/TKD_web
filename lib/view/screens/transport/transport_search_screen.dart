
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:number_pagination/number_pagination.dart';
import 'package:provider/provider.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';
import 'package:tkd_app/dialog/CustomCityListDialog.dart';
import 'package:tkd_app/dialog/animated_custom_dialog.dart';
import 'package:tkd_app/dialog/custom-dialogBox.dart';
import 'package:tkd_app/locator.dart';
import 'package:tkd_app/model/transport_serach_model.dart';
import 'package:tkd_app/provider/localization_provider.dart';
import 'package:tkd_app/provider/route_provider.dart';
import 'package:tkd_app/provider/transport_provider.dart';
import 'package:tkd_app/util/ResponsiveWidget.dart';
import 'package:tkd_app/util/color-resource.dart';
import 'package:tkd_app/util/colors.dart';
import 'package:tkd_app/util/custom_text_style.dart';
import 'package:tkd_app/util/star_display.dart';
import 'package:tkd_app/util/style.dart';
import 'package:tkd_app/view/base_widget/custom_button.dart';
import 'package:tkd_app/view/base_widget/custom_search_city_feild.dart';
import 'package:tkd_app/view/base_widget/custom_textview.dart';
import 'package:tkd_app/view/base_widget/cutom_city_textfield.dart';
import 'package:tkd_app/view/base_widget/getImage.dart';
import 'package:tkd_app/view/base_widget/getLoader.dart';
import 'package:tkd_app/view/base_widget/search_widget.dart';
import 'package:tkd_app/view/localization/language_constrants.dart';
import 'package:tkd_app/view/screens/my_routes/get_city_list.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../base_widget/appbar.dart';

class TransportSearchScreen extends StatefulWidget {
  final transportProvider = locator<TransportProvider>();

  TransportSearchScreen({Key? key}) : super(key: key) {
    transportProvider.getAllData();
  }

  @override
  _TransportSearchScreenState createState() => _TransportSearchScreenState();
}

class _TransportSearchScreenState extends State<TransportSearchScreen> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white
           ),
        child: Consumer<TransportProvider>(
          builder: (context, model,
                  child) => /* model.transportSearchList.isEmpty
              ? Container(
                  alignment: Alignment.center,
                  height: screenSize.height,
                  width: screenSize.width,
                  child: CircularProgressIndicator(
                  ))
              : */
              ResponsiveWidget(
            desktop: TransportWebScreen(model.transportSearchList),
            mobile: TransportWebScreen(model.transportSearchList),
            tablet: TransportWebScreen(model.transportSearchList),
          ),
        ),
      ),
    );
  }
}

class TransportWebScreen extends StatefulWidget {
  List<TransportSearchData> transportList;

  TransportWebScreen(this.transportList);

  @override
  _TransportWebScreenState createState() => _TransportWebScreenState();
}

class _TransportWebScreenState extends State<TransportWebScreen> {
  int val = 0;
  TextEditingController fromCityController = TextEditingController();
  TextEditingController toCityController = TextEditingController();
  TextEditingController _controller = TextEditingController();
  final routeProvider = locator<RouteProvider>();
  final transportProvider = locator<TransportProvider>();
  int selectedPageNumber = 1;
  ScrollController _scrollController = ScrollController();
  String? selectedFromCity = '', selectedToCity = "";
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final langProvider = locator<LocalizationProvider>();
  String? langCode;
  String hintSearch="Search By Name";

  @override
  initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        transportProvider.getAllData(currentPage: selectedPageNumber);
        selectedPageNumber++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final double itemHeight = ResponsiveWidget.isDesktop(context)
        ? (screenSize.height - kToolbarHeight - 24) / 4.5
        : ResponsiveWidget.isTablet(context)
            ? (screenSize.height - kToolbarHeight - 24) / 7
            : (screenSize.height - kToolbarHeight - 24) / 12.5;
    final double itemWidth = screenSize.width / 2;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: ThemeColor.baground,
      appBar: AppBarCommon(context, title: "Search")
          .appBarWithTextField(_controller, hintSearch, (value) {
        if (value.toString().length > 3)
          callApiByRadio();
          return value;
      },true),
      body: Consumer<TransportProvider>(
        builder: (context, model, child) => Container(
          margin: ResponsiveWidget.isDesktop(context)
              ? EdgeInsets.symmetric(horizontal: 35, vertical: 20)
              : EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(right: 10),
                width: ResponsiveWidget.isDesktop(context)
                    ? screenSize.width
                    : screenSize.width,

              ),
              getLoader(model.isLoading),
              model.transportSearchList.isEmpty && model.isLoading == false
                  ? Expanded(
                      child: Container(
                          //height: MediaQuery.of(context).size.height - 200,
                          child: Center(
                              child: Text(
                      "No Search Found",
                      style: Style.heading,
                    ))))
                  : model.transportSearchList.isEmpty && model.isLoading
                      ? SizedBox(
                          // height: MediaQuery.of(context).size.height / 2.5,
                          )
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
                            itemCount: model.transportSearchList.length,
                            itemBuilder: (context, index) {
                              return model.transportSearchList[index].type=="Directory"?InkWell(
                                onTap: () {},
                                child: Container(
                                   /* color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    elevation: 5,*/
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            model.transportSearchList[index]
                                                        .isPaid !=
                                                    0
                                                ? Container(
                                                    width: 140,
                                                    height: 20,
                                                    alignment: Alignment.center,
                                                    decoration: new BoxDecoration(
                                                        color:
                                                            Color(0xff97af66),
                                                        borderRadius:
                                                            BorderRadius.only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        10),
                                                                bottomRight: Radius
                                                                    .circular(
                                                                        15))),
                                                    child: CustomText(
                                                      'Verified',
                                                      style: Style.sponsered,
                                                    ),
                                                  )
                                                : SizedBox.shrink(),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8.0,
                                                      vertical: 5),
                                              child: StarDisplay(
                                                  value: model
                                                      .transportSearchList[
                                                  index]
                                                      .ratings==0.0 ? 4.5 : double.parse(model
                                                      .transportSearchList[
                                                  index]
                                                      .ratings!.toString())
                                                      ),
                                            ),
                                          ],
                                        ),
                                        ListTile(
                                          minLeadingWidth: 0,
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 0, horizontal: 5),
                                          horizontalTitleGap: 15,
                                          minVerticalPadding: 0,
                                          title: Row(
                                            children: [
                                              langCode == 'en'
                                                  ? Text(
                                                      "${model.transportSearchList[index].firstName} ${model.transportSearchList[index].lastName}"
                                                                  .length >
                                                              23
                                                          ? "${model.transportSearchList[index].firstName} ${model.transportSearchList[index].lastName}"
                                                                  .substring(
                                                                      0, 23) +
                                                              '...'
                                                          : "${model.transportSearchList[index].firstName} ${model.transportSearchList[index].lastName}",
                                                      //                                                 "${model.transportSearchList[index].firstName} ${model.transportSearchList[index].lastName}",
                                                      style: Style.title,
                                                    )
                                                  : CustomText(
                                                      "${model.transportSearchList[index].firstName} ${model.transportSearchList[index].lastName}"
                                                                  .length >
                                                              23
                                                          ? "${model.transportSearchList[index].firstName} ${model.transportSearchList[index].lastName}"
                                                                  .substring(
                                                                      0, 23) +
                                                              '...'
                                                          : "${model.transportSearchList[index].firstName} ${model.transportSearchList[index].lastName}",
                                                      //"${model.transportSearchList[index].firstName} ${model.transportSearchList[index].lastName}",
                                                      style: Style.title,
                                                    ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              model.transportSearchList[index]
                                                          .verified ==
                                                      0
                                                  ? SizedBox.shrink()
                                                  : Image.asset(
                                                      'assets/images/membership.png',
                                                      width: 15,
                                                      height: 15,
                                                    ),
                                              Stack(
                                                children: [
                                                  Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: IconButton(
                                                      onPressed: () async {
                                                        String _url = "tel:${model.transportSearchList[index].mobileNumber}";
                                                        if (!await launchUrl(Uri.parse(_url))) {
                                                        throw Exception('Could not launch $_url');
                                                        }
                                                        /*launch(
                                                            "tel:${model.transportSearchList[index].mobileNumber}");*/
                                                      },
                                                      icon: Image.asset(
                                                          "assets/images/call.png"),
                                                      alignment:
                                                          Alignment.centerLeft,
                                                    ),
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                          subtitle: langCode == 'en'
                                              ? Text(
                                                  "${model.transportSearchList[index].companyName}",
                                                  style: Style.subtitle,
                                                )
                                              : CustomText(
                                                  "${model.transportSearchList[index].companyName}",
                                                  style: Style.subtitle,
                                                ),
                                          leading: Stack(
                                            children: [
                                              getImage(
                                                  model
                                                      .transportSearchList[
                                                          index]
                                                      .profilePicture
                                                      .toString(),
                                                  height: 45,
                                                  width: 45),
                                             /* Positioned(
                                                bottom: -5,
                                                right: -3,
                                                child: Image.asset(
                                                  model
                                                              .transportSearchList[
                                                                  index]
                                                              .isPaid ==
                                                          30
                                                      ? 'assets/images/diamond.png'
                                                      : model
                                                                  .transportSearchList[
                                                                      index]
                                                                  .isPaid ==
                                                              20
                                                          ? 'assets/images/gold_badge.png'
                                                          : model
                                                                      .transportSearchList[
                                                                          index]
                                                                      .isPaid ==
                                                                  10
                                                              ? 'assets/images/ruby_badge.png'
                                                              : 'assets/images/silver.png',
                                                  width: 24,
                                                  height: 24,
                                                ),
                                              )*/
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 0),
                                          child:
                                              Text(
                                                  '${model.transportSearchList[index].city}, ${model.transportSearchList[index].state}',
                                                  style: Style.contentHeading),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 5),
                                          child:
                                               Text(
                                                  '${model.transportSearchList[index].companyAddress}',
                                                  style: Style.content)
                                             ,
                                        ),
                                        Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 10),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                InkWell(
                                                  onTap: () async {
                                                    await model.getById(model.transportSearchList[index].id!);
                                                    showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return CustomDialogBox(
                                                              model.transportSearchData!);
                                                        });
                                                  },
                                                  child: CustomText(
                                                    "View Route",
                                                    style: Style.aleaready,
                                                  ),
                                                ),
                                                /* ElevatedButton(
                                        onPressed: (){
                                          showDialog(context: context,
                                              builder: (BuildContext context){
                                                return CustomDialogBox(
                                                    model.transportSearchList[index]
                                                );
                                              }
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.black,
                                          onPrimary: Colors.white,
                                          elevation: 3,
                                          shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                                          child: Text(getTranslated('view_profile', context)!,
                                              style: Style.button),
                                        ),
                                      ),*/
                                                ElevatedButton(
                                                  onPressed: () {
                                                    showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return CustomDialogBox(
                                                            model.transportSearchList[
                                                                index],
                                                            flag: true,
                                                          );
                                                        });
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    foregroundColor: Colors.white, backgroundColor: ColorResources.THEME_COLOR,
                                                    elevation: 3,
                                                    side: BorderSide(
                                                        color: ColorResources.THEME_COLOR,
                                                        width: 2),
                                                    //shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 5,
                                                            horizontal: 5),
                                                    child: CustomText(
                                                        getTranslated(
                                                            'get_contact_details',
                                                            context)!,
                                                        style: Style.button),
                                                  ),
                                                )
                                              ],
                                            )),
                                      ],
                                    )),
                              ):getAdvCard(context, model.transportSearchList[index]);
                            },
                            shrinkWrap: true,
                            staggeredTileBuilder: (int index) =>
                                StaggeredTile.fit(1),
                          ),
                        ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: fliterdirectory(),
    );
  }

  Widget imageDialog(text, path, context,transportSearchData) {
    return Dialog(
      // backgroundColor: Colors.transparent,
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
          imageLoadAdd(transportSearchData,context),
        ],
      ),
    );}

  imageLoadAdd(TransportSearchData transportSearchData,BuildContext context){
    if(transportSearchData.images!.length==0){
      return    Column(
        children: [
          SizedBox(
            height: 0,
          ),

        ],
      );
    }else if(transportSearchData.images!.length==1){
      return Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: CachedNetworkImage(
              imageUrl: transportSearchData.images!.first,
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
                    items: transportSearchData.images!
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

  imageLoad(TransportSearchData transportSearchData){
    if(transportSearchData.images!.length==0){
      return    Column(
        children: [
          SizedBox(
            height: 0,
          ),

        ],
      );
    }else if(transportSearchData.images!.length==1){
      return Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: CachedNetworkImage(
              imageUrl: transportSearchData.images!.first,
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
                    items: transportSearchData.images!
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
  getAdvCard(BuildContext context,TransportSearchData transportSearchData) {
    return GestureDetector(
      onTap: (){
        // print('the deds');
        showDialog(
          context: context,
          builder: (_) => imageDialog(transportSearchData.companyName,transportSearchData.images!.first,context,transportSearchData),
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
                    transportSearchData.type!,
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
            imageLoad(transportSearchData),
            InkWell(
              onTap: ()async{
                final url = Uri.parse(
                  'http://${transportSearchData.website}',
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
                      transportSearchData.companyName??'',
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
                        transportSearchData.website??'',
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

  mobileCardView(screenSize, TransportProvider model) {
    return model.isExpand
        ? GestureDetector(
            onTap: () {
              model.getMenuItem(model.isExpand ? false : true);
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  "Search Transporter" + ' : ',
                  style: Style.title,
                ),
                Container(
                  child: ListTile(
                    title: CustomText(
                      "By Location",
                      style: Style.transportSearchHeading,
                    ),
                    leading: Radio(
                      value: 1,
                      groupValue: val,
                      onChanged: (int? value) {
                        setState(() {
                          val = value!;
                        });
                      },
                      activeColor: Colors.green,
                    ),
                  ),
                ),
                Container(
                  child: ListTile(
                    title: CustomText(getTranslated('by_name', context)!,
                        style: Style.transportSearchHeading),
                    leading: Radio(
                      value: 2,
                      groupValue: val,
                      onChanged: (int? value) {
                        setState(() {
                          val = value!;
                        });
                      },
                      activeColor: Colors.green,
                    ),
                  ),
                ),
                Container(
                  child: ListTile(
                    title: CustomText(getTranslated('by_routes', context)!,
                        style: Style.transportSearchHeading),
                    leading: Radio(
                      value: 3,
                      groupValue: val,
                      onChanged: (int? value) {
                        setState(() {
                          val = value!;
                        });
                      },
                      activeColor: Colors.green,
                    ),
                  ),
                ),
                val == 3
                    ? Container(
                        width: screenSize.width / 1,
                        child: Column(
                          children: [
                            CustomCityTextField(
                              hintText: 'Select City',
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
                            CustomCityTextField(
                              hintText: 'Select City',
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
                          ],
                        ),
                      )
                    : Container(
                                ),
              ],
            ),
          )
        : Container();
  }

  fliterdirectory() {
    return Consumer<TransportProvider>(
      builder: (context, model, child) => InkWell(
        child: Container(
          height: 59,
          decoration: BoxDecoration(
            border: Border(),
            color: ColorResources.GAINS_BORO,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    WidgetSpan(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: Icon(Icons.filter_list_outlined, size: 18,),
                      ),
                    ),
                    TextSpan(
                      text: 'Filter ',
                      style: Style.newheading,
                      /*recognizer: TapGestureRecognizer()
                        ..onTap = (){
                          openBottomSheet(context,model);
                        },*/
                    ),
                  ],
              ),
              ),
            ],
          ),

    ),
        onTap: (){
          openBottomSheet(context,model);
        },
      ));
  }

  callApiByRadio(){
    switch(val){
      case 0:
        hintSearch='Search by Name';
        transportProvider.getBySearchData(_controller.value.text);
        break;
      case 1:
        hintSearch='Search by Location';
        transportProvider.getByLocData(_controller.value.text);
        break;
      case 2:
        hintSearch='Search by Company Name';
        transportProvider.getByNameData(_controller.value.text);
        break;
      case 3:
        hintSearch='Search by City';
        transportProvider.getByRoutesData(_controller.value.text,_controller.value.text);
        break;
    }
  }

  void openBottomSheet(BuildContext context,model)  {
    showModalBottomSheet(
    // showBottomSheet(
          context: context,
          builder: (_) => Consumer<TransportProvider>(
        builder: (context, model, child) =>Container(
          height: val ==3?MediaQuery.of(context).size.height/2:MediaQuery.of(context).size.height/3,
          width: ResponsiveWidget.isMobile(context)
              ? MediaQuery.of(context).size.width - 50
              : ResponsiveWidget.isDesktop(context)
              ? 100
              : 100,

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:  EdgeInsets.only(left: 20),
                    child: CustomText(
                      "Search Transporter" + ' : ',
                      style: Style.title,
                    ),
                  ),
                  Container(
                    child: ListTile(
                      title: CustomText(
                        "By Name",
                        style:
                        Style.transportSearchHeading,
                      ),
                      leading: Radio(
                        value: 0,
                        groupValue: val,
                        onChanged: (int? value) {
                          setState(() {
                            val = value!;
                          });
                          callApiByRadio();
                          Navigator.pop(context);
                        },
                        activeColor: Colors.green,
                      ),
                    ),
                  ),
                  Container(
                    child: ListTile(
                      title: CustomText(
                        "By Location",
                        style:
                        Style.transportSearchHeading,
                      ),
                      leading: Radio(
                        value: 1,
                        groupValue: val,
                        onChanged: (int? value) {
                          setState(() {
                            val = value!;
                          });
                          callApiByRadio();
                          Navigator.pop(context);
                        },
                        activeColor: Colors.green,
                      ),
                    ),
                  ),
                  Container(
                    child: ListTile(
                      title: CustomText(
                          getTranslated(
                              'by_name', context)!,
                          style: Style
                              .transportSearchHeading),
                      leading: Radio(
                        value: 2,
                        groupValue: val,
                        onChanged: (int? value) {
                          setState(() {
                            val = value!;
                          });
                          callApiByRadio();
                          Navigator.pop(context);
                        },
                        activeColor: Colors.green,
                      ),
                    ),
                  ),
                  Container(
                    child: ListTile(
                      title: CustomText(
                          getTranslated(
                              'by_routes', context)!,
                          style: Style
                              .transportSearchHeading),
                      leading: Radio(
                        value: 3,
                        groupValue: val,
                        onChanged: (int? value) {
                          val=3;
                          model.selectRoutes();

                          //callApiByRadio();
                        },
                        activeColor: Colors.green,
                      ),
                    ),
                  ),
                  val == 3
                      ? Container(
                    width: MediaQuery.of(context)
                        .size
                        .width /
                        1,
                    child: Column(
                      children: [
                        CustomCityTextField(
                          hintText: 'Select City',
                          controller:
                          selectedFromCity!,
                          onTap: () {
                            showDialog(
                                context: context,
                                builder:
                                    (BuildContext
                                context) {
                                  return CustomCityListDialog(
                                      onTap: (String
                                      value) {
                                        if(selectedToCity!.isEmpty==true && selectedFromCity!.isEmpty==true){
                                          selectedFromCity = value;
                                          model.selectRoutes();
                                        }else{
                                          selectedFromCity = value;
                                          model.selectRoutes();
                                          callApiByRadio();
                                          Navigator.pop(context);
                                        }
                                      });
                                });
                          },
                        ),
                        CustomCityTextField(
                          hintText: 'Select City',
                          controller:
                          selectedToCity!,
                          onTap: () {
                            showDialog(
                                context: context,
                                builder:
                                    (BuildContext
                                context) {
                                  return CustomCityListDialog(
                                      onTap: (String
                                      value) {
                                        if(selectedToCity!.isEmpty==true && selectedFromCity!.isEmpty==true){
                                          selectedToCity = value;
                                          model.selectRoutes();
                                        }else{
                                          selectedToCity = value;
                                         model.selectRoutes();
                                          callApiByRadio();
                                          Navigator.pop(context);
                                        }
                                      });
                                });
                          },
                        ),
                      ],
                    ),
                  )
                      : Container(
                    width: MediaQuery.of(context)
                        .size
                        .width /
                        1,
                  ),
                ],
              ),
            ],
          ),
        )));
    }
}

