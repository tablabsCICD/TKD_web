import 'dart:convert';
import 'dart:ui';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';
import 'package:tkd_app/dialog/animated_custom_dialog.dart';
import 'package:tkd_app/dialog/my_dialog.dart';
import 'package:tkd_app/locator.dart';
import 'package:tkd_app/model/biding_user_model.dart';
import 'package:tkd_app/provider/auth_provider.dart';
import 'package:tkd_app/provider/bid_provider.dart';
import 'package:tkd_app/provider/localization_provider.dart';
import 'package:tkd_app/util/style.dart';
import 'package:tkd_app/view/base_widget/custom_textview.dart';
import 'package:tkd_app/view/base_widget/getLoader.dart';
import 'package:tkd_app/view/base_widget/home_base_widgets.dart';
import 'package:tkd_app/view/base_widget/utils.dart';
import 'package:tkd_app/view/localization/language_constrants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tkd_app/util/ResponsiveWidget.dart';
import 'package:tkd_app/util/color-resource.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../model/bid_placed.dart';
import '../../../network/geo_helper.dart';
import '../../../util/app_constants.dart';
import '../../../util/colors.dart';
import '../../../widgets/toast.dart';
import '../../base_widget/app_constant.dart';
import '../../base_widget/custom_button.dart';
import '../../base_widget/custom_textfeild.dart';
import '../tracking/common_tracking_screen.dart';

class MyBidsScreen extends StatefulWidget {
  final bidProvider = locator<BidProvider>();
  final authProvider = locator<AuthProvider>();

  MyBidsScreen({Key? key}) : super(key: key) {
    print('UserName : ${authProvider.userDetailList[0].userName.toString()}');
    bidProvider.getAllBidingList(authProvider.userDetailList[0].userName.toString(),0);
  }

  @override
  _MyBidsScreenState createState() => _MyBidsScreenState();
}

class _MyBidsScreenState extends State<MyBidsScreen> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: ColorResources.HOME_BG,
        child: ResponsiveWidget(
          desktop: WebScreenForBid(),
          mobile: WebScreenForBid(),
          tablet: WebScreenForBid(),
        ),
      ),
    );
  }
}

class WebScreenForBid extends StatefulWidget {
  @override
  _WebScreenForBidState createState() => _WebScreenForBidState();
}

class _WebScreenForBidState extends State<WebScreenForBid> {

  final langProvider = locator<LocalizationProvider>();
  final authProvider = locator<AuthProvider>();
  final bidProvider = locator<BidProvider>();
  String? langCode;

  @override
  void initState() {
    super.initState();
    langCode = langProvider.selectedlangCode;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BidProvider>(
        builder: (context, model, child) =>
            Container(
              margin: ResponsiveWidget.isDesktop(context) ? EdgeInsets
                  .symmetric(
                  horizontal: 35, vertical: 10
              ) : EdgeInsets.symmetric(
                  horizontal: 10, vertical: 10
              ),
              child: model.allBidingList.isEmpty && model.isLoading == false
                  ? Container(
                  alignment: Alignment.center,
                  height: MediaQuery
                      .of(context)
                      .size
                      .height - 200,
                  child: Center(child: Text(
                    getTranslated('no_post', context)!, style: Style.heading,)))
                  : Column(
                children: [
                  model.allBidingList.isEmpty && model.isLoading ? SizedBox(
                    height: MediaQuery
                        .of(context)
                        .size
                        .height / 2.5,) : Expanded(
                    child: StaggeredGridView.countBuilder(
                      crossAxisCount: ResponsiveWidget.isDesktop(context)
                          ? 3
                          : ResponsiveWidget.isMobile(context)
                          ? 1
                          : 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 12,
                      itemCount: model.allBidingList.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                            onTap: () {
                              // Navigator.push(context, MaterialPageRoute(builder: (builder)=> RequirementDetails(widget.loadTypeList[index])));
                            },
                            child: cardLoad(
                                index, context, model.allBidingList[index],
                                model)
                        );
                      },
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      staggeredTileBuilder: (int index) =>
                          StaggeredTile.fit(1),
                    ),
                  ),
                  getLoader(model.isLoading)
                ],
              ),
            )
    );
  }

  cardLoad(
      int index, BuildContext context, Bids bids, BidProvider provider) {
    return Opacity(
      opacity: bids.isCompleted == 1?0.5:1,
      child: Container(
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
                color: const Color(0x114A5568),
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
                  child: Container(
                    width: 120,
                    height: 18,
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: ShapeDecoration(
                      color: const Color(0xFF2C8FEA),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)),
                    ),
                    child: Center(
                      child: Text(
                        Utils().mainTag(bids.mainTag!),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 9.sp,
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  transform: Matrix4.translationValues(0.0, -20.0.h, 0.0),
                  child: Column(
                    children: [
                      Text(
                        "Quote Amount",
                        style: TextStyle(
                          color: const Color(0x99001E49),
                          fontSize: 10.sp,
                          fontFamily: AppConstant.FONTFAMILY,
                          fontWeight: FontWeight.w400,
                          height: 0,
                        ),
                      ),
                      Text(
                        '₹ ${bids.amount}',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.sp,
                          fontFamily: AppConstant.FONTFAMILY,
                          fontWeight: FontWeight.w600,
                          height: 0,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  bids.description ?? "",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 10.sp,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    fontWeight: FontWeight.w400,
                  ),
                  // overflow: TextOverflow.ellipsis,
                ),
                SizedBox(
                  height: 12.h,
                ),
                HomeBaseWidget().routes(bids.source!, bids.destination!),
                SizedBox(
                  height: 12.h,
                ),
                HomeBaseWidget().heading(bids.topicName!,
                    bids.postingTime!.split(" ").first),
                bids.isAccepted == 0
                    ? SizedBox.shrink()
                    : Column(
                  children: [
                    Text(
                      (Utils().mainTag(bids.mainTag!) == "Full vehicle required" ||
                          Utils().mainTag(bids.mainTag!) == "Part vehicle required")
                          ? ((bids.vehicleNumber?.isNotEmpty ?? false) &&
                          (bids.driverContact?.isNotEmpty ?? false))
                          ? ""
                          : "Your Quote is accepted, kindly share driver contact number and vehicle number."
                          : "",
                      style: TextStyle(
                        color: Colors.orange,
                        fontSize: 12.sp,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    Row(
                      children: [
                        Text(
                          "Vehicle Number : ",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12.sp,
                            fontFamily: AppConstant.FONTFAMILY,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          bids.vehicleNumber ?? '',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 12.sp,
                            fontFamily: AppConstant.FONTFAMILY,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "Driver Number : ",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12.sp,
                            fontFamily: AppConstant.FONTFAMILY,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          bids.driverContact ?? "",
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 12.sp,
                            fontFamily: AppConstant.FONTFAMILY,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    bids.isCompleted == 1
                        ? const SizedBox.shrink()
                        : ((bids.driverContact != null &&
                        bids.driverContact!.isNotEmpty) ||
                        (bids.vehicleNumber != null &&
                            bids.vehicleNumber!.isNotEmpty))
                        ?
                    ActionChip(
                        avatar: const Icon(Icons.location_on_outlined,
                            size: 18, color: Colors.white),
                        label: Text(
                          bids.isQuoteOwnerVerifiedForTrack ==
                              0
                              ? "Track Driver"
                              : "Track Ride",
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                        backgroundColor: Colors.green,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),

                      onPressed: () async {
                        bool verifying =
                            bids.isQuoteOwnerVerifiedForTrack != 0;

                        if (verifying) {
                          /*final startCoords = await GeoHelper.getLatLngFromCity(
                            bids.source ?? "",
                          );
                          final endCoords = await GeoHelper.getLatLngFromCity(
                            bids.destination ?? "",
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
                                  vehicleId: bids.vehicleNumber ?? '',
                                  driverNumber: bids.driverContact ?? '',
                                  postId: bids.id,
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
                          _showOtpDialog(context, bids);
                        }
                      },

                    ):SizedBox(),
                    SizedBox(height: 6,),
                    bids.isAccepted == 0
                        ? HomeBaseWidget().onlyBidButton(() {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(
                              'Withdraw quote',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16.sp,
                                fontFamily:
                                GoogleFonts.poppins().fontFamily,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            content: Text(
                              'Are you sure you want to withdraw this quote?',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12.sp,
                                fontFamily:
                                GoogleFonts.poppins().fontFamily,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(); // Close the dialog
                                },
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(
                                    color: ThemeColor.theme_blue,
                                    fontSize: 12.sp,
                                    fontFamily: GoogleFonts.poppins()
                                        .fontFamily,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  provider.deleteBid(
                                      bids);
                                  Navigator.of(context)
                                      .pop(); // Close the dialog
                                },
                                child: Text(
                                  'Withdraw',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 12.sp,
                                    fontFamily: GoogleFonts.poppins()
                                        .fontFamily,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    })
                        : InkWell(
                      onTap: () {
                        Utils().mainTag(bids.mainTag!) ==
                            "Full vehicle required" ||
                            Utils().mainTag(bids.mainTag!) ==
                                "Part vehicle required"
                            ? showAcceptQuoteDialog(
                            context, bids)
                            : null;
                      },
                      child: Container(
                        height: 38.h,
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                            horizontal: 24.w, vertical: 10.h),
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                                width: 0.50.w,
                                color: const Color(0x33001E49)),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment:
                          CrossAxisAlignment.center,
                          children: [
                            Text(
                              Utils().mainTag(bids.mainTag!) == "Full vehicle required" ||
                                  Utils().mainTag(bids.mainTag!) == "Part vehicle required"
                                  ? (bids.vehicleNumber != null && bids.vehicleNumber!.isNotEmpty &&
                                  bids.driverContact != null && bids.driverContact!.isNotEmpty)
                                  ? "Your Quote is accepted"
                                  : "Click to share details"
                                  : "Your Quote is accepted",
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 12.sp,
                                fontFamily:
                                GoogleFonts.poppins().fontFamily,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                )
              ])),
    );
  }

  showDialogs(int id, BidProvider model, int index) {
    showDialog(
        context: context,
        builder: (_) =>
        new CupertinoAlertDialog(
          title: CustomText(
              'Do you want to delete account',
              style: TextStyle(
                color: ColorResources.BOTTOM_HEADING,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              )),
          actions: <Widget>[
            TextButton(

              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                    'Cancel',
                    style: TextStyle(
                        color:
                        ColorResources
                            .GREEN,
                        fontSize:
                        18)),
              ),
              onPressed: () {
                callDeleteBid(model.allBidingList[index].id!, model, index);
              },
            ),
            TextButton(
              child: Padding(
                padding:
                const EdgeInsets
                    .all(10.0),
                child: Text(
                    'Yes',
                    style: TextStyle(
                        color:
                        ColorResources
                            .RED,
                        fontSize:
                        18)),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ));
  }

  void callDeleteBid(int id, BidProvider model, int index) async {
    String myUrl = ApiConstant.BID_TO_POST + '?id=$id';
    var req = await http.delete(Uri.parse(myUrl));
    json.decode(req.body);
    if (req.statusCode == 200) {
      model.allBidingList.removeAt(index);
    }
  }

  Future<void> showAcceptQuoteDialog(BuildContext context, Bids bids) async {
    final _formKey = GlobalKey<FormState>();
    final TextEditingController _driverNumberController = TextEditingController();
    final TextEditingController _vehicleNumberController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return Dialog( // Use Dialog for custom sizing
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
                12), // Optional: Add rounded corners
          ),
          child: Container(
            height: 350,
            // Adjust height here
            padding: EdgeInsets.all(16),
            // Optional: Add padding inside the dialog
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Accept Quote",
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: GoogleFonts
                        .poppins()
                        .fontFamily,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 16),
                Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        labelText("Vehicle Number"),
                        SizedBox(height: 8),
                        CustomTextField(
                          isValidator: true,
                          validatorMsg: "Please enter vehicle number",
                          hintText: "Vehicle Number",
                          controller: _vehicleNumberController, textInputType: TextInputType.text,
                        ),
                        SizedBox(height: 12),
                        labelText("Driver Number"),
                        SizedBox(height: 8),
                        CustomTextField(
                          isValidator: true,
                          validatorMsg: "Please enter driver number",
                          hintText: "Driver Number",
                          controller: _driverNumberController, textInputType: TextInputType.text,
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                      },
                      child: Text('Cancel', style: TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                        fontFamily: AppConstant.FONTFAMILY,
                        fontWeight: FontWeight.w400,),),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          Provider.of<BidProvider>(context, listen: false)
                              .updateAcceptBid(
                              context, bids, _driverNumberController.text,
                              _vehicleNumberController.text);
                        }
                      },
                      child: const Text('Submit'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  labelText(String label) {
    return SizedBox(
      width: 332,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.black,
              fontSize: 12,
              fontFamily: GoogleFonts
                  .poppins()
                  .fontFamily,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  void _showOtpDialog(BuildContext context, Bids postBidData) {
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
                  postBidData.driverContact ?? "",
                  context,
                  postBidData.id!,
                  false,
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
}

