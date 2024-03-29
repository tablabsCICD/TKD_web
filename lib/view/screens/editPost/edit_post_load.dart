import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tkd_app/dialog/CustomCityListDialog.dart';
import 'package:tkd_app/dialog/animated_custom_dialog.dart';
import 'package:tkd_app/dialog/my_dialog.dart';
import 'package:tkd_app/locator.dart';
import 'package:tkd_app/model/truck_load_model.dart';
import 'package:tkd_app/provider/auth_provider.dart';
import 'package:tkd_app/provider/dashboard_provider.dart';
import 'package:tkd_app/provider/edit_post_provider.dart';
import 'package:tkd_app/util/color-resource.dart';
import 'package:tkd_app/util/style.dart';
import 'package:tkd_app/view/base_widget/custom_button.dart';
import 'package:tkd_app/view/base_widget/custom_dropdown_list.dart';
import 'package:tkd_app/view/base_widget/custom_dropdown_search_multi_selection.dart';
import 'package:tkd_app/view/base_widget/custom_textfeild.dart';
import 'package:tkd_app/view/base_widget/cutom_city_textfield.dart';


class EditPostLoadScreen extends StatefulWidget {
  TruckLoad postBidData;
  final editProvider = locator<EditPostLoadProvider>();

  EditPostLoadScreen(this.postBidData,{Key? key}) : super(key: key) {
    editProvider.initData(postBidData);
  }

  @override
  State<StatefulWidget> createState() {
    return _EditPostLoadScreen();
  }
}

class _EditPostLoadScreen extends State<EditPostLoadScreen> {
  final authProvider = locator<AuthProvider>();
  final provider = locator<DashboardProvider>();
  final _formKey = GlobalKey<FormState>();


  @override
  void initState() {
    provider.getAllUserList();
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
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text("Edit Post load/vehicle requirement",style: Style.appheading,),
          shadowColor: Colors.white,
          leading: IconButton(icon:Icon(Icons.arrow_back,color: Colors.black,),onPressed:(){
            Navigator.pop(context,1);
          } ,),
        ),

        body: Container(
          child: Form(
            key: _formKey,
            child: Consumer<EditPostLoadProvider>(

              builder: (context, model, child) => Container(
                // margin: ResponsiveWidget.isDesktop(context)? EdgeInsets.symmetric(horizontal: 50,vertical: 10):EdgeInsets.symmetric(horizontal: 0,vertical: 0),
                child: SingleChildScrollView(
                  child: Column(
                    children:[
                      Container(
                          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          alignment: Alignment.center,
                          child: Text('Requirement you post will be visible on the general board to vendors whose routes match to yours.',style: Style.appsubtitle,)),

                      CustomDropdownList(
                        hintText: "Select Requirement",
                        items: model.requirementList,
                        selectedType: model.selectedRequirementType,
                        onChange: (String value){
                          // setState(() {
                          //   selectedRequirementType = value;
                          // });
                          model.selectedRequirementType=value;
                        },
                      ),
                      CustomDropdownList(
                        hintText: "Select Post Type",
                        items: model.itemList,
                        selectedType: model.selectedPostType,
                        onChange: (String value){
                          setState(() {
                            model.selectedPostType = value;
                          });
                        },
                      ),
                      CustomCityTextField(
                        hintText: 'Select City From',
                        controller: model.selectedFromCity,
                        onTap: (){
                          showDialog(context: context,
                              builder: (BuildContext context){
                                return CustomCityListDialog(
                                    onTap : (String value){
                                      setState(() {
                                        model.selectedFromCity = value;
                                      });
                                    }
                                );
                              }
                          ) ;

                        },
                      ),
                      CustomCityTextField(
                        hintText: 'Select City To',
                        controller: model.selectedToCity,
                        onTap: (){
                          showDialog(context: context,
                              builder: (BuildContext context){
                                return CustomCityListDialog(
                                    onTap : (String value){
                                      setState(() {
                                        model.selectedToCity = value;
                                      });
                                    }
                                );
                              }
                          ) ;
                        },
                      ),
                      CustomDropdownList(
                        hintText: "Select Cargo Type",
                        items: model.cargoList,
                        selectedType: model.selectedCargo,
                        onChange: (String value){
                          setState(() {
                            model.selectedCargo = value;
                          });
                        },
                      ),
                      CustomTextField(
                        hintText: 'Vehicle Size',
                        controller: model.selectedVehicleSizeController,
                        textInputType: TextInputType.text,
                      ),
                      CustomTextField(
                          hintText: 'Load Weight (In Tons)',
                          controller: model.loadWeightController,
                          textInputType: TextInputType.text,
                          onValueChange: (){
                            setState(() {

                            });
                          }

                      ),
                      CustomTextField(
                          hintText: 'Special Instruction',
                          controller: model.instructionController,
                          textInputType: TextInputType.text,
                          onValueChange: (){
                            setState(() {

                            });
                          }
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
                        onValueChange: (){
                          setState(() {

                          });
                        },

                      ),
                      CustomDropdownList(
                        hintText: "Select Type Of Payment",
                        items: model.paymentList,
                        selectedType: model.selectedTypeOfPayment,
                        onChange: (String value){
                          setState(() {
                            model.selectedTypeOfPayment = value;
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
                              value: model.identitySwitch,
                              onToggle: (val) {
                                setState(() {
                                  model.identitySwitch = model.selectedSampleData == "Show To All"? false : val;
                                  if(model.identitySwitch == true){
                                    showDialog(context: context,
                                        builder: (BuildContext context){
                                          return CustomDropdownSearchMultiSelection(labelText: "Select Transporters", itemList: provider.allUserNameList, selectedItems: provider.searchingList,allUserList : provider.allUserList);
                                        }
                                    ) as List<String> ;

                                  }
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                        height: 25,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Do Not Disturb',style: Style.heading1),
                            FlutterSwitch(
                              showOnOff: true,
                              valueFontSize: 12,
                              activeColor: ColorResources.PRIMARY_COLOR,
                              activeTextColor: Colors.black,
                              inactiveTextColor: Colors.red,
                              value: model.disturbSwitch,
                              onToggle: (val) {
                                setState(() {
                                  model.disturbSwitch = val;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      CustomButton(
                          onTap: () async{
                            if (_formKey.currentState!.validate()) {
                              var result = await model.editPost(
                               context,widget.postBidData.id
                                //   userId: authProvider.userDetailList[0].id
                              ).then((value) => {
                                showAnimatedDialog(
                                    context,
                                    MyDialog(
                                      icon: Icons.check,
                                      title:
                                      'Edit Post',
                                      description:
                                      'Your post editted successfully',
                                      isFailed: false,
                                      isFromPost: true,
                                    ),
                                    dismissible: false,
                                    isFlip: false),
                              });
                              if(result) {

                                Navigator.of(context).pop();

                              }
                            }},
                          buttonText: "Edit Post")
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