import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';
import 'package:tkd_app/dialog/CustomCityListDialog.dart';
import 'package:tkd_app/dialog/animated_custom_dialog.dart';
import 'package:tkd_app/dialog/my_dialog.dart';
import 'package:tkd_app/locator.dart';
import 'package:tkd_app/model/truck_load_model.dart';
import 'package:tkd_app/provider/auth_provider.dart';
import 'package:tkd_app/provider/bid_provider.dart';
import 'package:tkd_app/provider/dashboard_provider.dart';
import 'package:tkd_app/provider/delete_interface.dart';
import 'package:tkd_app/provider/localization_provider.dart';
import 'package:tkd_app/util/ResponsiveWidget.dart';
import 'package:tkd_app/util/color-resource.dart';
import 'package:tkd_app/util/colors.dart';
import 'package:tkd_app/util/style.dart';
import 'package:tkd_app/view/base_widget/all_cards.dart';
import 'package:tkd_app/view/base_widget/custom_button.dart';
import 'package:tkd_app/view/base_widget/custom_search_city_feild.dart';
import 'package:tkd_app/view/base_widget/custom_textview.dart';
import 'package:tkd_app/view/base_widget/getLoader.dart';
import 'package:tkd_app/view/localization/language_constrants.dart';
import 'package:tkd_app/view/screens/menu_page.dart';
import 'package:tkd_app/widgets/dashboard_cards.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../widgets/base_widgets.dart';
import '../../../widgets/button.dart';
import 'debouncer.dart';

class DashBoardScreen extends StatefulWidget {
  final dashboardProvider = locator<DashboardProvider>();

  DashBoardScreen({Key? key}) : super(key: key) {
    dashboardProvider.getFullLoadTruckList("From", "To");
  }

  @override
  _DashBoardScreenState createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
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

class _WebScreenDashBoardState extends State<WebScreenDashBoard>
    implements DeletePostInf {
  final bidProvider = locator<BidProvider>();
  final authProvider = locator<AuthProvider>();
  TextEditingController bidAmtController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController sourceController = TextEditingController();
  TextEditingController destinationController = TextEditingController();
  TextEditingController filterController = TextEditingController();
  TextEditingController _controller = TextEditingController();
  final Debouncer _debouncer = Debouncer();
  int counter = 0;
  var selectedPageNumber = 1;
  final dashboardProvider = locator<DashboardProvider>();
  ScrollController _scrollController = ScrollController();
  TextEditingController selectedFromCity = TextEditingController();
  TextEditingController selectedToCity = TextEditingController();

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
        dashboardProvider.getFullLoadTruckList(
          selectedFromCity.text,
          selectedToCity.text,
          currentPage: selectedPageNumber,
        );
        selectedPageNumber++;
      }
    });
  }

  @override
  void dispose() {
    _debouncer.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: ThemeColor.baground,
      body: Consumer<DashboardProvider>(
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
                      SizedBox(
                        height: 45,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 40,
                              margin: EdgeInsets.fromLTRB(5, 10, 5, 0),
                              alignment: Alignment.center,
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
                              width: 500,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    /// FROM CITY
                                    CustomSearchCityTextField(
                                      hintText: 'From',
                                      controller: selectedFromCity.text,
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return CustomCityListDialog(
                                              onTap: (String value) {
                                                setState(() {
                                                  selectedFromCity.text = value;
                                                });
                                              },
                                            );
                                          },
                                        );
                                      },
                                    ),

                                    Container(
                                      height: 40,
                                      width: 0.2,
                                      color: Colors.grey[200],
                                    ),

                                    /// TO CITY
                                    CustomSearchCityTextField(
                                      hintText: 'To',
                                      controller: selectedToCity.text,
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return CustomCityListDialog(
                                              onTap: (String value) {
                                                setState(() {
                                                  selectedToCity.text = value;
                                                });
                                              },
                                            );
                                          },
                                        );
                                      },
                                    ),

                                    /// SEARCH BUTTON
                                    ElevatedButton(
                                      onPressed: () {
                                        model.getFullLoadTruckList(
                                          selectedFromCity.text,
                                          selectedToCity.text,
                                          currentPage: 0,
                                        );
                                        selectedPageNumber = 1;
                                      },
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        backgroundColor:
                                            ColorResources.THEME_COLOR,
                                        elevation: 3,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                        ),
                                      ),
                                      child: Container(
                                        height: 30,
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.symmetric(
                                            vertical: 0, horizontal: 0),
                                        child: CustomText("Search",
                                            style: Style.boardButton),
                                      ),
                                    ),

                                    /// CLEAR FILTER (corrected condition)
                                    if ((selectedFromCity.text.isNotEmpty &&
                                            selectedFromCity.text != "From") ||
                                        (selectedToCity.text.isNotEmpty &&
                                            selectedToCity.text != "To"))
                                      TextButton(
                                        onPressed: () {
                                          setState(() {
                                            selectedFromCity.text = "From";
                                            selectedToCity.text = "To";
                                            selectedPageNumber = 1;
                                          });

                                          model.getFullLoadTruckList(
                                            "From",
                                            "To",
                                            currentPage: 0,
                                          );
                                        },
                                        child: Text(
                                          "Clear",
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                                height: 40,
                                margin: EdgeInsets.fromLTRB(5, 10, 5, 0),
                                alignment: Alignment.center,
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
                                width: 400,
                                child: TextField(
                                  controller: _controller,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.all(8),
                                    hintText: "Search here",
                                    prefixIcon: const Icon(Icons.search),
                                    suffixIcon: _controller.text.isNotEmpty
                                        ? IconButton(
                                            icon: Icon(Icons.clear),
                                            onPressed: () {
                                              _controller.clear();
                                              model.getFullLoadTruckList(
                                                  "From", "To");
                                            },
                                          )
                                        : null,
                                    border: const OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                  style: Style.searchHint,
                                  onChanged: (value) {
                                    final search = value.trim();

                                    _debouncer.run(() {
                                      if (!mounted) return;
                                      // Clear search → load default list
                                      if (search.isEmpty) {
                                        model.getFullLoadTruckList(
                                            "From", "To");
                                        return;
                                      }

                                      // Avoid unnecessary calls
                                      if (search.length < 3) return;

                                      model.getSearchByNameList(0, search);
                                    });
                                  },
                                ))
                          ],
                        ),
                      ),

                      // ---- TABS BELOW ----
                      Container(
                        height: 62,
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          children: [
                            getCircularContainer("All Loads",
                                (selectedTab == "All Loads"), 0),
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
                            getCircularContainer(
                                "Jobs", (selectedTab == "Jobs"), 7),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              : Container(
                  height: 180,
                  width: MediaQuery.of(context).size.width,
                  color: ThemeColor.baground,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          height: 40,
                          width: double.infinity,
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: CustomSearchCityTextField(
                                    hintText: 'From',
                                    controller: selectedFromCity.text,
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return CustomCityListDialog(
                                            onTap: (String value) {
                                              setState(() {
                                                selectedFromCity.text = value;
                                              });
                                            },
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ),
                                SizedBox(width: 6),
                                Expanded(
                                  child: CustomSearchCityTextField(
                                    hintText: 'To',
                                    controller: selectedToCity.text,
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return CustomCityListDialog(
                                            onTap: (String value) {
                                              setState(() {
                                                selectedToCity.text = value;
                                              });
                                            },
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ),
                                SizedBox(width: 6),
                                ElevatedButton(
                                  onPressed: () {
                                    model.getFullLoadTruckList(
                                      selectedFromCity.text,
                                      selectedToCity.text,
                                      currentPage: 0,
                                    );
                                    selectedPageNumber = 1;
                                  },
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: ColorResources.THEME_COLOR,
                                    elevation: 3,
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5)),
                                    ),
                                  ),
                                  child: Container(
                                    height: 28,
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.symmetric(
                                        vertical: 0, horizontal: 0),
                                    child: CustomText("Search",
                                        style: Style.boardButton),
                                  ),
                                ),
                                if ((selectedFromCity.text.isNotEmpty &&
                                        selectedFromCity.text != "From") ||
                                    (selectedToCity.text.isNotEmpty &&
                                        selectedToCity.text != "To"))
                                  SizedBox(width: 2),
                                if ((selectedFromCity.text.isNotEmpty &&
                                        selectedFromCity.text != "From") ||
                                    (selectedToCity.text.isNotEmpty &&
                                        selectedToCity.text != "To"))
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        selectedFromCity.text = "From";
                                        selectedToCity.text = "To";
                                        selectedPageNumber = 1;
                                      });

                                      model.getFullLoadTruckList(
                                        "From",
                                        "To",
                                        currentPage: 0,
                                      );
                                    },
                                    icon: Icon(
                                      Icons.close,
                                      color: ThemeColor.red,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                            height: 40,
                            margin: EdgeInsets.fromLTRB(5, 10, 5, 0),
                            alignment: Alignment.center,
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
                            width: double.infinity,
                            child: TextField(
                              controller: _controller,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(8),
                                hintText: "Search here",
                                prefixIcon: const Icon(Icons.search),
                                suffixIcon: _controller.text.isNotEmpty
                                    ? IconButton(
                                        icon: Icon(Icons.clear),
                                        onPressed: () {
                                          _controller.clear();
                                          model.getFullLoadTruckList(
                                              "From", "To");
                                        },
                                      )
                                    : null,
                                border: const OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              style: Style.searchHint,
                              onChanged: (value) {
                                final search = value.trim();

                                _debouncer.run(() {
                                  if (!mounted) return;
                                  // Clear search → load default list
                                  if (search.isEmpty) {
                                    model.getFullLoadTruckList("From", "To");
                                    return;
                                  }

                                  // Avoid unnecessary calls
                                  if (search.length < 3) return;

                                  model.getSearchByNameList(0, search);
                                });
                              },
                            )),
                        Container(
                          height: 40,
                          color: ColorResources.HOME_BG,
                          padding: EdgeInsets.only(left: 5, top: 10),
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
                                  (selectedTab == "Sell Buy Post"), 6),
                              getCircularContainer("General Post",
                                  (selectedTab == "General Post"), 5),
                              getCircularContainer(
                                  "Jobs", (selectedTab == "Jobs"), 7),
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
              : model.truckLoadTypeList.isEmpty && model.isLoading
                  ? Container(
                      child: Container(
                          height: MediaQuery.of(context).size.height - 300,
                          child: Center(child: CircularProgressIndicator())))
                  : Expanded(
                      child: Container(
                        color: ThemeColor.baground,
                        padding: ResponsiveWidget.isDesktop(context)
                            ? EdgeInsets.symmetric(horizontal: 35)
                            : EdgeInsets.symmetric(horizontal: 10),
                        child: StaggeredGridView.countBuilder(
                            controller: _scrollController,
                            physics: ScrollPhysics(),
                            staggeredTileBuilder: (int index) =>
                                StaggeredTile.fit(1),
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
                              print(
                                  "Date: ${model.truckLoadTypeList[index].postingTime.toString()}");
                              TruckLoad load = model.truckLoadTypeList[index];
                              List<String> stringList = (load.images ?? [])
                                  .map((e) => e?.toString() ?? "")
                                  .toList();

                              return model.truckLoadTypeList[index].type ==
                                      "Advertisement"
                                  ? DashbordCards().getAdvCard(
                                      context,
                                      load.companyName ?? "",
                                      load.mobileNumber.toString(),
                                      load.website ?? "",
                                      stringList,
                                      load.type ?? "")
                                  : model.truckLoadTypeList[index].type ==
                                          "Buy/Sell"
                                      ? AllCards().cardSellBuyPost(
                                          index, context, model.truckLoadTypeList[index], this,
                                          userId: authProvider
                                              .userDetailList[0].id!,
                                          isDashBoard: true)
                                      : model.truckLoadTypeList[index].type ==
                                              "Jobs"
                                          ? AllCards().cardJobPost(
                                              index,
                                              context,
                                              model.truckLoadTypeList[index],
                                              this,
                                              userId: authProvider
                                                  .userDetailList[0].id!)
                                          : model.truckLoadTypeList[index].type ==
                                                  "General Post"
                                              ? DashbordCards().generalPost(
                                                  model.truckLoadTypeList[index], context)
                                              : DashbordCards().cardLoadHome(index, context, model.truckLoadTypeList[index], authProvider.userDetailList[0].id!, this, model, model.truckLoadTypeList[index].userId == authProvider.userDetailList[0].id! ? true : false);
                            }),
                      ),
                    ),
        ])),
      ),
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

  var selectedTab = 'All Loads';
  late List<int> selectedValuesList = <int>[];

  getCircularContainer(String title, bool isSelected, int i) {
    return Consumer<DashboardProvider>(
      builder: (context, model, child) => InkWell(
        onTap: () {
          setState(() {
            selectedTab = title;
          });

          model.falseAllFilter(); // reset all to false

          if (title == 'Full Load Required')
            model.flr = true;
          else if (title == 'Part Load Required')
            model.plr = true;
          else if (title == 'Full Vehicle Required')
            model.fla = true;
          else if (title == 'Part Vehicle Required')
            model.pla = true;
          else if (title == 'General Post')
            model.gp = true;
          else if (title == 'Sell Buy Post')
            model.buy_sell = true;
          else if (title == 'Jobs') model.jobs = true;
          // All Requirement → keep all false

          model.notifyListeners();
          if (selectedFromCity.text.isEmpty) selectedFromCity.text = "From";
          if (selectedToCity.text.isEmpty) selectedToCity.text = "To";
          model.getFullLoadTruckList(
              selectedFromCity.text, selectedToCity.text);
        },
        child: Card(
          margin: EdgeInsets.symmetric(horizontal: 2.7),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Container(
            height: ResponsiveWidget.isDesktop(context) ? 30 : 25,
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(vertical: 3, horizontal: 20),
            child: CustomText(
              title,
              style: isSelected
                  ? Style.filterSelectedHeading
                  : Style.filterHeading,
              textAlign: TextAlign.center,
            ),
            decoration: BoxDecoration(
              color:
                  isSelected ? ColorResources.PRIMARY_COLOR : Color(0xffffffff),
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
    String type;
    type =
        'Type : ${truckLoadTypeList.type} Subject : ${truckLoadTypeList.content} Source : ${truckLoadTypeList.source} Destination : ${truckLoadTypeList.deviceId}';
    return type;
  }

  getDateObject(String? dateTime) {
    try {
      DateTime formatedDate = DateTime.parse(dateTime!);
      // print(formatedDate);
      var date1 = DateFormat("yyyy-MM-dd").format(formatedDate);
      var todayDate = DateFormat("yyyy-MM-dd").format(DateTime.now());
      if (date1 == todayDate) {
        date1 = DateFormat("H:mm").format(formatedDate);
      }
      return date1;
    } catch (e) {
      return dateTime;
    }
  }

  @override
  void deleteOwnPost(
    int postId,
    int index,
  ) {
    _showMyDialog(index, postId, dashboardProvider);
  }

  Future<void> _showMyDialog(
      int index, int id, DashboardProvider provider) async {
    return showDialog(
        context: context,
        builder: (_) => new CupertinoAlertDialog(
              title: CustomText(
                'Are you sure want to delete your post?',
                style: Style.title,
              ),
              actions: <Widget>[
                TextButton(
                  child: CustomText(getTranslated('yes', context)!,
                      style: Style.okButton),
                  onPressed: () {
                    provider.deleteFullLoad(id, index).then((value) => {
                          showAnimatedDialog(
                              context,
                              MyDialog(
                                icon: Icons.check,
                                title: 'Post Completed',
                                description: 'Your post completed successfully',
                                isFailed: false,
                              ),
                              dismissible: false,
                              isFlip: false)
                        });
                    Navigator.of(context).pop();
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

  Widget imageDialog(text, path, context, load) {
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
          imageLoadAdd(load, context),
        ],
      ),
    );
  }

  imageLoadAdd(TruckLoad load, BuildContext context) {
    Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: CachedNetworkImage(
            imageUrl: load.images!.first,
            placeholder: (context, url) =>
                SvgPicture.asset("assets/svg/logo.svg"),
            errorWidget: (context, url, error) => ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  "https://igps.net/wp-content/uploads/2018/08/shutterstock_711168088.jpg",
                  fit: BoxFit.fill,
                  width: MediaQuery.of(context).size.width - 100,
                  height: MediaQuery.of(context).size.height - 100,
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
                      res == true
                          ? showAnimatedDialog(
                              context,
                              MyDialog(
                                icon: Icons.check,
                                title: 'City Interchange Post',
                                description: 'Your post submitted successfully',
                                isFailed: false,
                              ),
                              dismissible: false,
                              isFlip: false)
                          : Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (builder) => MenuPage(
                                        userDetailList:
                                            authProvider.userDetailList,
                                        selectedTab: "Package Change",
                                      )));
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
                      } else {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (builder) => MenuPage(
                                      userDetailList:
                                          authProvider.userDetailList,
                                      selectedTab: "Package Change",
                                    )));
                      }
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
