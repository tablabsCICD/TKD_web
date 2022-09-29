

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tkd_app/dialog/animated_custom_dialog.dart';
import 'package:tkd_app/locator.dart';
import 'package:tkd_app/model/feet_model.dart';
import 'package:tkd_app/model/truck_load_model.dart';
import 'package:tkd_app/open_whatsapp.dart';
import 'package:tkd_app/provider/auth_provider.dart';
import 'package:tkd_app/provider/bid_provider.dart';
import 'package:tkd_app/provider/route_provider.dart';
import 'package:tkd_app/share_data.dart';
import 'package:tkd_app/util/ResponsiveWidget.dart';
import 'package:tkd_app/util/color-resource.dart';
import 'package:tkd_app/util/custom_text_style.dart';
import 'package:tkd_app/util/date_converter.dart';
import 'package:tkd_app/util/star_display.dart';
import 'package:tkd_app/util/style.dart';
import 'package:tkd_app/view/base_widget/custom_button.dart';
import 'package:tkd_app/view/base_widget/custom_textfeild.dart';
import 'package:tkd_app/view/base_widget/rating_star.dart';
import 'package:tkd_app/view/screens/my_routes/get_city_list.dart';

class FleetDetails extends StatefulWidget {
  Fleet fleet;
  FleetDetails(this.fleet);

  @override
  _FleetDetailsState createState() => _FleetDetailsState();
}

class _FleetDetailsState extends State<FleetDetails> {

  TextEditingController fromCityController = TextEditingController();
  TextEditingController toCityController = TextEditingController();
  TextEditingController destinationController = TextEditingController();
  final authProvider = locator<AuthProvider>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorResources.PRIMARY_COLOR,
        title: Text('Fleet Details'),),
      body: Container(
        child: ResponsiveWidget.isMobile(context)
            ? Stack(children: [
          Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fill,
                image: NetworkImage('assets/images/truck.png'),
              ),
            ),
            child: getCart()
          ),
        ])
            : Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage('assets/images/truck.png'),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: getCart(),
            ),

          ],
        ),
      ),

    );
  }

  getCart(){
    return Container(
      width: ResponsiveWidget.isMobile(context) ? MediaQuery.of(context).size.width : MediaQuery.of(context).size.width/2,
      child: Card(
        color: Colors.transparent,
        elevation: 5,
        margin: EdgeInsets.all(10),
        child: ListView(
          children: [
            ListTile(
              contentPadding:
              EdgeInsets.symmetric(vertical: 0, horizontal: 5),
              horizontalTitleGap: 5,
              minVerticalPadding: 0,
              title: Text(
                  authProvider.userDetailList[0].firstName
                      .toString(),
                  style: Style.title),
              subtitle: Text(
                  authProvider.userDetailList[0].companyName.toString(),
                  style: Style.subtitle),
              trailing: ConvertStringToDate(authProvider.userDetailList[0].paidStartDate
                  .toString()),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 10.0, bottom: 10, right: 10),
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Vehicle Type',
                        style: regularTextStyle,
                      ),
                      Text('Vehicle Number', style: regularTextStyle),
                      Text('Weight', style: regularTextStyle),
                    ],
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ': ${widget.fleet.typeOfVehicle.toString()}',
                        style: TextStyle(
                            color: ColorResources.PRIMARY_COLOR),
                      ),
                      Text(
                        ': ${widget.fleet.vehicleNumber.toString()}',
                        style: TextStyle(
                            color: ColorResources.PRIMARY_COLOR),
                      ),
                      Text(
                        ': ${widget.fleet.weightInTonnes.toString()}',
                        style: TextStyle(
                            color: ColorResources.PRIMARY_COLOR),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Divider(
              height: 1.5,
              thickness: 1.5,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 10.0, vertical: 7),
              child: Text(
                  'Add Routes',
                  style: titilliumSemiBold),
            ),
            Consumer<RouteProvider>(
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
                          child: Text('To get maximum Business please add the route of your business operations- maximum 05 route',style: TextStyle(color: Colors.black,fontSize: 12),),
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
                                borderRadius: BorderRadius.circular(10),
                                color:ColorResources.WHITE
                            ),
                            child: TextField(
                              enabled: false,
                              controller: fromCityController,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Select from location"),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                          padding: EdgeInsets.symmetric(vertical: 3,horizontal: 5),
                          height: 40,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color:ColorResources.WHITE
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
                                  hintText: "Select to location"),
                            ),
                          ),
                        ),
                        SizedBox(height: 50,),
                        Container(
                          alignment: Alignment.center,
                          child: CustomButton(
                              onTap: (){
                                model.createRoute(userName : authProvider.userDetailList[0].userName,source: fromCityController.text,destination: toCityController.text,id: 1,userId: authProvider.userDetailList[0].id);
                                fromCityController.clear();
                                toCityController.clear();
                              },
                              buttonText: "Add Route"),
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
                                    child: Text('Delete'),
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
          ],
        ),
      ),
    );
  }
}
