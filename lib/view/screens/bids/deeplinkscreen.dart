import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tkd_app/locator.dart';
import 'package:tkd_app/model/deep_link_load.dart';
import 'package:tkd_app/provider/auth_provider.dart';
import 'package:tkd_app/util/app_constants.dart';
import 'package:tkd_app/view/screens/bids/received_bids.dart';
import 'package:tkd_app/view/screens/bids/show_bidds.dart';
import 'package:tkd_app/view/screens/dashboard/sharedPostDetailsScreen.dart';
import 'package:tkd_app/view/screens/menu_page.dart';
import 'package:tkd_app/widgets/toast.dart';
import 'package:tkd_app/model/truck_load_model.dart';

import 'package:http/http.dart' as http;

class DeepLink extends StatefulWidget{
 final String id;

  const DeepLink({ required this.id});

  @override
  State<StatefulWidget> createState() {
    return _DeppLink();
  }




}
class _DeppLink extends State<DeepLink>{
  @override
  void initState() {
    callApiPost();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
  return const Scaffold(
    body: Center(
      child: CircularProgressIndicator(),
    ),

  );
  }

  final authProvider = locator<AuthProvider>();
  callApiPost()async{
    try{
     // ApiResponse apiResponse=await ApiHelper().apiWithoutDecodeGet("${ApiConstant.BASE_URL}fullTruckLoad/${widget.id}");
      String myUrl = ApiConstant.BASE_URL + 'fullTruckLoad/${widget.id}';
      print(myUrl);
      var req = await http.get(Uri.parse(myUrl));
      var response = await json.decode(req.body);
      print('the response status code ${req.statusCode}');
      if(req.statusCode==200){
        print('the response ${response}');
        TruckDeep truckLoadType =TruckDeep.fromJson(response);
        TruckLoad load=truckLoadType.content!.first;

        if(load.mobileNumber==authProvider.userDetailList[0].mobileNumber){
          print('the response in navi');
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (builder) =>
                      MenuPage(userDetailList: authProvider.userDetailList,selectedTab:"Received Quotes")));
        //  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>ReceivedBidsScreen()));
        }else{
          print('the response in deep');
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=>SharedPostDetails(load)));
        }
      }else{
        ToastMessage.show(context, "Error to find the load");
        Navigator.push(context, MaterialPageRoute(builder: (builder)=>MenuPage(userDetailList: authProvider.userDetailList,selectedTab:"Board")));

      }
    }catch(e){
      ToastMessage.show(context, "Post is not avilable");
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }

    }

  }

}
