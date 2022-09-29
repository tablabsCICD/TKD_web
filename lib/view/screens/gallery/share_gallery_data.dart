import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:tkd_app/dialog/share_dialog_box.dart';
import 'package:tkd_app/model/gallary_model.dart';
import 'package:tkd_app/model/truck_load_model.dart';
import 'package:universal_html/html.dart' as html;
import 'package:url_launcher/url_launcher.dart';


Future gallery_share_data(Gallery gallery, SocialMedia socialMedia) async {

  final subject = gallery.description.toString();
  final text = "Name: "+gallery.firstName.toString()+gallery.lastName.toString()+
      "\nMobile Number: "+gallery.mobileNumber.toString()+
      '\nType : ${gallery.topicName}, '
          '\nSubject : ${gallery.description}, ';

  final urlShare =  " ";//Uri.encodeComponent(gallery.sharableLink.toString()) ;


  switch(socialMedia){
    case SocialMedia.facebook :
      if(await canLaunch('https://www.facebook.com/sharer.php?u=$urlShare&t=$text')){
        await launch('https://www.facebook.com/sharer.php?u=$urlShare');
      }
      break;
    case SocialMedia.whatsapp :
      if(await canLaunch('https://api.whatsapp.com/send?text=${text}')){
        await launch('https://api.whatsapp.com/send?text=${text}');
      }
      break;
    case SocialMedia.linkedin :
      if(await canLaunch('https://www.linkedin.com/shareArticle?url=$urlShare&title=$text')){
        await launch('https://www.linkedin.com/shareArticle?url=$urlShare&title=$text');
      }
      break;
    case SocialMedia.email :
      if(await canLaunch('mailto:?subject=$subject&body=$text')){
        await launch('mailto:?subject=$subject&body=$text');
      }
      break;
    case SocialMedia.twitter :
      if(await canLaunch('https://twitter.com/share?url=$urlShare&text=$text&via=$urlShare&hashtags=$subject')){
        await launch('https://twitter.com/share?url=$urlShare&text=$text&via=$urlShare&hashtags=$subject');
      }
      break;
    case SocialMedia.pintrest :
      if(await canLaunch('https://pinterest.com/pin/create/bookmarklet/?media=$text&url=$urlShare&idescription=$text')){
        await launch('https://pinterest.com/pin/create/bookmarklet/?media=$text&url=$urlShare&idescription=$text');
      }
      break;
    case SocialMedia.google :
      if(await canLaunch('https://plus.google.com/share?url=$urlShare')){
        await launch('https://plus.google.com/share?url=$urlShare');
      }
      break;
    case SocialMedia.evernote :
      if(await canLaunch('https://www.evernote.com/clip.action?url=$urlShare&title=$text')){
        await launch('https://www.evernote.com/clip.action?url=$urlShare&title=$text');
      }
      break;
    case SocialMedia.evernote :
      if(await canLaunch('https://bufferapp.com/add?text=$text&url=$urlShare')){
        await launch('https://bufferapp.com/add?text=$text&url=$urlShare');
      }
      break;
  }




}