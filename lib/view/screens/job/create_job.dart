


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tkd_app/dialog/animated_custom_dialog.dart';
import 'package:tkd_app/dialog/my_dialog.dart';
import 'package:tkd_app/locator.dart';
import 'package:tkd_app/provider/auth_provider.dart';
import 'package:tkd_app/provider/job_provider.dart';
import 'package:tkd_app/util/ResponsiveWidget.dart';
import 'package:tkd_app/util/color-resource.dart';
import 'package:tkd_app/util/style.dart';
import 'package:tkd_app/view/base_widget/custom_button.dart';
import 'package:tkd_app/view/base_widget/custom_textfeild.dart';
import 'package:tkd_app/view/base_widget/cutom_city_textfield.dart';

import 'package:tkd_app/view/screens/menu_page.dart';
import 'package:tkd_app/view/screens/my_routes/get_city_list.dart';

class CreateJob extends StatefulWidget {
  final jobProvider = locator<JobProvider>();
  @override
  _CreateJobState createState() => _CreateJobState();
}

class _CreateJobState extends State<CreateJob> {
  String selectedPostType = '';
  String selectedCtc = '';
  String selectedJobType = '';
  String selectedExpFrom = '';
  String selectedExpTo = '';
  List<String> ctcList = List<String>.empty(growable: true);
  List<String> jobTypeList = List<String>.empty(growable: true);
  TextEditingController description = TextEditingController();
  TextEditingController experience = TextEditingController();
  TextEditingController position = TextEditingController();
  TextEditingController jobTitle = TextEditingController();
  TextEditingController cityController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  setCity(value){
    print(value);
    setState(() {
      cityController.text = value;
    });
  }

  List<String> expList = ["Fresher","6 Month","1 Year","1.5 Year","2 Year","2.5 Year","3 Year","3.5 Year","4 Year","4.5  Year","5 Year","5.5 Year","6 Year"];
  List<String> salaryList = ['1LPA','1PLA to 2LPA','2PLA to 3LPA','4PLA to 5LPA','6PLA to 7LPA','8PLA to 9LPA','10PLA to Above',];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Post Job",style: Style.appheading,),
        shadowColor: Colors.white,
        leading: IconButton(icon:Icon(Icons.arrow_back,color: Colors.black,),onPressed:(){
          Navigator.pop(context,1);
        } ,),
      ),
      body: Consumer<AuthProvider>(
          builder: (context, model, child) =>
         Form(
           key: _formKey,
           child: Container(
             child: ListView(
              shrinkWrap: true,
              children: [
                CustomTextField(
                  hintText: 'Position',
                  controller: position,
                  textInputType: TextInputType.text,
                ),
                CustomTextField(
                  hintText: 'Job Title',
                  controller: jobTitle,
                  textInputType: TextInputType.text,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                  padding: EdgeInsets.symmetric(vertical: 3,horizontal: 5),
                  height: 50,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black54, width: 0.9),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: DropdownButtonFormField(
                      decoration: InputDecoration(
                        enabledBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        border: InputBorder.none
                      ),
                      hint: Text("Select Salary",style: TextStyle(
                        color: Color(0x662C363F),
                        fontSize: 14,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontWeight: FontWeight.w400,
                      ),),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontWeight: FontWeight.w400,
                      ),
                      items: ['1LPA','1PLA to 2LPA','2PLA to 3LPA','4PLA to 5LPA','6PLA to 7LPA','8PLA to 9LPA','10PLA to Above',]
                          .map((value) => DropdownMenuItem(
                        value: value,
                        child: Text('$value',style: Style.dropdownValue,),
                      ))
                          .toList(),
                      onChanged: (String? value){
                        setState(() {
                          selectedCtc = value!;
                        });}
                  ),
                ),
                CustomTextField(
                  hintText: 'Job description',
                  controller: description,
                  textInputType: TextInputType.text,
                  maxLine: 5,
                ),
                jobExp(context),
                CustomButton(onTap: () async {
                    if (_formKey.currentState!.validate()) {
                      await widget.jobProvider.saveJobs(context,salary : selectedCtc,description : description.text,experience : "${selectedExpFrom} - ${selectedExpTo}",position : position.text,jonTitle : jobTitle.text,model: model);/*.then((value) => {
                        showAnimatedDialog(
                            context,
                            MyDialog(
                              icon: Icons.check,
                              title:
                              'New Post',
                              description:
                              'Your post submitted successfully',
                              isFailed: false,
                              isFromPost: true,
                            ),
                            dismissible: false,
                            isFlip: false),
                      });*/
                   //   if(result) {


                    //  }
                    }
                },
                    buttonText: "Post Job")
              ],
            ),
                   ),
         ),
      ),
    );
  }

  jobExp(BuildContext context) {
    return Consumer<JobProvider>(
      builder: (context, provider, child) {
        return Row(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
              padding: EdgeInsets.symmetric(vertical: 3,horizontal: 5),
              height: 50,
              width:200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black54, width: 0.9),
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: DropdownButtonFormField(
                  hint: Text('Experience From',style: TextStyle(
                    color: Color(0x662C363F),
                    fontSize: 14,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    fontWeight: FontWeight.w400,
                  ),),
                  decoration: InputDecoration(
                      enabledBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      border: InputBorder.none
                  ),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    fontWeight: FontWeight.w400,
                  ),
                  items: ["Fresher","6 Month","1 Year","1.5 Year","2 Year","2.5 Year","3 Year","3.5 Year","4 Year","4.5  Year","5 Year","5.5 Year","6 Year"]
                      .map((value) => DropdownMenuItem(
                    value: value,
                    child: Text('$value',style: Style.dropdownValue,),
                  ))
                      .toList(),
                  onChanged: (String? value){
                    setState(() {
                      selectedExpFrom = value!;
                    });}
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
              padding: EdgeInsets.symmetric(vertical: 3,horizontal: 5),
              height: 50,
              width: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black54, width: 0.9),
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: DropdownButtonFormField(
                  decoration: InputDecoration(
                      enabledBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      border: InputBorder.none
                  ),
                hint: Text("Experience To",style: TextStyle(
                  color: Color(0x662C363F),
                  fontSize: 14,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  fontWeight: FontWeight.w400,
                ),),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    fontWeight: FontWeight.w400,
                  ),
                  items:["Fresher","6 Month","1 Year","1.5 Year","2 Year","2.5 Year","3 Year","3.5 Year","4 Year","4.5  Year","5 Year","5.5 Year","6 Year"]
                      .map((value) => DropdownMenuItem(
                    value: value,
                    child: Text('$value',style: Style.dropdownValue,),
                  ))
                      .toList(),
                  onChanged: (String? value){
                    setState(() {
                      selectedExpTo = value!;
                    });}
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDropdownField(String label, String hint,
      List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        SizedBox(
          height: 52,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 0.7),
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: DropdownButton(
                value: label,
                isExpanded: true,
                icon: const Icon(Icons.arrow_drop_down),
                borderRadius: BorderRadius.circular(5.0),
                underline: SizedBox.shrink(),
                hint: Text(
                  "Source of Lead",
                  style: TextStyle(
                    color: Color(0xff1B1B1B),
                    fontSize: 15,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                items: items.map((String items) {
                  return DropdownMenuItem(
                    value: items,
                    child: Text(
                      items,
                      style: TextStyle(
                        color: Color(0xff1B1B1B),
                        fontSize: 15,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    if(hint=="Experience From"){
                      selectedExpFrom = newValue!;
                    }else if(hint=="Experience To"){
                      selectedExpTo = newValue!;
                    }else{
                      selectedCtc = newValue!;
                    }
                  });
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
