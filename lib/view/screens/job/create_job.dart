/*



import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
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
  String selectedSalary = '';
  String selectedCity = 'Pune';
  List<String> ctcList = List<String>.empty(growable: true);
  List<String> jobTypeList = List<String>.empty(growable: true);
  TextEditingController description = TextEditingController();
  TextEditingController experience = TextEditingController();
  TextEditingController msg = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController cityController = TextEditingController();

  setCity(value){
    print(value);
    setState(() {
      cityController.text = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post Job',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
        backgroundColor: ColorResources.PRIMARY_COLOR,
      ),
      backgroundColor: ColorResources.HOME_BG,
      body: Consumer<AuthProvider>(
          builder: (context, model, child) =>
         Container(
           margin: ResponsiveWidget.isDesktop(context)? EdgeInsets.symmetric(horizontal: 200,vertical: 10):ResponsiveWidget.isMobile(context)?EdgeInsets.symmetric(horizontal: 20,vertical: 10):EdgeInsets.symmetric(horizontal: 100,vertical: 10),
           child: ListView(
            shrinkWrap: true,
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                padding: EdgeInsets.symmetric(vertical: 3,horizontal: 5),
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color:ColorResources.WHITE
                ),
                child: FormBuilderDropdown(
                    name: 'Post Type',
                    allowClear: true,
                    style: Style.searchHint,
                    hint: Text("Post Type"),
                    validator: FormBuilderValidators.compose(
                        [FormBuilderValidators.required(context)]),
                    items: ['Post Type','Job Seeker','Employer']
                        .map((value) => DropdownMenuItem(
                      value: value,
                      child: Text('$value',style: Style.dropdownValue,),
                    ))
                        .toList(),
                    onChanged: (String? value){
                      setState(() {
                        selectedPostType = value!;
                     });}
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                padding: EdgeInsets.symmetric(vertical: 3,horizontal: 5),
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color:ColorResources.WHITE
                ),
                child: FormBuilderDropdown(
                    name: 'CTC',
                   allowClear: true,
                    hint: Text("CTC"),
                    style: Style.searchHint,
                    validator: FormBuilderValidators.compose(
                        [FormBuilderValidators.required(context)]),
                    items: ['0.5K to 1LPA','1PLA to 2LPA','2PLA to 3LPA','3PLA to 4LPA','4PLA to 5LPA','5PLA to Above',]
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
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                padding: EdgeInsets.symmetric(vertical: 3,horizontal: 5),
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color:ColorResources.WHITE
                ),
                child: FormBuilderDropdown(
                    name: 'Salary Negotiable',
                   allowClear: true,
                    style: Style.searchHint,
                    hint: Text("Salary Negotiable"),
                    validator: FormBuilderValidators.compose(
                        [FormBuilderValidators.required(context)]),
                    items: ['Yes','No']
                        .map((value) => DropdownMenuItem(
                      value: value,
                      child: Text('$value',style: Style.dropdownValue,),
                    ))
                        .toList(),
                    onChanged: (String? value){
                      setState(() {
                        selectedSalary = value!;
                      });}
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                padding: EdgeInsets.symmetric(vertical: 3,horizontal: 5),
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color:ColorResources.WHITE
                ),
                child: FormBuilderDropdown(
                    name: 'Job Type',
                    allowClear: true,
                    style: Style.searchHint,
                    hint: Text("Job Type"),
                    validator: FormBuilderValidators.compose(
                        [FormBuilderValidators.required(context)]),
                    items: ['Driver','Traffic','Maintenance','Marketing','Manager','Traffic Department','Other']
                        .map((value) => DropdownMenuItem(
                      value: value,
                      child: Text('$value',style: Style.dropdownValue,),
                    ))
                        .toList(),
                    onChanged: (String? value){
                      setState(() {
                        selectedJobType = value!;
                      });}
                ),
              ),
              CustomCityTextField(
                hintText: 'Select City',
                controller: selectedCity,
                onTap: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              GetCityList())).then((value) {
                    if (value.toString().isNotEmpty &&
                        value != null) {
                      selectedCity = value[0];
                      setState(() {});
                    }
                  });
                },
              ),

              */
/*Container(
                margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                padding: EdgeInsets.symmetric(vertical: 3,horizontal: 5),
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color:ColorResources.WHITE
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width-64,
                      child: InkWell(
                        onTap: (){
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) =>
                                  CityScreen())
                          ).then((value) => value!=null ? setCity(value) : null);
                        },
                        child: TextFormField(
                          readOnly: true,
                          enabled: false,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select City';
                            }
                            return null;
                          },
                          controller: cityController,
                          decoration: InputDecoration(
                            hintText: 'Select City',
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                            ),
                            counterText: "",
                          ),
                          onChanged: (value) {
                            selctedCity = value;
                            setState(() {

                            });
                          },
                        ),
                      ),
                    ),
                    cityController.text==''?SizedBox.shrink():IconButton(
                      icon: Icon(Icons.clear),
                      iconSize: 20,
                      onPressed: (){
                        setState(() {
                          cityController.text = '';
                        });
                      },
                    )
                  ],
                ),
              ),*//*

              CustomTextField(
                hintText: 'Job description',
                controller: description,
                textInputType: TextInputType.text,
              ),
              CustomTextField(
                hintText: 'Job Experience (in years)',
                controller: experience,
                textInputType: TextInputType.text,
              ),
              CustomTextField(
                hintText: 'Message',
                controller: msg,
                textInputType: TextInputType.text,
              ),
              CustomTextField(
                hintText: 'Enter Name',
                controller: name,
                textInputType: TextInputType.text,
              ),
              CustomTextField(
                hintText: 'Email',
                controller: TextEditingController(text: model.userDetailList[0].emailId ?? ''),
                textInputType: TextInputType.emailAddress,
                readOnly: true,
              ),
              CustomTextField(
                hintText: 'Mobile',
                controller: TextEditingController(text: model.userDetailList[0].mobileNumber.toString()),
                textInputType: TextInputType.phone,
                readOnly: true,
              ),
              CustomButton(onTap: (){
                  widget.jobProvider.saveJabs(selectedPostType: selectedPostType,ctc : selectedCtc,salaryType : selectedSalary,jobType : selectedJobType,city : selectedCity,description : description.text,experience : experience.text,msg : msg.text,name : name.text,email : model.userDetailList[0].emailId,mobile: model.userDetailList[0].mobileNumber,model: model);
                  Navigator.of(context).pop();
              },
                  buttonText: "Post Jobs")
            ],
          ),
        ),
      ),
    );
  }
}
*/
