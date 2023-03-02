import 'package:flutter/cupertino.dart';

class LogoTkd{

   Widget getLogo() {
    return Align(
      alignment: Alignment.topCenter,
      child: Image.asset(
        'assets/images/tkd.png',
        height: 150,
        width: 250,
      ),
    );
  }
}