import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tkd_app/view/base_widget/custom_button.dart';
import 'package:tkd_app/view/base_widget/custom_textfeild.dart';
import 'package:http/http.dart' as http;
import 'package:tkd_app/view/base_widget/custom_textview.dart';

import '../../model/api_response.dart';
import '../../network/api_call.dart';
import '../../util/app_constants.dart';
import '../../widgets/toast.dart';

class FinanceAndInsurance extends StatefulWidget {
  String enquiry;
  int id;
  FinanceAndInsurance(this.enquiry, this.id);

  @override
  State<FinanceAndInsurance> createState() => _FinanceAndInsuranceState();
}

class _FinanceAndInsuranceState extends State<FinanceAndInsurance> {
  final TextEditingController _reasonController = TextEditingController();
  bool enable = false;

  callInsuranceApi(String enquiry) async {
    String url = ApiConstant.INSURANCE_API;
    Map<String,dynamic> data = {
      "date": "",
      "id": 0,
      "requirement": enquiry,
      "userId": widget.id
    };
    var response=await ApiHelper().ApiAddPostDataMapRequest(url, data);
    print('the resopnse is ${response.statusCode}');
    if(response.statusCode==200){
      ToastMessage.show(context, "Insurance Enquiry submitted successfully!");
    }else{
      ToastMessage.show(context, "Please try again");
    }
  }


  callFinanceApi(String enquiry) async {
    String url = ApiConstant.FINANCE_API;

    Map<String,dynamic> data = {
      "date": "",
      "id": 0,
      "requirement": enquiry,
      "userId": widget.id
    };
    var response=await ApiHelper().ApiAddPostDataMapRequest(url, data);
    print('the resopnse is ${response.statusCode}');
    if(response.statusCode==200){
      ToastMessage.show(context, "Finance Enquiry submitted successfully!");
    }else{
      ToastMessage.show(context, "Please try again");
    }
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomText(widget.enquiry),
            SizedBox(height: 10,),
            Padding(
              padding: EdgeInsets.symmetric(horizontal:200),
              child: CustomTextField(
                controller: _reasonController,
                hintText: widget.enquiry,
                textInputType: TextInputType.text,
                validatorMsg: "Please Enter enquiry details",
              ),
            ),
            CustomButton(onTap: (){
              if (_formKey.currentState!.validate()) {
                if ("Insurance enquiry" == widget.enquiry) {
                  callInsuranceApi(_reasonController.text);
                } else {
                  callFinanceApi(_reasonController.text);
                }
                _reasonController.clear();
                setState(() {

                });
              }
            }, buttonText: "Submit")
          ],
        ),
      ),
    );
  }
}
