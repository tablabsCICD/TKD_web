import 'dart:convert';
import 'package:razorpay_web/razorpay_web.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tkd_app/locator.dart';
import 'package:tkd_app/model/api_response.dart';
import 'package:tkd_app/model/auth_api.dart';
import 'package:tkd_app/model/phone_pay_model.dart';
import 'package:tkd_app/network/api_call.dart';
import 'package:tkd_app/provider/auth_provider.dart';
import 'package:tkd_app/util/app_constants.dart';
import 'package:tkd_app/view/base_widget/app_constant.dart';
import 'package:tkd_app/view/screens/menu_page.dart';


import 'package:tkd_app/widgets/toast.dart';



class RazorPayClass {
   BuildContext context;
  static String orderID="id";
  static int planId=0;

  RazorPayClass(this.context);





    createOrderId(int amount) async {
      ApiResponse apiResponse=await ApiHelper().ApiPostData(ApiConstant.CREATE_ORDER_ID(amount));
      if(apiResponse.statusCode==200){
       RazorPayOrderId payOrderId=RazorPayOrderId.fromJson(json.decode(apiResponse.response));
       orderID=payOrderId.data!;
      }


    }

  initalPay(int amount,int contact,String email,String packageName,int plan)async{
      planId=plan;
      await createOrderId(amount);
     if(orderID=="id"){
       ToastMessage.show(context, "Please try again");
       return;
     }
    Razorpay razorpay = Razorpay();
    // var options = {
    //   'key': 'rzp_test_7zwe2M6kcEJB5d',
    //   'amount': amount,
    //   'name': 'Acme Corp.',
    //   'description': 'Fine T-Shirt',
    //   'retry': {'enabled': true, 'max_count': 1},
    //   'send_sms_hash': true,
    //   'prefill': {
    //     'contact': '$contact',
    //     'email': '$email'
    //   },
    //   'external': {
    //     'wallets': ['paytm']
    //   }
    // };
    var options1 = {
      'key': 'rzp_live_LraIKZvldr9N1J',
      'amount': amount, //in the smallest currency sub-unit.
      'name': 'Package.',
      'order_id': '$orderID', // Generate order_id using Orders API
      'description': 'TKD',
      'timeout': 60, // in seconds
      'prefill': {
        'contact': '$contact',
        'email': '$email'
      }
    };
    razorpay.on(
        Razorpay.EVENT_PAYMENT_ERROR, handlePaymentErrorResponse);
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS,
        handlePaymentSuccessResponse);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET,
        handleExternalWalletSelected);
    razorpay.open(options1);

  }


  void handlePaymentErrorResponse(PaymentFailureResponse response) {
    /*
    * PaymentFailureResponse contains three values:
    * 1. Error Code
    * 2. Error Description
    * 3. Metadata
    * */
    showAlertDialog(context, "Payment Failed",
        "Please Try Again");
  }

  void handlePaymentSuccessResponse(PaymentSuccessResponse response) {
    /*
    * Payment Success Response contains three values:
    * 1. Order ID
    * 2. Payment ID
    * 3. Signature
    * */
    print(response.toString());
    String razorpay_signature=response.signature.toString();
    String  razorpay_order_id=response.orderId.toString();
    String? paymentId=response.paymentId;
  callSignature(razorpay_signature,razorpay_order_id,paymentId,planId);



  }

  void handleExternalWalletSelected(ExternalWalletResponse response) {
    showAlertDialog(
        context, "External Wallet Selected", "${response.walletName}");
  }

  void showAlertDialog(BuildContext context, String title, String message) {
    // set up the buttons
    Widget continueButton = ElevatedButton(
      child: const Text("Continue"),
      onPressed: () {},
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

   final authProvider = locator<AuthProvider>();

  void callSignature(String razorpay_signature,String  razorpay_order_id,String? paymentId,int plan)async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
      User user=await authProvider.getLoginData();

      Map<String,dynamic>parameter={
          "plan": plan,
          "razorPayOrderId": razorpay_order_id,
          "signature": razorpay_signature,
          "transactionId": paymentId,
          "userId": user.id

      };
      ApiResponse response=await ApiHelper().ApiAddPostDataMapRequest(ApiConstant.PAYMENT_SIGNATURE, parameter);
      print('the response is ${response.response}');
      if(response.statusCode==200){
        showAlertDialog(
            context, "Payment Successful", "Redirect To Home");
        SharedPreferences _prefs = await SharedPreferences.getInstance();
        _prefs.setString(AppConstant.LOGIN_KEY, jsonEncode(response.response));
        Navigator.pop(context);
        List<User> userList = [];
        userList.add(user);
       // Navigator.pushNamedAndRemoveUntil(context,AppRoutes.home, (route) => true);
          Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (builder)=>MenuPage(userDetailList: userList)) , (route) => false);
          }
        else{
        showAlertDialog(
            context, "Payment Faild", "Payment ID: ");
          }
     }
}

