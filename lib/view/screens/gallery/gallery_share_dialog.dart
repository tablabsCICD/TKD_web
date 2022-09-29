import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tkd_app/constant.dart';
import 'package:tkd_app/dialog/share_dialog_box.dart';
import 'package:tkd_app/locator.dart';
import 'package:tkd_app/model/gallary_model.dart';
import 'package:tkd_app/model/transport_serach_model.dart';
import 'package:tkd_app/model/truck_load_model.dart';
import 'package:tkd_app/provider/route_provider.dart';
import 'package:tkd_app/share_data.dart';
import 'package:tkd_app/util/ResponsiveWidget.dart';
import 'package:tkd_app/util/color-resource.dart';
import 'package:tkd_app/util/style.dart';
import 'package:tkd_app/view/base_widget/custom_textview.dart';
import 'package:tkd_app/view/screens/gallery/share_gallery_data.dart';

//enum SocialMedia {whatsapp,facebook,email,twitter,linkedin,pintrest,google,evernote}



class GalleryShareDialogBox extends StatefulWidget {
  Gallery galleryList;

  GalleryShareDialogBox(this.galleryList);


  @override
  _GalleryShareDialogBoxState createState() => _GalleryShareDialogBoxState();
}

class _GalleryShareDialogBoxState extends State<GalleryShareDialogBox> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Constants.padding),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
            margin: ResponsiveWidget.isDesktop(context)
                ?EdgeInsets.only(top: Constants.avatarRadius,left: 250,right: 250)
                :EdgeInsets.only(top: Constants.avatarRadius,left: 10,right: 10,bottom: 50),
            height: ResponsiveWidget.isDesktop(context)
                ?350
                :400,
            width: ResponsiveWidget.isMobile(context)?MediaQuery.of(context).size.width-50:ResponsiveWidget.isDesktop(context)?400:400,
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.white,
                borderRadius: BorderRadius.circular(Constants.padding),
                boxShadow: [
                  BoxShadow(color: Colors.black,offset: Offset(0,10),
                      blurRadius: 10
                  ),
                ]
            ),
            child:Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Share Data Using....",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    buildSocialButton(
                        icon: Icons.mail,
                        color:Colors.red,
                        onClicked: ()=>gallery_share_data(widget.galleryList,SocialMedia.email),
                        iconName: "Mail"
                    ),

                    buildSocialButton(
                        icon: FontAwesomeIcons.whatsapp,
                        color:Colors.green,
                        onClicked: ()=>gallery_share_data(widget.galleryList,SocialMedia.whatsapp),
                        iconName: "WhatsApp"
                    ),
                    buildSocialButton(
                        icon: FontAwesomeIcons.linkedin,
                        color:Colors.blue,
                        onClicked: ()=>gallery_share_data(widget.galleryList,SocialMedia.linkedin),
                        iconName: "LinkeIn"
                    ),
                  ],
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    buildSocialButton(
                        icon: FontAwesomeIcons.twitter,
                        color:Colors.blue,
                        onClicked: ()=>gallery_share_data(widget.galleryList,SocialMedia.twitter),
                        iconName: "Twitter"
                    ),
                    buildSocialButton(
                        icon: FontAwesomeIcons.googlePlus,
                        color:Colors.red,
                        onClicked: ()=>gallery_share_data(widget.galleryList,SocialMedia.google),
                        iconName: "GooglePlus"
                    ),
                    buildSocialButton(
                        icon: FontAwesomeIcons.facebookSquare,
                        color:Colors.blue,
                        onClicked: ()=>gallery_share_data(widget.galleryList,SocialMedia.facebook),
                        iconName : "Facebook"
                    ),
                  ],
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    buildSocialButton(
                        icon: FontAwesomeIcons.pinterest,
                        color:Colors.red,
                        onClicked: ()=>gallery_share_data(widget.galleryList,SocialMedia.pintrest),
                        iconName: "Pinterest"
                    ),
                    buildSocialButton(
                        icon: FontAwesomeIcons.evernote,
                        color:Colors.pink,
                        onClicked: ()=>gallery_share_data(widget.galleryList,SocialMedia.evernote),
                        iconName: "EverNote"
                    ),
                    buildSocialButton(
                        icon: FontAwesomeIcons.evernote,
                        color:Colors.pink,
                        onClicked: ()=>gallery_share_data(widget.galleryList,SocialMedia.evernote),
                        iconName: "EverNote"
                    ),
                  ],
                )
              ],
            )
        )
    );
  }

  Widget buildSocialButton({required IconData icon,Color? color,required VoidCallback onClicked, required String iconName}){
    return InkWell(
      onTap: (){
        onClicked();
      },
      child: Container(
        width: 80,
        height: 80,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: FaIcon(icon,color: color,size:40),
            ),
            Text(iconName),
          ],
        ),
      ),
    );
  }

}
