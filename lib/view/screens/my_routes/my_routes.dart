
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:tkd_app/dialog/CustomCityListDialog.dart';
import 'package:tkd_app/dialog/CustomStateListDialog.dart';
import 'package:tkd_app/locator.dart';
import 'package:tkd_app/provider/auth_provider.dart';
import 'package:tkd_app/provider/route_provider.dart';
import 'package:tkd_app/util/ResponsiveWidget.dart';
import 'package:tkd_app/util/color-resource.dart';
import 'package:tkd_app/util/style.dart';
import 'package:tkd_app/view/base_widget/custom_button.dart';
import 'package:tkd_app/view/base_widget/custom_textfeild.dart';
import 'package:tkd_app/view/base_widget/custom_textview.dart';
import 'package:tkd_app/view/base_widget/cutom_city_textfield.dart';
import 'package:tkd_app/view/localization/language_constrants.dart';
import 'package:tkd_app/view/screens/my_routes/get_city_list.dart';

class MyRoutes extends StatefulWidget {
  @override
  _MyRoutesState createState() => _MyRoutesState();
}

class _MyRoutesState extends State<MyRoutes> {
  TextEditingController fromCityController = TextEditingController();
  TextEditingController toCityController = TextEditingController();
  final routeProvider = locator<RouteProvider>();
  final authProvider = locator<AuthProvider>();
  String? selectedFromCity = '',selectedToCity = "";
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    routeProvider.getRouteListByUserId(authProvider.userDetailList[0].id!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.HOME_BG,
      body: Form(
        key: _formKey,
        child: Consumer<RouteProvider>(
            builder: (context, model, child) =>
            Container(
            alignment: Alignment.center,
            margin: ResponsiveWidget.isDesktop(context)? EdgeInsets.symmetric(horizontal: 200,vertical: 10):ResponsiveWidget.isMobile(context)?EdgeInsets.symmetric(horizontal: 0,vertical: 10):EdgeInsets.symmetric(horizontal: 100,vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.center,
                  child: CustomText(getTranslated('my_route_label',context)!,style: Style.title,textAlign: TextAlign.center,),
                ),
                SizedBox(height: ResponsiveWidget.isDesktop(context)?50:30,),
                CustomCityTextField(
                  hintText: 'Select City',
                  controller: selectedFromCity!,
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
                  hintText: 'Select City',
                  controller: selectedToCity!,
                  onTap: (){
                    showDialog(context: context,
                        builder: (BuildContext context){
                          return CustomCityListDialog(
                              onTap : (String value){
                                setState(() {
                                  if(value != selectedFromCity){
                                    selectedToCity = value;
                                  }else{
                                    showDialog(
                                        context: context,
                                        builder: (_) => new CupertinoAlertDialog(
                                          title: Column(
                                            children: [
                                              CustomText(
                                                  'Source and destination should not be same',
                                                  style: TextStyle(
                                                      color: ColorResources.BOTTOM_HEADING,
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.bold)),
                                              CustomText(
                                                  'Please select different destination',
                                                  style: TextStyle(
                                                      color: ColorResources.BOTTOM_HEADING,
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.normal)),
                                            ],
                                          ),

                                          actions: <Widget>[
                                            TextButton(
                                              child: Padding(
                                                padding: const EdgeInsets.all(10.0),
                                                child: Text(getTranslated('ok', context)!,
                                                    style: TextStyle(
                                                        color: Colors.red, fontSize: 18)),
                                              ),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        ));
                                  }

                                });
                              }
                          );
                        }
                    ) ;
                  },
                ),

                SizedBox(height: ResponsiveWidget.isDesktop(context)?50:30,),
                Container(
                  alignment: Alignment.center,
                  child: CustomButton(
                      onTap: (){
    if (_formKey.currentState!.validate()) {
                        if(model.routeList.length <= 4){
                          model.createRoute(userName : authProvider.userDetailList[0].userName,source: selectedFromCity,destination: selectedToCity,id: 1,userId: authProvider.userDetailList[0].id);
                          selectedFromCity='';
                          selectedToCity='';
                        }else{
                          showDialog(
                              context: context,
                              builder: (_) => new CupertinoAlertDialog(
                                title: Column(
                                  children: [
                                    CustomText(
                                        'Maximum Routes Reached',
                                        style: TextStyle(
                                            color: ColorResources.BOTTOM_HEADING,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold)),
                                    CustomText(
                                        'You can have maximum 05 routes. In order to add another route, please delete one of the existing routes',
                                        style: TextStyle(
                                            color: ColorResources.BOTTOM_HEADING,
                                            fontSize: 15,
                                            fontWeight: FontWeight.normal)),
                                  ],
                                ),

                                actions: <Widget>[
                                  TextButton(
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: CustomText("Ok",
                                          style: TextStyle(
                                              color: Colors.red, fontSize: 18)),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              ));
                        }

                      }},
                      buttonText: getTranslated('add', context)),
                ),
                SizedBox(height: ResponsiveWidget.isDesktop(context)?50:30,),
                model.routeList.isEmpty ? Container(
                  alignment: Alignment.center,
                  child:CustomText('Add Your Business Route',style: Style.contentHeading,)
                )
                :Container(
                  padding: EdgeInsets.only(bottom: 20),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: model.routeList.length,
                    padding: EdgeInsets.only(bottom: 20),
                    scrollDirection: Axis.vertical,
                    itemBuilder: (contex,index){
                      return Container(
                        height: 50,
                        color: index.isEven
                            ? ColorResources.HOME_APPBAR
                            : ColorResources.HOME_BG,
                        child: ListTile(
                          title: Row(
                            children: [
                           Text('${model.routeList[index].routeSource}'),
                              SizedBox(width: 10,),
                              Image.asset('assets/images/two_way_arrow.png',height: 15,width: 25,),
                              SizedBox(width: 10,),
                            Text('${model.routeList[index].routeDestination}'),
                            ],
                          ),//Text('${model.routeList[index].routeSource} To ${model.routeList[index].routeDestination}',style: Style.cityHeading,),
                          trailing: ElevatedButton(
                            onPressed: (){
                              model.deleteRoute(model.routeList[index]);
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.red[200],
                              onPrimary: Colors.white,
                              elevation: 3,
                            ),
                            child: CustomText(getTranslated('delete', context)!,style: Style.button,),
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
