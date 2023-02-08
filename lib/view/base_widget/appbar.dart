import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:tkd_app/util/style.dart';
import 'package:tkd_app/view/base_widget/search_widget.dart';
import 'package:tkd_app/view/screens/dashboard/dashboard.dart';
import 'package:tkd_app/view/screens/discussion/discussion_new.dart';



class AppBarCommon {
  final String title;
  final BuildContext context;

  const AppBarCommon(this.context, {required this.title});

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
  AppBar appBarWithTextField(TextEditingController _controller,String hintText,Function onChangeVal(value)){
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
      leading: IconButton(icon:Icon(Icons.arrow_back_ios_new,color: Colors.black,),
        onPressed:(){
          Navigator.pop(context);
        } ,
      ),

    );
  }

  AppBar appBarWithNewButton(Function ontap){
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
                text: 'New',style: Style.newheadingappbar,
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


}