// MERGED BuySellVehicles (single class) - preserves all business logic
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';
import 'package:tkd_app/dialog/animated_custom_dialog.dart';
import 'package:tkd_app/dialog/my_dialog.dart';
import 'package:tkd_app/locator.dart';
import 'package:tkd_app/model/truck_load_model.dart';
import 'package:tkd_app/provider/auth_provider.dart';
import 'package:tkd_app/provider/buy_sell_provider.dart';
import 'package:tkd_app/provider/delete_interface.dart';
import 'package:tkd_app/provider/localization_provider.dart';
import 'package:tkd_app/util/ResponsiveWidget.dart';
import 'package:tkd_app/util/color-resource.dart';
import 'package:tkd_app/util/colors.dart';
import 'package:tkd_app/util/style.dart';
import 'package:tkd_app/view/base_widget/all_cards.dart';
import 'package:tkd_app/view/base_widget/custom_textview.dart';
import 'package:tkd_app/view/base_widget/getLoader.dart';
import 'package:tkd_app/view/localization/language_constrants.dart';
import 'package:tkd_app/view/screens/buy_sell/buy_sell_details_screen.dart';

class BuySellVehicles extends StatefulWidget {
  final buySellProvider = locator<BuySellProvider>();

  BuySellVehicles({Key? key}) : super(key: key);

  @override
  _BuySellVehiclesState createState() => _BuySellVehiclesState();
}

class _BuySellVehiclesState extends State<BuySellVehicles> implements DeletePostInf {
  // providers
  final buySellProvider = locator<BuySellProvider>();
  final authProvider = locator<AuthProvider>();
  final langProvider = locator<LocalizationProvider>();

  // state
  String selectedTab = 'Sell Vehicle'; // default same as before
  int selectedPageNumber = 1; // pagination (1-based as earlier)
  final ScrollController _scrollController = ScrollController();

  // search controller
  final TextEditingController _searchController = TextEditingController();

  // filter controllers and values
  final TextEditingController companyCtrl = TextEditingController();
  final TextEditingController personCtrl = TextEditingController();
  final TextEditingController locationCtrl = TextEditingController();
  final TextEditingController modelCtrl = TextEditingController();
  final TextEditingController sizeCtrl = TextEditingController();
  final TextEditingController yearCtrl = TextEditingController();

  String? filterCompanyName;
  String? filterNameOfPerson;
  String? filterLocation;
  String? filterModel;
  String? filterVehicleSize;
  String? filterMfgYear;
  RangeValues priceRange = RangeValues(20000, 5000000);

  String? langCode;

  @override
  void initState() {
    super.initState();

    // initial load same as old constructor behavior
    // call both so cached lists populate (keeps original behavior)
    buySellProvider.getSellVehicles();
    buySellProvider.getBuyVehicles();

    langCode = langProvider.selectedlangCode;

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        // ON SCROLL TO END: call provider based on current tab
        if (selectedTab == 'Buy Vehicle') {
          buySellProvider.getBuyVehicles(currentPage: selectedPageNumber);
        } else {
          buySellProvider.getSellVehicles(currentPage: selectedPageNumber);
        }
        selectedPageNumber++;
      }
    });

    // optional: react to search controller onChange (user had logic to call when >2)
    _searchController.addListener(() {
      final v = _searchController.text;
      if (v.length > 2) {
        _callVehicleSearch();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    companyCtrl.dispose();
    personCtrl.dispose();
    locationCtrl.dispose();
    modelCtrl.dispose();
    sizeCtrl.dispose();
    yearCtrl.dispose();
    super.dispose();
  }

  // small helper: price formatting (kept from old)
  String priceText(String price) {
    price = '${formNum(
      price.replaceAll(',', ''),
    )}';
    return price;
  }

  String formNum(String s) {
    return NumberFormat.decimalPattern().format(
      int.parse(s),
    );
  }

  // -----------------------------------------------------------
  // FILTER / BOTTOM SHEET
  // -----------------------------------------------------------
  void _openBuySellFilters(BuildContext context) {
    // set controllers BEFORE UI builds
    companyCtrl.text = filterCompanyName ?? "";
    personCtrl.text = filterNameOfPerson ?? "";
    locationCtrl.text = filterLocation ?? "";
    modelCtrl.text = filterModel ?? "";
    sizeCtrl.text = filterVehicleSize ?? "";
    yearCtrl.text = filterMfgYear ?? "";

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setStateSB) {
            return Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Filter Vehicles",
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                        IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () => Navigator.pop(context)),
                      ],
                    ),
                    Divider(),
                    SizedBox(height: 12),

                    // Fields
                    _textField("Company Name", companyCtrl, (v) => filterCompanyName = v),
                    SizedBox(height: 12),

                    _textField("Person Name", personCtrl, (v) => filterNameOfPerson = v),
                    SizedBox(height: 12),

                    _textField("Location", locationCtrl, (v) => filterLocation = v),
                    SizedBox(height: 12),

                    _textField("Model", modelCtrl, (v) => filterModel = v),
                    SizedBox(height: 12),

                    _textField("Vehicle Size", sizeCtrl, (v) => filterVehicleSize = v),
                    SizedBox(height: 12),

                    _textField("MFG Year", yearCtrl, (v) => filterMfgYear = v),
                    SizedBox(height: 20),

                    Text("Price Range", style: TextStyle(fontWeight: FontWeight.w700)),
                    RangeSlider(
                      values: priceRange,
                      min: 20000,
                      max: 5000000,
                      divisions: 50,
                      labels: RangeLabels(
                        priceRange.start.toStringAsFixed(0),
                        priceRange.end.toStringAsFixed(0),
                      ),
                      onChanged: (v) {
                        setStateSB(() => priceRange = v);
                      },
                    ),

                    SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // CLEAR ALL
                        TextButton(
                          onPressed: () {
                            setStateSB(() {
                              filterCompanyName = null;
                              filterNameOfPerson = null;
                              filterLocation = null;
                              filterModel = null;
                              filterVehicleSize = null;
                              filterMfgYear = null;
                              priceRange = RangeValues(20000, 5000000);

                              // ALSO CLEAR UI
                              companyCtrl.clear();
                              personCtrl.clear();
                              locationCtrl.clear();
                              modelCtrl.clear();
                              sizeCtrl.clear();
                              yearCtrl.clear();
                            });
                          },
                          child: Text("Clear All", style: TextStyle(color: Colors.red)),
                        ),

                        // APPLY
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorResources.THEME_COLOR,
                            padding: EdgeInsets.symmetric(horizontal: 22, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text("Apply", style: TextStyle(color: Colors.white)),
                          onPressed: () {
                            Navigator.pop(context);
                            // Reset pagination and call searched provider based on selectedTab
                            selectedPageNumber = 1;
                            _callVehicleSearch();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _textField(String label, TextEditingController controller, Function(String) onChanged) {
    return TextField(
      controller: controller,
      textAlign: TextAlign.left,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onChanged: onChanged,
    );
  }

  // -----------------------------------------------------------
  // SEARCH / API CALL (plug-in ready) — auto chooses based on tab
  // -----------------------------------------------------------
  void _callVehicleSearch() {
    // Reset first page
    selectedPageNumber = 1;

    if (selectedTab == 'Buy Vehicle') {
      buySellProvider.getBuyVehicles(
        currentPage: 0,
        companyName: filterCompanyName,
        nameOfPerson: filterNameOfPerson,
        location: filterLocation,
        model: filterModel,
        mfgYear: filterMfgYear,
        vehicleSize: filterVehicleSize,
        minPrice: null,
        maxPrice:null,
        searchText: _searchController.text.trim(),
      );
    } else {
      // Sell
      buySellProvider.getSellVehicles(
        currentPage: 0,
        companyName: filterCompanyName,
        nameOfPerson: filterNameOfPerson,
        location: filterLocation,
        model: filterModel,
        mfgYear: filterMfgYear,
        vehicleSize: filterVehicleSize,
        minPrice: null,
        maxPrice: null,
        searchText: _searchController.text.trim(),
      );
    }
  }

  // -----------------------------------------------------------
  // DELETE CONFIRM + HANDLER (preserves original logic)
  // -----------------------------------------------------------
  @override
  void deleteOwnPost(int postId, int index) {
    final bool isBuy = selectedTab == 'Buy Vehicle';
    _showMyDialog(index, postId, buySellProvider, isBuy);
  }

  Future<void> _showMyDialog(int index, int id, BuySellProvider provider, bool isBuy) async {
    return showDialog(
        context: context,
        builder: (_) => new CupertinoAlertDialog(
          title: CustomText(
            'Are you sure want to deleted your post?',
            style: Style.title,
          ),
          actions: <Widget>[
            TextButton(
              child: CustomText(
                getTranslated('yes', context)!,
                style: Style.okButton,
              ),
              onPressed: () {
                provider.deleteBuySell(id, index, isBuy).then((value) => {
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

  @override
  void rePost(TruckLoad truckLoad, bool isCityInterchange) {
    // keep as placeholder (same as before)
  }

  // -----------------------------------------------------------
  // UI Build
  // -----------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.HOME_BG,
      body: Container(
        child: Column(
          children: [
            // tabs header
            Container(
              height: 62,
              color: ThemeColor.baground,
              child: Padding(
                padding: ResponsiveWidget.isDesktop(context)
                    ? EdgeInsets.symmetric(horizontal: 35, vertical: 10)
                    : EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: ResponsiveWidget.isDesktop(context)
                    ? Row(
                  children: [
                    // left: tabs
                    Row(
                      children: [
                        getCircularContainer("Sell Vehicle", (selectedTab == "Sell Vehicle")),
                        getCircularContainer("Buy Vehicle", (selectedTab == "Buy Vehicle")),
                      ],
                    ),

                    Spacer(),

                    // right: search + filter (desktop) using Flexible to avoid unbounded errors
                    SizedBox(
                      width: 520, // keep a reasonable max width on desktop group
                      child: Row(
                        children: [
                          Flexible(
                            child: TextField(
                              controller: _searchController,
                              decoration: InputDecoration(
                                hintText: "Search vehicles...",
                                filled: true,
                                fillColor: Colors.white,
                                prefixIcon: Icon(Icons.search),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              onChanged: (v) {
                                if (v.isNotEmpty && v.length > 2) {
                                  _callVehicleSearch();
                                }
                              },
                            ),
                          ),
                          SizedBox(width: 10),
                          InkWell(
                            onTap: () => _openBuySellFilters(context),
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              decoration: BoxDecoration(
                                color: ColorResources.THEME_COLOR,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.filter_alt_rounded, color: Colors.white),
                                  SizedBox(width: 5),
                                  Text("Filter", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
                    : Column(
                  children: [
                    Row(
                      children: [
                        getCircularContainer("Sell Vehicle", (selectedTab == "Sell Vehicle")),
                        getCircularContainer("Buy Vehicle", (selectedTab == "Buy Vehicle")),
                      ],
                    ),
                    SizedBox(height: 8),
                    Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Row(
                        children: [
                          Flexible(
                            child: TextField(
                              controller: _searchController,
                              decoration: InputDecoration(
                                hintText: "Search vehicles...",
                                filled: true,
                                fillColor: Colors.white,
                                prefixIcon: Icon(Icons.search),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              onChanged: (v) {
                                if (v.isNotEmpty && v.length > 2) {
                                  _callVehicleSearch();
                                }
                              },
                            ),
                          ),
                          SizedBox(width: 10),
                          InkWell(
                            onTap: () => _openBuySellFilters(context),
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              decoration: BoxDecoration(
                                color: ColorResources.THEME_COLOR,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.filter_alt_rounded, color: Colors.white),
                                  SizedBox(width: 5),
                                  Text("Filter", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // main content - search, filter, list
            Expanded(
              child: Container(
                color: ColorResources.HOME_BG,
                child: ResponsiveWidget(
                  desktop: _buildListContent(context),
                  mobile: _buildListContent(context),
                  tablet: _buildListContent(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper to build the list content (unified)
  Widget _buildListContent(BuildContext context) {
    return Consumer<BuySellProvider>(
      builder: (context, model, child) {
        // decide list & loading flag based on selected tab
        final bool isBuy = selectedTab == 'Buy Vehicle';
        final int itemCount = isBuy ? model.buyVehicleList.length : model.sellVehicleList.length;
        final bool isLoading = isBuy ? model.isLoadingForBuyVehicles : model.isLoadingForSellVehicles;

        return Container(
          margin: EdgeInsets.all(10),
          child: Column(
            children: [
              // list / empty states (keeps your original behavior)
              if (itemCount == 0 && !isLoading) ...[
                Expanded(
                  child: Container(
                    height: MediaQuery.of(context).size.height - 200,
                    child: Center(child: Text(getTranslated('no_post', context)!, style: Style.heading)),
                  ),
                ),
              ] else if (itemCount == 0 && isLoading) ...[
                SizedBox(height: MediaQuery.of(context).size.height / 2.5),
              ] else ...[
                Expanded(
                  child: SizedBox(
                    width: double.infinity,
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
                      itemCount: itemCount,
                      itemBuilder: (context, index) {
                        final item = isBuy ? model.buyVehicleList[index] : model.sellVehicleList[index];
                        return InkWell(
                          onTap: () {
                           /* Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (builder) => BuySellDetailsScreen(item)));*/
                          },
                          child: AllCards().cardSellBuyPost(index, context, item, this, userId: authProvider.userDetailList[0].id!),
                        );
                      },
                      shrinkWrap: true,
                      staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
                    ),
                  ),
                ),
              ],

              // loader: show buy loader if buy, else sell loader
              getLoader(isBuy ? model.isLoadingForBuyVehicles : model.isLoadingForSellVehicles),
            ],
          ),
        );
      },
    );
  }

  // tab button helper
  getCircularContainer(String title, bool isSelected) {
    return InkWell(
      onTap: () {
        setState(() {
          selectedTab = title;
          selectedPageNumber = 1;
        });

        // avoid calling provider during build
        Future.microtask(() {
          if (selectedTab == "Buy Vehicle") {
            buySellProvider.getBuyVehicles(currentPage: 0);
          } else {
            buySellProvider.getSellVehicles(currentPage: 0);
          }
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
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
          child: CustomText(title, style: isSelected ? Style.filterSelectedHeading : Style.filterHeading, textAlign: TextAlign.center),
          decoration: BoxDecoration(
            color: isSelected ? ColorResources.RED : Color(0xffffffff),
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
