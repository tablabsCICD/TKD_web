import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tkd_app/locator.dart';
import 'package:tkd_app/model/api_response.dart';
import 'package:tkd_app/model/auth_api.dart';
import 'package:tkd_app/model/my_bids.dart';
import 'package:tkd_app/model/quoteResponse.dart';
import 'package:tkd_app/network/api_call.dart';
import 'package:tkd_app/provider/auth_provider.dart';
import 'package:tkd_app/provider/bid_provider.dart';
import 'package:tkd_app/util/app_constants.dart';
import 'package:tkd_app/util/colors.dart';
import 'package:tkd_app/util/images.dart';
import 'package:tkd_app/view/base_widget/app_constant.dart';
import 'package:tkd_app/view/base_widget/utils.dart';
import 'package:tkd_app/view/screens/bids/received_bids.dart';
import 'package:tkd_app/view/screens/dashboard/dashboard.dart';
import 'package:tkd_app/view/screens/menu_page.dart';
import 'package:tkd_app/view/screens/plan/select_plan_screen.dart';
import 'package:tkd_app/widgets/base_widgets.dart';
import 'package:tkd_app/widgets/button.dart';
import 'package:tkd_app/widgets/toast.dart';
import 'package:tkd_app/widgets/verified_tag.dart';

class ShowAllBids extends StatefulWidget {
  final String id;

  const ShowAllBids({required this.id});
  @override
  State<StatefulWidget> createState() {
    return _ShowAllBids();
  }
}

class _ShowAllBids extends State<ShowAllBids> {
  bool isLoad = false;
  PostBidData? postBidData;
  final authProvider = locator<AuthProvider>();

  @override
  void initState() {
    callApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BidProvider>(builder: (context, provider, child) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 1,
          leading: InkWell(
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (builder) => MenuPage(
                            userDetailList: authProvider.userDetailList,
                            selectedTab: "Home",
                          )));
            },
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: SvgPicture.asset(
                Images.arrow_back,
                height: 18,
                width: 18,
              ),
            ),
          ),
          centerTitle: true,
          title: Text(
            "Bids",
            style: TextStyle(
              color: Colors.black,
              fontSize: 16.sp,
              fontFamily: GoogleFonts.poppins().fontFamily,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: Container(
          color: ThemeColor.baground,
          child: !isLoad
              ? _shimmerLoader()
              : (postBidData == null
                  ? const Center(child: Text("No bids found"))
                  : iteamMyPost(postBidData!, provider)),
        ),
      );
    });
  }

  // ============================================================
  // 🔄 SHIMMER LOADER
  // ============================================================
  Widget _shimmerLoader() {
    return ListView.builder(
      padding: EdgeInsets.all(12.r),
      itemCount: 3,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            margin: EdgeInsets.only(bottom: 12.h),
            height: 160.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // 📦 MAIN CARD
  // ============================================================
  Widget iteamMyPost(PostBidData postBidData, BidProvider provider) {
    return Opacity(
      opacity: postBidData.genericCardsDto!.isCompleted == 1 ? 1 : 1,
      child: Container(
        margin: EdgeInsets.all(12.r),
        padding: EdgeInsets.all(14.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: const Color(0x114A5568),
              blurRadius: 8.r,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 TOP TAGS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (postBidData.genericCardsDto!.expireDate?.isNotEmpty ??
                    false)
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: ThemeColor.red, width: 0.5),
                    ),
                    child: Text(
                      "Valid till: ${postBidData.genericCardsDto!.expireDate}",
                      style: TextStyle(fontSize: 10.sp),
                    ),
                  ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2C8FEA),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    Utils().mainTag(postBidData.genericCardsDto!.mainTag!),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),

            SizedBox(height: 8.h),

            // 🔹 HEADING
            BaseWidget().headingWithoutDate(
                postBidData.genericCardsDto!.topicName!,
                postBidData.genericCardsDto!.content!),

            SizedBox(height: 8.h),

            // 🔹 ROUTE
            BaseWidget().routes(postBidData.genericCardsDto!.source!,
                postBidData.genericCardsDto!.destination!),

            SizedBox(height: 12.h),

            // 🔹 SWITCH
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("(Your quote)", style: TextStyle(fontSize: 10.sp)),
                SizedBox(width: 6.w),
                Icon(Icons.list,
                    color: !postBidData.genericCardsDto!.showCharts
                        ? ThemeColor.red
                        : Colors.grey),
                Switch(
                  value: postBidData.genericCardsDto!.showCharts,
                  onChanged: (value) async {
                    if (value) {
                      await provider.getGraphDataForBids(
                          context, postBidData.genericCardsDto!.id!, 0);
                    }
                    setState(() {
                      postBidData.genericCardsDto!.showCharts = value;
                    });
                  },
                  activeColor: ThemeColor.theme_blue,
                ),
                Icon(Icons.bar_chart,
                    color: postBidData.genericCardsDto!.showCharts
                        ? ThemeColor.red
                        : Colors.grey),
                SizedBox(width: 6.w),
                Text("(Avg Market Rate)", style: TextStyle(fontSize: 10.sp)),
              ],
            ),

            postBidData.genericCardsDto!.showCharts
                ? drawGraph(postBidData)
                : iteams(postBidData, provider),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // 📋 BIDS LIST
  // ============================================================
  Widget iteams(PostBidData postBidData, BidProvider provider) {
    if (postBidData.bidings!.isEmpty) {
      return const SizedBox();
    }

    return Column(
      children:
          postBidData.bidings!.take(3).toList().asMap().entries.map((entry) {
        final index = entry.key;
        final bid = entry.value;
        final isLast = index == postBidData.bidings!.take(3).length - 1;
        return itemBid(bid, isLast, postBidData, provider);
      }).toList(),
    );
  }

  // ============================================================
  // 👤 SINGLE BID ITEM (RESPONSIVE)
  // ============================================================
  Widget itemBid(Bidings bidings, bool isLast, PostBidData postBidData,
      BidProvider provider) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 8.h),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: isLast ? Colors.transparent : const Color(0x332C363F),
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BaseWidget().getImage(
            bidings.profileImage ?? "",
            height: 32.h,
            width: 32.w,
          ),
          SizedBox(width: 10.w),

          // 🔹 INFO
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "${bidings.firstName!} ${bidings.lastName!}",
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    if (bidings.isVerified != 0) VerifiedTag().onVeriedTag(),
                  ],
                ),
                Text(
                  bidings.companyName ?? '',
                  style: TextStyle(
                    color: const Color(0x99001E49),
                    fontSize: 10.sp,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                Text(
                  '₹ ${bidings.bidings?.amount ?? '-'}',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  'Quote: ${bidings.bidings?.description ?? '-'}',
                  style: TextStyle(fontSize: 11.sp),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                // 🔹 ACTIONS
                if (bidings.isAccepted == 1) ...[
                  SizedBox(height: 6.h),
                  Text("Quote Accepted",
                      style: TextStyle(color: Colors.green, fontSize: 11.sp)),
                  Text("Vehicle: ${bidings.vehicleNumber ?? ''}",
                      style: TextStyle(fontSize: 11.sp)),
                  Text("Driver: ${bidings.driverContact ?? ''}",
                      style: TextStyle(fontSize: 11.sp)),
                ] else if (postBidData.genericCardsDto?.isOpenForBid == 1)
                  Padding(
                    padding: EdgeInsets.only(top: 6.h),
                    child: Button(
                      width: 110,
                      height: 36,
                      title: 'Accept Quote',
                      onClick: () {
                        provider.acceptBidSaveForm(
                            context, postBidData, bidings, '', '');
                      },
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 12.sp,
                      ),
                    ),
                  )
              ],
            ),
          ),

          // 🔹 CALL BUTTON
          InkWell(
            onTap: () async {
              User use = authProvider.userDetailList[0];

              Utils().callFunction(context, "${bidings.bidings?.mobileNumber}");
            },
            child: Container(
              width: 38.w,
              height: 38.h,
              decoration: BoxDecoration(
                color: ThemeColor.theme_blue.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.call, color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // 📊 GRAPH (MOBILE OPTIMIZED)
  // ============================================================
  Widget drawGraph(PostBidData postBidData) {
    return Consumer<BidProvider>(builder: (context, provider, child) {
      final graphList = postBidData.genericCardsDto?.graphList ?? [];
      final parsedData = prepareChartData(graphList);
      final xAxisLabels = parsedData.keys.toList();
      final chartData = _createBarGroups(parsedData, xAxisLabels);

      return SizedBox(
        height: 260.h,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: xAxisLabels.length * 60.w,
            child: BarChart(
              BarChartData(
                barGroups: chartData,
                groupsSpace: 16,
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 32,
                      getTitlesWidget: (value, meta) => Text(
                        value.toInt().toString(),
                        style: TextStyle(fontSize: 9.sp),
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() < xAxisLabels.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              xAxisLabels[value.toInt()],
                              style: TextStyle(fontSize: 9.sp),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                  topTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                gridData: FlGridData(show: false),
              ),
            ),
          ),
        ),
      );
    });
  }

  // ============================================================
  // 🔧 HELPERS
  // ============================================================
  Map<String, Map<String, int>> prepareChartData(List<MonthData> response) {
    Map<String, Map<String, int>> chartData = {};
    for (var monthData in response) {
      Map<String, int> labelValues = {};
      for (var item in monthData.list!) {
        labelValues[item.label!] = int.parse(item.value.toString());
      }
      chartData[monthData.month!] = labelValues;
    }
    return chartData;
  }

  List<BarChartGroupData> _createBarGroups(
      Map<String, Map<String, int>> parsedData, List<String> xAxisLabels) {
    return xAxisLabels.asMap().entries.map((entry) {
      final index = entry.key;
      final date = entry.value;
      final nestedValues = parsedData[date] ?? {};
      final barRods = nestedValues.entries.map((e) {
        return BarChartRodData(
          toY: e.value.toDouble(),
          width: 10,
          borderRadius: BorderRadius.circular(4),
          color: Colors.blueAccent,
        );
      }).toList();

      return BarChartGroupData(
        x: index,
        barRods: barRods,
        barsSpace: 4,
      );
    }).toList();
  }

  // ============================================================
  // 🌐 API CALL
  // ============================================================
  void callApi() async {
    try {
      final url =
          "${ApiConstant.BASE_URL}getPostAndBidByPostId?postId=${widget.id}";
      debugPrint(url);
      dynamic raw = await ApiHelper().ApiGetData(url);
      if (raw is String) {
        raw = jsonDecode(raw);
      }
      debugPrint(raw.toString());

      if (raw is Map<String, dynamic>) {
        postBidData = PostBidData.fromJson(raw);
      } else {
        ToastMessage.show(context, "Unable to parse bid response");
      }
    } catch (e) {
      debugPrint("show_bidds callApi error: $e");
      ToastMessage.show(context, "Please try again later");
    } finally {
      if (!mounted) return;
      setState(() {
        isLoad = true;
      });
    }
  }
}
