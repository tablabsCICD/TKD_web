import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tkd_app/util/style.dart';
import 'package:tkd_app/view/base_widget/custom_textview.dart';

class CustomButton extends StatelessWidget {
  final FutureOr<void> Function()? onTap;
  final String? buttonText;

  CustomButton({required this.onTap, required this.buttonText});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20,vertical: 15),
      height: 50,
      alignment: Alignment.center,
      child: ElevatedButton(
        onPressed: (){
            if (onTap != null) {
              final result = onTap!();   // works for sync + async
              if (result is Future) {
                result.catchError((e) {
                  // optional error handling
                });
              }
            }

        },
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white, backgroundColor: Color(0xFF001E49),
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10,horizontal: 0),
          child: CustomText(buttonText!,
              style: Style.button),
        ),
      ),
    );
  }
}

