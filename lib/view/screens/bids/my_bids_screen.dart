import 'dart:convert';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
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
import '../../../model/bid_placed.dart';
import '../../../util/app_constants.dart';
import '../../base_widget/app_constant.dart';
import '../../base_widget/custom_button.dart';
import '../../base_widget/custom_textfeild.dart';

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

  cardLoad(int index, BuildContext context, Bids bids, BidProvider provider) {
    return Container(
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
              width: 120,
              height: 18,
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: ShapeDecoration(
                color: Color(0xFF2C8FEA),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)),
              ),
              child: Center(
                child: Text(
                  Utils().mainTag(bids.mainTag!),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontFamily: GoogleFonts
                        .poppins()
                        .fontFamily,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          Container(
            transform: Matrix4.translationValues(0.0, -20.0, 0.0),
            child: Column(
              children: [
                Text(
                  "Quote price",
                  style: TextStyle(
                    color: Color(0x99001E49),
                    fontSize: 10,
                    fontFamily: GoogleFonts
                        .poppins()
                        .fontFamily,
                    fontWeight: FontWeight.w400,
                    height: 0,
                  ),
                ),
                Text(
                  '₹ ${bids.amount}',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: GoogleFonts
                        .poppins()
                        .fontFamily,
                    fontWeight: FontWeight.w600,
                    height: 0,
                  ),
                ),
              ],
            ),
          ),
          BaseWidget().routes(bids.source!, bids.destination!),
          SizedBox(
            height: 12,
          ),
          BaseWidget().heading1(
              bids.topicName!, bids.postingTime!.split(" ").first,
              bids.content!),
          bids.isAccepted == 0 ? SizedBox.shrink() : Text(
            Utils().mainTag(bids.mainTag!) == "Full vehicle required" ||
                Utils().mainTag(bids.mainTag!) == "Part vehicle required"
                ? 'Your Quote is accepted kindly share driver contact number and vehicle number.'
                : "",
            style: TextStyle(color: Colors.orange, fontSize: 12,
              fontFamily: GoogleFonts
                  .poppins()
                  .fontFamily,
              fontWeight: FontWeight.bold,),
          ),
          bids.isAccepted == 0 ? BaseWidget().onlyBidButton(() {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Withdraw quote', style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: GoogleFonts
                        .poppins()
                        .fontFamily,
                    fontWeight: FontWeight.w600,
                  ),),
                  content: Text('Are you sure you want to withdraw this quote?',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontFamily: GoogleFonts
                          .poppins()
                          .fontFamily,
                      fontWeight: FontWeight.w400,
                    ),),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                      },
                      child: Text('Cancel', style: TextStyle(
                        color: ColorResources.THEME_COLOR, fontSize: 12,
                        fontFamily: GoogleFonts
                            .poppins()
                            .fontFamily,
                        fontWeight: FontWeight.w600,),),
                    ),
                    TextButton(
                      onPressed: () {
                        provider
                            .deleteBid(provider
                            .allBidingList[
                        index])
                            .then(
                                (value) =>
                            {
                              showAnimatedDialog(
                                  context,
                                  MyDialog(
                                    icon: Icons.check,
                                    title: 'Quote Withdraw',
                                    description: 'Your quote deleted successfully',
                                    isFailed: false,
                                  ),
                                  dismissible: false,
                                  isFlip: false)
                            });
                        Navigator.of(
                            context)
                            .pop();
                      },
                      child: Text(
                        'Withdraw',
                        style: TextStyle(color: Colors.red, fontSize: 12,
                          fontFamily: GoogleFonts
                              .poppins()
                              .fontFamily,
                          fontWeight: FontWeight.w600,),
                      ),
                    ),
                  ],
                );
              },
            );
          }) : InkWell(
            onTap: () {
              Utils().mainTag(bids.mainTag!) == "Full vehicle required" ||
                  Utils().mainTag(bids.mainTag!) == "Part vehicle required"
                  ? showAcceptQuoteDialog(context, bids,) : null;
            },
            child: Container(
              height: 38,
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 0.50, color: const Color(0x33001E49)),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    Utils().mainTag(bids.mainTag!) == "Full vehicle required" ||
                        Utils().mainTag(bids.mainTag!) ==
                            "Part vehicle required"
                        ? "Click to share details" : "Your Quote is accepted",
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 12,
                      fontFamily: GoogleFonts
                          .poppins()
                          .fontFamily,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
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
                  child: Expanded( // Use Expanded to handle overflow
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
}