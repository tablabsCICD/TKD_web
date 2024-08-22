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

class BidProvider extends ChangeNotifier {
  List<BidingUser> allBidingList = [];
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
        '?userName=${userName}&privatePost=${isPublic}';
    print(myUrl);
    var req = await http.get(Uri.parse(myUrl));
    isLoading = false;
    response = json.decode(req.body);
    print(response);
    var type = BidingUserModel.fromJson(response);
    allBidingList.clear();
    allBidingList = type.content;
    allBidingList
        .sort((a, b) => int.parse(a.amount).compareTo(int.parse(b.amount)));
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
      CommonResponse commonResponse = CommonResponse.fromJson(jsonData);
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
      }
    } else if (response.statusCode == 401) {
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

  deleteBid(BidingUser bid) async {
    String myUrl = ApiConstant.BID_TO_POST + '?id=${bid.bidingId}';
    print(myUrl);
    var req = await http.delete(Uri.parse(myUrl));
    response = json.decode(req.body);
    print(response);
    allBidingList.remove(bid);
    notifyListeners();
  }
}
