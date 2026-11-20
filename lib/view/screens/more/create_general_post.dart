import 'dart:async';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tkd_app/dialog/CustomCityListDialog.dart';
import 'package:tkd_app/dialog/CustomStateListDialog.dart';
import 'package:tkd_app/dialog/animated_custom_dialog.dart';
import 'package:tkd_app/dialog/my_dialog.dart';
import 'package:tkd_app/locator.dart';
import 'package:tkd_app/provider/auth_provider.dart';
import 'package:tkd_app/provider/buy_sell_provider.dart';
import 'package:tkd_app/provider/dashboard_provider.dart';
import 'package:tkd_app/provider/general_post_provider.dart';
import 'package:tkd_app/provider/job_provider.dart';
import 'package:tkd_app/util/ResponsiveWidget.dart';
import 'package:tkd_app/util/app_constants.dart';
import 'package:tkd_app/util/color-resource.dart';
import 'package:tkd_app/util/colors.dart';
import 'package:tkd_app/util/images.dart';
import 'package:tkd_app/util/style.dart';
import 'package:tkd_app/view/base_widget/custom_button.dart';
import 'package:tkd_app/view/base_widget/custom_dropdown_list.dart';
import 'package:tkd_app/view/base_widget/custom_dropdown_search_multi_selection.dart';
import 'package:tkd_app/view/base_widget/custom_textfeild.dart';
import 'package:tkd_app/view/base_widget/cutom_city_textfield.dart';
import 'package:tkd_app/view/base_widget/getLoader.dart';
import 'package:tkd_app/view/screens/menu_page.dart';
import 'package:tkd_app/view/screens/my_routes/get_city_list.dart';

import '../../../widgets/base_widgets.dart';
import '../../base_widget/home_base_widgets.dart';

class CreateGeneralPost extends StatefulWidget {


  @override
  _CreateGeneralPostState createState() => _CreateGeneralPostState();
}

class _CreateGeneralPostState extends State<CreateGeneralPost> {
  final authProvider = locator<AuthProvider>();
  final _formKey = GlobalKey<FormState>();
  DashboardProvider provider = locator<DashboardProvider>();

  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();

  @override
  void initState() {
     super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Do something here
        print("After clicking the Android Back Button");
        Navigator.pop(context,1);
        return false;
      },
      child: Scaffold(
        backgroundColor: ThemeColor.baground,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text("General Post requirement",style: Style.appheading,),
          shadowColor: Colors.white,
          leading: IconButton(icon:Icon(Icons.arrow_back,color: Colors.black,),onPressed:(){
            Navigator.pop(context,1);
          } ,),
        ),

        body: Container(
          child: Form(
            key: _formKey,
            child: Consumer<GeneralPostProvider>(
              builder: (context, model, child) => Container(
               // margin: ResponsiveWidget.isDesktop(context)? EdgeInsets.symmetric(horizontal: 50,vertical: 10):EdgeInsets.symmetric(horizontal: 0,vertical: 0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:[

                  CustomTextField(
                    hintText: 'Title',
                    controller: titleController,
                    textInputType: TextInputType.text,
                    validatorMsg: 'Please enter some thing',
                    isValidator: true,
                  ),
                  CustomTextField(
                      hintText: 'Description',
                      controller: descController,
                      textInputType: TextInputType.text,
                      validatorMsg: 'Please enter some thing',
                  ),
                  model.images.length>0? BaseWidget().carouseImage(context,model.images):SizedBox(),
                      InkWell(
                          onTap: () {
                            model.uploadImages(context);
                          },
                          child: SvgPicture.asset(Images.add_image)),
                      Text(
                        "Add images at just ₹0",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF001E49),
                          fontSize: 12,
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                  SizedBox(height: 16,),
                  CustomButton(
                      onTap: (){
                        if (_formKey.currentState!.validate()) {

                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('General Post',style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontFamily: GoogleFonts.poppins().fontFamily,
                                  fontWeight: FontWeight.w600,
                                ),),
                                content: Text('Are you sure you want to post this requirement?',style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontFamily: GoogleFonts.poppins().fontFamily,
                                  fontWeight: FontWeight.w400,
                                ),),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(); // Close the dialog
                                    },
                                    child: Text('No',style: TextStyle(color: ThemeColor.theme_blue, fontSize: 12,
                                      fontFamily: GoogleFonts.poppins().fontFamily,
                                      fontWeight: FontWeight.w600,),),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      model.createGeneralPost(
                                          context,
                                          titleController.text,
                                          descController.text
                                      );
                                    },
                                    child: Text(
                                      'Yes',
                                      style: TextStyle(color: Colors.green, fontSize: 12,
                                        fontFamily: GoogleFonts.poppins().fontFamily,
                                        fontWeight: FontWeight.w600,),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        }},
                      buttonText: "Post Load")
                  ],
                  ),


                ),
              ),
            ),
          ),
        ),
      ),
    );
  }



}


class RadioModel {
  bool isSelected;
  final String text;
  RadioModel(this.isSelected, this.text);
}

class RadioItem extends StatelessWidget {
  final RadioModel _item;
  RadioItem(this._item);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15,horizontal: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width -165,
            margin: EdgeInsets.only(left: 5.0),
            child:  Text(_item.text,style: TextStyle(fontSize: 14,fontWeight: FontWeight.normal),maxLines: 2,),
          ),
          Container(
            height: 20.0,
            width: 20.0,
            child: Center(
              child:Icon(Icons.check,color: _item.isSelected?Colors.white:Colors.transparent,size: 15,),
            ),
            decoration: BoxDecoration(
              color: _item.isSelected
                  ? Colors.blueAccent
                  : Colors.transparent,
              border: Border.all(
                  width: 1.0,
                  color: _item.isSelected
                      ? Colors.blueAccent
                      : Colors.grey),

              borderRadius: const BorderRadius.all(const Radius.circular(50.0)),
            ),
          ),

        ],
      ),
    );
  }
}