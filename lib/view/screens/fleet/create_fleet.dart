import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:tkd_app/locator.dart';
import 'package:tkd_app/provider/auth_provider.dart';
import 'package:tkd_app/provider/fleet_provider.dart';
import 'package:tkd_app/provider/job_provider.dart';
import 'package:tkd_app/provider/route_provider.dart';
import 'package:tkd_app/util/ResponsiveWidget.dart';
import 'package:tkd_app/util/color-resource.dart';
import 'package:tkd_app/util/style.dart';
import 'package:tkd_app/view/base_widget/custom_button.dart';
import 'package:tkd_app/view/base_widget/custom_dropdown_list.dart';
import 'package:tkd_app/view/base_widget/custom_textfeild.dart';
import 'package:tkd_app/view/localization/language_constrants.dart';

import 'package:tkd_app/view/screens/menu_page.dart';
import 'package:tkd_app/view/screens/my_routes/get_city_list.dart';

class CreateFleet extends StatefulWidget {
  final fleetProvider = locator<FleetProvider>();
  @override
  _CreateFleetState createState() => _CreateFleetState();
}

class _CreateFleetState extends State<CreateFleet> {
  String selectedVehicleType = '';
  TextEditingController vehicleNumber = TextEditingController();
  TextEditingController weight = TextEditingController();
  TextEditingController fromCityController = TextEditingController();
  TextEditingController toCityController = TextEditingController();
  final auth = locator<AuthProvider>();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Consumer<AuthProvider>(
        builder: (context, model, child) =>
            Container(
              margin: ResponsiveWidget.isDesktop(context)? EdgeInsets.symmetric(horizontal: 50,vertical: 10):ResponsiveWidget.isMobile(context)?EdgeInsets.symmetric(horizontal: 20,vertical: 10):EdgeInsets.symmetric(horizontal: 100,vertical: 10),
              child: ListView(
                shrinkWrap: true,
                children: [
                  CustomDropdownList(
                    hintText: 'Vehicle Type',
                    items: ['Truck','Container','Trailor','Hyva','Tanker','LCV'],
                    selectedType: selectedVehicleType,
                    onChange: (String value){
                      setState(() {
                        selectedVehicleType = value;
                      });
                    },
                  ),

                  CustomTextField(
                    hintText: 'Vehicle Number',
                    controller: vehicleNumber,
                    textInputType: TextInputType.text,
                  ),
                  CustomTextField(
                    hintText: 'Weight In Tonnes',
                    controller: weight,
                    textInputType: TextInputType.text,
                  ),
                  /* Consumer<RouteProvider>(
                      builder: (context, model, child) =>
                          Container(
                            alignment: Alignment.center,
                            margin: ResponsiveWidget.isDesktop(context)? EdgeInsets.symmetric(horizontal: 200,vertical: 10):ResponsiveWidget.isMobile(context)?EdgeInsets.symmetric(horizontal: 20,vertical: 10):EdgeInsets.symmetric(horizontal: 100,vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  child: Text(getTranslated('my_route_label',context)!,style: TextStyle(color: Colors.black,fontSize: 16),),
                                ),
                                SizedBox(height: 50,),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => GetCityList()))
                                        .then((value) {
                                      if (value.toString().isNotEmpty && value != null) {
                                        fromCityController.text = value[0];
                                      }
                                    });
                                  },
                                  child: Container(
                                    margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                    padding: EdgeInsets.symmetric(vertical: 3,horizontal: 5),
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black12,
                                          offset: Offset(0, 0),
                                          blurRadius: 5,
                                          spreadRadius: 0,
                                        ),
                                      ],
                                    ),
                                    child: TextField(
                                      enabled: false,
                                      controller: fromCityController,
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: getTranslated('from', context)),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                  padding: EdgeInsets.symmetric(vertical: 3,horizontal: 5),
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        offset: Offset(0, 0),
                                        blurRadius: 5,
                                        spreadRadius: 0,
                                      ),
                                    ],
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => GetCityList()))
                                          .then((value) {
                                        if (value.toString().isNotEmpty && value != null) {
                                          toCityController.text = value[0];
                                        }
                                      });
                                    },
                                    child:TextField(
                                      enabled: false,
                                      controller: toCityController,

                                      decoration: InputDecoration(border: InputBorder.none,
                                          hintText: getTranslated('to', context)),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 50,),
                                Container(
                                  alignment: Alignment.center,
                                  child: CustomButton(
                                      onTap: (){
                                        model.createRoute(userName : auth.userDetailList[0].userName,source: fromCityController.text,destination: toCityController.text,id: 1,userId: auth.userDetailList[0].id);
                                        fromCityController.clear();
                                        toCityController.clear();
                                      },
                                      buttonText: getTranslated('add', context)),
                                ),
                                SizedBox(height: 50,),
                                model.routeList.isEmpty ? Container(
                                    alignment: Alignment.center,
                                    child:Text('Add Your Business Route')
                                )
                                    :Container(
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: model.routeList.length,
                                    itemBuilder: (contex,index){
                                      return Container(
                                        height: 70,
                                        color: index.isEven
                                            ? Colors.blueGrey[200]
                                            : Colors.grey[200],
                                        child: ListTile(
                                          title: Text('${model.routeList[index].routeSource} To ${model.routeList[index].routeDestination}'),
                                          trailing: ElevatedButton(
                                            onPressed: (){
                                              model.deleteRoute(model.routeList[index]);
                                            },
                                            child: Text(getTranslated('delete', context)!),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                    ),*/
                  CustomButton(onTap: (){
                    if (_formKey.currentState!.validate()) {
                      widget.fleetProvider.createFleet(userName: selectedVehicleType,
                          orgId : auth.userDetailList[0].companyId,
                          typeOfVehicle : selectedVehicleType,
                          userId : auth.userDetailList[0].id,vehicleNumber : vehicleNumber.text,weight : weight.text);
                      Navigator.of(context).pop();}
                  },
                      buttonText: "Create Fleet")
                ],
              ),
            ),
      ),
    );
    /*return Scaffold(
      appBar: AppBar(
        title: Text('Create Fleet',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
        backgroundColor: ColorResources.PRIMARY_COLOR,
      ),
      backgroundColor: ColorResources.HOME_BG,
      body: Form(
        key: _formKey,
        child: Consumer<AuthProvider>(
          builder: (context, model, child) =>
              Container(
                margin: ResponsiveWidget.isDesktop(context)? EdgeInsets.symmetric(horizontal: 200,vertical: 10):ResponsiveWidget.isMobile(context)?EdgeInsets.symmetric(horizontal: 20,vertical: 10):EdgeInsets.symmetric(horizontal: 100,vertical: 10),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    CustomDropdownList(
                      hintText: 'Vehicle Type',
                      items: ['Truck','Container','Trailor','Hyva','Tanker','LCV'],
                      selectedType: selectedVehicleType,
                      onChange: (String value){
                        setState(() {
                          selectedVehicleType = value;
                        });
                      },
                    ),

                    CustomTextField(
                      hintText: 'Vehicle Number',
                      controller: vehicleNumber,
                      textInputType: TextInputType.text,
                    ),
                    CustomTextField(
                      hintText: 'Weight In Tonnes',
                      controller: weight,
                      textInputType: TextInputType.text,
                    ),
                   *//* Consumer<RouteProvider>(
                      builder: (context, model, child) =>
                          Container(
                            alignment: Alignment.center,
                            margin: ResponsiveWidget.isDesktop(context)? EdgeInsets.symmetric(horizontal: 200,vertical: 10):ResponsiveWidget.isMobile(context)?EdgeInsets.symmetric(horizontal: 20,vertical: 10):EdgeInsets.symmetric(horizontal: 100,vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  child: Text(getTranslated('my_route_label',context)!,style: TextStyle(color: Colors.black,fontSize: 16),),
                                ),
                                SizedBox(height: 50,),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => GetCityList()))
                                        .then((value) {
                                      if (value.toString().isNotEmpty && value != null) {
                                        fromCityController.text = value[0];
                                      }
                                    });
                                  },
                                  child: Container(
                                    margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                    padding: EdgeInsets.symmetric(vertical: 3,horizontal: 5),
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black12,
                                          offset: Offset(0, 0),
                                          blurRadius: 5,
                                          spreadRadius: 0,
                                        ),
                                      ],
                                    ),
                                    child: TextField(
                                      enabled: false,
                                      controller: fromCityController,
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: getTranslated('from', context)),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                  padding: EdgeInsets.symmetric(vertical: 3,horizontal: 5),
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        offset: Offset(0, 0),
                                        blurRadius: 5,
                                        spreadRadius: 0,
                                      ),
                                    ],
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => GetCityList()))
                                          .then((value) {
                                        if (value.toString().isNotEmpty && value != null) {
                                          toCityController.text = value[0];
                                        }
                                      });
                                    },
                                    child:TextField(
                                      enabled: false,
                                      controller: toCityController,

                                      decoration: InputDecoration(border: InputBorder.none,
                                          hintText: getTranslated('to', context)),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 50,),
                                Container(
                                  alignment: Alignment.center,
                                  child: CustomButton(
                                      onTap: (){
                                        model.createRoute(userName : auth.userDetailList[0].userName,source: fromCityController.text,destination: toCityController.text,id: 1,userId: auth.userDetailList[0].id);
                                        fromCityController.clear();
                                        toCityController.clear();
                                      },
                                      buttonText: getTranslated('add', context)),
                                ),
                                SizedBox(height: 50,),
                                model.routeList.isEmpty ? Container(
                                    alignment: Alignment.center,
                                    child:Text('Add Your Business Route')
                                )
                                    :Container(
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: model.routeList.length,
                                    itemBuilder: (contex,index){
                                      return Container(
                                        height: 70,
                                        color: index.isEven
                                            ? Colors.blueGrey[200]
                                            : Colors.grey[200],
                                        child: ListTile(
                                          title: Text('${model.routeList[index].routeSource} To ${model.routeList[index].routeDestination}'),
                                          trailing: ElevatedButton(
                                            onPressed: (){
                                              model.deleteRoute(model.routeList[index]);
                                            },
                                            child: Text(getTranslated('delete', context)!),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                    ),*//*
                    CustomButton(onTap: (){
      if (_formKey.currentState!.validate()) {
                      widget.fleetProvider.createFleet(userName: selectedVehicleType,
                          orgId : auth.userDetailList[0].companyId,
                          typeOfVehicle : selectedVehicleType,
                          userId : auth.userDetailList[0].id,vehicleNumber : vehicleNumber.text,weight : weight.text);
                      Navigator.of(context).pop();}
                    },
                        buttonText: "Create Fleet")
                  ],
                ),
              ),
        ),
      ),
    );*/
  }
}
