
import 'dart:ui';
import 'dart:math';

import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:tkd_app/constant.dart';
import 'package:tkd_app/locator.dart';
import 'package:tkd_app/model/auth_api.dart';
import 'package:tkd_app/multi_select.dart';
import 'package:tkd_app/provider/auth_provider.dart';
import 'package:tkd_app/provider/localization_provider.dart';
import 'package:tkd_app/provider/menu_provider.dart';
import 'package:tkd_app/provider/route_provider.dart';
import 'package:tkd_app/util/ResponsiveWidget.dart';
import 'package:tkd_app/util/app_constants.dart';
import 'package:tkd_app/util/color-resource.dart';
import 'package:tkd_app/util/custom_text_style.dart';
import 'package:tkd_app/util/style.dart';
import 'package:tkd_app/view/base_widget/custom_textview.dart';
import 'package:tkd_app/view/base_widget/dashboard_header.dart';
import 'package:tkd_app/view/base_widget/drawer_menu.dart';
import 'package:tkd_app/view/base_widget/custom_button.dart';
import 'package:tkd_app/view/base_widget/getImage.dart';
import 'package:tkd_app/view/base_widget/search_widget.dart';
import 'package:tkd_app/view/localization/language_constrants.dart';
import 'package:tkd_app/view/payment/razor_pay.dart';
import 'package:tkd_app/view/screens/bids/my_bids_screen.dart';
import 'package:tkd_app/view/screens/bids/received_bids.dart';
import 'package:tkd_app/view/screens/buy_sell/buy_sell_vehicles.dart';
import 'package:tkd_app/view/screens/buy_sell/create_new_post.dart';
import 'package:tkd_app/view/screens/company/create_organization.dart';
import 'package:tkd_app/view/screens/dashboard/create_requirement.dart';
import 'package:tkd_app/view/screens/dashboard/dashboard.dart';
import 'package:tkd_app/view/screens/discussion/discussion_dashboard.dart';
import 'package:tkd_app/view/screens/feedback/feedback_screen.dart';
import 'package:tkd_app/view/screens/fleet/create_fleet.dart';
import 'package:tkd_app/view/screens/fleet/fleet_screen.dart';
import 'package:tkd_app/view/screens/gallery/create_gallary_post.dart';
import 'package:tkd_app/view/screens/gallery/gallery_screen.dart';
import 'package:tkd_app/view/screens/insuranceAndFinance.dart';
import 'package:tkd_app/view/screens/job/create_job.dart';
import 'package:tkd_app/view/screens/job/job_screen.dart';
import 'package:tkd_app/view/screens/more/create_general_post.dart';
import 'package:tkd_app/view/screens/plan/select_plan_screen.dart';
import 'auth/login_screen.dart';
import 'package:tkd_app/view/screens/more/more_screen.dart';
import 'package:tkd_app/view/screens/more/my_profile.dart';
import 'package:tkd_app/view/screens/my_routes/my_routes.dart';
import 'auth/otp_screen.dart';
import 'package:tkd_app/view/screens/plan/plan_screen.dart';
import 'package:tkd_app/view/screens/pool_purchase/create_pool_purchase_post.dart';
import 'package:tkd_app/view/screens/pool_purchase/pool_purches_screen.dart';
import 'package:tkd_app/view/screens/transport/transport_search_screen.dart';

import 'chats/IFramePage.dart';
import 'discussion/discussion_new.dart';
import 'dart:html' as html;

class MenuPage extends StatefulWidget {
  List<User>? userDetailList;
  String selectedTab;

  MenuPage({Key? key, this.userDetailList, required this.selectedTab }) : super(key: key);

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  late Widget container = DashBoardScreen();
  String dropdownValue = 'English';
  String value = 'All requirements';
  final authProvider = locator<AuthProvider>();
  final routeProvider = locator<RouteProvider>();
  List<String> _valueList = ["English", "हिंदी",'मराठी','ಕನ್ನಡ','മലയാളം','తెలుగు','தமிழ்'];
  late TextEditingController searchText = TextEditingController();

  @override
  void initState() {
    container = widget.selectedTab=="Board"?DashBoardScreen():SelectPlanScreen();
    routeProvider.addDataFromDummyListToRouteList();
    ApiConstant.languages
        .forEach((language) => _valueList.add(language.languageName!));
  }

  ScrollController _scrollController = new ScrollController();

  @override
  Widget build(BuildContext context) {
    int index;
    index =
        Provider.of<LocalizationProvider>(context, listen: false).languageIndex;
    return Scaffold(
      key: context.read<MenuProvider>().scaffoldKey,
      appBar: ResponsiveWidget.isMobile(context)
          ? AppBar(
              leading: ResponsiveWidget.isDesktop(context)
                  ?/* Image.asset(
                      'assets/images/tkd.png',
                      height: 500,
                      width: 500,
                    )*/
              Visibility(visible:false,child: SvgPicture.asset('assets/svg/logo.svg',height: 250,width: 500,))
                  : IconButton(
                      icon: Icon(
                        Icons.menu,
                        color: Colors.black,
                      ),
                      onPressed: context.read<MenuProvider>().controlMenu,
                    ),
              title: CustomText("Requirement",
                style: appbarTextStyle,
              ),
              backgroundColor: ColorResources.APPBAR_COLOR,
            )
          : AppBar(
              toolbarHeight: 60,
              leading: ResponsiveWidget.isDesktop(context)
                  ? Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Container(
                height: 60,
                width: 70,
               /* decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover,
                      image: AssetImage('assets/images/tkd.png',)
                    )
                ),*/

                      child: Visibility(visible:false,child: SvgPicture.asset('assets/svg/logo.svg',height: 250,width: 500,)),
                    ),
                  )
                  : IconButton(
                      icon: Icon(
                        Icons.menu,
                        color: Colors.black,
                      ),
                      onPressed: context.read<MenuProvider>().controlMenu,
                    ),
              /*title: Container(
                width: 255,
                height: 40,
                child: SearchWidget(
                  controller: searchText,
                  hintText: getTranslated('search_here', context)!,
                  onSubmit: () {},
                  onClearPressed: () {},
                ),
              ),*/
              backgroundColor: ColorResources.APPBAR_COLOR,
              actions: [
                Consumer<AuthProvider>(
                  builder: (context, model, child) => Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      CustomText(
                          '${model.userDetailList[0].firstName} ${model.userDetailList[0].lastName}',
                          style: Style.leadingName),
                      CustomText("${model.userDetailList[0].companyName}",
                          style: Style.companyName),
                    ],
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 12),
                  child: Consumer<AuthProvider>(
                    builder: (context, model, child) => Builder(builder: (context) {
                      return InkWell(
                          onTap: () {
                            showAlignedDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(Radius.circular(10))),
                                      child: DefaultTextStyle(
                                        style: TextStyle(fontSize: 18, color: Colors.black87),
                                        child: IntrinsicWidth(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                             /* CustomButton(
                                                onTap: (){
                                                  // Navigator.push(context, MaterialPageRoute(builder: (builder)=> MyProfile(widget.userDetailList![0])));
                                                  setState(() {
                                                    container = MyProfile();
                                                  });
                                                },
                                                buttonText: "View Profile",
                                              ),*/
                                              CustomButton(
                                                onTap: (){
                                                  getLogoutFunction();

                                                },
                                                buttonText: "Logout",
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                followerAnchor: Alignment.topLeft,
                                targetAnchor: Alignment.bottomLeft,
                                barrierColor: Colors.transparent);
                          },
                          child: getImage(
                          model.userDetailList[0].companyLogo.toString())
                      );
                    }),
                  ),
                ),
               /* Consumer<AuthProvider>(
                  builder: (context, model, child) => InkWell(
                    onTap: () {
                      print('UserId : ${model.userDetailList[0].id}');
                      setState(() {
                        container = Container(
                            color: ColorResources.HOME_BG,
                            child: IFramePage(
                              url:
                                  'https://tkdchatdemo.000webhostapp.com/#/register?id=${model.userDetailList[0].id}',
                            ));
                      });
                    },
                    child: Container(
                        child: Image.asset(
                      'assets/images/notifications.png',
                      height: 64,
                      width: 64,
                    )),
                  ),
                ),*/
                Consumer<LocalizationProvider>(
                  builder: (context, model, child) => Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 12),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        value: model.selectedlanguage,
                        hint: Text(
                          "English",
                          style: TextStyle(color: Colors.black),
                        ),
                        items: ["English", "हिंदी", "मराठी", "ಕನ್ನಡ",'മലയാളം','తెలుగు','தமிழ்']
                            .map((choosen) => DropdownMenuItem(
                                  value: choosen,
                                  child: Text('  $choosen', style: Style.title),
                                ))
                            .toList(),
                        isExpanded: false,
                        onChanged: (value) {
                          setState(() {
                            model.selectedlanguage = value.toString();
                            model.selectedlanguage == 'हिंदी'
                                ? index = 1
                                : model.selectedlanguage == 'मराठी'
                                    ? index = 2
                                    : model.selectedlanguage == 'ಕನ್ನಡ'
                                        ? index = 3
                                        : model.selectedlanguage == 'മലയാളം'
                                          ? index = 4
                                          : model.selectedlanguage == 'తెలుగు'
                                            ? index = 5
                                            : model.selectedlanguage == 'தமிழ்'
                                              ? index = 6
                                              : index = 0;
                            Provider.of<LocalizationProvider>(context,
                                    listen: false)
                                .setLanguage(Locale(
                              ApiConstant.languages[index].languageCode!,
                              ApiConstant.languages[index].countryCode,
                            ));
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
      drawer: DrawerMenu(callBack: menuCallBack,selectedTab: widget.selectedTab),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(width: 20,),
          Container(
              height: 40,
              color: Colors.black12,
              child: Text("Note : As we offer annual packages, \n we don't offer refunds.")),

          Spacer(),

          FloatingActionButton.extended(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)
          ),
            backgroundColor: ColorResources.THEME_COLOR,
            foregroundColor: Colors.white,
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (_) =>
                  new CupertinoAlertDialog(
                    title: CustomText(
                        'Contact Number : 8123004666 and 8123006888',
                        style: TextStyle(
                            color:
                            ColorResources
                                .BOTTOM_HEADING,
                            fontSize: 18,
                            fontWeight:
                            FontWeight
                                .bold)),
                    actions: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50.0),
                        child: CustomButton(
                          buttonText: 'Ok',
                          onTap: () {
                            Navigator.of(context)
                                .pop();
                          },
                        ),
                      ),
                    ],
                  ));
            },
            icon: Icon(Icons.call),
            label: Text("Call Load Support", style: Style.button),
          ),
          SizedBox(width: 16,),
          FloatingActionButton.extended(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)
            ),
            backgroundColor: ColorResources.THEME_COLOR,
            foregroundColor: Colors.white,
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                      content: Container(

                        height: ResponsiveWidget.isDesktop(context)
                            ?220
                            :220,
                        width: ResponsiveWidget.isMobile(context)?MediaQuery.of(context).size.width-50:ResponsiveWidget.isDesktop(context)?100:100,
                        // alignment: Alignment.center,
                        child: Column(
                           mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              child: CustomText('Full Load'),
                              onTap: () {
                                /*Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (builder) =>
                                            CreateRequirement('Full Load')));*/
                                showDialog(
                                    context: context,
                                    builder: (_) => Dialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16.0),
                                      ),
                                      elevation: 0.0,
                                      insetPadding: ResponsiveWidget.isMobile(context)?EdgeInsets.symmetric(vertical: 50,horizontal: 10):ResponsiveWidget.isTablet(context)?EdgeInsets.symmetric(vertical: 50,horizontal: 50):EdgeInsets.symmetric(vertical: 50,horizontal: 50),
                                      backgroundColor: Colors.white,
                                      child: Container(
                                        width: ResponsiveWidget.isMobile(context)?MediaQuery.of(context).size.width-50:ResponsiveWidget.isDesktop(context)?500:400,
                                        child: Stack(
                                          children: [
                                            CreateRequirement("Full Load"),
                                            Positioned(
                                              top: 7,
                                              right: 7,
                                              child: IconButton(
                                                icon: Icon(Icons.close,size: 18,),
                                                onPressed: (){
                                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder)=>MenuPage(userDetailList: widget.userDetailList,selectedTab: "Board",)));
                                                },
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                );
                              },
                            ),
                            Divider(),
                            InkWell(
                              child: CustomText('Part Load'),
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (_) => Dialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16.0),
                                      ),
                                      elevation: 0.0,
                                      insetPadding: ResponsiveWidget.isMobile(context)?EdgeInsets.symmetric(vertical: 50,horizontal: 10):ResponsiveWidget.isTablet(context)?EdgeInsets.symmetric(vertical: 50,horizontal: 50):EdgeInsets.symmetric(vertical: 50,horizontal: 50),
                                      backgroundColor: Colors.white,
                                      child: Container(
                                        width: ResponsiveWidget.isMobile(context)?MediaQuery.of(context).size.width-50:ResponsiveWidget.isDesktop(context)?500:400,
                                        child: Stack(
                                          children: [
                                            CreateRequirement("Part Load"),
                                            Positioned(
                                              top: 7,
                                              right: 7,
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
                                    )
                                );
                              },
                            ),
                            Divider(),
                            InkWell(
                              child: Text("General Post"),
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (_) => Dialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16.0),
                                      ),
                                      elevation: 0.0,
                                      insetPadding: ResponsiveWidget.isMobile(context)?EdgeInsets.symmetric(vertical: 50,horizontal: 10):ResponsiveWidget.isTablet(context)?EdgeInsets.symmetric(vertical: 50,horizontal: 50):EdgeInsets.symmetric(vertical: 50,horizontal: 50),
                                      backgroundColor: Colors.white,
                                      child: Container(
                                        width: ResponsiveWidget.isMobile(context)?MediaQuery.of(context).size.width-50:ResponsiveWidget.isDesktop(context)?500:400,
                                        child: Stack(
                                          children: [
                                            CreateGeneralPost(),
                                            Positioned(
                                              top: 7,
                                              right: 7,
                                              child: IconButton(
                                                icon: Icon(Icons.close,size: 18,),
                                                onPressed: (){
                                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder)=>MenuPage(userDetailList: widget.userDetailList,selectedTab: "Board",)));
                                                },
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                );
                              },
                            ),

                            Divider(),
                            if (widget.userDetailList![0].transporterOrAgent == 2 ||
                                widget.userDetailList![0].transporterOrAgent == 3)
                              SizedBox.shrink()
                            else
                              InkWell(
                                child: CustomText('Buy/Sell Vehicle'),
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (_) => Dialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(16.0),
                                        ),
                                        elevation: 0.0,
                                        insetPadding: ResponsiveWidget.isMobile(context)?EdgeInsets.symmetric(vertical: 50,horizontal: 10):ResponsiveWidget.isTablet(context)?EdgeInsets.symmetric(vertical: 50,horizontal: 50):EdgeInsets.symmetric(vertical: 50,horizontal: 50),
                                        backgroundColor: Colors.white,
                                        child: Container(
                                          width: ResponsiveWidget.isMobile(context)?MediaQuery.of(context).size.width-50:ResponsiveWidget.isDesktop(context)?500:400,
                                          child: Stack(
                                            children: [
                                              CreateNewBuySellPost(),
                                              Positioned(
                                                top: 7,
                                                right: 7,
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
                                      )
                                  );
                                },
                              ),
                            if (widget.userDetailList![0].transporterOrAgent == 2 ||
                                widget.userDetailList![0].transporterOrAgent == 3 || authProvider.userDetailList[0].isPaid != 30)
                              SizedBox.shrink()
                            else
                            Divider(),

                            if (widget.userDetailList![0].transporterOrAgent == 2 ||
                                widget.userDetailList![0].transporterOrAgent == 3 || authProvider.userDetailList[0].isPaid != 30)
                              SizedBox.shrink()
                            else
                              InkWell(
                                child: Text(getTranslated('jobs', context)!),
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (_) => Dialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(16.0),
                                        ),
                                        elevation: 0.0,
                                        insetPadding: ResponsiveWidget.isMobile(context)?EdgeInsets.symmetric(vertical: 50,horizontal: 10):ResponsiveWidget.isTablet(context)?EdgeInsets.symmetric(vertical: 50,horizontal: 50):EdgeInsets.symmetric(vertical: 50,horizontal: 50),
                                        backgroundColor: Colors.white,
                                        child: Container(
                                          height: 500,
                                          width: ResponsiveWidget.isMobile(context)?MediaQuery.of(context).size.width-50:ResponsiveWidget.isDesktop(context)?500:400,
                                          child: Stack(
                                            children: [
                                              CreateJob(),
                                              Positioned(
                                                top: 7,
                                                right: 7,
                                                child: IconButton(
                                                  icon: Icon(Icons.close,size: 18,),
                                                  onPressed: (){
                                                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder)=>MenuPage(userDetailList: widget.userDetailList,selectedTab: "Board",)));
                                                  },
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                  );
                                },
                              ),
                            Divider(),/*
                            if (widget.userDetailList![0].transporterOrAgent == 2 ||
                                widget.userDetailList![0].transporterOrAgent == 3)
                              SizedBox.shrink()
                            else*/
                           /* InkWell(
                              child: CustomText('BroadCast'),
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (_) => Dialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16.0),
                                      ),
                                      elevation: 0.0,
                                      insetPadding: ResponsiveWidget.isMobile(context)?EdgeInsets.symmetric(vertical: 50,horizontal: 10):ResponsiveWidget.isTablet(context)?EdgeInsets.symmetric(vertical: 50,horizontal: 50):EdgeInsets.symmetric(vertical: 50,horizontal: 50),
                                      backgroundColor: Colors.white,
                                      child: Container(
                                        width: ResponsiveWidget.isMobile(context)?MediaQuery.of(context).size.width-50:ResponsiveWidget.isDesktop(context)?500:400,
                                        child: Stack(
                                          children: [
                                            CreateGalleryPost(),
                                            Positioned(
                                              top: 7,
                                              right: 7,
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
                                    )
                                );
                              },
                            ),*/
                         //   Divider(),

                            /*if (widget.userDetailList![0].transporterOrAgent == 2 ||
                                widget.userDetailList![0].transporterOrAgent == 3)
                              SizedBox.shrink()
                            else
                              InkWell(
                                child:
                                CustomText('Pool Purchase'),
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (_) => Dialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(16.0),
                                        ),
                                        elevation: 0.0,
                                        insetPadding: ResponsiveWidget.isMobile(context)?EdgeInsets.symmetric(vertical: 50,horizontal: 10):ResponsiveWidget.isTablet(context)?EdgeInsets.symmetric(vertical: 50,horizontal: 50):EdgeInsets.symmetric(vertical: 50,horizontal: 50),
                                        backgroundColor: Colors.white,
                                        child: Container(
                                          width: ResponsiveWidget.isMobile(context)?MediaQuery.of(context).size.width-50:ResponsiveWidget.isDesktop(context)?500:400,
                                          child: Stack(
                                            children: [
                                              CreatePoolPurchasePost(),
                                              Positioned(
                                                top: 7,
                                                right: 7,
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
                                      )
                                  );
                                },
                              ),*/

                          /*  if (widget.userDetailList![0].transporterOrAgent == 2 ||
                                widget.userDetailList![0].transporterOrAgent == 3)
                              SizedBox.shrink()
                            else
                              Divider(),
                            if (widget.userDetailList![0].transporterOrAgent == 2 ||
                                widget.userDetailList![0].transporterOrAgent == 3)
                              SizedBox.shrink()
                            else
                              InkWell(
                                child: CustomText('Fleet'),
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (_) => Dialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(16.0),
                                        ),
                                        elevation: 0.0,
                                        insetPadding: ResponsiveWidget.isMobile(context)?EdgeInsets.symmetric(vertical: 50,horizontal: 10):ResponsiveWidget.isTablet(context)?EdgeInsets.symmetric(vertical: 50,horizontal: 50):EdgeInsets.symmetric(vertical: 50,horizontal: 50),
                                        backgroundColor: Colors.white,
                                        child: Container(
                                          width: ResponsiveWidget.isMobile(context)?MediaQuery.of(context).size.width-50:ResponsiveWidget.isDesktop(context)?500:400,
                                          child: Stack(
                                            children: [
                                              CreateFleet(),
                                              Positioned(
                                                top: 7,
                                                right: 7,
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
                                      )
                                  );
                                },
                              ),*/
                          /*  if (widget.userDetailList![0].transporterOrAgent == 2 ||
                                widget.userDetailList![0].transporterOrAgent == 3)
                              SizedBox.shrink()
                            else
                              Divider(),*/
                            InkWell(
                              child: CustomText(
                                "Cancel",
                                style:
                                TextStyle(color: ColorResources.PRIMARY_COLOR),
                              ),
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                      )));
            },
            icon: Icon(Icons.add),
            label: Text("New Post", style: Style.button),
          ),
        ],
      ),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (ResponsiveWidget.isDesktop(context))
              Expanded(
                  flex: 1,
                  child: DrawerMenu(
                    callBack: menuCallBack,
                    selectedTab: widget.selectedTab,
                  )),
            Expanded(flex: 5, child: container)
          ],
        ),
      ),
    );
  }

  menuCallBack(String value) {
    print(value);
    switch (value) {
      case "Board":
        container = DashBoardScreen();
        break;
      case "Markets":
        container = TransportSearchScreen();
        break;
      case "Transport":
        widget.userDetailList![0].isPaid == 0
            ? showDialog(
                context: context,
                builder: (_) => new CupertinoAlertDialog(
                      title: CustomText(
                          'You Don\'t have any plan? please get plan for business growth',
                          style: TextStyle(
                              color: ColorResources.BOTTOM_HEADING,
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                      actions: <Widget>[
                        TextButton(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: CustomText("Ok" ,
                                style: TextStyle(
                                    color: Colors.green, fontSize: 18)),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: CustomText("Cancel",
                              style: TextStyle(
                                  color: ColorResources.RED, fontSize: 18),
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ))
            : SizedBox.shrink();
        container = TransportSearchScreen();
        break;
      case "Discussions":
        container = TransportSearchScreen();
        break;
      case "Buy_Sell_Vehicles":
        container = BuySellVehicles(); //BuySellVehicles();
        break;
      case "Insurance_Finance":
        container = InsuranceAndFinanceScreen();
        break;
      case "Package Change":
        container = SelectPlanScreen();
        break;
      case "Jobs":
        container = JobScreen();
        break;
      case "Pool_Purchase":
        container = PoolPurchesScreen();
        break;
      case "My_Account":
        container = MyProfile();
        break;
      case "My_Post":
        container = MoreScreen();
        break;
      case "My_Routes":
        container = MyRoutes();
        break;
      case "My Quotes":
        container = MyBidsScreen();
        break;
      case "Received Quotes":
        container = ReceivedBidsScreen();
        break;
      case "Company":
        container = CreateOrganization();
        break;
      case "Fleets":
        container = FleetScreen();
        break;
      case "Feedback":
        container = FeedbackScreen();
        break;
      case "Plans":
        container = PlanScreen();
        //container = IFramePage(url: 'https://rcltechlab.000webhostapp.com/#/register',);
        break;
      case "Privacy Policy":
        String url = "https://s3.ap-south-1.amazonaws.com//tkd-images/profileImages//1711368127989-privacyPolicy.pdf";
        html.window.open(url,"_blank"/*,"_self"*/);

        break;
      case "Chats":
        container = Consumer<AuthProvider>(
          builder: (context, model, child) =>Container(
              color: ColorResources.HOME_BG,

              // child: IFramePage(
              //   url:'https://tkdchatdemo.000webhostapp.com/#/register?id=${model.userDetailList[0].id}',
              //
              // )),
        ));
        break;

      case "Logout":
        logoutFunction(authProvider);
        print('logout');
        break;
      default:
        container = TransportSearchScreen();
    }
    if (!ResponsiveWidget.isDesktop(context)) Navigator.pop(context);
    setState(() {});
  }

  Future<void> logoutFunction(AuthProvider authProvider) async {
    await authProvider.setVisitingFlag(false);
    await authProvider.setEmpId(0);
    Navigator.push(
        context, MaterialPageRoute(builder: (builder) => Login_Screen()));
  }

  WidgetBuilder get _localDialogBuilder {
    return (BuildContext context) {
      return GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: DefaultTextStyle(
            style: TextStyle(fontSize: 18, color: Colors.black87),
            child: IntrinsicWidth(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomButton(
                    onTap: (){
                     // Navigator.push(context, MaterialPageRoute(builder: (builder)=> MyProfile(widget.userDetailList![0])));
                     setState(() {
                        container = MyProfile();
                      });
                    },
                    buttonText: "View Profile",
                  ),
                  CustomButton(
                    onTap: (){
                      getLogoutFunction();
                    },
                    buttonText: "Logout",
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    };
  }

  void getLogoutFunction() {
    showDialog(
        context: context,
        builder: (_) => new CupertinoAlertDialog(
              title: CustomText("Logout"),
              actions: <Widget>[
                TextButton(
                  child: CustomText("Yes",
                      style: TextStyle(color: ColorResources.RED)),
                  onPressed: () {
                    logoutFunction(authProvider);
                  },
                ),
                TextButton(
                  child: CustomText("No",
                    style: TextStyle(color: ColorResources.GREEN),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
  }
}
