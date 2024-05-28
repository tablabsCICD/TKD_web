import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
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
import 'package:tkd_app/provider/job_provider.dart';
import 'package:tkd_app/util/ResponsiveWidget.dart';
import 'package:tkd_app/util/color-resource.dart';
import 'package:tkd_app/util/colors.dart';
import 'package:tkd_app/util/style.dart';
import 'package:tkd_app/view/base_widget/custom_button.dart';
import 'package:tkd_app/view/base_widget/custom_dropdown_list.dart';
import 'package:tkd_app/view/base_widget/custom_dropdown_search_multi_selection.dart';
import 'package:tkd_app/view/base_widget/custom_textfeild.dart';
import 'package:tkd_app/view/base_widget/cutom_city_textfield.dart';
import 'package:tkd_app/view/base_widget/getLoader.dart';
import 'package:tkd_app/view/screens/dashboard/show_option_dropdown.dart';
import 'package:tkd_app/view/screens/menu_page.dart';
import 'package:tkd_app/view/screens/my_routes/get_city_list.dart';
import 'package:tkd_app/widgets/bottomsheet.dart';
import 'package:tkd_app/widgets/drop_down.dart';

class CreateRequirement extends StatefulWidget {

  String postType;
  CreateRequirement(this.postType);

  @override
  _CreateRequirementState createState() => _CreateRequirementState();
}

class _CreateRequirementState extends State<CreateRequirement> {
  final authProvider = locator<AuthProvider>();
  static String  selectedRequirementType = '';
  static String selectedPostType = '';
  String selectedCargoType = '';
  String selectedTypeOfPayment = 'Immediate';

  List<String> requirementList = <String>['I Want Vehicle', 'I Have Vehicle'];
  List<String> itemList = <String>['Full Load', 'Part Load'];
  List<String> cargoList = <String>['Wooden Case','Cartons','Drums','Gunny Bags',"Machinery",'Other'];
  List<String> paymentList = <String>['Immediate','Fortnight','Weekly','Others'];
  String selectedFromCity = '';
  String selectedToCity = '';
  final _formKey = GlobalKey<FormState>();
  List<int> userIdList = [];
  TextEditingController selectedVehicleSizeController = TextEditingController();
  TextEditingController loadWeightController = TextEditingController();
  TextEditingController instructionController = TextEditingController();
  DashboardProvider provider = locator<DashboardProvider>();
  bool identitySwitch = false;
  bool privateSwitch = false;
  bool disturbSwitch = false;
  List<RadioModel> sampleData = <RadioModel>[
    RadioModel(true, 'Show to only Group'),
    RadioModel(false, 'Show to only verified Transporters'),
    RadioModel(false, 'Show to All')
  ];

  @override
  void initState() {
    selectedPostType = widget.postType;

      sampleData.add(new RadioModel(true, 'Show to only Group'));
      sampleData.add(new RadioModel(false, 'Show to only verified Transporters'));
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
          title: Text("Post load/vehicle requirement",style: Style.appheading,),
          shadowColor: Colors.white,
          leading: IconButton(icon:Icon(Icons.arrow_back,color: Colors.black,),onPressed:(){
            Navigator.pop(context,1);
          } ,),
        ),

        body: Container(
          child: Form(
            key: _formKey,
            child: Consumer<DashboardProvider>(

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
                    items: requirementList,
                    selectedType: selectedRequirementType,
                    onChange: (String value){
                      // setState(() {
                      //   selectedRequirementType = value;
                      // });
                      selectedRequirementType=value;
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
                                  provider.getListOfVefiyUser(selectedFromCity);
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
                      onValueChange: (){
                        setState(() {

                        });
                      }

                  ),
                  CustomTextField(
                      hintText: 'Special Instruction',
                      controller: instructionController,
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
                    items: paymentList,
                    selectedType: selectedTypeOfPayment,
                    onChange: (String value){
                      setState(() {
                        selectedTypeOfPayment = value;
                      });
                    },
                  ),
                 Container(
                   margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                   padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                   height: 50,
                   decoration: ShapeDecoration(
                     color: Colors.white,
                     shape: RoundedRectangleBorder(
                       side: BorderSide(width: 1, color: Colors.black54),
                       borderRadius: BorderRadius.circular(8),
                     ),
                   ),
                   child: TextFormField(
                      decoration:InputDecoration(
                        hintText: "Show Post To",
                        border: InputBorder.none,
                      ),
                     controller: TextEditingController(
                         text: userIdList.isEmpty?"All Users":"Groups"),
                     readOnly: true,
                     style: TextStyle(
                       fontSize: 12,
                       fontFamily: GoogleFonts.poppins().fontFamily,
                       color: Colors.black
                     ),
                     onTap: ()  async{
                       userIdList = await showDialog(context: context,
                           builder: (BuildContext context){
                             return ShowOptionDropDown(selectedFromCity);
                           }
                       );
                       print(userIdList.length);
                       setState(() {
                       });
                     },
                   ),
                 ),

                 /*     Text("Show Post To:",style: TextStyle(fontFamily: GoogleFonts.poppins().fontFamily,fontSize: 16),),
                      CustomTextField(
                        hintText: 'Show Post To',
                        controller: TextEditingController(
                            text: userIdList==[]?"All Users":"Groups"),
                        textInputType: TextInputType.emailAddress,
                        readOnly: true,
                        onValueChange: ()  {
                          setState(()async {
                          userIdList = await showDialog(context: context,
                              builder: (BuildContext context){
                                return ShowOptionDropDown(selectedFromCity);
                              }
                          );
                          print(userIdList.length);

                          });
                        },

                      ),*/
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
                            setState(() async {
                              identitySwitch = val;
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
                              value: disturbSwitch,
                              onToggle: (val) {
                                setState(() {
                                  disturbSwitch = val;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                  CustomButton(
                      onTap: () async{
                        if (_formKey.currentState!.validate()) {
                          var result = await model.savePost(context,
                            mobile: authProvider.userDetailList[0].mobileNumber ,
                            destination: selectedToCity,
                            email: authProvider.userDetailList[0].emailId,
                            fullLoadChoice: selectedRequirementType,
                            id: 0,
                            instruction: instructionController.text,
                            loadWeight: loadWeightController.text,
                            name: authProvider.userDetailList[0].userName,
                            mainTag: selectedPostType,
                            os: 'App',
                            otherDetails: instructionController.text,
                            source: selectedFromCity,
                            partLoad: selectedPostType == 'Part Load' ? 1 : 0,
                            privatePost: identitySwitch == true ? 1 : 0,
                            rating: 5,
                            dnd:disturbSwitch == true ? 1 : 0,
                            customerName: '${authProvider.userDetailList[0].firstName} ${authProvider.userDetailList[0].lastName}',
                            type: selectedPostType,
                            typeOfCargo: selectedCargoType,
                            typeOfPayment: selectedTypeOfPayment,
                            vehicleSize: selectedVehicleSizeController.text,
                            selectedUserList: userIdList
                            //   userId: authProvider.userDetailList[0].id
                          ).then((value) => {

                          });
                          if(result == true) {

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
                                isFlip: false);

                          }else{
                            Navigator.of(context).pop();
                          }
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
           // width: MediaQuery.of(context).size.width -165,
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