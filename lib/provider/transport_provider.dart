

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:tkd_app/model/transport_serach_model.dart';
import 'package:http/http.dart' as http;
import 'package:tkd_app/util/app_constants.dart';

class TransportProvider extends ChangeNotifier{
  List<TransportSearchData> transportSearchList = [];
  var response;
  int totalPages = 0 ;
  bool isLoading = false;
  bool isLoadingForName = false;
  bool isLoadingForLoc = false;
  bool isLoadingForRoutes = false;
  bool isExpand=false;

  getAllData({int currentPage = 0}) async {
    isLoading = true;
    notifyListeners();
    if(currentPage == 0){
      transportSearchList.clear();
    }
    String myUrl = ApiConstant.DIRECTORY +'?page=${currentPage}&size=30';
    print(myUrl);
    var req = await http.get(Uri.parse(myUrl));
    isLoading = false;
    response = json.decode(req.body);
    var type = TransportSearchModel.fromJson(response);
    transportSearchList.addAll(type.content!);
    totalPages = type.totalPages!;
    notifyListeners();
   }

  getByLocData(String city) async {
    isLoading = true;
    notifyListeners();
    transportSearchList.clear();
    String myUrl = ApiConstant.DIRECTORY +'?cityOfRegistrtion=${city}';
    print(myUrl);
    var req = await http.get(Uri.parse(myUrl));
    isLoading = false;
    response = json.decode(req.body);
    var type = TransportSearchModel.fromJson(response);
    transportSearchList = type.content!;
    if(type.content!.length >0){
      isExpand=false;
    }else {
      isExpand=true;
    }
    notifyListeners();
  }

  getByNameData(String name) async {
    isLoading = true;
    notifyListeners();
    transportSearchList.clear();
    String myUrl = ApiConstant.BASE_URL +'/directory?search=${name}&page=0&size=30';
    print("Api Call"+myUrl);
    var req = await http.get(Uri.parse(myUrl));
    isLoading = false;
    response = json.decode(req.body);
    var type = TransportSearchModel.fromJson(response);
    transportSearchList = type.content!;
    if(type.content!.length >0){
      isExpand=false;
    }else {
      isExpand=true;
    }
    notifyListeners();
  }

  TransportSearchData? transportSearchData;
  getById(int id) async {
    String myUrl = ApiConstant.BASE_URL +'directory/detailsOfDirectoryUser?directoryUserId=${id}';
    print("Api Call By id"+myUrl);
    var req = await http.get(Uri.parse(myUrl));
    response = json.decode(req.body);
    var type = TransportSearchModel.fromJson(response);
    transportSearchData = type.content![0];

    notifyListeners();
  }

  getBySearchData(String name) async {
    isLoading = true;
    notifyListeners();
    transportSearchList.clear();
    String myUrl = ApiConstant.DIRECTORY +'?search=${name}';
    print("Search Api Call"+myUrl);
    var req = await http.get(Uri.parse(myUrl));
    isLoading = false;
    response = json.decode(req.body);
    var type = TransportSearchModel.fromJson(response);
    transportSearchList = type.content!;
    if(type.content!.length >0){
      isExpand=false;
    }else {
      isExpand=true;
    }
    notifyListeners();
  }

  getByRoutesData(String source,String destination) async {
    isLoading = true;
    notifyListeners();
    transportSearchList.clear();
    String myUrl = ApiConstant.DIRECTORY +'?source=${source}&destination=${destination}';
    print(myUrl);
    var req = await http.get(Uri.parse(myUrl));
    isLoading = false;
    response = json.decode(req.body);
    var type = TransportSearchModel.fromJson(response);
    transportSearchList = type.content!;
    if(type.content!.length >0){
      isExpand=false;
    }else {
      isExpand=true;
    }
    notifyListeners();
  }
  selectRoutes(){

  notifyListeners();
}

  getMenuItem(bool isExpanded){
    isExpand =isExpanded;
    notifyListeners();
  }

}