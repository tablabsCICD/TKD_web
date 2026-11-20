// ======================================================================
// PART 1 — IMPORTS + RECEIVED BIDS SCREEN + STAGGERED GRID
// ======================================================================

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:tkd_app/locator.dart';
import 'package:tkd_app/model/my_bids.dart';
import 'package:tkd_app/model/truck_load_model.dart';
import 'package:tkd_app/provider/bid_provider.dart';
import 'package:tkd_app/provider/auth_provider.dart';
import 'package:tkd_app/provider/localization_provider.dart';
import 'package:tkd_app/util/color-resource.dart';
import 'package:tkd_app/util/ResponsiveWidget.dart';
import 'package:tkd_app/util/style.dart';
import 'package:tkd_app/widgets/base_widgets.dart';
import 'package:tkd_app/widgets/button.dart';
import 'package:tkd_app/widgets/toast.dart';
import 'package:tkd_app/view/localization/language_constrants.dart';
import 'package:tkd_app/view/base_widget/app_constant.dart';
import 'package:tkd_app/view/base_widget/custom_textfeild.dart';
import 'package:tkd_app/view/base_widget/custom_button.dart';
import 'package:tkd_app/view/base_widget/utils.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../dialog/received_bids_dialog.dart';
import '../../../network/geo_helper.dart';
import '../tracking/vehicle_tracking.dart';
import 'bid_post_cord.dart';


/// ======================================================================
/// RECEIVED BIDS SCREEN → ENTRY POINT
/// ======================================================================
class ReceivedBidsScreen extends StatefulWidget {
  final authProvider = locator<AuthProvider>();
  final bidProvider = locator<BidProvider>();
  final langProvider = locator<LocalizationProvider>();

  ReceivedBidsScreen({Key? key}) : super(key: key) {
    bidProvider.getReceivedBidingList(currentPage: 0);
  }

  @override
  State<ReceivedBidsScreen> createState() => _ReceivedBidsScreenState();
}

class _ReceivedBidsScreenState extends State<ReceivedBidsScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: ColorResources.HOME_BG,
        child: ResponsiveWidget(
          desktop: WebScreenForBid(),
          tablet: WebScreenForBid(),
          mobile: WebScreenForBid(),
        ),
      ),
    );
  }
}

/// ======================================================================
/// MAIN RESPONSIVE SCREEN
/// ======================================================================
class WebScreenForBid extends StatefulWidget {
  @override
  State<WebScreenForBid> createState() => _WebScreenForBidState();
}

class _WebScreenForBidState extends State<WebScreenForBid> {
  final bidProvider = locator<BidProvider>();
  final authProvider = locator<AuthProvider>();
  final langProvider = locator<LocalizationProvider>();

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {

      if (!bidProvider.isPaginationLoading &&
          !bidProvider.isLastPage) {
        bidProvider.getReceivedBidingList(
          currentPage: bidProvider.currentPage + 1,
        );
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BidProvider>(
      builder: (context, model, child) {
        return Container(
          margin: ResponsiveWidget.isDesktop(context)
              ? const EdgeInsets.symmetric(horizontal: 35, vertical: 10)
              : const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: model.isLoading && model.ownBidPostList.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : Column(
            children: [
              if (model.ownBidPostList.isEmpty)
                Expanded(
                  child: Center(
                    child: Text(
                      getTranslated('no_post', context)!,
                      style: Style.heading,
                    ),
                  ),
                )
              else
                Expanded(child: _buildBidGrid(model)),

              /// 👇 Bottom Pagination Loader
              if (model.isPaginationLoading)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: CircularProgressIndicator(),
                ),
            ],
          ),
        );
      },
    );
  }

  /// ==================================================================
  /// STAGGERED GRID (MASONRY) WITH PAGINATION
  /// ==================================================================
  Widget _buildBidGrid(BidProvider model) {
    final int crossAxis = ResponsiveWidget.isDesktop(context)
        ? 3
        : ResponsiveWidget.isMobile(context)
        ? 1
        : 2;

    return MasonryGridView.builder(
      controller: _scrollController, // 👈 Attach controller
      padding: const EdgeInsets.only(top: 10),
      gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxis,
      ),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      itemCount: model.ownBidPostList.length,
      itemBuilder: (context, index) {
        return BidPostCard(
          postData: model.ownBidPostList[index],
          index: index,
          authProvider: authProvider,
          bidProvider: bidProvider,
        );
      },
    );
  }
}





