import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tkd_app/util/colors.dart';

class Button extends StatelessWidget {
  final double width;
  final double height;
  final String title;
  final TextStyle textStyle;
  final Function onClick;
  bool isEnbale;

  Button(
      {key,
      this.isEnbale = true,
      required this.width,
      required this.height,
      required this.title,
      required this.textStyle,
      required this.onClick});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        if (isEnbale) {
          onClick();
        } else {}
      },
      child: Container(
        width: width,
        height: height,
        decoration: ShapeDecoration(
          color: isEnbale ? ThemeColor.theme_blue : ThemeColor.border_grey,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Center(
          child: Text(
            title,
            style: textStyle,
          ),
        ),
      ),
    );
  }
}
