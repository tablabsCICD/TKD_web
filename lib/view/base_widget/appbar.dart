import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:tkd_app/locator.dart';
import 'package:tkd_app/model/group_list_model.dart';
import 'package:tkd_app/provider/auth_provider.dart';
import 'package:tkd_app/provider/group/groupChatProvider.dart';
import 'package:tkd_app/util/style.dart';
import 'package:tkd_app/view/base_widget/getImage.dart';
import 'package:tkd_app/view/base_widget/search_widget.dart';
import 'package:tkd_app/view/screens/dashboard/dashboard.dart';
import 'package:tkd_app/view/screens/discussion/discussion_new.dart';
import 'package:tkd_app/view/screens/group/groupListScreen.dart';
import 'package:tkd_app/view/screens/menu_page.dart';

import '../localization/language_constrants.dart';
import '../screens/group/editGroupScreen.dart';

class AppBarCommon {
  final String title;
  final BuildContext context;
   final String appBarWord;

  AppBarCommon(this.context,{this.appBarWord="New",required this.title});

  AppBar appBar(){
    return AppBar(
      title: Text(title,style:Style.appheading,),
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(icon:Icon(Icons.arrow_back_ios_new,color: Colors.black,),onPressed:(){
    Navigator.pop(context);
    } ,
    ),);
  }

  AppBar appBarWithTextField(TextEditingController _controller,String hintText,Function onChangeVal(value),bool backShow){
    //TextEditingController _controller = TextEditingController();
    return AppBar(
      leadingWidth: 25,
      title: Container(
            alignment: Alignment.center,

            width: MediaQuery.of(context).size.width ,
            child: TextField(
              controller: _controller,
             decoration: InputDecoration(
               filled: true,
               fillColor: Colors.black12,
               contentPadding: EdgeInsets.all(1),
               hintText:hintText,
               prefixIcon:Icon(Icons.search),
               //border: InputBorder.none,
              border: OutlineInputBorder(
              borderRadius: const BorderRadius.all(
              const Radius.circular(15.0),
              ),
              borderSide: BorderSide(
              width: 0,
              style: BorderStyle.none,

              ),)
             ),
              style: Style.searchHint,
              onChanged: (value){
                onChangeVal(value);
              },
            ),
          ),
      backgroundColor: Colors.white,
      leading: Visibility(
        visible: backShow,
        child: IconButton(icon:Icon(Icons.arrow_back_ios_new,color: Colors.black,),
          onPressed:(){
          Navigator.pop(context);
        } ,
        ),
      ),

    );
  }

  final userProvider = locator<AuthProvider>();
  AppBar appBarWithNewButton(Function ontap){
    return AppBar(
      title: Text(title,style:Style.appheading,),
      backgroundColor: Colors.white,
      leading: IconButton(icon:Icon(Icons.arrow_back_ios_new,color: Colors.black,),onPressed:(){
        if(title=="Group"){
          Navigator.push(context, MaterialPageRoute(builder: (context) =>MenuPage(userDetailList: userProvider.userDetailList,selectedTab: "Board",)));
        }else{
          Navigator.pop(context);
        }
      } ,
      ),
      actions: [
      Center(
        child: Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
          child: RichText(text:
          TextSpan(
              text: appBarWord,style: Style.newheadingappbar,
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                 ontap();
                }
                ),
          ),
        ),
      )
      ],

    );
  }

  AppBar appBarWithDeleteButton(Function ontap){
    return AppBar(
      title: Text(title,style:Style.appheading,),
      backgroundColor: Colors.white,
      leading: IconButton(icon:Icon(Icons.arrow_back_ios_new,color: Colors.black,),onPressed:(){
        Navigator.pop(context);
      } ,
      ),
      actions: [
        Center(
          child: Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
            child: RichText(text:
            TextSpan(
                text: "Delete",style: Style.newheadingappbar,
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    ontap();
                  }
            ),
            ),
          ),
        )
      ],

    );
  }

  AppBar appBarWithNotification(Function ontap){
    return AppBar(
      title: Text(title,style:Style.appheading,),
      backgroundColor: Colors.white,
      elevation: 0,
      actions: [
        Center(
          child: Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
              child: IconButton(
                  onPressed: ontap(),
                  icon: Icon(Icons.notifications))
          ),
        )
      ],
      leading: IconButton(icon:Icon(Icons.arrow_back_ios_new,color: Colors.black,),onPressed:(){
        Navigator.pop(context);
      } ,
      ),);
  }

  Widget appBarWithSearch(TextEditingController _controller,String hintText,Function onChangeVal(value),bool backShow){
    //TextEditingController _controller = TextEditingController();
    return TextField(
      controller: _controller,
      decoration: InputDecoration(
          filled: true,
          fillColor: Colors.black12,
          contentPadding: EdgeInsets.all(1),
          hintText:hintText,
          prefixIcon:Icon(Icons.search),
          //border: InputBorder.none,
          border: OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              const Radius.circular(15.0),
            ),
            borderSide: BorderSide(
              width: 0,
              style: BorderStyle.none,

            ),)
      ),
      style: Style.searchHint,
      onChanged: (value){
        onChangeVal(value);
      },
    );

  }

  AppBar appBarImage(String img,GroupContent content,BuildContext context,GroupChatProvider groupChatProvider){
    img=img.replaceAll('"', '');
    return AppBar(
      title: InkWell(
        onTap:(){
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EditGroupScreen(groupContent: content)));
        } ,
        child: Row(
          children: [Padding(padding: EdgeInsets.only(top: 5),child:  CircleAvatar(
            radius: 25.0,
            backgroundImage:
            NetworkImage(img),
            backgroundColor: Colors.transparent,
          ),),SizedBox(width: 20,),Text(title,style:Style.appheading,)],
        ),
      ),
      backgroundColor: Colors.white,
      actions: [
        IconButton(icon:Icon(Icons.refresh,color: Colors.black,),onPressed:(){
          groupChatProvider.loadMessage(content.id!);
          return;
        } ,
        )
      ],
      elevation: 0,
      leading: IconButton(icon:Icon(Icons.arrow_back_ios_new,color: Colors.black,),onPressed:(){
        Navigator.pop(context);
      } ,
      ),);
  }



}
