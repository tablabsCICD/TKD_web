import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:tkd_app/locator.dart';
import 'package:tkd_app/model/truck_load_model.dart';
import 'package:tkd_app/provider/dashboard_provider.dart';
import 'package:tkd_app/util/app_constants.dart';
import 'package:tkd_app/util/date_converter.dart';

class BuySellProvider extends ChangeNotifier{
  List<TruckLoad> buyVehicleList = [];
  var response;
  List<TruckLoad> sellVehicleList = [];
  var response1;
  int sellTotalPages = 0;
  int totalPages = 0;
  bool isLoadingForBuyVehicles = false;
  bool isLoadingForSellVehicles = false;
  bool isLoding=true;
  late TruckLoad truckLoadNotification;

  Future<TruckLoadType> getBuyVehicles({int currentPage = 0}) async {
    isLoadingForBuyVehicles = true;
    notifyListeners();
    if(currentPage == 0){
      buyVehicleList.clear();
    }
    String myUrl = ApiConstant.BUY_SELL_ALL_CARD +'?type=Buy&&page=${currentPage}';
    var req = await http.get(Uri.parse(myUrl));
    isLoadingForBuyVehicles = false;
    response = json.decode(req.body);
    var type = TruckLoadType.fromJson(response);
    buyVehicleList.addAll(type.content);
    notifyListeners();
    return type;
  }

  Future<TruckLoadType> getSellVehicles({int currentPage = 0}) async {
    isLoadingForSellVehicles = true;
    notifyListeners();
    if(currentPage==0){
    sellVehicleList.clear();}
    String myUrl = ApiConstant.BUY_SELL_ALL_CARD +'?type=Sell&page=${currentPage}';
    print(myUrl);
    var req = await http.get(Uri.parse(myUrl));
    isLoadingForSellVehicles = false;
    response1 = json.decode(req.body);
    var type1 = TruckLoadType.fromJson(response1);
    sellVehicleList.addAll(type1.content);
    print('the id is ${truckLoadNotification.id}');
    notifyListeners();
    return type1;
  }

  Future<TruckLoadType> getSellVehiclesNotification(int id) async {
    isLoadingForSellVehicles = true;
    notifyListeners();
    sellVehicleList.clear();
    String myUrl = ApiConstant.BUY_SELL_SINGLE_CARD +'${id}';
    var req = await http.get(Uri.parse(myUrl));
    print('req $myUrl');
    isLoadingForSellVehicles = false;
    response1 = json.decode(req.body);
    print('${response1}');
    var type1 = TruckLoadType.fromJson(response1);
    sellVehicleList.addAll(type1.content);
    notifyListeners();
    return type1;
  }

  createBuySell({int? userId,String? description,String? agentName,String? bodyType,String? buySellType,String? city,String? conditionOfTyre,
    String? ConOfVehicle,int? mobile,String? date,String? price,int? id,String? image,String? insurancePaidDate,String? mainTag,String? maker,String? mfgYear,
    String? model,String? lUserName,String? owner,String? postingTime,String? type,String? registrationNumber,String? yearOfBuying
  }) async {
    String myUrl = ApiConstant.POST_BUY_SELL;
    Uri uri = Uri.parse(myUrl);
    Map<String, dynamic> data = {
      "additionalInformation": description,
      "agentName": agentName,
      "bodyType": bodyType,
      "buySelltype": buySellType,
      "city": city,
      "conditionOfTyres": conditionOfTyre,
      "conditionOfVehicle": ConOfVehicle,
      "contactNumber": mobile,
      "date": "2022-01-22T11:29:53.473Z",
      "estimatedPrice": price,
      "id": 0,
      "image1": image,
      "image2": "",
      "image3": "",
      "image4": "",
      "insaurancePaidUpto": insurancePaidDate,
      "loggedTime": "",
      "loggedUserName": lUserName,
      "mainTag": mainTag,
      "maker": maker,
      "mfgYear": yearOfBuying,
      "model": model,
      "negotiable": 0,
      "os": "",
      "ownerName": owner,
      "postingTime": "",
      "privatePost": 0,
      "tableName": "string",
      "topicName": "string",
      "type": type,
      "userId":userId,
      "vehicleRegistrationNumber": registrationNumber,
      "yearOfBuying": yearOfBuying
    };
    var body = json.encode(data);
    print(data);
    var createResponse = await http.post(uri,
        headers: {"Content-Type": "application/json"}, body: body);
    print("${createResponse.statusCode}" + " --- " + createResponse.body.toString());
    var jsonData = jsonDecode(createResponse.body);
    if(type=='Buy Vehicle'){
      TruckLoad dataObj = TruckLoad.fromJson(jsonData);
      buyVehicleList.add(dataObj);
    }
    else{
      TruckLoad dataObj = TruckLoad.fromJson(jsonData);
      sellVehicleList.add(dataObj);
    }
    notifyListeners();
  }

  final dashBoardProvider = locator<DashboardProvider>();
  deleteBuySell(int id,int index,bool isBuy) async {
    String myUrl = ApiConstant.POST_BUY_SELL +'?id=${id}';
    var req = await http.delete(Uri.parse(myUrl));
    var deleteResponse = json.decode(req.body);
    if(isBuy){
      buyVehicleList.removeAt(index);
    }
    else{
      sellVehicleList.removeAt(index);
    }
    dashBoardProvider.notifyListeners();
    dashBoardProvider.getFullLoadTruckList("All", "All");
    notifyListeners();
    }
}