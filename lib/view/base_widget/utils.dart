import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tkd_app/dialog/animated_custom_dialog.dart';
import 'package:tkd_app/dialog/my_dialog.dart';
import 'package:tkd_app/dialog/share_dialog_box.dart';
import 'package:tkd_app/locator.dart';
import 'package:tkd_app/model/truck_load_model.dart';
import 'package:tkd_app/provider/auth_provider.dart';
import 'package:tkd_app/provider/bid_provider.dart';
import 'package:tkd_app/provider/dashboard_provider.dart';
import 'package:tkd_app/util/color-resource.dart';
import 'package:tkd_app/view/base_widget/custom_button.dart';
import 'package:tkd_app/view/base_widget/custom_textfeild.dart';
import 'package:tkd_app/view/base_widget/custom_textview.dart';
import 'package:tkd_app/view/screens/menu_page.dart';
import 'package:tkd_app/widgets/rating_dailog.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

import '../../util/colors.dart';
import '../../util/images.dart';
import 'app_constant.dart';

class Utils {
  String getTransport(int? val) {
    switch (val) {
      case 0:
        return AppConstant().BUSINESS_TYPE_AGENT;
      case 1:
        return AppConstant().BUSINESS_TYPE_TRANSPORTER;
      case 2:
        return AppConstant().BUSINESS_TYPE_MANUFACTURER;
      case 6:
        return AppConstant().BUSINESS_TYPE_DRIVER;
      default:
        return AppConstant().BUSINESS_TYPE_TRANSPORTER;;
    }
  }

  String mainTag(String tag) {
    switch (tag) {
      case 'Full load available':
        return 'Full vehicle required';
      case 'Part load available':
        return 'Part vehicle required';
      case 'Full load required':
        return 'Full load required';
      case 'Part load required':
        return 'Part load required';

      case '':
    }

    return "";
  }

  final authProvider = locator<AuthProvider>();
  final dashboardProvider = locator<DashboardProvider>();

  callFunction(BuildContext context, String mobile) async {
   /* if (authProvider.userDetailList[0].isPaid == 0) {
      authProvider.userDetailList[0].transporterOrAgent == 3
          ? getAdminSupportDailog(context)
          : Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (builder) => MenuPage(
                        userDetailList: authProvider.userDetailList,
                        selectedTab: "Package Change",
                      )));
    } else {*/
      showDialog(
          context: context,
          builder: (_) => new CupertinoAlertDialog(
                title: CustomText('Contact Number : $mobile',
                    style: TextStyle(
                        color: ColorResources.BOTTOM_HEADING,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
                actions: <Widget>[
                  TextButton(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text("Ok",
                          style: TextStyle(
                              color: ColorResources.GREEN, fontSize: 18)),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ));
    //}
  }

  callShareFunction(String des, TruckLoad load, context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return ShareDialogBox(load);
        });
  }

  getAdminSupportDailog(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) => new CupertinoAlertDialog(
              title: CustomText(
                  'For Upgrade Plan please connect To the below contact',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
              content: Column(
                children: [
                  SizedBox(height: 16),
                  CustomText('Email Id :',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w700)),
                  SizedBox(height: 10),
                  CustomText('support@tkdconnect.in',
                      style: TextStyle(
                          color: ColorResources.PRIMARY_COLOR,
                          fontSize: 14,
                          fontWeight: FontWeight.bold)),
                  SizedBox(height: 15),
                  CustomText('Mobile Number',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w700)),
                  SizedBox(height: 10),
                  CustomText('(+91) 8123006888 / (+91) 8123004666',
                      style: TextStyle(
                          color: ColorResources.PRIMARY_COLOR,
                          fontSize: 14,
                          fontWeight: FontWeight.bold)),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text("Ok",
                        style: TextStyle(color: Colors.black, fontSize: 18)),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
  }

  Future openwhatsapp(BuildContext context, int number, String text) async {
    final link = WhatsAppUnilink(
      phoneNumber: "+91 ${number}",
      text: text,
    );

    await launchUrl(Uri.parse(link.toString()));

  /*  if (authProvider.userDetailList[0].isPaid != 0) {
      authProvider.userDetailList[0].transporterOrAgent == 3
          ? getAdminSupportDailog(context)
          : Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (builder) => MenuPage(
                        userDetailList: authProvider.userDetailList,
                        selectedTab: "Package Change",
                      )));
    } else {
      authProvider.userDetailList[0].transporterOrAgent == 3
          ? getAdminSupportDailog(context)
          : await launchUrl(Uri.parse(link.toString()));
    }*/
  }

  final _formKey = GlobalKey<FormState>();
  final bidProvider = locator<BidProvider>();

  TextEditingController bidAmtController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

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
              fontFamily: GoogleFonts.poppins().fontFamily,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  openMenu(int a, TruckLoad load, BuildContext context) async {
    if (a == 0) {
      showAnimatedDialog(
        context,
        StatefulBuilder(
          builder: (context, setState) {
            String? successMessage;
            bool isSubmitting = false;

            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Form(
                key: _formKey,
                child: Container(
                  height: 350,
                  width: 300,
                  padding: EdgeInsets.all(16),
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          Text(
                            'Place Your Quote',
                            style:
                            TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 20),

                          /// QUOTE AMOUNT
                          CustomTextField(
                            controller: bidAmtController,
                            hintText: "Enter your quote amount",
                            isDigits: true,
                            textInputType: TextInputType.number,
                          ),

                          SizedBox(height: 12),

                          /// DESCRIPTION
                          CustomTextField(
                            controller: descriptionController,
                            hintText: "Justification (optional)",
                            textInputType: TextInputType.text,
                            isValidator: false,
                          ),

                          SizedBox(height: 20),

                          /// SUBMIT BUTTON
                          CustomButton(
                            buttonText:
                            isSubmitting ? "Submitting..." : "Submit",
                            onTap: isSubmitting ? null : () async {
                              if (_formKey.currentState!.validate()) {
                                setState(() => isSubmitting = true);

                                final success = await bidProvider.generateBid(
                                  context,
                                  mobile: authProvider.userDetailList[0].mobileNumber,
                                  description: descriptionController.text,
                                  idOfPost: load.id,
                                  email: authProvider.userDetailList[0].emailId,
                                  amount: bidAmtController.text,
                                  id: 0,
                                  bidderUserName: authProvider.userDetailList[0].userName,
                                  userName: authProvider.userDetailList[0].userName,
                                  type: load.mainTag,
                                  loggedUserName: authProvider.userDetailList[0].userName,
                                );

                                if (success) {
                                  Navigator.of(context).pop(true);   // ✅ Correct context (fix)
                                }

                                setState(() => isSubmitting = false);
                              }
                            },

                          ),

                          SizedBox(height: 15),

                          /// INLINE SUCCESS / ERROR MESSAGE
                          if (successMessage != null)
                            Text(
                              successMessage!,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: successMessage!.contains("success")
                                    ? Colors.green
                                    : Colors.red,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                        ],
                      ),

                      /// CLOSE BUTTON
                      Positioned(
                        top: 10,
                        right: 10,
                        child: IconButton(
                          icon: Icon(Icons.close, size: 18),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );


    } else {
      String description =
          "${load.mobileNumber.toString()}'Type : ${load.type}, \nSubject : ${load.content}, \nSource : ${load.source}, \nDestination : ${load.destination}, \nLink : https://api.tkdost.com/bids/?id=${load.id}'";

      switch (a) {
        case 1:
          Utils().openwhatsapp(context, load.mobileNumber!, description);
          return;
        case 2:
          await Utils().callFunction(context, "${load.mobileNumber}");
          return;

        case 3:
          Utils().callShareFunction(description, load, context);
          return;

        case 4:
          Utils().callRatingAndReview(context, load);
          return;

        case 11:
         _showCompleteDialog(context, load.id!,);
          return;
      }
    }
  }

  Future<void> _showCompleteDialog(BuildContext context,int id) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title:  Text("Complete Post",style: TextStyle(fontFamily: AppConstant.FONTFAMILY,color: ThemeColor.theme_blue)),
          content:  SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                CustomText("Do you want to complete this post.",style: TextStyle(fontFamily: AppConstant.FONTFAMILY,color: ThemeColor.theme_blue),),

              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child:  CustomText("Complete",style: TextStyle(fontFamily: AppConstant.FONTFAMILY,color: ThemeColor.red)),
              onPressed: () {
                dashboardProvider.completePost(id,context);
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child:  CustomText("No",style: TextStyle(fontFamily: AppConstant.FONTFAMILY,color: ThemeColor.green)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  bool isExpired(String expiryDateString) {
    if(expiryDateString==''){
      return false;
    }else{
      // Parse the string into a DateTime object
      DateTime expiryDate = DateTime.parse(expiryDateString);

      // Compare with the current date
      return DateTime.now().isAfter(expiryDate.add(const Duration(days: 1)));
    }
  }
  callRatingAndReview(context, TruckLoad load) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return FractionallySizedBox(
              heightFactor: 0.58, child: RatingDialog(load));
        });
  }

  getSelectedPackageImage(int val) {
    switch (val) {
      case 0:
        return Images.pearls;

      case 10:
        return Images.pearls_blue;

      case 20:
        return Images.pearls_red;
      case 30:
        return Images.pearls_black;
    }
  }

  getSelectedPackageName(int val) {
    switch (val) {
      case 0:
        return "Clear";

      case 10:
        return "Blue";

      case 20:
        return "Red";
      case 30:
        return "Black";
    }
  }
}
