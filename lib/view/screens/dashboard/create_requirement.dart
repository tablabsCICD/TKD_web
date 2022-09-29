


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_switch/flutter_switch.dart';
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
import 'package:tkd_app/provider/job_provider.dart';
import 'package:tkd_app/util/ResponsiveWidget.dart';
import 'package:tkd_app/util/color-resource.dart';
import 'package:tkd_app/util/style.dart';
import 'package:tkd_app/view/base_widget/custom_button.dart';
import 'package:tkd_app/view/base_widget/custom_dropdown_list.dart';
import 'package:tkd_app/view/base_widget/custom_dropdown_search_multi_selection.dart';
import 'package:tkd_app/view/base_widget/custom_textfeild.dart';
import 'package:tkd_app/view/base_widget/cutom_city_textfield.dart';
import 'package:tkd_app/view/screens/menu_page.dart';
import 'package:tkd_app/view/screens/my_routes/get_city_list.dart';

class CreateRequirement extends StatefulWidget {

  String postType;
  CreateRequirement(this.postType);

  @override
  _CreateRequirementState createState() => _CreateRequirementState();
}

class _CreateRequirementState extends State<CreateRequirement> {
  final authProvider = locator<AuthProvider>();
  String selectedRequirementType = '';
  String selectedPostType = 'Full Load';
  String selectedCargoType = '';
  String selectedTypeOfPayment = 'Immediate';

  List<String> requirementList = <String>['I Want Vehicle', 'I Have Vehicle'];
  List<String> itemList = <String>['Full Load', 'Part Load'];
  List<String> cargoList = <String>['Wooden Case','Cartons','Drums','Gunny Bags',"Machinery",'Other'];
  List<String> paymentList = <String>['Immediate','Fortnight','Weekly','Others'];
  String selectedFromCity = 'Pune';
  String selectedToCity = 'Pune';
  final _formKey = GlobalKey<FormState>();

  TextEditingController selectedVehicleSizeController = TextEditingController();
  TextEditingController loadWeightController = TextEditingController();
  TextEditingController instructionController = TextEditingController();
  DashboardProvider provider = locator<DashboardProvider>();
  bool identitySwitch = false;
  bool privateSwitch = false;
  bool disturbSwitch = false;
  List<RadioModel> sampleData = <RadioModel>[
    RadioModel(true, 'Show to only your preferred Transporters'),
    RadioModel(false, 'Show to only verified Transporters'),
    RadioModel(false, 'Show to All')
  ];

  @override
  void initState() {
    selectedPostType = widget.postType;
    provider.getAllUserList();
      sampleData.add(new RadioModel(true, 'Show to only your preferred Transporters'));
      sampleData.add(new RadioModel(false, 'Show to only verified Transporters'));
     super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Consumer<DashboardProvider>(
        builder: (context, model, child) => Container(
          margin: ResponsiveWidget.isDesktop(context)? EdgeInsets.symmetric(horizontal: 50,vertical: 10):ResponsiveWidget.isMobile(context)?EdgeInsets.symmetric(horizontal: 20,vertical: 10):EdgeInsets.symmetric(horizontal: 100,vertical: 10),
          child: ListView(
            shrinkWrap: true,
            children: [
              Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  alignment: Alignment.center,
                  child: Text('Requirement you post will be visible on the general board to vendors whose routes match to yours.',style: Style.heading,)),
              /*Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  padding: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                  height: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: ColorResources.WHITE),
                  child: FormBuilderDropdown(
                      name: 'Your requirement',
                      allowClear: true,
                      style: Style.searchHint,
                      hint: Text("Your requirement"),
                      validator: FormBuilderValidators.compose(
                          [FormBuilderValidators.required(context)]),
                      items: ['I Want Vehicle', 'I Have Vehicle']
                          .map((value) => DropdownMenuItem(
                        value: value,
                        child: Text('$value',style: Style.dropdownValue,),
                      ))
                          .toList(),
                      onChanged: (String? value) {
                        setState(() {
                          selectedRequirementType = value!;
                        });
                      }),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  padding: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                  height: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: ColorResources.WHITE),
                  child: FormBuilderDropdown(
                      name: 'Post Type',
                      allowClear: true,
                      style: Style.searchHint,
                      hint: Text("Select Type"),
                      validator: FormBuilderValidators.compose(
                          [FormBuilderValidators.required(context)]),
                      items: ['Full Load', 'Part Load']
                          .map((value) => DropdownMenuItem(
                        value: value,
                        child: Text('$value',style: Style.dropdownValue,),
                      ))
                          .toList(),
                      onChanged: (String? value) {
                        setState(() {
                          selectedPostType = value!;
                        });
                      }),
                ),*/
              CustomDropdownList(
                hintText: "Select Requirement",
                items: requirementList,
                selectedType: selectedRequirementType,
                onChange: (String value){
                  setState(() {
                    selectedRequirementType = value;
                  });
                },
              ),
              CustomDropdownList(
                hintText: "Select Post Type",
                items: itemList,
                selectedType: selectedPostType,
                onChange: (String value){
                  setState(() {
                    selectedPostType = value;
                  });
                },
              ),
              CustomCityTextField(
                hintText: 'Select City From',
                controller: selectedFromCity,
                onTap: (){
                  showDialog(context: context,
                      builder: (BuildContext context){
                        return CustomCityListDialog(
                            onTap : (String value){
                              setState(() {
                                selectedFromCity = value;
                              });
                            }
                        );
                      }
                  ) ;

                },
              ),
              CustomCityTextField(
                hintText: 'Select City To',
                controller: selectedToCity,
                onTap: (){
                  showDialog(context: context,
                      builder: (BuildContext context){
                        return CustomCityListDialog(
                            onTap : (String value){
                              setState(() {
                                selectedToCity = value;
                              });
                            }
                        );
                      }
                  ) ;
                },
              ),
              CustomDropdownList(
                hintText: "Select Cargo Type",
                items: cargoList,
                selectedType: selectedCargoType,
                onChange: (String value){
                  setState(() {
                    selectedCargoType = value;
                  });
                },
              ),
              CustomTextField(
                hintText: 'Vehicle Size',
                controller: selectedVehicleSizeController,
                textInputType: TextInputType.text,
              ),
              CustomTextField(
                hintText: 'Load Weight (In Tons)',
                controller: loadWeightController,
                textInputType: TextInputType.text,

              ),
              CustomTextField(
                hintText: 'Special Instruction',
                controller: instructionController,
                textInputType: TextInputType.text,
              ),
              CustomTextField(
                hintText: 'Mobile',
                controller: TextEditingController(
                    text:
                    authProvider.userDetailList[0].mobileNumber.toString()),
                textInputType: TextInputType.phone,
                readOnly: true,
              ),
              CustomTextField(
                hintText: 'Email',
                controller: TextEditingController(
                    text: authProvider.userDetailList[0].emailId?? ''),
                textInputType: TextInputType.emailAddress,
                readOnly: true,
              ),
              CustomDropdownList(
                hintText: "Select Type Of Payment",
                items: paymentList,
                selectedType: selectedTypeOfPayment,
                onChange: (String value){
                  setState(() {
                    selectedTypeOfPayment = value;
                  });
                },
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                height: 25,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Hide my identity',style: Style.heading1),
                    FlutterSwitch(
                      showOnOff: true,
                      valueFontSize: 12,
                      activeColor: ColorResources.PRIMARY_COLOR,
                      activeTextColor: Colors.black,
                      inactiveTextColor: Colors.red,
                      value: identitySwitch,
                      onToggle: (val) {
                        setState(() {
                          identitySwitch = model.selectedSampleData == "Show To All"? false : val;
                          if(identitySwitch == true){
                           showDialog(context: context,
                                builder: (BuildContext context){
                                  return CustomDropdownSearchMultiSelection(labelText: "Select Transporters", itemList: model.allUserNameList, selectedItems: model.searchingList,allUserList : model.allUserList);
                                /*return AlertDialog(
                                  title: Text("Selcet Option"),
                                  content: Container(
                                    width: 400,
                                    child:  ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: sampleData.length,
                                      itemBuilder: (BuildContext context, int index) {
                                        return new InkWell(
                                          //highlightColor: Colors.red,
                                          splashColor: Colors.blueAccent,
                                          onTap: () {
                                            setState(() {
                                              sampleData.forEach((element) => element.isSelected = false);
                                              sampleData[index].isSelected = true;
                                            });
                                          },
                                          child: new RadioItem(sampleData[index]),
                                        );
                                      },
                                    ),
                                  ),
                                );*/
                            }
                            ) as List<String> ;

                          }
                        });
                      },
                    ),
                  ],
                ),
              ),
              /*Container(
                  margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Make this post private',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                          Text('Private posts are not visible to all in the general board,you will be able to share this post only with users you select.',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 12),),
                        ],
                      ),
                      FlutterSwitch(
                        showOnOff: true,
                        activeColor: ColorResources.PRIMARY_COLOR,
                        activeTextColor: Colors.black,
                        inactiveTextColor: Colors.red,
                        value: privateSwitch,
                        onToggle: (val) {
                          setState(() {
                            privateSwitch = val;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Do not disturb',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                          Text('Once you activate this, only Bid function work,chat & call will not work.',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 12),),
                        ],
                      ),
                      FlutterSwitch(
                        showOnOff: true,
                        activeColor: ColorResources.PRIMARY_COLOR,
                        activeTextColor: Colors.black,
                        inactiveTextColor: Colors.red,
                        value: disturbSwitch,
                        onToggle: (val) {
                          setState(() {
                            disturbSwitch = val;
                          });
                        },
                      ),
                    ],
                  ),
                ),*/
              CustomButton(
                  onTap: () async{
                    if (_formKey.currentState!.validate()) {
                      var result = await model.savePost(
                          mobile: authProvider.userDetailList[0].mobileNumber ,
                          destination: selectedToCity,
                          dnd: 0,
                          email: authProvider.userDetailList[0].emailId,
                          fullLoadChoice: selectedRequirementType,
                          id: 1,
                          instruction: instructionController.text,
                          loadWeight: loadWeightController.text,
                          name: authProvider.userDetailList[0].userName,
                          mainTag: selectedPostType,
                          os: 'Web',
                          otherDetails: instructionController.text,
                          source: selectedFromCity,
                          partLoad: selectedPostType == 'Part Load' ? 1 : 0,
                          privatePost: identitySwitch == true ? 1 : 0,
                          rating: 5,
                          customerName: '${authProvider.userDetailList[0].firstName} ${authProvider.userDetailList[0].lastName}',
                          type: selectedPostType,
                          typeOfCargo: selectedCargoType,
                          typeOfPayment: selectedTypeOfPayment,
                          vehicleSize: selectedVehicleSizeController.text,
                       //   userId: authProvider.userDetailList[0].id
                      ).then((value) => {
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
                  buttonText: "Post Load")
            ],
          ),
        ),
      ),
    );
   /* return Scaffold(
      appBar: AppBar(
        title: Text('Post Requirement',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
        backgroundColor: ColorResources.PRIMARY_COLOR,
      ),
      backgroundColor: ColorResources.HOME_BG,
      body: Form(
        key: _formKey,
        child: Consumer<DashboardProvider>(
          builder: (context, model, child) => Container(
            margin: ResponsiveWidget.isDesktop(context)? EdgeInsets.symmetric(horizontal: 200,vertical: 10):ResponsiveWidget.isMobile(context)?EdgeInsets.symmetric(horizontal: 20,vertical: 10):EdgeInsets.symmetric(horizontal: 100,vertical: 10),
            child: ListView(
              shrinkWrap: true,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  alignment: Alignment.center,
                    child: Text('Requirement you post will be visible on the general board to vendors whose routes match to yours.',style: Style.heading,)),
                *//*Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  padding: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                  height: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: ColorResources.WHITE),
                  child: FormBuilderDropdown(
                      name: 'Your requirement',
                      allowClear: true,
                      style: Style.searchHint,
                      hint: Text("Your requirement"),
                      validator: FormBuilderValidators.compose(
                          [FormBuilderValidators.required(context)]),
                      items: ['I Want Vehicle', 'I Have Vehicle']
                          .map((value) => DropdownMenuItem(
                        value: value,
                        child: Text('$value',style: Style.dropdownValue,),
                      ))
                          .toList(),
                      onChanged: (String? value) {
                        setState(() {
                          selectedRequirementType = value!;
                        });
                      }),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  padding: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                  height: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: ColorResources.WHITE),
                  child: FormBuilderDropdown(
                      name: 'Post Type',
                      allowClear: true,
                      style: Style.searchHint,
                      hint: Text("Select Type"),
                      validator: FormBuilderValidators.compose(
                          [FormBuilderValidators.required(context)]),
                      items: ['Full Load', 'Part Load']
                          .map((value) => DropdownMenuItem(
                        value: value,
                        child: Text('$value',style: Style.dropdownValue,),
                      ))
                          .toList(),
                      onChanged: (String? value) {
                        setState(() {
                          selectedPostType = value!;
                        });
                      }),
                ),*//*
                CustomDropdownList(
                  hintText: "Select Requirement",
                  items: requirementList,
                  selectedType: selectedRequirementType,
                  onChange: (String value){
                    setState(() {
                      selectedRequirementType = value;
                    });
                  },
                ),
                CustomDropdownList(
                  hintText: "Select Post Type",
                  items: itemList,
                  selectedType: selectedPostType,
                  onChange: (String value){
                    setState(() {
                      selectedPostType = value;
                    });
                  },
                ),
                CustomCityTextField(
                  hintText: 'Select City From',
                  controller: selectedFromCity,
                  onTap: (){
                    showDialog(context: context,
                        builder: (BuildContext context){
                          return CustomCityListDialog(
                              onTap : (String value){
                                setState(() {
                                  selectedFromCity = value;
                                });
                              }
                          );
                        }
                    ) ;

                  },
                ),
                CustomCityTextField(
                  hintText: 'Select City To',
                  controller: selectedToCity,
                  onTap: (){
                    showDialog(context: context,
                        builder: (BuildContext context){
                          return CustomCityListDialog(
                              onTap : (String value){
                                setState(() {
                                  selectedToCity = value;
                                });
                              }
                          );
                        }
                    ) ;
                  },
                ),
                CustomDropdownList(
                  hintText: "Select Cargo Type",
                  items: cargoList,
                  selectedType: selectedCargoType,
                  onChange: (String value){
                    setState(() {
                      selectedCargoType = value;
                    });
                  },
                ),
                CustomTextField(
                  hintText: 'Vehicle Size',
                  controller: selectedVehicleSizeController,
                  textInputType: TextInputType.text,
                 ),
                CustomTextField(
                  hintText: 'Load Weight (In Tons)',
                  controller: loadWeightController,
                  textInputType: TextInputType.text,
                ),
                CustomTextField(
                  hintText: 'Special Instruction',
                  controller: instructionController,
                  textInputType: TextInputType.text,
                ),
                CustomTextField(
                  hintText: 'Mobile',
                  controller: TextEditingController(
                      text:
                      authProvider.userDetailList[0].mobileNumber.toString()),
                  textInputType: TextInputType.phone,
                  readOnly: true,
                ),
                CustomTextField(
                  hintText: 'Email',
                  controller: TextEditingController(
                      text: authProvider.userDetailList[0].emailId?? ''),
                  textInputType: TextInputType.emailAddress,
                  readOnly: true,
                ),
                CustomDropdownList(
                  hintText: "Select Type Of Payment",
                  items: paymentList,
                  selectedType: selectedTypeOfPayment,
                  onChange: (String value){
                    setState(() {
                      selectedTypeOfPayment = value;
                    });
                  },
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                  height: 25,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                     Text('Hide my identity',style: Style.heading1),
                      FlutterSwitch(
                        showOnOff: true,
                        activeColor: ColorResources.PRIMARY_COLOR,
                        activeTextColor: Colors.black,
                        inactiveTextColor: Colors.red,
                        value: identitySwitch,
                        onToggle: (val) {
                          setState(() {
                            identitySwitch = val;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                *//*Container(
                  margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Make this post private',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                          Text('Private posts are not visible to all in the general board,you will be able to share this post only with users you select.',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 12),),
                        ],
                      ),
                      FlutterSwitch(
                        showOnOff: true,
                        activeColor: ColorResources.PRIMARY_COLOR,
                        activeTextColor: Colors.black,
                        inactiveTextColor: Colors.red,
                        value: privateSwitch,
                        onToggle: (val) {
                          setState(() {
                            privateSwitch = val;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Do not disturb',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                          Text('Once you activate this, only Bid function work,chat & call will not work.',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 12),),
                        ],
                      ),
                      FlutterSwitch(
                        showOnOff: true,
                        activeColor: ColorResources.PRIMARY_COLOR,
                        activeTextColor: Colors.black,
                        inactiveTextColor: Colors.red,
                        value: disturbSwitch,
                        onToggle: (val) {
                          setState(() {
                            disturbSwitch = val;
                          });
                        },
                      ),
                    ],
                  ),
                ),*//*
                CustomButton(
                    onTap: () async{
    if (_formKey.currentState!.validate()) {
                     await model.savePost(
                          mobile: authProvider.userDetailList[0].mobileNumber ,
                          destination: selectedToCity,
                          dnd: 0,
                          email: authProvider.userDetailList[0].emailId,
                          fullLoadChoice: selectedPostType,
                          id: 1,
                          instruction: instructionController.text,
                          loadWeight: loadWeightController.text,
                          name: authProvider.userDetailList[0].userName,
                          mainTag: selectedPostType,
                          os: '',
                          otherDetails: instructionController.text,
                          source: selectedFromCity,
                          partLoad: selectedPostType == 'Part Load' ? 1 : 0,
                          privatePost: privateSwitch == true ? 1 : 0,
                          rating: 5,
                          customerName: '${authProvider.userDetailList[0].firstName} ${authProvider.userDetailList[0].lastName}',
                          type: selectedPostType,
                          typeOfCargo: selectedCargoType,
                          typeOfPayment: selectedTypeOfPayment,
                          vehicleSize: selectedVehicleSizeController.text,
                          userId: authProvider.userDetailList[0].id
                          );
                      print('pop');
                      Navigator.pop(context,"refresh");
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
            margin: EdgeInsets.only(left: 5.0),
            child:  Text(_item.text,style: TextStyle(fontSize: 16,fontWeight: FontWeight.normal),),
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