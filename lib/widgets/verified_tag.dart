
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tkd_app/util/colors.dart';
import 'package:tkd_app/view/base_widget/app_constant.dart';

class VerifiedTag {


  onVeriedTag(){
   return Center(
      child: Container(
        padding: EdgeInsets.all(2),
        decoration:  BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(2)
          ),
          border: Border.all(
            width: 0.5,
            color: ThemeColor.red,
            style: BorderStyle.solid,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Verified',
              style: TextStyle(
                color: ThemeColor.theme_blue, // Customize text color
                fontWeight: FontWeight.bold,
                fontSize: 8,
                fontFamily: AppConstant.FONTFAMILY

              ),
            ),
          ],
        ),
      ),
    );
  }

}