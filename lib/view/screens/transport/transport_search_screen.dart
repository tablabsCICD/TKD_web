// -----------------------------------------------------------
// PART 1 — IMPORTS & STATE
// -----------------------------------------------------------

import 'dart:convert';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
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
import 'package:tkd_app/view/base_widget/home_base_widgets.dart';
import 'package:tkd_app/view/base_widget/search_widget.dart';
import 'package:tkd_app/view/base_widget/utils.dart';
import 'package:tkd_app/view/localization/language_constrants.dart';
import 'package:tkd_app/view/screens/my_routes/get_city_list.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../widgets/dashboard_cards.dart';
import '../../base_widget/appbar.dart';

// -----------------------------------------------------------
// FULL TRANSPORT SEARCH SCREEN
// -----------------------------------------------------------

class TransportSearchScreen extends StatefulWidget {
  @override
  _TransportSearchScreenState createState() => _TransportSearchScreenState();
}

class _TransportSearchScreenState extends State<TransportSearchScreen> {
  // ✔ OLD LOGIC KEPT
  TextEditingController fromCityController = TextEditingController();
  TextEditingController toCityController = TextEditingController();
  TextEditingController _controller = TextEditingController();
  final routeProvider = locator<RouteProvider>();
  final transportProvider = locator<TransportProvider>();
  ScrollController _scrollController = ScrollController();
  int selectedPageNumber = 0;

  String? selectedFromCity = "";
  String? selectedToCity = "";
  String hintSearch = "Search here";

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String? langCode;

  // ✔ NEW: Multi-select filter IDs (0,1,2,3)
  List<int> selectedFilters = [];

  @override
  void initState() {
    super.initState();

    // initial load
    transportProvider.getAllData();

    // pagination
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        selectedPageNumber++;
        transportProvider.getAllData(currentPage: selectedPageNumber);
      }
    });

    // search listener
    _controller.addListener(() {
      final v = _controller.text;
      if (v.length > 2) {
        callApiByMultiSelect();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _controller.dispose();
    fromCityController.dispose();
    toCityController.dispose();
    super.dispose();
  }

  // -----------------------------------------------------------
  // CONVERT SELECTED FILTER IDS TO LABELS (FOR CHIPS)
  // -----------------------------------------------------------
  List<String> getFilterNames() {
    List<String> filters = [];

    if (selectedFilters.contains(0)) filters.add("Name");
    if (selectedFilters.contains(1)) filters.add("Location");
    if (selectedFilters.contains(2)) filters.add("Company");

    if (selectedFilters.contains(3)) {
      if ((selectedFromCity ?? '').isNotEmpty ||
          (selectedToCity ?? '').isNotEmpty) {
        filters.add("${selectedFromCity ?? ''} → ${selectedToCity ?? ''}");
      } else {
        filters.add("Route");
      }
    }

    return filters;
  }

  // -----------------------------------------------------------
  // MULTI-SELECTION API LOGIC
  // -----------------------------------------------------------
  void callApiByMultiSelect() {
    if (selectedFilters.isEmpty) {
      transportProvider.getAllData();
      return;
    }

    transportProvider.transportSearchList.clear();

    for (int filter in selectedFilters) {
      switch (filter) {
        case 0:
          transportProvider.getByNameData(_controller.text.trim());
          break;

        case 1:
          transportProvider.getByNameData(_controller.text.trim());
          break;

        case 2:
          transportProvider.getByNameData(_controller.text.trim());
          break;

        case 3:
          String routeText =
          "${selectedFromCity?.trim() ?? ''} ${selectedToCity?.trim() ?? ''}"
              .trim();
          transportProvider.getByNameData(routeText);
          break;
      }
    }

    setState(() {});
  }

  // -----------------------------------------------------------
  // MAIN UI BUILD
  // -----------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery
        .of(context)
        .size;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: ThemeColor.baground,

      body: Consumer<TransportProvider>(
        builder: (context, model, child) {
          return Container(
            margin: ResponsiveWidget.isDesktop(context)
                ? EdgeInsets.symmetric(horizontal: 35, vertical: 20)
                : EdgeInsets.symmetric(horizontal: 10, vertical: 10),

            child: Column(
              children: [
              SizedBox(
              height: 50,
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
                            controller: fromCityController.text,
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return CustomCityListDialog(
                                    onTap: (String value) {
                                      setState(() {
                                        fromCityController.text = value;
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
                            controller: toCityController.text,
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return CustomCityListDialog(
                                    onTap: (String value) {
                                      setState(() {
                                        toCityController.text = value;
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
                              model.getByRoutesData(
                                fromCityController.text,
                                toCityController.text,
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
                          if ((fromCityController.text.isNotEmpty &&
                              fromCityController.text != "From") ||
                              (toCityController.text.isNotEmpty &&
                                  toCityController.text != "To"))
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  fromCityController.text = "From";
                                  toCityController.text = "To";
                                  selectedPageNumber = 1;
                                });

                                model.getAllData(
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
                              model.getAllData();
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


                               if (search.isEmpty) {
                              model.getAllData();
                              return;
                            }

                            // Avoid unnecessary calls
                            if (search.length < 3) return;

                            model.getByNameData(search);

                        },
                      )
                  )
                ],
              ),),
                SizedBox(height: 16,),
                getLoader(model.isLoading),
                // PART 2 — GRID / LIST + DIRECTORY CARD
                model.transportSearchList.isEmpty && model.isLoading == false
                    ? Expanded(
                  child: Center(
                    child: Text(
                      "No Search Found",
                      style: Style.heading,
                    ),
                  ),
                )
                    : model.transportSearchList.isEmpty && model.isLoading
                    ? SizedBox()
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
                      final item = model.transportSearchList[index];
                      return item.type == "Directory"
                          ? directoryCard(item, model, index)
                          : DashbordCards().getAdvCard(
                          context,
                          item.companyName ?? "",
                          item.mobileNumber.toString() ?? "",
                          item.website ?? "",
                          item.images,
                          item.type ?? "");
                    },
                    shrinkWrap: true,
                    staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // -----------------------------------------------------------
  // DIRECTORY CARD (modern UI) — keeps your logic intact
  // -----------------------------------------------------------
  Widget directoryCard(TransportSearchData item, TransportProvider model,
      int index) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.only(bottom: 14,left: 14,right: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              spreadRadius: 1,
              offset: Offset(0, 3),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// ⭐ VERIFIED + RATING BAR
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (item.isPaid != 0)
                  Container(
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
                  ),

              ],
            ),

            SizedBox(height: 12),

            /// 🧑‍💼 NAME + CALL ICON + LOGO
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// Company Logo
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: getImage(
                      item.companyLogo.toString(), height: 50, width: 50),
                ),

                SizedBox(width: 12),

                /// Name + Company
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${item.firstName} ${item.lastName}".trim(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Style.title.copyWith(fontSize: 16),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "${item.companyName}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Style.subtitle.copyWith(
                            color: Colors.grey.shade700),
                      ),
                      SizedBox(height: 4),
                      RatingBar.builder(
                        itemSize: 10,
                        initialRating: item.ratings??0.0,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemPadding: const EdgeInsets.symmetric(
                            horizontal: 1.0),
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: ThemeColor.red,
                          size: 5,
                        ),
                        onRatingUpdate: (rating) {
                          //print(rating);
                        },
                      )
                    ],
                  ),
                ),

                /// Call Button
                InkWell(
                  onTap: () =>
                      Utils().openwhatsapp(
                          context, item.mobileNumber!, "Message"),
                  child: Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: ThemeColor.theme_blue,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.call, color: Colors.white, size: 20),
                  ),
                ),
              ],
            ),

            SizedBox(height: 14),

            /// 📍 Location Section
            Row(
              children: [
                Icon(Icons.location_on, color: Colors.redAccent, size: 18),
                SizedBox(width: 6),
                Expanded(
                  child: Text(
                    "${item.city}",
                    style: Style.contentHeading.copyWith(
                        fontWeight: FontWeight.w600),
                  ),
                )
              ],
            ),

            SizedBox(height: 6),

            Text(
              "${item.companyAddress}",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Style.content.copyWith(color: Colors.black54),
            ),

            SizedBox(height: 16),

            /// 🔘 ACTION BUTTONS — View Route & Get Details
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                /// View Route
                InkWell(
                  onTap: () async {
                    await model.getById(item.id!);
                    showDialog(
                      context: context,
                      builder: (_) =>
                          CustomDialogBox(model.transportSearchData!),
                    );
                  },
                  child: Row(
                    children: [
                      Icon(Icons.map, color: ThemeColor.theme_blue, size: 18),
                      SizedBox(width: 6),
                      Text("View Route",
                          style: Style.aleaready.copyWith(
                              color: ThemeColor.theme_blue)),
                    ],
                  ),
                ),

                /// Contact Button
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) =>
                          CustomDialogBox(
                              model.transportSearchList[index], flag: true),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: ColorResources.THEME_COLOR,
                    elevation: 3,
                    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text(
                    getTranslated('get_contact_details', context)!,
                    style: Style.button,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // -----------------------------------------------------------
// PART 3 — MODERN FILTER BOTTOM SHEET (CHECKBOX BASED)
// -----------------------------------------------------------

  void openFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        final isDesktop = ResponsiveWidget.isDesktop(context);
        final sheetWidth = isDesktop
            ? 520.0
            : MediaQuery
            .of(context)
            .size
            .width;

        return Center(
          child: Container(
            width: sheetWidth,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  spreadRadius: 2,
                  offset: Offset(0, -2),
                )
              ],
            ),

            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // HEADER
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Filter Search",
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700)),
                      IconButton(
                          icon: Icon(Icons.close, size: 26),
                          onPressed: () => Navigator.pop(context))
                    ],
                  ),

                  SizedBox(height: 10),
                  Divider(),

                  SizedBox(height: 12),
                  Text("Select Filters",
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600)),

                  SizedBox(height: 10),

                  // --------------- CHECKBOXES (MODERN STYLE) ------------------
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      children: [
                        _multiCheckOption(title: "By Name", id: 0),
                        _multiCheckOption(title: "By Location", id: 1),
                        _multiCheckOption(title: "By Company", id: 2),
                        _multiCheckOption(
                          title: "By Routes",
                          id: 3,
                          onTapRoutes: () {
                            // Keep sheet open while picking routes
                          },
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 16),

                  // --------------- ROUTE PICKER SECTION ------------------
                  if (selectedFilters.contains(3)) ...[
                    Divider(),
                    SizedBox(height: 10),

                    Text(
                      "Route City Selection",
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 14),

                    // From City
                    _routeCityField(
                      label: "From City",
                      value: selectedFromCity,
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (_) {
                            return CustomCityListDialog(
                              onTap: (String value) {
                                setState(() => selectedFromCity = value);

                                if ((selectedToCity ?? '').isNotEmpty) {
                                  callApiByMultiSelect();
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                } else {
                                  Navigator.pop(context);
                                  setState(() {});
                                }
                              },
                            );
                          },
                        );
                      },
                    ),

                    SizedBox(height: 12),

                    // To City
                    _routeCityField(
                      label: "To City",
                      value: selectedToCity,
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (_) {
                            return CustomCityListDialog(
                              onTap: (String value) {
                                setState(() => selectedToCity = value);

                                if ((selectedFromCity ?? '').isNotEmpty) {
                                  callApiByMultiSelect();
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                } else {
                                  Navigator.pop(context);
                                  setState(() {});
                                }
                              },
                            );
                          },
                        );
                      },
                    ),

                    SizedBox(height: 20),
                  ],

                  // ---------------- CLEAR ALL BUTTON --------------------
                  TextButton.icon(
                    onPressed: () {
                      setState(() {
                        selectedFilters.clear();
                        selectedFromCity = "";
                        selectedToCity = "";
                        _controller.clear();
                      });

                      transportProvider.getAllData();
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.clear_all, color: Colors.red),
                    label: Text("Clear All Filters",
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 14,
                            fontWeight: FontWeight.w600)),
                  ),

                  SizedBox(height: 16),

                  // ---------------- APPLY FILTER --------------------
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () {
                        callApiByMultiSelect();
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ThemeColor.theme_blue,
                        padding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(
                        "Apply Filter",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),

                  SizedBox(height: 12),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

// -----------------------------------------------------------
// CHECKBOX WIDGET (rounded, clean)
// -----------------------------------------------------------
  Widget _multiCheckOption({
    required String title,
    required int id,
    VoidCallback? onTapRoutes,
  }) {
    return CheckboxListTile(
      value: selectedFilters.contains(id),
      onChanged: (bool? checked) {
        setState(() {
          if (checked == true) {
            selectedFilters.add(id);

            if (id == 3 && onTapRoutes != null) {
              onTapRoutes();
            }
          } else {
            selectedFilters.remove(id);
          }
        });
      },
      title: Text(
        title,
        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
      ),
      controlAffinity: ListTileControlAffinity.leading,
      activeColor: ThemeColor.theme_blue,
      checkboxShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }

// -----------------------------------------------------------
// ROUTE CITY FIELD (Better UI)
// -----------------------------------------------------------
  Widget _routeCityField({
    required String label,
    required String? value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey.shade100,
          border: Border.all(color: Colors.grey.shade400),
        ),
        child: Row(
          children: [
            Icon(Icons.location_city, color: Colors.grey.shade700, size: 20),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                value?.isEmpty ?? true ? label : value!,
                style: TextStyle(
                  fontSize: 15,
                  color: value!.isEmpty
                      ? Colors.grey.shade600
                      : Colors.black,
                ),
              ),
            ),
            Icon(Icons.arrow_drop_down, size: 28, color: Colors.black),
          ],
        ),
      ),
    );
  }
}