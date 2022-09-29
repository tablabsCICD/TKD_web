import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tkd_app/view/base_widget/custom_button.dart';
import 'package:tkd_app/view/base_widget/custom_textfeild.dart';

show_dialog(BuildContext context,String title){
  TextEditingController bidAmtController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Container(
            height: 150,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomTextField(controller: bidAmtController, hintText: "Enter Your Bid Amount", textInputType: TextInputType.number),
                CustomTextField(controller: descriptionController, hintText: "Comments/Descriptions", textInputType: TextInputType.number),

              ],
            ),
          ),
          actions: <Widget>[
            CustomButton(
                onTap: () {
                  Navigator.pop(context);
                },
                buttonText: "Close",),
            CustomButton(
              onTap: () {
                 Navigator.pop(context);
              },
              buttonText: "Submit",
            )
          ],
        );
      }
   );
}