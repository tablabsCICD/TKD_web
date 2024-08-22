import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tkd_app/model/route_model.dart';
import 'package:tkd_app/util/app_constants.dart';

class RouteProvider extends ChangeNotifier{
  List<RouteData> routeList = [];
  List<DummyRoute> dummyRouteList = [];

  getRouteListByUserId(int id) async {
    String myUrl = ApiConstant.ROUTE +'/userId/${id}';
    var req = await http.get(Uri.parse(myUrl));
    var response = json.decode(req.body);
    var type = RouteModel.fromJson(response);
    routeList = type.content;
    notifyListeners();
  }

  addDataFromDummyListToRouteList() async {
    SharedPreferences preferences=await SharedPreferences.getInstance();
    String? uname = await preferences.getString("userName")!;
    int? id = await preferences.getInt("id")!;
    print("Id :::::: ${id}    UserName ::::::: ${uname}");
    if(dummyRouteList.isNotEmpty){
      dummyRouteList.forEach((element) {
        createRoute(
            userName : uname,source: element.source,destination: element.destination,
            id: 1,userId: id);
      });
      print("Dummy Route List Length : "+dummyRouteList.length.toString());
      dummyRouteList = [];
      print("Route List Length : "+routeList.length.toString());
    }
    notifyListeners();
  }


  addDummyRoute(String? source,String? destination){
    dummyRouteList.add(DummyRoute(source, destination));
    notifyListeners();
    print(dummyRouteList.length);
    print(dummyRouteList);
  }

  createRoute({String? userName,String? source,String? destination,int? id,int? userId}) async {
    String myUrl = ApiConstant.ROUTE;
    Uri uri = Uri.parse(myUrl);
    Map<String, dynamic> data = {
      "id": id,
      "loggedTime": "",
      "loggedUserName": userName,
      "routeDestination": destination,
      "routeSource": source,
      "userId": userId
    };
    var body = json.encode(data);
    print(data);
    var createResponse = await http.post(uri,
        headers: {"Content-Type": "application/json"}, body: body);
    print("${createResponse.statusCode}" + " --- " + createResponse.body.toString());
    var jsonData = jsonDecode(createResponse.body);
    RouteData routeData = RouteData.fromJson(jsonData);
    routeList.add(routeData);
    notifyListeners();
  }

  deleteRoute(RouteData obj) async {
    String myUrl = ApiConstant.ROUTE +'?id=${obj.id}';
    var req = await http.delete(Uri.parse(myUrl));
    json.decode(req.body);
    routeList.remove(obj);
    notifyListeners();
  }

  deleteDummyRoute(DummyRoute obj) async {
    dummyRouteList.remove(obj);
    notifyListeners();
  }
}

class DummyRoute{
  String? source,destination;

  DummyRoute(this.source, this.destination);

}