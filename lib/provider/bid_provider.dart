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
import '../model/deleteuser.dart';
import '../model/quoteResponse.dart';
import '../model/quote_response.dart';
import '../network/api_call.dart';
import '../util/validation.dart';
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
  bool isPaginationLoading = false;
  bool isLastPage = false;

  int currentPage = 0;

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

  Future<List<Bidings>> getReceivedBidingList({int currentPage = 0}) async {
    // Stop if last page already loaded
    if (isLastPage) return receivedBidingList;

    // Initial load vs pagination
    if (currentPage == 0) {
      isLoading = true;
      ownBidPostList.clear();
      receivedBidingList.clear();
    } else {
      isPaginationLoading = true;
    }

    notifyListeners();

    String myUrl = ApiConstant.BASE_URL +
        'getOwnPostAndBid?userId=${authProvider.userDetailList[0].id}&page=$currentPage&size=10';

    print(myUrl);

    try {
      var req = await http.get(Uri.parse(myUrl));
      response = json.decode(req.body);
      print(response);

      var type = MyPostBids.fromJson(response);

      /// 🔹 Check if API returned empty → last page
      if (type.content == null || type.content!.isEmpty) {
        isLastPage = true;
      } else {
        /// 🔹 Append instead of overwrite
        ownBidPostList.addAll(type.content!);

        /// 🔹 Collect all bidings
        for (var post in type.content!) {
          if (post.bidings != null && post.bidings!.isNotEmpty) {
            receivedBidingList.addAll(post.bidings!);
          }
        }

        /// 🔹 Sort by amount (Low → High)
        receivedBidingList.sort((a, b) => int.parse(a.bidings!.amount!)
            .compareTo(int.parse(b.bidings!.amount!)));

        this.currentPage = currentPage;
      }
    } catch (e) {
      debugPrint("Pagination error: $e");
    }

    isLoading = false;
    isPaginationLoading = false;
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

  Future<bool> generateBid(
    BuildContext context, {
    int? mobile,
    String? description,
    int? id,
    String? email,
    String? amount,
    int? idOfPost,
    String? bidderUserName,
    String? userName,
    String? type,
    String? loggedUserName,
  }) async {
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

    final response = await http.post(
      uri,
      headers: {"Content-Type": "application/json"},
      body: json.encode(data),
    );

    print("${response.statusCode}" + " --- " + response.body.toString());

    if (response.statusCode == 200) {
      QuoteRespose quoteResponse =
          QuoteRespose.fromJson(jsonDecode(response.body));
      if (quoteResponse.isSuccess == false) {
        showSimpleNotification(
          Text(quoteResponse.message.toString(),
              style: TextStyle(color: Colors.white)),
          background: Colors.orange,
        );

        return false;
      } else {
        showSimpleNotification(
          Text(quoteResponse.message.toString(),
              style: TextStyle(color: Colors.white)),
          background: Colors.green,
        );

        return true;
      }
    }

    if (response.statusCode == 400 || response.statusCode == 401) {
      showSimpleNotification(
        Text("Please update your package",
            style: TextStyle(color: Colors.white)),
        background: Colors.orange,
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (builder) => MenuPage(
            userDetailList: authProvider.userDetailList,
            selectedTab: "Package Change",
          ),
        ),
      );

      return false;
    }

    showSimpleNotification(
      Text("Please Try Again!", style: TextStyle(color: Colors.white)),
      background: Colors.red,
    );

    return false;
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
      "sourceLocation": data.genericCardsDto!.source,
      "userId": authProvider.userDetailList[0].id,
      "vehicleNumber": vehicleNumber
    };

    print(ApiConstant.ACCEPTBID);

    var apiResponse = await ApiHelper().ApiAddPostDataMapRequest(
      ApiConstant.ACCEPTBID,
      mapData,
    );

    if (apiResponse.statusCode == 200) {
      /// IMPORTANT FIX
      final Map<String, dynamic> jsonMap = jsonDecode(apiResponse.body);
      AcceptBidResponse acceptBidResponse = AcceptBidResponse.fromJson(jsonMap);

      ToastMessage.show(context, acceptBidResponse.message ?? "Success");

      notifyListeners();
      getReceivedBidingList();

      Navigator.of(context).pop();
    } else {
      ToastMessage.show(context, "Please Try Again");
    }
  }

  updateAcceptBid(BuildContext context, Bids data, String driverNumber,
      String vehicleNumber) async {
    Map<String, dynamic> mapData = {
      "driverContact": driverNumber,
      "id": data.acceptBidId,
      "userId": authProvider.userDetailList[0].id,
      "vehicleNumber": vehicleNumber
    };
    print(ApiConstant.UPDATE_ACCEPTED_BID);
    var response = await ApiHelper()
        .ApiPutDataMapRequest(ApiConstant.UPDATE_ACCEPTED_BID, mapData);
    print('the request is ${json.encode(mapData)}');
    print('the resopnse is ${response.statusCode}');
    if (response.statusCode == 200) {
      showSimpleNotification(
          Text(
            "driver number and vehicle number added Successfully",
            style: TextStyle(color: Colors.white),
          ),
          background: Colors.black);
      //nch  Navigator.pop(context);
      Navigator.pop(context, 1);
    } else {
      showSimpleNotification(
          Text(
            "Please try again",
            style: TextStyle(color: Colors.white),
          ),
          background: Colors.black);
    }
  }

  late Map<String, dynamic> data = {};

  getGraphDataForBids(BuildContext context, int postId, int index) async {
    try {
      debugPrint('Fetching bid data from ${ApiConstant.GET_BID_TREND(postId)}');
      ApiResponse apiResponse = await ApiHelper()
          .apiWithoutDecodeGet(ApiConstant.GET_BID_TREND(postId));

      if (apiResponse.statusCode == 200) {
        debugPrint('${apiResponse.status}');
        ownBidPostList[index].genericCardsDto!.graphList = [];
        data = jsonDecode(apiResponse.response) as Map<String, dynamic>;
        QuoteResponse response = QuoteResponse.fromJson(data);
        if (response.data != null) {
          ownBidPostList[index].genericCardsDto!.graphList = response.data;
        } else {
          ToastMessage.show(context, response.message!);
        }
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

  Future<bool> callOtp(BuildContext context, String mobileNumber, int postId,
      bool isPostOwner) async {
    try {
      var req = await ApiHelper()
          .ApiPostData(ApiConstant.SEND_TRACKING_OTP(isPostOwner, postId));

      // ✅ Prevent calling Toasts on disposed context
      if (!context.mounted) return false;

      if (req.statusCode == 200) {
        ToastMessage.show(context, "OTP Sent Successfully");
        return true;
      } else {
        ToastMessage.show(context, "Failed to send OTP");
        return false;
      }
    } catch (e) {
      if (context.mounted) {
        ToastMessage.show(context, "Error: $e");
      }
      return false;
    }
  }

  Future<bool> callSwitch(DeleteUser user, BuildContext context,
      String mobileNumber, int postId, bool isPostOwner) async {
    try {
      switch (user.errorCode) {
        case '200':
          return await callOtp(context, mobileNumber, postId, isPostOwner);

        case '201':
          if (context.mounted) {
            ToastMessage.show(
                context, "User is deleted, please register again");
          }
          return false;

        case '500':
          if (context.mounted) {
            ToastMessage.show(
                context, "Mobile number is not registered, please register");
          }
          return false;

        default:
          if (context.mounted) {
            ToastMessage.show(context, "Unexpected response");
          }
          return false;
      }
    } catch (e) {
      if (context.mounted) {
        ToastMessage.show(context, "Error: $e");
      }
      return false;
    }
  }

  Future<bool> isUserDeleted(String mobileNumber, BuildContext context,
      int postId, bool isPostOwner) async {
    if (!Validation().isValidPhoneNumber(mobileNumber)) {
      if (context.mounted) {
        ToastMessage.show(context, "Enter valid mobile number");
      }
      return false;
    }

    try {
    
      var req = await http.get(Uri.parse( "${ApiConstant.USER_FIND_BY_MOBILE}$mobileNumber"));
      // ✅ Check again after API call
      if (!context.mounted) return false;

      if (req.statusCode == 200) {
        DeleteUser deleteUser = DeleteUser.fromJson(jsonDecode(req.body));
        bool returnVal = await callSwitch(
            deleteUser, context, mobileNumber, postId, isPostOwner);
        return returnVal;
      } else {
        if (context.mounted) {
          ToastMessage.show(context, "Please try again");
        }
        return false;
      }
    } catch (e) {
      if (context.mounted) {
        ToastMessage.show(context, "Error: $e");
      }
      return false;
    }
  }
}
