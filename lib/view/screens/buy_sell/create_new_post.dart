
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tkd_app/dialog/CustomCityListDialog.dart';
import 'package:tkd_app/dialog/CustomStateListDialog.dart';
import 'package:tkd_app/dialog/animated_custom_dialog.dart';
import 'package:tkd_app/dialog/my_dialog.dart';
import 'package:tkd_app/locator.dart';
import 'package:tkd_app/provider/auth_provider.dart';
import 'package:tkd_app/provider/buy_sell_provider.dart';
import 'package:tkd_app/provider/job_provider.dart';
import 'package:tkd_app/util/ResponsiveWidget.dart';
import 'package:tkd_app/util/color-resource.dart';
import 'package:tkd_app/util/style.dart';
import 'package:tkd_app/view/base_widget/custom_button.dart';
import 'package:tkd_app/view/base_widget/custom_dropdown_list.dart';
import 'package:tkd_app/view/base_widget/custom_textfeild.dart';
import 'package:tkd_app/view/base_widget/cutom_city_textfield.dart';

import 'package:tkd_app/view/screens/menu_page.dart';
import 'package:tkd_app/view/screens/my_routes/get_city_list.dart';

class CreateNewBuySellPost extends StatefulWidget {
  final buySellProvider = locator<BuySellProvider>();

  @override
  _CreateNewBuySellPostState createState() => _CreateNewBuySellPostState();
}

class _CreateNewBuySellPostState extends State<CreateNewBuySellPost> {
  String selectedPostType = '';
  String selectedCondition = '';
  String selectedMakerName = '';
  String selectedVehicleSize = '';
  String selectedYear = '';
  String selectedCity = 'Pune';
  final _formKey = GlobalKey<FormState>();
  List<String> requirementList = <String>['Buy Vehicle', 'Sell Vehicle'];
  List<String> makerList = <String>[
    'TATA',
    'Ashok Leyland',
    'Mahindra',
    'Isuzu',
    'Bharat Benz',
    'Volva',
    'Other'
  ];
  List<String> conditionList = <String>['Average', 'Good', 'Excellent'];
  List<String> yearList = <String>[
    '2021',
    '2020',
    '2019',
    '2018',
    '2017',
    '2016',
    '2015',
    '2014',
    '2013',
    '2012',
    '2011',
    '2010',
    '2009',
    '2008',
    '2007',
    '2006',
    '2005',
    '2004',
    '2003',
    '2002',
    '2001',
    '2000',
  ];
  List<String> vehicleSizeList = <String>[
    '32ft Closer Container',
    '24ft Closed Vehicles',
    '20ft Closed Vehicles',
    '20ft Closed',
    '20ft Open',
    '15ft Closed',
    '15ft Open',
    '13ft Closed',
    '13ft Open',
    '24ft Single XL',
    '24ft Double XL',
    '24ft Multi XL',
    '32ft Single XL',
    '32ft Double XL',
    '32ft Multi XL',
    'Trailer',
    'Other'
  ];

  List<String> ctcList = List<String>.empty(growable: true);
  List<String> jobTypeList = List<String>.empty(growable: true);
  TextEditingController description = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController modelName = TextEditingController();
  TextEditingController vehicleRno = TextEditingController();
  TextEditingController kiloMeter = TextEditingController();
//  TextEditingController insuranceDate = TextEditingController();
  TextEditingController cityController = TextEditingController();

  setCity(value) {
    print(value);
    setState(() {
      cityController.text = value;
    });
  }

  String insuranceDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
  var _date = DateTime.now();
  _selectDate(BuildContext context) async {
    DateTime? _datePicker = await showDatePicker(
      initialDatePickerMode: DatePickerMode.day,
      context: context,
      initialDate: _date,
      firstDate: DateTime(1947),
      lastDate: DateTime(2030),
    );

    if (_datePicker != null && _datePicker != _date) {
      setState(() {
        insuranceDate = DateFormat('dd/MM/yyyy').format(_datePicker);
      });
    }
    return _datePicker;
  }


  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Consumer<AuthProvider>(
        builder: (context, model, child) => Container(
          margin: ResponsiveWidget.isDesktop(context)? EdgeInsets.symmetric(horizontal: 50,vertical: 10):ResponsiveWidget.isMobile(context)?EdgeInsets.symmetric(horizontal: 20,vertical: 10):EdgeInsets.symmetric(horizontal: 100,vertical: 10),
          child: ListView(
            shrinkWrap: true,
            children: [
              CustomDropdownList(
                hintText: "Select type",
                items: requirementList,
                selectedType: selectedPostType,
                onChange: (String value){
                  setState(() {
                    selectedPostType = value;
                  });
                },
              ),
              CustomTextField(
                hintText: 'Company Name',
                controller: TextEditingController(
                    text: model.userDetailList[0].companyName ?? ''),
                textInputType: TextInputType.text,
                readOnly: true,
              ),
              CustomTextField(
                hintText: 'Mobile',
                controller: TextEditingController(
                    text:
                    model.userDetailList[0].mobileNumber.toString()),
                textInputType: TextInputType.phone,
                readOnly: true,
              ),
              CustomTextField(
                hintText: 'Email',
                controller: TextEditingController(
                    text: model.userDetailList[0].emailId ?? ''),
                textInputType: TextInputType.emailAddress,
                readOnly: true,
              ),
              CustomCityTextField(
                hintText: 'Select City',
                controller: selectedCity,
                onTap: (){
                  showDialog(context: context,
                      builder: (BuildContext context){
                        return CustomCityListDialog(
                            onTap : (String value){
                              setState(() {
                                selectedCity = value;
                              });
                            }
                        );
                      }
                  ) ;
                },
              ),

              CustomDropdownList(
                hintText: "Select Maker Name",
                items: makerList,
                selectedType: selectedMakerName,
                onChange: (String value){
                  setState(() {
                    selectedMakerName = value;
                  });
                },
              ),
              CustomTextField(
                hintText: 'Model Name',
                controller: modelName,
                textInputType: TextInputType.text,
              ),
              CustomDropdownList(
                hintText: "Select Manufacturing Year",
                items: yearList,
                selectedType: selectedYear,
                onChange: (String value){
                  setState(() {
                    selectedYear = value;
                  });
                },
              ),
              CustomDropdownList(
                hintText: "Select Vehicle Size",
                items: vehicleSizeList,
                selectedType: selectedVehicleSize,
                onChange: (String value){
                  setState(() {
                    selectedVehicleSize = value;
                  });
                },
              ),
              selectedPostType == 'Sell Vehicle'
                  ? CustomTextField(
                hintText: 'Kilometer Driven',
                controller: kiloMeter,
                textInputType: TextInputType.number,
              )
                  : SizedBox.shrink(),
              selectedPostType == 'Sell Vehicle'
                  ? CustomTextField(
                hintText: 'Vehicle Register Number',
                controller: vehicleRno,
                textInputType: TextInputType.text,
              )
                  : SizedBox.shrink(),
              CustomDropdownList(
                hintText: "Condition Of Vehicles",
                items: conditionList,
                selectedType: selectedCondition,
                onChange: (String value){
                  setState(() {
                    selectedCondition = value;
                  });
                },
              ),
              selectedPostType == 'Sell Vehicle'
                  ? CustomTextField(
                hintText: 'Insurance Date Up To(dd/mm/yyyy)',
                controller: TextEditingController(text:insuranceDate),
                textInputType: TextInputType.datetime,
                readOnly: true,
                onTap: (){
                  _selectDate(context);
                },
              )
                  : SizedBox.shrink(),
              CustomTextField(
                hintText: 'Approximate Price',
                controller: price,
                textInputType: TextInputType.text,
                isDigits: true,
              ),
              CustomTextField(
                hintText: 'Additional Information',
                controller: description,
                textInputType: TextInputType.text,
              ),
              CustomButton(
                  onTap: () async {
                    if (_formKey.currentState!.validate()) {
                     var result = await widget.buySellProvider.createBuySell(
                          description: description.text,
                          agentName: '${model.userDetailList[0].firstName} ${model.userDetailList[0].lastName}',
                          bodyType: selectedVehicleSize,
                          buySellType: selectedPostType,
                          city: selectedCity,
                          conditionOfTyre: selectedCondition,
                          ConOfVehicle: selectedCondition,
                          mobile: model.userDetailList[0].mobileNumber,
                          price: price.text,
                          id: model.userDetailList[0].id,
                          image: '',
                          insurancePaidDate: insuranceDate,
                          mainTag: selectedPostType,
                          maker: selectedMakerName,
                          mfgYear: selectedYear,
                          model: modelName.text,
                          lUserName: model.userDetailList[0].userName,
                          owner: model.userDetailList[0].userName,
                          postingTime: '',
                          type: selectedPostType,
                          registrationNumber: vehicleRno.text,
                          yearOfBuying: selectedYear).then((value) => {
                        showAnimatedDialog(
                            context,
                            MyDialog(
                              icon: Icons.check,
                              title:
                              'New Post',
                              description:
                              'Your post submitted successfully',
                              isFailed: false,
                            ),
                            dismissible: false,
                            isFlip: false),
                      });
                     if(result) {
                       Navigator.of(context).pop();
                     }
                    }},
                  buttonText: "Post")
            ],
          ),
        ),
      ),
    );
    /*return Scaffold(
      backgroundColor: ColorResources.HOME_BG,
      appBar: AppBar(
        title: Text('Post Buy/Sell vehicles',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
        backgroundColor: ColorResources.PRIMARY_COLOR,
      ),
      body: Form(
        key: _formKey,
        child: Consumer<AuthProvider>(
          builder: (context, model, child) => Container(
            margin: ResponsiveWidget.isDesktop(context)? EdgeInsets.symmetric(horizontal: 200,vertical: 10):ResponsiveWidget.isMobile(context)?EdgeInsets.symmetric(horizontal: 20,vertical: 10):EdgeInsets.symmetric(horizontal: 100,vertical: 10),
            child: ListView(
              shrinkWrap: true,
              children: [
                CustomDropdownList(
                  hintText: "Select type",
                  items: requirementList,
                  selectedType: selectedPostType,
                  onChange: (String value){
                    setState(() {
                      selectedPostType = value;
                    });
                  },
                ),
                CustomTextField(
                  hintText: 'Company Name',
                  controller: TextEditingController(
                      text: model.userDetailList[0].companyName ?? ''),
                  textInputType: TextInputType.text,
                  readOnly: true,
                ),
                CustomTextField(
                  hintText: 'Mobile',
                  controller: TextEditingController(
                      text:
                          model.userDetailList[0].mobileNumber.toString()),
                  textInputType: TextInputType.phone,
                  readOnly: true,
                ),
                CustomTextField(
                  hintText: 'Email',
                  controller: TextEditingController(
                      text: model.userDetailList[0].emailId ?? ''),
                  textInputType: TextInputType.emailAddress,
                  readOnly: true,
                ),
                CustomCityTextField(
                  hintText: 'Select City',
                  controller: selectedCity,
                  onTap: (){
                    showDialog(context: context,
                        builder: (BuildContext context){
                          return CustomCityListDialog(
                              onTap : (String value){
                                setState(() {
                                  selectedCity = value;
                                });
                              }
                          );
                        }
                    ) ;
                  },
                ),

                CustomDropdownList(
                  hintText: "Select Maker Name",
                  items: makerList,
                  selectedType: selectedMakerName,
                  onChange: (String value){
                    setState(() {
                      selectedMakerName = value;
                    });
                  },
                ),
                CustomTextField(
                  hintText: 'Model Name',
                  controller: modelName,
                  textInputType: TextInputType.text,
                ),
              CustomDropdownList(
                hintText: "Select Manufacturing Year",
                items: yearList,
                selectedType: selectedYear,
                onChange: (String value){
                  setState(() {
                    selectedYear = value;
                  });
                },
              ),
              CustomDropdownList(
                hintText: "Select Vehicle Size",
                items: vehicleSizeList,
                selectedType: selectedVehicleSize,
                onChange: (String value){
                  setState(() {
                    selectedVehicleSize = value;
                  });
                },
              ),
                selectedPostType == 'Sell Vehicle'
                    ? CustomTextField(
                        hintText: 'Kilometer Driven',
                        controller: kiloMeter,
                        textInputType: TextInputType.number,
                      )
                    : SizedBox.shrink(),
                selectedPostType == 'Sell Vehicle'
                    ? CustomTextField(
                        hintText: 'Vehicle Register Number',
                        controller: vehicleRno,
                        textInputType: TextInputType.text,
                      )
                    : SizedBox.shrink(),
                CustomDropdownList(
                  hintText: "Condition Of Vehicles",
                  items: conditionList,
                  selectedType: selectedCondition,
                  onChange: (String value){
                    setState(() {
                      selectedCondition = value;
                    });
                  },
                ),
                selectedPostType == 'Sell Vehicle'
                    ? CustomTextField(
                          hintText: 'Insurance Date Up To(dd/mm/yyyy)',
                          controller: TextEditingController(text:insuranceDate),
                          textInputType: TextInputType.datetime,
                          readOnly: true,
                      onTap: (){
                            _selectDate(context);
                      },
                     )
                    : SizedBox.shrink(),
                CustomTextField(
                  hintText: 'Approximate Price',
                  controller: price,
                  textInputType: TextInputType.text,
                ),
                CustomTextField(
                  hintText: 'Additional Information',
                  controller: description,
                  textInputType: TextInputType.text,
                  isValidator: false,
                ),
                CustomButton(
                    onTap: () {
      if (_formKey.currentState!.validate()) {
                      widget.buySellProvider.createBuySell(
                          description: description.text,
                          agentName: '${model.userDetailList[0].firstName} ${model.userDetailList[0].lastName}',
                          bodyType: selectedVehicleSize,
                          buySellType: selectedPostType,
                          city: selectedCity,
                          conditionOfTyre: selectedCondition,
                          ConOfVehicle: selectedCondition,
                          mobile: model.userDetailList[0].mobileNumber,
                          price: price.text,
                          id: model.userDetailList[0].id,
                          image: '',
                          insurancePaidDate: insuranceDate,
                          mainTag: selectedPostType,
                          maker: selectedMakerName,
                          mfgYear: selectedYear,
                          model: modelName.text,
                          lUserName: model.userDetailList[0].userName,
                          owner: model.userDetailList[0].userName,
                          postingTime: '',
                          type: selectedPostType,
                          registrationNumber: vehicleRno.text,
                          yearOfBuying: selectedYear);
                      Navigator.of(context).pop();
                    }},
                    buttonText: "Post Jobs")
              ],
            ),
          ),
        ),
      ),
    );*/
  }
}
