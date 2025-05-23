import 'dart:convert';
import 'dart:js' as js; // Import dart:js for web integration
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

  RazorPayClass(this.context);

  Future<void> createOrderId(int amount) async {
    ApiResponse apiResponse =
    await ApiHelper().ApiPostData(ApiConstant.CREATE_ORDER_ID(amount));
    if (apiResponse.statusCode == 200) {
      var responseJson = json.decode(apiResponse.response);
      orderID = responseJson['data'];
    } else {
      ToastMessage.show(context, "Failed to create order ID");
    }
  }

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
      ToastMessage.show(context, "Please try again");
      return;
    }

    // Use JS interop for web platform
    if (kIsWeb) {
      final options = {
        'key': 'rzp_live_LraIKZvldr9N1J', // Replace with your Razorpay key
        'amount': 99, // Amount in paise
        'currency': 'INR',
        'name': 'TKD Connect',
        'description': 'Test Payment',
        'prefill': {
          'contact': '9999999999',
          'email': 'example@test.com',
        },
      };

      js.context.callMethod('Razorpay', [options]);
      js.context['handlePaymentSuccess'] = (response) {
        handlePaymentSuccessResponse(response['razorpay_signature'], response['razorpay_order_id'], response['razorpay_payment_id']);
      };
      js.context['handlePaymentError'] = (response) {
        handlePaymentErrorResponse(response['error']['description']);
      };
    } else {
      ToastMessage.show(context, "Razorpay is only supported on the web");
    }
  }

  void handlePaymentErrorResponse(String errorMessage) {
    showAlertDialog(context, "Payment Failed", errorMessage);
  }

  void handlePaymentSuccessResponse(String signature, String orderId, String paymentId) {
    callSignature(signature, orderId, paymentId, planId);
  }

  void showAlertDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  final AuthProvider authProvider = locator<AuthProvider>();

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

    if (response.statusCode == 200) {
      showAlertDialog(context, "Payment Successful", "Redirecting to Home...");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(AppConstant.LOGIN_KEY, jsonEncode(response.response));
      Navigator.pop(context);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (builder) => MenuPage(
            userDetailList: [user],
            selectedTab: "Board",
          ),
        ),
            (route) => false,
      );
    } else {
      showAlertDialog(context, "Payment Failed", "Transaction ID: $paymentId");
    }
  }
}
