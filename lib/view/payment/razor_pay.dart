import 'dart:convert';
import 'dart:js' as js;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tkd_app/locator.dart';
import 'package:tkd_app/model/api_response.dart';
import 'package:tkd_app/network/api_call.dart';
import 'package:tkd_app/provider/auth_provider.dart';
import 'package:tkd_app/util/app_constants.dart';
import 'package:tkd_app/view/screens/menu_page.dart';
import 'package:tkd_app/widgets/toast.dart';

import '../../model/auth_api.dart';
import '../base_widget/app_constant.dart';

class RazorPayClass {
  BuildContext context;
  static String orderID = "id";
  static int planId = 0;

  final AuthProvider authProvider = locator<AuthProvider>();

  RazorPayClass(this.context);

  // ------------------------
  // SHOW LOADER
  // ------------------------
  void showLoader([String message = "Processing Payment..."]) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        backgroundColor: Colors.black54,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: Colors.white),
              SizedBox(width: 16),
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void hideLoader() {
    Navigator.pop(context, null);
  }

  // ------------------------
  // ERROR BANNER
  // ------------------------
  void showErrorBanner(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.redAccent,
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ------------------------
  // RETRY ALERT
  // ------------------------
  void showRetryDialog(String title, String message, VoidCallback retryCallback) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            child: Text("Retry"),
            onPressed: () {
              Navigator.pop(ctx);
              retryCallback();
            },
          ),
          TextButton(
            child: Text("Cancel"),
            onPressed: () => Navigator.pop(ctx),
          ),
        ],
      ),
    );
  }

  // ------------------------
  // CREATE ORDER ID
  // ------------------------
  Future<void> createOrderId(int amount) async {
    try {
      showLoader("Creating order...");

      User user = await authProvider.getLoginData();

      String url = ApiConstant.CREATE_ORDER_ID(amount);
      print(url);

      var apiResponse = await ApiHelper().ApiAddPostDataMapRequest(url, {
        "userId": user.id,
      });

      print(apiResponse.body);

      if (apiResponse.statusCode == 200) {
        // DECODE JSON FIRST
        final Map<String, dynamic> jsonData = jsonDecode(apiResponse.body);

        // NOW YOU CAN ACCESS "data"
        orderID = jsonData["data"];  // order_RhVzdg6dDW9HWw

        print("ORDER ID → $orderID");
      } else {
        showErrorBanner("Failed to create order ID");
      }
    } catch (e) {
      showErrorBanner("Order creation failed!");
      print(e);
    } finally {
      hideLoader();
    }
  }


  // ------------------------
  // INITIAL PAY (WEB)
  // ------------------------
  Future<void> initalPay(
      int amount,
      int contact,
      String email,
      String packageName,
      int plan,
      ) async {
    planId = plan;

    await createOrderId(amount);

    if (orderID == "id") {
      showRetryDialog(
        "Order Failed",
        "Unable to create order. Retry?",
            () => initalPay(amount, contact, email, packageName, plan),
      );
      return;
    }

    if (!kIsWeb) {
      showErrorBanner("Web Razorpay works only on browser!");
      return;
    }

    final options = {
      "key": "rzp_live_LraIKZvldr9N1J",
      "name": "TKD Connect",
      "description": packageName,
      "order_id": orderID,
      "amount": amount * 100,
      "currency": "INR",
      "prefill": {
        "contact": contact.toString(),
        "email": email,
      },
      "theme": {"color": "#FF0000"},
    };

    showLoader("Opening Razorpay...");

    js.context["handleWebPaymentSuccess"] = (resp) {
      hideLoader();
      handlePaymentSuccessResponse(
        resp["razorpay_signature"],
        resp["razorpay_order_id"],
        resp["razorpay_payment_id"],
      );
    };

    js.context["handleWebPaymentError"] = (resp) {
      hideLoader();
      showRetryDialog(
        "Payment Failed",
        resp["error"]["description"] ?? "Something went wrong",
            () => initalPay(amount, contact, email, packageName, plan),
      );
    };

    hideLoader(); // Close loader before opening Razorpay

    js.context.callMethod("openRazorpayCheckout", [js.JsObject.jsify(options)]);
  }

  // ------------------------
  // PAYMENT ERROR
  // ------------------------
  void handlePaymentErrorResponse(String message) {
    showErrorBanner(message);
  }

  // ------------------------
  // PAYMENT SUCCESS
  // ------------------------
  void handlePaymentSuccessResponse(
      String signature,
      String orderId,
      String paymentId,
      ) {
    showLoader("Verifying payment...");
    callSignature(signature, orderId, paymentId, planId);
  }

  // ------------------------
  // VERIFY SIGNATURE
  // ------------------------
  Future<void> callSignature(
      String razorpaySignature,
      String razorpayOrderId,
      String paymentId,
      int plan,
      ) async {
    User user = await authProvider.getLoginData();

    Map<String, dynamic> parameter = {
      "plan": plan,
      "razorPayOrderId": razorpayOrderId,
      "signature": razorpaySignature,
      "transactionId": paymentId,
      "userId": user.id,
    };

    ApiResponse response = await ApiHelper()
        .ApiAddPostDataMapRequest(ApiConstant.PAYMENT_SIGNATURE, parameter);

    hideLoader();

    if (response.statusCode == 200) {
      showErrorBanner("Payment Successful!");

      // ------------------------
      // AUTO REFRESH USER PLAN
      // ------------------------
      await authProvider.getUserDetails(authProvider.userDetailList[0].id!);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(AppConstant.LOGIN_KEY, jsonEncode(response.response));

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => MenuPage(
            userDetailList: [user],
            selectedTab: "Home",
          ),
        ),
            (_) => false,
      );
    } else {
      showRetryDialog(
        "Verification Failed",
        "Unable to verify payment. Retry?",
            () => callSignature(razorpaySignature, razorpayOrderId, paymentId, plan),
      );
    }
  }
}
