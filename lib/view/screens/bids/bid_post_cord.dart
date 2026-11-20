// ======================================================================
// PART 2 — BID POST CARD (MAIN CARD UI)
// ======================================================================

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tkd_app/view/screens/tracking/common_tracking_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../dialog/received_bids_dialog.dart';
import '../../../model/my_bids.dart';
import '../../../model/truck_load_model.dart';
import '../../../network/geo_helper.dart';
import '../../../provider/auth_provider.dart';
import '../../../provider/bid_provider.dart';
import '../../../util/ResponsiveWidget.dart';
import '../../../widgets/base_widgets.dart';
import '../../../widgets/button.dart';
import '../../../widgets/toast.dart';
import '../../base_widget/custom_button.dart';
import '../../base_widget/custom_textfeild.dart';
import '../../base_widget/utils.dart';
import '../tracking/vehicle_tracking.dart';

class BidPostCard extends StatefulWidget {
  final PostBidData postData;
  final int index;
  final AuthProvider authProvider;
  final BidProvider bidProvider;

  const BidPostCard({
    Key? key,
    required this.postData,
    required this.index,
    required this.authProvider,
    required this.bidProvider,
  }) : super(key: key);

  @override
  State<BidPostCard> createState() => _BidPostCardState();
}

class _BidPostCardState extends State<BidPostCard> {
  @override
  Widget build(BuildContext context) {
    final data = widget.postData;
    final generic = data.genericCardsDto!;

    return Opacity(
      
      opacity: generic.isCompleted == 1?0.5:1,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              spreadRadius: 1,
              offset: Offset(0, 3),
            )
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildExpiryTag(generic),
            _buildMainTag(generic),
            const SizedBox(height: 10),
      
            BaseWidget().headingWithoutDate(
              generic.topicName!,
              generic.content!,
            ),
      
            const SizedBox(height: 8),
      
            BaseWidget().routes(
              generic.source!,
              generic.destination!,
            ),
      
            const SizedBox(height: 8),
      
            if (data.bidings!.isNotEmpty) _buildChartToggle(data),
      
            /// Chart OR Bid List
            generic.showCharts == true ? _buildChart(data) : _buildBidList(data),
      
            const SizedBox(height: 8),
      
            _buildBottomButtons(data),
          ],
        ),
      ),
    );
  }

  // ================================================================
  // VALID TILL TAG
  // ================================================================
  Widget _buildExpiryTag(GenericCardsDto generic) {
    if (generic.expireDate == '') return const SizedBox();

    return Container(
      width: 140,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.red, width: 0.7),
      ),
      child: Text(
        "Valid till: ${generic.expireDate}",
        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }

  // ================================================================
  // MAIN TAG (BLUE)
  // ================================================================
  Widget _buildMainTag(GenericCardsDto generic) {
    return Align(
      alignment: Alignment.topRight,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          generic.mainTag ?? '',
          style: const TextStyle(fontSize: 9, color: Colors.white),
        ),
      ),
    );
  }

  // ================================================================
  // CHART / LIST TOGGLE
  // ================================================================
  Widget _buildChartToggle(PostBidData data) {
    final generic = data.genericCardsDto!;
    final provider = widget.bidProvider;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.bar_chart,
            color: generic.showCharts ? Colors.red : Colors.grey),
        Switch(
          value: generic.showCharts,
          activeColor: Colors.blue,
          onChanged: (v) async {
            if (v) {
              await provider.getGraphDataForBids(
                context,
                generic.id!,
                widget.index,
              );
            }
            setState(() => generic.showCharts = v);
          },
        ),
        Icon(Icons.list, color: !generic.showCharts ? Colors.red : Colors.grey),
      ],
    );
  }

  // ================================================================
  // CHART VIEW
  // ================================================================
  Widget _buildChart(PostBidData data) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: BidGraphWidget(postData: data),
    );
  }

  // ================================================================
  // BID LIST
  // ================================================================
  Widget _buildBidList(PostBidData data) {
    final list = data.bidings!;
    if (list.isEmpty) return const SizedBox();

    return ListView.builder(
      itemCount: list.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return BidItemRow(
          bid: list[index],
          isLast: index == list.length - 1,
          postData: data,
          authProvider: widget.authProvider,
          bidProvider: widget.bidProvider,
        );
      },
    );
  }

  // ================================================================
  // BOTTOM BUTTONS
  // ================================================================
  Widget _buildBottomButtons(PostBidData postBidData) {
    return BaseWidget().showBidButton((val) async {
      if (val == 0) {
        if (postBidData.bidings!.isNotEmpty) {
          if (widget.authProvider.userDetailList[0].isPaid == 0) {
            ToastMessage.show(context, "Upgrade required to view bids");
          } else {
            showDialog(
              context: context,
              builder: (context) => ReceivedBidsDialogBox(postBidData.bidings!),
            );
          }
        } else {
          ToastMessage.show(context, "No bids available");
        }
      }

      if (val == 3) {
        _sharePost(postBidData);
      }
    }, true, postBidData);
  }

  // ================================================================
  // SHARE LOGIC
  // ================================================================
  void _sharePost(PostBidData postBidData) async {
    final g = postBidData.genericCardsDto!;
    String desc =
        "${g.mobileNumber}'Type : ${g.type}, \nSubject : ${g.content}, \nSource : ${g.source}, "
        "\nDestination : ${g.destination}, \nLink : https://api.tkdost.com/bids/?id=${g.id}'";

    TruckLoad truckLoad = TruckLoad(
      id: g.id,
      userId: g.userId,
      type: g.type,
      postingTime: g.postingTime,
      content: g.content,
      topicName: g.topicName,
      tableName: g.tableName,
      source: g.source,
      destination: g.destination,
      mainTag: g.mainTag,
      mobileNumber: g.mobileNumber,
      companyName: g.companyName,
      partLoadOrNot: g.partLoadOrNot,
      isPaid: int.parse(g.isPaid.toString()),
      website: g.website,
      sharableLink: g.sharableLink,
      deviceId: g.deviceId,
      privatePost: g.privatePost,
      ratings: g.ratings,
      vehicleSize: g.vehicleSize,
      association: g.association,
      nameOfPerson: g.nameOfPerson,
      dnd: g.dnd,
      companyDetailsName: g.companyDetailsName,
    );

    await Utils().callShareFunction(desc, truckLoad, context);
  }
}

// ======================================================================
// PART 3 — BID GRAPH WIDGET
// ======================================================================

class BidGraphWidget extends StatelessWidget {
  final PostBidData postData;

  const BidGraphWidget({
    Key? key,
    required this.postData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<BidProvider>(
      builder: (context, provider, child) {
        final graphData = provider.data;

        if (graphData.isEmpty) {
          return const Center(
            child: Text("No graph data available"),
          );
        }

        final maxValue =
            graphData.values.reduce((a, b) => a > b ? a : b).toDouble();

        return Column(
          children: [
            const SizedBox(height: 8),
            const Text(
              "Recent Quote Analysis",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const RotatedBox(
                  quarterTurns: -1,
                  child: Text(
                    "Quote Count",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      width: graphData.length * 60.0,
                      height: 260,
                      child: BarChart(
                        BarChartData(
                          maxY: maxValue + 1,
                          barGroups: _createBarGroups(graphData),
                          gridData: FlGridData(show: true),
                          borderData: FlBorderData(
                            show: true,
                            border: Border.all(color: Colors.black12),
                          ),
                          titlesData: FlTitlesData(
                            rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 32,
                                getTitlesWidget: (value, meta) {
                                  final idx = value.toInt();
                                  if (idx < 0 || idx >= graphData.length) {
                                    return const SizedBox();
                                  }
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Text(
                                      graphData.keys.elementAt(idx),
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                interval: 1,
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  if (value % 1 == 0) {
                                    return Text(
                                      value.toInt().toString(),
                                      style: const TextStyle(fontSize: 10),
                                    );
                                  }
                                  return const SizedBox.shrink();
                                },
                              ),
                            ),
                          ),
                          barTouchData: BarTouchData(
                            enabled: true,
                            touchTooltipData: BarTouchTooltipData(
                              getTooltipItem:
                                  (group, groupIndex, rod, rodIndex) {
                                return BarTooltipItem(
                                  "Count: ${rod.toY.toInt()}",
                                  const TextStyle(color: Colors.white),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Text(
              "Quote Amount",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        );
      },
    );
  }

  // ------------------------------------------------------------------
  // MAP DATA → BAR GROUPS
  // ------------------------------------------------------------------
  List<BarChartGroupData> _createBarGroups(Map<String, dynamic> graphData) {
    return List.generate(graphData.length, (index) {
      double value = 0;

      try {
        value = double.parse(
          graphData.values.elementAt(index).toString(),
        );
      } catch (_) {
        value = 0;
      }

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: value,
            width: 28,
            borderRadius: BorderRadius.circular(4),
            color: Colors.blue,
          ),
        ],
      );
    });
  }
}

// ======================================================================
// PART 4 — BID ITEM ROW
// ======================================================================

class BidItemRow extends StatelessWidget {
  final Bidings bid;
  final bool isLast;
  final PostBidData postData;
  final AuthProvider authProvider;
  final BidProvider bidProvider;

  const BidItemRow({
    Key? key,
    required this.bid,
    required this.isLast,
    required this.postData,
    required this.authProvider,
    required this.bidProvider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final generic = postData.genericCardsDto!;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isLast ? Colors.transparent : Colors.black12,
            width: 1,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BaseWidget().getImage(
            bid.profileImage ?? "",
            height: 32,
            width: 32,
          ),
          const SizedBox(width: 10),
          Expanded(child: _buildBidDetails(context)),
          _buildCallButton(context),
        ],
      ),
    );
  }

  // --------------------------------------------------------------
  Widget _buildBidDetails(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// NAME + VERIFIED
        Row(
          children: [
            Text(
              "${bid.firstName} ${bid.lastName}",
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 4),
            if (bid.isPaid != 0)
              const Icon(Icons.verified, size: 14, color: Colors.blue),
          ],
        ),

        const SizedBox(height: 4),

        /// COMPANY
        Text(
          bid.companyName ?? "",
          style: const TextStyle(fontSize: 11, color: Colors.black54),
        ),

        const SizedBox(height: 6),

        /// BID AMOUNT
        Text(
          "₹ ${bid.bidings?.amount ?? 0}",
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),

        if ((bid.bidings?.description ?? "").isNotEmpty) ...[
          const SizedBox(height: 6),
          Text(
            "Justification: ${bid.bidings!.description}",
            style: const TextStyle(
              fontSize: 11,
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],

        const SizedBox(height: 8),

        _buildAcceptSection(context),
      ],
    );
  }

  // --------------------------------------------------------------
  /// ACCEPT / ACCEPTED SECTION
  Widget _buildAcceptSection(BuildContext context) {
    final generic = postData.genericCardsDto!;

    if (bid.isAccepted == 1) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Quote Accepted",
            style: TextStyle(color: Colors.green),
          ),
          const SizedBox(height: 4),
          if ((bid.vehicleNumber ?? '').isNotEmpty)
            Text(
              "Vehicle Number: ${bid.vehicleNumber}",
              style: const TextStyle(fontSize: 12),
            ),
          if ((bid.driverContact ?? '').isNotEmpty)
            Text(
              "Driver Number: ${bid.driverContact}",
              style: const TextStyle(fontSize: 12),
            ),
          const SizedBox(height: 6),
          generic.isCompleted == 1
              ? const SizedBox.shrink()
              : ((bid.vehicleNumber ?? '').isEmpty ||
                  (bid.driverContact ?? '').isEmpty)
              ? const SizedBox.shrink()
              : _buildTrackingChip(context, postData)
        ],
      );
    }

    /// BIDDING OPEN
    if (generic.isOpenForBid == 1) {
      return Button(
        width: 110,
        height: 36,
        title: "Accept Quote",
        textStyle: const TextStyle(fontSize: 12, color: Colors.white),
        onClick: () {
          if (["Full load required", "Part load required"]
              .contains(generic.mainTag)) {
            _showAcceptDialog(context);
          } else {
            bidProvider.acceptBidSaveForm(
              context,
              postData,
              bid,
              '',
              '',
            );
          }
        },
      );
    }

    return const SizedBox();
  }

  // --------------------------------------------------------------
  Widget _buildTrackingChip(BuildContext context, PostBidData postBidData) {
    return ActionChip(
      backgroundColor: Colors.green,
      avatar: const Icon(
        Icons.location_on_outlined,
        color: Colors.white,
        size: 18,
      ),
      label: const Text(
        "Track Driver",
        style: TextStyle(color: Colors.white, fontSize: 12),
      ),
      onPressed: () async {
        bool verifying =
            postBidData.genericCardsDto!.ispostOwnerVerifiedForTrack != 0;

        if (verifying) {
          /*final startCoords = await GeoHelper.getLatLngFromCity(
            postBidData.genericCardsDto?.source ?? "",
          );
          final endCoords = await GeoHelper.getLatLngFromCity(
            postBidData.genericCardsDto?.destination ?? "",
          );

          if (startCoords != null && endCoords != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => VehicleTrackingScreen(
                  startLocation: LatLng(
                    startCoords['lat']!,
                    startCoords['lng']!,
                  ),
                  endLocation: LatLng(
                    endCoords['lat']!,
                    endCoords['lng']!,
                  ),
                  vehicleId: bid.vehicleNumber ?? '',
                  driverNumber: bid.driverContact ?? '',
                  postId: postBidData.genericCardsDto?.id,
                ),
              ),
            );
          }*/

            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (dialogCtx) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  title: const Text(
                    "Download TKD Connect App",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  content: const Text(
                    "This feature is not available on the web version.\n\n"
                        "Please download the TKD Connect mobile application from the Play Store or App Store to access the live tracking feature.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),

                  actionsAlignment: MainAxisAlignment.center,

                  actions: [
                    // Play Store Button
                    CustomButton(

                        onTap: () {
                          launchUrl(
                            Uri.parse("https://play.google.com/store/apps/details?id=com.pdk.tkd"),
                            mode: LaunchMode.externalApplication,
                          );
                        },
                        buttonText: "Play Store"
                    ),

                    // App Store Button
                    CustomButton(
                      onTap: () {
                        launchUrl(
                          Uri.parse("https://apps.apple.com/in/app/tkd-connect/id123456789"),
                          mode: LaunchMode.externalApplication,
                        );
                      },
                      buttonText:"App Store",
                    ),

                    // Close Button
                    TextButton(
                      onPressed: () => Navigator.of(dialogCtx).pop(),
                      child: const Text("Close"),
                    ),
                  ],
                );
              },
            );


        } else {
          _showOtpDialog(context, postBidData);
        }
      },
    );
  }

  // --------------------------------------------------------------
  Widget _buildCallButton(BuildContext context) {
    return InkWell(
      onTap: () {
        Utils().callFunction(
          context,
          bid.bidings!.mobileNumber.toString(),
        );
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.blue.withOpacity(.1),
        ),
        child: const Icon(Icons.call, color: Colors.blue),
      ),
    );
  }

  // --------------------------------------------------------------
  void _showOtpDialog(BuildContext context, PostBidData postBidData) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) {
        return AlertDialog(
          title: const Text("Send OTP To Verify Driver"),
          content: const Text("Send OTP for driver verification."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                final success = await bidProvider.isUserDeleted(
                  bid.driverContact ?? "",
                  context,
                  postBidData.genericCardsDto!.id!,
                  true,
                );

                if (success) {
                  Navigator.of(context).pop();
                } else {
                  ToastMessage.show(
                    context,
                    "Failed to send OTP",
                  );
                }
              },
              child: const Text("Send OTP"),
            ),
          ],
        );
      },
    );
  }

  // --------------------------------------------------------------
  void _showAcceptDialog(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final vehicleCtrl = TextEditingController();
    final driverCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) {
        final size = MediaQuery.of(context).size;
        final bool isMobile = size.width < 600;
        final bool isTablet = size.width >= 600 && size.width < 1024;

        double dialogWidth = isMobile
            ? size.width * 0.90
            : isTablet
                ? size.width * 0.55
                : size.width * 0.35;

        return Dialog(
          insetPadding: EdgeInsets.symmetric(
            horizontal: isMobile ? 20 : size.width * 0.25,
            vertical: isMobile ? 20 : 60,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            width: dialogWidth,
            padding: const EdgeInsets.all(16),
            height: 330,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Accept Quote",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          CustomTextField(
                            controller: vehicleCtrl,
                            hintText: "Enter vehicle number",
                            isValidator: true,
                            validatorMsg: "Vehicle number required",
                            textInputType: TextInputType.text,
                          ),
                          const SizedBox(height: 8),
                          CustomTextField(
                            controller: driverCtrl,
                            hintText: "Enter driver number",
                            isValidator: true,
                            validatorMsg: "Driver number required",
                            textInputType: TextInputType.phone,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                    const SizedBox(width: 12),
                    CustomButton(
                      buttonText: "Submit",
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          bidProvider.acceptBidSaveForm(
                            context,
                            postData,
                            bid,
                            driverCtrl.text,
                            vehicleCtrl.text,
                          );
                        }
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

// ======================================================================
// PART 5 — FINAL HELPERS & GLUE CODE
// ======================================================================

/// Vertical space helper
Widget vSpace(double h) => SizedBox(height: h);

/// Horizontal space helper
Widget hSpace(double w) => SizedBox(width: w);

/// Simple field label widget
class FieldLabel extends StatelessWidget {
  final String text;

  const FieldLabel(this.text, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          color: Colors.black87,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

/// Safe URL launcher
Future<bool> safeLaunch(Uri url) async {
  try {
    return await launchUrl(url);
  } catch (e) {
    debugPrint("URL launch failed: $e");
    return false;
  }
}

/// Scroll config wrapper (prevents glow & overflow)
class SafeScroll extends StatelessWidget {
  final Widget child;

  const SafeScroll({required this.child, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: ScrollBehavior().copyWith(overscroll: false),
      child: child,
    );
  }
}

/// Image error placeholder
Widget errorImagePlaceholder({double size = 40}) {
  return Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      color: Colors.grey.shade300,
      shape: BoxShape.circle,
    ),
    child: const Icon(Icons.error, color: Colors.white),
  );
}

/// Divider line widget
class SeparatorLine extends StatelessWidget {
  final double indent;
  final double endIndent;

  const SeparatorLine({
    this.indent = 0,
    this.endIndent = 0,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 18,
      thickness: 1,
      indent: indent,
      endIndent: endIndent,
      color: Colors.black12,
    );
  }
}

/// Responsive padding wrapper
class RPadding extends StatelessWidget {
  final Widget child;

  const RPadding({required this.child, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: ResponsiveWidget.isDesktop(context)
          ? const EdgeInsets.symmetric(horizontal: 30, vertical: 16)
          : const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      child: child,
    );
  }
}

/// Small badge widget
class Badge extends StatelessWidget {
  final String label;
  final Color color;

  const Badge(this.label, {this.color = Colors.blue, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 10,
          color: Colors.white,
        ),
      ),
    );
  }
}

/// Initial loader widget
class InitialLoader extends StatelessWidget {
  const InitialLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(strokeWidth: 3),
    );
  }
}

/// Null-safe list helper
List<T> safeList<T>(List<T>? list) => list ?? [];

/// Section title widget
class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle(this.title, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: Colors.black87,
      ),
    );
  }
}
