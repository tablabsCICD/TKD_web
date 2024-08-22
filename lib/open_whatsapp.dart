import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

Future openwhatsapp(BuildContext context,String number,String text,) async{
  final link = WhatsAppUnilink(
    phoneNumber: "+91 ${number}",
    text: text,
  );

  await launch('$link');
}