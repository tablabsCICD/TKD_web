import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tkd_app/locator.dart';
import 'package:tkd_app/model/api_response.dart';
import 'package:tkd_app/model/auth_api.dart';
import 'package:tkd_app/model/comman_response.dart';
import 'package:tkd_app/model/group_added_member.dart';
import 'package:tkd_app/model/group_list_model.dart';
import 'package:tkd_app/model/shared_post_model.dart';
import 'package:tkd_app/model/truck_load_model.dart';
import 'package:http/http.dart' as http;
import 'package:tkd_app/model/verified_user.dart';
import 'package:tkd_app/network/api_call.dart';
import 'package:tkd_app/provider/auth_provider.dart';
import 'package:tkd_app/util/app_constants.dart';
import 'package:tkd_app/view/screens/menu_page.dart';
import 'package:tkd_app/widgets/bottomsheet.dart';

class DashboardProvider extends ChangeNotifier {
  String? selectedSampleData = '';
  List<User> allUserList = [];
  List<int> selectedUserList = List<int>.empty(growable: true);
  List<String> allUserNameList = [];
  List<String> searchingList = [];
  List<TruckLoad> truckLoadTypeList = [];
  bool isLoading = false;
  var response;
  bool isFirstLoading = false;
  int totalPages = 0;
  bool fla = false,
      pla = false,
      flr = false,
      plr = false,
      gp = false,
      buy_sell = false,
      jobs = false;

  final RefreshController refreshController =
      RefreshController(initialRefresh: true);
  final authProvider = locator<AuthProvider>();

  getFullLoadTruckList(String fromCity, String toCity,
      {int currentPage = 0}) async {
    User user = await authProvider.getLoginData();
    String url = "";
    if (currentPage == 0) {
      truckLoadTypeList.clear();
      // print('the clear the api');
      notifyListeners();
    }
    isLoading = true;
    if (fromCity == "From" && toCity == "To") {
      if (!fla && !pla && !flr & !plr & !gp & !buy_sell & !jobs) {
        url = ApiConstant.ALL_CARD(user.id,
            currentPage); //&fullLoadAvailable=${fla}&fullLoadRequired=${flr}&partLoadAvailable=${pla}&partLoadRequired=${plr}&loggedUserId=${user.content!.first.id}&generalPost=$gp&postJob=$jobs&buySell=$buy_sell';
      } else {
        if (fla) {
          url = ApiConstant.FULL_LOAD_AVILABLE(user.id, currentPage);
        } else if (pla) {
          url = ApiConstant.PART_LOAD_AVILABLE(user.id, currentPage);
        } else if (flr) {
          url = ApiConstant.FULL_LOAD_REQUIRED(user.id, currentPage);
        } else if (plr) {
          url = ApiConstant.PART_LOAD_REQUIRED(user.id, currentPage);
        } else if (gp) {
          url = ApiConstant.General_POST_HOMEPAGE(user.id, currentPage);
        } else if (buy_sell) {
          url = ApiConstant.BUYSELL_HOMEPAGE(user.id, currentPage);
        } else if (jobs) {
          url = ApiConstant.JOBS_HOMEPAGE(user.id, currentPage);
        } else {
          url = ApiConstant.FULL_LOAD_ALL_CARD +
              '?page=${currentPage}&size=50&fullLoadAvailable=${fla}&fullLoadRequired=${flr}&partLoadAvailable=${pla}&partLoadRequired=${plr}&loggedUserId=${user.id}&generalPost=$gp&postJob=$jobs&buySell=$buy_sell';
        }
      }
    } else {
      if (fromCity != "From" && toCity != "To") {
        url = ApiConstant.HOMEPAGE_FILTER +
            '?page=${currentPage}&size=10&fullLoadAvailable=${fla}&fullLoadRequired=${flr}&partLoadAvailable=${pla}&partLoadRequired=${plr}&source=$fromCity&destination=$toCity&loggedUserId=${user.id}&generalPost=$gp&postJob=$jobs&buySell=$buy_sell';
      } else if (fromCity != "From" && toCity == "To") {
        url = ApiConstant.HOMEPAGE_FILTER +
            '?page=${currentPage}&size=10&fullLoadAvailable=${fla}&fullLoadRequired=${flr}&partLoadAvailable=${pla}&partLoadRequired=${plr}&source=$fromCity&loggedUserId=${user.id}&generalPost=$gp&postJob=$jobs&buySell=$buy_sell';
      } else {
        url = ApiConstant.HOMEPAGE_FILTER +
            '?page=${currentPage}&size=10&fullLoadAvailable=${fla}&fullLoadRequired=${flr}&partLoadAvailable=${pla}&partLoadRequired=${plr}&destination=$toCity&loggedUserId=${user.id}&generalPost=$gp&postJob=$jobs&buySell=$buy_sell';
      }
    }
    print('the url $url');

    var req = await http.get(Uri.parse(url));
    isFirstLoading = false;
    isLoading = false;
    if (req.statusCode == 200) {
      response = json.decode(req.body);
      print(response);
      var type = TruckLoadType.fromJson(response);

      totalPages = type.totalPages;
      truckLoadTypeList.addAll(type.content);

      notifyListeners();
    }
  }

  reSendPost(BuildContext context, TruckLoad postBidData) async {
    var apiResponse = await http.post(Uri.parse(ApiConstant.BASE_URL +
        "repost?id=${postBidData.id!}&interchange=${false}"));
    if (apiResponse.statusCode == 200) {
      var jsonData = jsonDecode(apiResponse.body);
      CommonResponse commonResponse = CommonResponse.fromJson(jsonData);
      if (commonResponse.isSuccess == true) {
        await getFullLoadTruckList("From", "To", currentPage: 0);
        showSimpleNotification(
            Text(
              "Re-post submitted successfully!",
              style: TextStyle(color: Colors.white),
            ),
            background: Colors.black);
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
      return commonResponse.isSuccess;
    } else if (apiResponse.statusCode == 401) {
      showSimpleNotification(
          Text(
            "Please update your package",
            style: TextStyle(color: Colors.white),
          ),
          background: Colors.orange);
      return false;
    } else {
      showSimpleNotification(
          Text(
            "Please Try Again!",
            style: TextStyle(color: Colors.white),
          ),
          background: Colors.red);
      return false;
    }
  }

  interChnageSendPost(BuildContext context, TruckLoad postBidData) async {
    var apiResponse = await http.post(Uri.parse(ApiConstant.BASE_URL +
        "repost?id=${postBidData.id!}&interchange=${true}"));
    if (apiResponse.statusCode == 200) {
      var jsonData = jsonDecode(apiResponse.body);
      CommonResponse commonResponse = CommonResponse.fromJson(jsonData);
      if (commonResponse.isSuccess == true) {
        await getFullLoadTruckList("From", "To", currentPage: 0);
        showSimpleNotification(
            Text(
              "Intercity post submitted successfully!",
              style: TextStyle(color: Colors.white),
            ),
            background: Colors.black);
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

  List<GroupContent> groupListByUserId = [];
  List<String> groupListName = [];
  List<String> listOptionShow = ["All User", "Group", "Verified user"];
  List<GroupMemberContent> listAddedMember = [];
  List<int> addedMemberIdList = [];
  String selectedGroup = "Select One";

  selecteGroup(int index) async {
    addedMemberIdList.clear();
    selectedGroup = groupListByUserId[index].groupName!;
    await getGroupMember(groupListByUserId[index].id!);
  }

  getGroupMember(int groupId) async {
    listAddedMember.clear();
    isLoading = true;
    ApiHelper apiHelper = ApiHelper();
    var response = await apiHelper.ApiGetData(
        ApiConstant.GROUP_MEMBER_LIST + groupId.toString());
    GroupMemberModel groupListModel = GroupMemberModel.fromJson(response);

    listAddedMember.addAll(groupListModel.content!);
    isLoading = false;
    notifyListeners();
  }

  getAllGroup(int? userId, context) async {
    print('the id is +${ApiConstant.USER_OBJECT.id}');
    isLoading = true;
    ApiHelper apiHelper = ApiHelper();
    var response = await apiHelper.ApiGetData(
        ApiConstant.GROUP_BY_USER + userId!.toString() + "?page=0&size=1000");
    if (response.status == 200) {
      GroupListModel groupListModel = GroupListModel.fromJson(response);
      groupListByUserId.clear();
      groupListName.clear();
      groupListByUserId
          .addAll(groupListModel.content as Iterable<GroupContent>);
      groupListByUserId.forEach((element) {
        groupListName.add(element.groupName!);
      });
    }
    isLoading = false;
    notifyListeners();
  }

  selecteOptiontoShow(
      int index, BuildContext context, String sourceCity) async {
    notifyListeners();
    switch (index) {
      case 0:
        addedMemberIdList.clear();
        selectedGroup = listOptionShow[index];
        return;
      case 1:
        if (groupListName.isEmpty) {
          await getAllGroup(authProvider.userDetailList[0].id!, context);
        }
        ItemBottomSheet itemBottomSheet = ItemBottomSheet();
        int a = await itemBottomSheet.showIteamHieght(
            context, groupListName, "Select Group");
        selecteGroup(a);
        selectedGroup = listOptionShow[index];
        notifyListeners();
        return;

      case 2:
        if (sourceCity == "Select One") {
          showSimpleNotification(
              Text(
                "Please select the source city ",
                style: TextStyle(color: Colors.white),
              ),
              background: Colors.black);
        } else {
          /* if (selectedUserList.isNotEmpty) {
            addedMemberIdList.clear();
            for (int i = 0; i < verfiedUserList.length; i++) {
              addedMemberIdList.add(verfiedUserList[i].id!);
            }
            selectedGroup = listOptionShow[index];
          }*/
        }

        return;
    }
  }

  getListOfVefiyUser(String selectedFromCity) async {
    String myUrl = ApiConstant.GET_USER_SOURCE_LIST(selectedFromCity);
    ApiResponse apiResponse = await ApiHelper().apiWithoutDecodeGet(myUrl);
    if (apiResponse.statusCode == 200) {
      VerifiedUser verifiedUser =
          VerifiedUser.fromJson(jsonDecode(apiResponse.response));
      allVerifiedUserList.addAll(verifiedUser.data!);
      allVerifiedUserList.forEach((element) {
        allUserNameList.add('${element.firstName} ${element.lastName}');
        if (element.isPaid != 0) {
          allVerifiedUserNameList.add(
              '${element.firstName} ${element.lastName}\n${element.companyName}');
        }
      });
      print(allVerifiedUserNameList.length.toString() + "length ");
    }
    notifyListeners();
  }

  List<UserVerifiedData> allVerifiedUserList = [];
  List<String> allVerifiedUserNameList = [];

  getAllUserList({int currentPage = 0}) async {
    isLoading = true;
    notifyListeners();
    if (currentPage == 0) {
      isFirstLoading = true;
      allUserList.clear();
    }

    String myUrl = ApiConstant.BASE_URL +
        'companyRegistration?page=${currentPage}&size=6000';
    print(myUrl);
    var req = await http.get(Uri.parse(myUrl));
    isFirstLoading = false;
    isLoading = false;
    if (req.statusCode == 200) {
      response = json.decode(req.body);
      var type = AuthApi.fromJson(response);
      allUserList.addAll(type.content!);
      allUserList.forEach((element) {
        allUserNameList.add('${element.firstName} ${element.lastName}');
        if (element.isPaid != 0) {
          allVerifiedUserNameList.add(
              '${element.firstName} ${element.lastName}\n${element.companyName}');
        }
      });
      print(allUserNameList.length.toString() +
          "length sacsczcscscscscscscscscscscscscscscscs");
      //  notifyListeners();
    }
  }

  getSelectedUserId(List<String> selectedItems) {
    selectedUserList.clear();
    for (int i = 0; i < selectedItems.length; i++) {
      final selectedItem = selectedItems.elementAt(i);
      for (var i = 0; i < allVerifiedUserList.length; i++) {
        if (selectedItem ==
            "${allVerifiedUserList[i].firstName} ${allVerifiedUserList[i].lastName}") {
          selectedUserList.add(allVerifiedUserList[i].id!);
        }
      }
    }
    print("Final" + selectedUserList.length.toString());
    notifyListeners();
  }

  deleteFullLoad(int id, int index) async {
    String myUrl = ApiConstant.BASE_URL + 'fullTruckLoad?id=${id}';
    print(myUrl);
    var req = await http.delete(Uri.parse(myUrl));
    var deleteResponse = json.decode(req.body);
    print(deleteResponse);
    truckLoadTypeList.removeAt(index);
    notifyListeners();
  }

  savePost(BuildContext context,
      {int? mobile,
      String? destination,
      int? dnd,
      String? email,
      String? fullLoadChoice,
      int? id,
      String? instruction,
      User? userList,
      String? loadWeight,
      String? name,
      String? mainTag,
      String? os,
      String? otherDetails,
      String? source,
      int? partLoad,
      int? privatePost,
      double? rating,
      String? customerName,
      String? type,
      String? typeOfCargo,
      String? vehicleSize,
      String? typeOfPayment,
      int? userId,
      List<int>? selectedUserList}) async {
    isLoading = true;
    notifyListeners();
    String myUrl = selectedSampleData == "Show to All"
        ? ApiConstant.BASE_URL + "fullTruckLoad"
        : ApiConstant.POST_FULL_LOAD;
    print(myUrl);
    Uri uri = Uri.parse(myUrl);

    Map<String, dynamic> data = {
      "contactNumber": mobile ?? 0,
      "destination": destination,
      "dnd": dnd,
      "emailId": email,
      "fullLoadChoice": fullLoadChoice,
      "instructions": instruction,
      "listOfUserIds": selectedUserList,
      "loadWeight": loadWeight,
      "loggedUserName": name,
      "mainTag": mainTag,
      "os": "Web",
      "otherDetails": otherDetails,
      "partLoad": partLoad ?? 0,
      "privatePost": selectedSampleData == "Show to All" ? 0 : privatePost,
      "rating": rating ?? 5,
      "source": source,
      "tableName": "Full Load",
      "topicName": "Full Load Truck",
      "transporterOrCustomerName": customerName,
      "type": type,
      "typeOfCargo": typeOfCargo,
      "typeOfPayment": typeOfPayment,
      "vehicleSize": vehicleSize,
      // "userId": userId
    };

    var body = json.encode(data);
    print("request : ${data}");
    final response = await http.post(uri,
        headers: {"Content-Type": "application/json"}, body: body);
    isLoading=false;
    print("response : ${response.statusCode}" +
        " --- " +
        response.body.toString());
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      CommonResponse commonResponse = CommonResponse.fromJson(jsonData);
      if (commonResponse.isSuccess == true) {
        var jsonData = jsonDecode(response.body);
        TruckLoad dataObj = TruckLoad.fromJson(jsonData);
        print(dataObj);
        truckLoadTypeList.add(dataObj);
        notifyListeners();
        showSimpleNotification(
            Text(
              "Post submitted successfully!",
              style: TextStyle(color: Colors.white),
            ),
            background: Colors.black);
        await getFullLoadTruckList('From', "To");
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        return true;
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
      return commonResponse.isSuccess;
    } else if (response.statusCode == 401) {
      showSimpleNotification(
          Text(
            "Please update your package",
            style: TextStyle(color: Colors.white),
          ),
          background: Colors.orange);
      Navigator.of(context).pop();
      return false;
    } else {
      showSimpleNotification(
          Text(
            "Please Try Again!",
            style: TextStyle(color: Colors.white),
          ),
          background: Colors.red);
      Navigator.of(context).pop();
      return false;
    }
  }

  SharedPostModel? truckLoad;

  getRequirementDetails(int id) async {
    String myUrl = ApiConstant.BASE_URL + 'fullTruckLoad/${id}';
    print(myUrl);
    var req = await http.get(Uri.parse(myUrl));
    response = await json.decode(req.body);
    var list = SharedPost.fromJson(response);
    truckLoad = list.content![0];
    return truckLoad;
  }

  getSearchByNameList(String name, String source, String dest) async {
    isLoading = true;
    notifyListeners();
    truckLoadTypeList.clear();
    String myUrl = ApiConstant.FULL_LOAD_ALL_CARD +
        '?nameOfPerson=${name}&source=${source}&destination=${dest}';
    print(myUrl);
    var req = await http.get(Uri.parse(myUrl));
    isLoading == false;
    response = json.decode(req.body);
    var type = TruckLoadType.fromJson(response);
    truckLoadTypeList = type.content;
    notifyListeners();
  }

  getCountUnreadNotification(int userId) {
    ApiHelper apiHelper = ApiHelper();
    apiHelper.ApiGetData(ApiConstant.BASE_URL + "getCount/${userId}");
  }
}
