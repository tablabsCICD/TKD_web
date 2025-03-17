import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:tkd_app/locator.dart';
import 'package:http/http.dart' as http;
import 'package:tkd_app/model/biding_user_model.dart';
import 'package:tkd_app/model/comman_response.dart';
import 'package:tkd_app/model/my_bids.dart';
import 'package:tkd_app/model/truck_load_model.dart';
import 'package:tkd_app/provider/auth_provider.dart';
import 'package:tkd_app/util/app_constants.dart';
import 'package:tkd_app/view/screens/menu_page.dart';

import '../model/acceptBidResponse.dart';
import '../model/api_response.dart';
import '../model/bid_placed.dart';
import '../network/api_call.dart';
import '../widgets/toast.dart';

class BidProvider extends ChangeNotifier {
  List<Bids> allBidingList = [];
  List<Bidings> receivedBidingList = [];
  List<PostBidData> ownBidPostList = [];
  var response;
  int totalPages = 0;
  bool isLoading = false;
  List<BidingUser> truckLoadTypeList = [];
  final authProvider = locator<AuthProvider>();

  getAllBidingList(String userName, int isPublic) async {
    isLoading = true;
    notifyListeners();
    String myUrl = ApiConstant.BID_OWN_POST +
        '?userName=${userName}&privatePost=${isPublic}&page=0&size=100&fullLoadAvailable=true&fullLoadRequired=true&partLoadAvailable=true&partLoadRequired=true';
    print(myUrl);
    var req = await http.get(Uri.parse(myUrl));
    isLoading = false;
    response = json.decode(req.body);
    print(response);
    var type = BidPlaced.fromJson(response);
    allBidingList.clear();
    allBidingList = type.content!;
    allBidingList
        .sort((a, b) => int.parse(a.amount!).compareTo(int.parse(b.amount!)));
    print('Low to hight in biding amount: $allBidingList');
    allBidingList.forEach((element) {
      print("amount : " + element.amount.toString());
    });
    notifyListeners();
  }

  List<TruckLoad> allPostList = [];
  List<TruckLoad> myOwnPostList = [];

  getReceivedBidingList() async {
    isLoading = true;
    notifyListeners();
    String myUrl = ApiConstant.BASE_URL +
        'getOwnPostAndBid?userId=${authProvider.userDetailList[0].id}';
    print(myUrl);
    var req = await http.get(Uri.parse(myUrl));
    isLoading = false;
    response = json.decode(req.body);
    print(response);
    var type = MyPostBids.fromJson(response);
    ownBidPostList.clear();
    ownBidPostList = type.content!;
    receivedBidingList.clear();
    receivedBidingList = type.content![0].bidings!;
    receivedBidingList.sort((a, b) =>
        int.parse(a.bidings!.amount!).compareTo(int.parse(b.bidings!.amount!)));
    print('Low to hight in biding amount: $receivedBidingList');
    receivedBidingList.forEach((element) {
      print("amount : " + element.bidings!.amount.toString());
    });
    notifyListeners();
    return receivedBidingList;
  }

  getBidingUser(int id) async {
    String myUrl = ApiConstant.BASE_URL + '/fullTruckLoad/${id}';
    print(myUrl);
    var req = await http.get(Uri.parse(myUrl));
    response = await json.decode(req.body);
    var list = BidingUserModel.fromJson(response);
    truckLoadTypeList.addAll(list.content);
    print(truckLoadTypeList);
    notifyListeners();
    return truckLoadTypeList;
  }

  generateBid(BuildContext context,
      {int? mobile,
      String? description,
      int? id,
      String? email,
      String? amount,
      int? idOfPost,
      String? bidderUserName,
      String? userName,
      String? type,
      String? loggedUserName}) async {
    String myUrl = ApiConstant.BID_TO_POST;
    Uri uri = Uri.parse(myUrl);
    Map<String, dynamic> data = {
      "amount": amount,
      "bidderUserName": bidderUserName,
      "description": description,
      "emailId": email,
      "id": id,
      "idOfPost": idOfPost,
      "loggedTime": "",
      "loggedUserName": loggedUserName,
      "mobileNumber": mobile,
      "type": type,
      "userName": userName
    };
    var body = json.encode(data);
    print(data);

    final response = await http.post(uri,
        headers: {"Content-Type": "application/json"}, body: body);
    print("${response.statusCode}" + " --- " + response.body.toString());
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      showSimpleNotification(
          Text(
            "Quote Submitted Successfully",
            style: TextStyle(color: Colors.white),
          ),
          background: Colors.green);
   /*   CommonResponse commonResponse = CommonResponse.fromJson(jsonData);
      if (commonResponse.isSuccess == true) {
      } else {
        showSimpleNotification(
            Text(
              commonResponse.message.toString(),
              style: TextStyle(color: Colors.white),
            ),
            background: Colors.orange);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (builder) => MenuPage(
                      userDetailList: authProvider.userDetailList,
                      selectedTab: "Package Change",
                    )));
      }*/
    } else if (response.statusCode == 401||response.statusCode == 400) {
      showSimpleNotification(
          Text(
            "Please update your package",
            style: TextStyle(color: Colors.white),
          ),
          background: Colors.orange);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (builder) => MenuPage(
                    userDetailList: authProvider.userDetailList,
                    selectedTab: "Package Change",
                  )));
    } else {
      showSimpleNotification(
          Text(
            "Please Try Again!",
            style: TextStyle(color: Colors.white),
          ),
          background: Colors.red);
    }
    notifyListeners();
  }

  deleteBid(Bids bid) async {
    String myUrl = ApiConstant.BID_TO_POST + '?id=${bid.bidingId}';
    print(myUrl);
    var req = await http.delete(Uri.parse(myUrl));
    response = json.decode(req.body);
    print(response);
    allBidingList.remove(bid);
    notifyListeners();
  }

  acceptBidSaveForm(BuildContext context, PostBidData data, Bidings bidings,
      String driverNumber, String vehicleNumber) async {
    Map<String, dynamic> mapData = {
      "amount": bidings.bidings!.amount,
      "bidId": bidings.bidings!.id,
      "bidderUserId": 0,
      "bidderUserName": bidings.bidings!.bidderUserName,
      "destinationLocation": data.genericCardsDto!.destination,
      "driverContact": driverNumber,
      "id": 0,
      "isUpdatedDriverDetails": 0,
      "loggedTime": "",
      "postId": data.genericCardsDto!.id,
      "sourceLocation":data.genericCardsDto!.source ,
      "userId": authProvider.userDetailList[0].id,
      "vehicleNumber": vehicleNumber
    };
    print(ApiConstant.ACCEPTBID);
    var apiResponse = await ApiHelper().ApiAddPostDataMapRequest(ApiConstant.ACCEPTBID,mapData);
    if (apiResponse.statusCode == 200) {
      AcceptBidResponse acceptBidResponse = AcceptBidResponse.fromJson(apiResponse.body);

      if(acceptBidResponse.success == true){
        ToastMessage.show(context, acceptBidResponse.message.toString());
      }else{
        ToastMessage.show(context, acceptBidResponse.message.toString());
      }
      notifyListeners();
      getReceivedBidingList();
      Navigator.of(context).pop();
    } else {
      ToastMessage.show(context, "Please Try Again");
    }
  }

  updateAcceptBid(BuildContext context, Bids data,
      String driverNumber, String vehicleNumber) async {
    Map<String, dynamic> mapData = {
      "driverContact": driverNumber,
      "id": data.acceptBidId,
      "userId":authProvider.userDetailList[0].id,
      "vehicleNumber": vehicleNumber
    };
    print(ApiConstant.UPDATE_ACCEPTED_BID);
    var response = await ApiHelper().ApiPutDataMapRequest(ApiConstant.UPDATE_ACCEPTED_BID,mapData);
    print('the request is ${json.encode(mapData)}');
    print('the resopnse is ${response.statusCode}');
    if (response.statusCode == 200) {
      showSimpleNotification(
          Text("driver number and vehicle number added Successfully",style: TextStyle(color: Colors.white),),
          background: Colors.black
      );
      //nch  Navigator.pop(context);
      Navigator.pop(context, 1);
    } else {
      showSimpleNotification(
          Text("Please try again",style: TextStyle(color: Colors.white),),
          background: Colors.black
      );
    }
  }


  late Map<String, dynamic> data = {};

  getGraphDataForBids(BuildContext context, int postId,int index) async {
    try {
      debugPrint('Fetching bid data from ${ApiConstant.GET_BID_TREND(postId)}');
      ApiResponse apiResponse = await ApiHelper()
          .apiWithoutDecodeGet(ApiConstant.GET_BID_TREND(postId));

      if (apiResponse.statusCode == 200) {
        debugPrint('${apiResponse.status}');
        ownBidPostList[index].genericCardsDto!.graphList = {};
        data = jsonDecode(apiResponse.response) as Map<String, dynamic>;
        ownBidPostList[index].genericCardsDto!.graphList = data;
        notifyListeners();
      } else {
        ToastMessage.show(context, "Please Try Again");
        // Default data in case of failure
      }
    } catch (e) {
      debugPrint("Error fetching bid data: $e");
      ToastMessage.show(context, "An error occurred. Please try again.");
    }
  }
}
