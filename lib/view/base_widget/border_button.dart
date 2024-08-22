import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tkd_app/util/style.dart';
import 'package:tkd_app/view/base_widget/custom_textview.dart';

class BorderButton extends StatelessWidget {
  Function onTap;
  final String? buttonText;

  BorderButton({required this.onTap, required this.buttonText});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20,vertical: 15),
      height: 50,
      child: ElevatedButton(
        onPressed: (){
          onTap();
        },
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.black, backgroundColor: Colors.white,
          elevation: 3,
          shape: RoundedRectangleBorder(side: BorderSide(
              color: Colors.black,
              width: 1,
              style: BorderStyle.solid
          ), borderRadius: BorderRadius.circular(7)),
        ),

        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10,horizontal: 0),
          child: CustomText(buttonText!,
              style: Style.buttonborder),
        ),
      ),
    );
  }
}