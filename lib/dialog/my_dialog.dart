import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tkd_app/util/color-resource.dart';
import 'package:tkd_app/util/style.dart';
import 'package:tkd_app/view/base_widget/custom_button.dart';
import 'package:tkd_app/view/base_widget/custom_textview.dart';
import 'package:tkd_app/view/screens/menu_page.dart';

import '../locator.dart';
import '../model/auth_api.dart';
import '../provider/auth_provider.dart';

class MyDialog extends StatelessWidget {
  final bool isFailed;
  final double rotateAngle;
  final IconData icon;
  final String title;
  final String description;
  final bool isFromPost;
  final authProvider = locator<AuthProvider>();

  MyDialog({this.isFailed = false, this.rotateAngle = 0,this.isFromPost=false,required this.icon, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Stack(clipBehavior: Clip.none, children: [
          Positioned(
            left: 0, right: 0, top: -55,
            child: Container(
              height: 70,
              width: 70,
              alignment: Alignment.center,
              decoration: BoxDecoration(color: isFailed ? ColorResources.RED : ColorResources.GREEN, shape: BoxShape.circle),
              child: Transform.rotate(angle: rotateAngle, child: Icon(icon, size: 40, color: Colors.white)),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
             children: [
               CustomText(title, style: Style.title),
              SizedBox(height: 10),
               CustomText(description, textAlign: TextAlign.center, style: Style.subtitle),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: CustomButton(buttonText: 'Ok', onTap: () =>{
                   if(isFromPost==false){
                     Navigator.pop(context)
                   }else{
                     Navigator.of(context).pushAndRemoveUntil(
                         MaterialPageRoute(builder: (c) => MenuPage(userDetailList:authProvider.userDetailList)),
                             (route) => false)
                   }
                } ),
              ),
            ]),
          ),
        ]),
      ),
    );
  }
}
