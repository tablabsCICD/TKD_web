import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../network/api_call.dart';
import '../../util/app_constants.dart';
import '../../util/colors.dart';
import '../../widgets/button.dart';
import '../../widgets/toast.dart';

class FinanceAndInsurance extends StatefulWidget {
  final String enquiry;
  final int id;

  FinanceAndInsurance(this.enquiry, this.id);

  @override
  State<FinanceAndInsurance> createState() => _FinanceAndInsuranceState();
}

class _FinanceAndInsuranceState extends State<FinanceAndInsurance> {
  bool loading = false;

  // ------------------- API CALLS ---------------------
  Future<void> callInsuranceApi() async {
    setState(() => loading = true);
    String url = ApiConstant.INSURANCE_API;

    Map<String, dynamic> data = {
      "date": "",
      "id": 0,
      "requirement":
      "I AM INTERESTED IN GETTING A GOOD DEAL FOR Insurance Inquiry.",
      "userId": widget.id
    };

    var response = await ApiHelper().ApiAddPostDataMapRequest(url, data);
    setState(() => loading = false);

    if (response.statusCode == 200) {
      ToastMessage.show(context, "Insurance Enquiry submitted successfully!");
    } else {
      ToastMessage.show(context, "Please try again");
    }
  }

  Future<void> callFinanceApi() async {
    setState(() => loading = true);
    String url = ApiConstant.FINANCE_API;

    Map<String, dynamic> data = {
      "date": "",
      "id": 0,
      "requirement":
      "I AM INTERESTED IN GETTING A GOOD DEAL FOR Finance Inquiry.",
      "userId": widget.id
    };

    var response = await ApiHelper().ApiAddPostDataMapRequest(url, data);
    setState(() => loading = false);

    if (response.statusCode == 200) {
      ToastMessage.show(context, "Finance Enquiry submitted successfully!");
    } else {
      ToastMessage.show(context, "Please try again");
    }
  }

  // ------------------- UI ------------------------
  @override
  Widget build(BuildContext context) {
    String titleText =
        "I AM INTERESTED IN GETTING A GOOD DEAL FOR ${widget.enquiry.toUpperCase()}";

    return Scaffold(
      backgroundColor: ThemeColor.baground,


      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(   // ensures perfect center even on small screens
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    widget.enquiry,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      height: 1.4,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                    ),
                  ),
                  SizedBox(height: 20,),
                  /// Main Title — CENTERED PERFECTLY
                  Text(
                    titleText,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      height: 1.4,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                    ),
                  ),

                  const SizedBox(height: 55),

                  /// Submit Button
                  Button(
                    width: MediaQuery.of(context).size.width * 0.60,
                    height: 48,
                    title: loading ? "Please wait..." : "Submit",
                    isEnbale: !loading,
                    onClick: () {
                      if (widget.enquiry.toLowerCase() == "insurance enquiry") {
                        callInsuranceApi();
                      } else {
                        callFinanceApi();
                      }
                    },
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
