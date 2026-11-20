import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:tkd_app/locator.dart';
import 'package:tkd_app/model/api_response.dart';
import 'package:tkd_app/model/auth_api.dart';
import 'package:tkd_app/model/group_added_member.dart';
import 'package:tkd_app/model/group_list_model.dart';
import 'package:tkd_app/model/group_response.dart';
import 'package:tkd_app/model/new_truckLod_model.dart';
import 'package:tkd_app/model/request/post_load.dart';
import 'package:tkd_app/model/truck_load_model.dart';
import 'package:tkd_app/model/userdata.dart';
import 'package:tkd_app/model/verified_user.dart';
import 'package:tkd_app/network/api_call.dart';
import 'package:tkd_app/provider/auth_provider.dart';
import 'package:tkd_app/provider/dashboard_provider.dart';
import 'package:tkd_app/provider/more_provider.dart';
import 'package:tkd_app/util/app_constants.dart';
import 'package:http/http.dart' as http;
import 'package:tkd_app/widgets/bottomsheet.dart';

import '../view/screens/editPost/edit_post_load.dart';


class EditPostLoadProvider extends ChangeNotifier {

  TextEditingController loadWeightController = TextEditingController();
  TextEditingController vehicleSizeController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController emailIdController = TextEditingController();
  TextEditingController expireDateController = TextEditingController();
  String selectedRequriment = "Select One";
  String selectedPostType = "Select One";
  String selectedCargo = "Select One";
  String selectedSI = "Double Delivery";
  String selectedPayment = "Select One";
  String selectedGroup = "Select Group";
  String sourceCity = "Select One";
  String destinationCity = "Select One";
  String selectedSampleData = "Show to only your preferred Transporters";

  bool identitySwitch = false;
  bool privateSwitch = false;
  bool disturbSwitch = false;
  bool dnd = false;
  bool hideMyID = false;
  bool enableButton = false;
  bool vehicleSize = false;
  bool loadWieght = false;

  List<String> requirementList = <String>['I Want Vehicle', 'I Have Vehicle'];
  List<String> postTypeList = <String>['Full Load', 'Part Load'];
  List<String> cargoList = <String>['Wooden Case','Cartons','Drums','Gunny Bags',"Machinery",'Other'];
  List<String> paymentList = <String>['Immediate','Fortnight','Weekly','Others'];
  List<String> reqirement = ["Full Load", "Part Load"];
  List<String> reqirementVehicale = ["Full Load Vehicle", "Part Load Vehicle"];
  List<String> specialInstructionList = [
    'Double Delivery',
    'Express Delivery',
    'Loading From Multiple Places',
    'Unloading At Multiple Place ',
    "Give Rate Inclusive Of Loading Hamali",
    'Give Rate Inclusive Of Unloading Hamali',
    'Others',
    'None'
  ];
  List<String> images = [];
  List<String> searchingList = [];

  List<RadioModel> sampleData = <RadioModel>[
    RadioModel(true, 'Show to only your preferred Transporters'),
    RadioModel(false, 'Show to only verified Transporters'),
    RadioModel(false, 'Show to All')
  ];

 final authProvider = locator<AuthProvider>();
  final moreProvider = locator<MoreProvider>();
  final dashProvider = locator<DashboardProvider>();



  initData(TruckLoad postBidData) async {
    print("Edit Object:"+postBidData.mobileNumber.toString());
    User user = authProvider.userDetailList[0];
    emailIdController.text = user.emailId!;
    mobileNumberController.text = user.mobileNumber!.toString();
    selectedCargo = postBidData.typeOfCargo??"";
    setSafeSelectedSI(postBidData.content);

    loadWeightController.text = postBidData.loadWeight!;
    selectedPostType=postBidData.type??'';
    await getTruckLoadById(postBidData.id!);
    notifyListeners();
  }

  pickFile() async {
    var result = await FilePicker.platform.pickFiles(
      withReadStream:
      true,
      allowMultiple: true,
    );

    if(result!=null){
      try {
        String fileName = result.files.first.name;
        print(result.files.first.toString());
        var objFile = result.files.single;
        var imageBytes = result.files.first.bytes;
        print(fileName);
        var docs =  await uploadGroupPhoto(imageFilePath: fileName,imageBytes: imageBytes,objectFile: objFile);
        print(docs);

      } catch (ex) {
        throw Exception("Exception Occurred ${ex.toString()}");
      }
    }

  }

  void setSafeSelectedSI(String? value) {
    if (value != null &&
        value.isNotEmpty &&
        specialInstructionList.contains(value)) {
      selectedSI = value;
    } else {
      selectedSI = 'None'; // or null-safe default
    }
  }


  uploadGroupPhoto({String? imageFilePath,
    Uint8List? imageBytes,PlatformFile? objectFile}) async {
    String myUrl = ApiConstant.IMG_UPLOAD;
    var postUri = Uri.parse(myUrl);
    var request = new http.MultipartRequest("POST", postUri);
    Map<String,String> headers = {"Content-Type": "multipart/form-data"};
    request.files.add(new http.MultipartFile(
        "profilePicture", objectFile!.readStream!, objectFile.size,
        filename: objectFile.name));
    request.headers.addAll(headers);
    var response = await request.send();
    print(response.statusCode);
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
      images.add(value);
      //changeImageUrl=value;
    });

    notifyListeners();
  }

  List<GroupContent> groupListByUserId = [];
  List<String> groupListName = [];
  List<GroupMemberContent> listAddedMember = [];
  List<int> addedMemberIdList = [];

  getGroupListByUserId() async {
    User user = authProvider.userDetailList[0];
    ApiHelper apiHelper=ApiHelper();
    var response=await apiHelper.ApiGetData(ApiConstant.GROUP_BY_USER+user.id!.toString()+"?page=0&size=1000");
    GroupListModel groupListModel=GroupListModel.fromJson(response);
    groupListByUserId.addAll(groupListModel.content!);
    if (response.status == 200) {
      GroupListResponse groupListResponse =
          GroupListResponse.fromJson(response.response);
      groupListByUserId.clear();
      groupListName.clear();
      groupListByUserId
          .addAll(groupListResponse.content as Iterable<GroupContent>);
      groupListByUserId.forEach((element) {
        groupListName.add(element.groupName!);
      });
    }
    notifyListeners();
  }

  getGroupMember(int groupId) async {
    listAddedMember.clear();
    addedMemberIdList.clear();
    ApiHelper apiHelper=ApiHelper();
    var response=await apiHelper.ApiGetData(ApiConstant.GROUP_MEMBER_LIST+groupId.toString());
    GroupMemberModel groupListModel=GroupMemberModel.fromJson(response);

    listAddedMember.addAll(groupListModel.content!);
    listAddedMember.forEach((element) {
      addedMemberIdList.add(element.id!);
    });
    print(addedMemberIdList.length);
    notifyListeners();
  }

  List<String> addedUserListIdInPost=[];
  List<int> addedUserListInPost=[];
  List<UserData> addedUsers = [];
  getUserListFromString(String userList){
    if(userList.isNotEmpty){
      addedUserListIdInPost = userList.split(',').map((e) => e.trim()).toList();
      print(addedUserListIdInPost);
      addedUserListIdInPost.forEach((element) async {
        UserData userData = await getUserById(int.parse(element));
        addedUserListInPost.add(int.parse(element));
        print(userData.id);
        print(userData.firstName);
        addedUsers.add(userData);
      });
    }
    return addedUserListIdInPost;
  }

  setDate(String date) async {
    expireDateController.text = date;
    notifyListeners();
  }

  getUserById(int userId) async {
    ApiHelper apiHelper = ApiHelper();
    String myUrl = ApiConstant.BASE_URL +"/companyRegistration/"+ userId.toString();
    print(myUrl);
    var response = await apiHelper.apiWithoutDecodeGet(myUrl);
    print(response.response);
    if(response.statusCode==200){
      var result = UserModel.fromJson(jsonDecode(response.response));
      UserData userData = result.content!.first;
      return userData;
    }else{
      return null;
    }
  }

  List<User> allUserList = [];
  List<String> allVerifiedUserList = [];
  List<String> allUserNameList = [];
  getAllUserList({int currentPage = 0}) async {
    notifyListeners();
    if(currentPage == 0){
      allUserList.clear();
    }

    String myUrl = ApiConstant.BASE_URL +'companyRegistration?page=${currentPage}&size=6000';
    print(myUrl);
    var req = await http.get(Uri.parse(myUrl));
    if(req.statusCode == 200) {
      var response = json.decode(req.body);
      var type = AuthApi.fromJson(response);
      allUserList.addAll(type.content!);
      allUserList.forEach((element) {
        allUserNameList.add('${element.firstName} ${element.lastName}');
        if(element.isPaid != 0) {
          allVerifiedUserList.add('${element.firstName} ${element.lastName}\n${element.companyName}');
        }
      });
      print(allUserNameList.length.toString() + "length sacsczcscscscscscscscscscscscscscscscs");
      notifyListeners();
    }
  }

  getTruckLoadById(int id) async {
    ApiHelper apiHelper = ApiHelper();
    String myUrl = ApiConstant.FULL_LOAD_BY_ID + id.toString();
    print(myUrl);
    var response = await apiHelper.apiWithoutDecodeGet(myUrl);
    print(response.response);
    var result = NewTruckLoadModel.fromJson(jsonDecode(response.response));
    NewTruckLoad newTruckLoad = result.content![0];
    vehicleSizeController.text = newTruckLoad.vehicleSize!;
    loadWeightController.text = newTruckLoad.loadWeight!;
    setSafeSelectedSI(newTruckLoad.otherDetails);

    selectedCargo = newTruckLoad.typeOfCargo!;
    selectedPayment = newTruckLoad.typeOfPayment!;
    selectedRequriment = newTruckLoad.fullLoadChoice!;
    selectedPostType = newTruckLoad.type??"";
    sourceCity = newTruckLoad.source!;
    destinationCity = newTruckLoad.destination!;
    dnd = newTruckLoad.dnd == 0 ? false : true;
    hideMyID = newTruckLoad.privatePost == 0 ? false : true;
    expireDateController.text = newTruckLoad.expireDate!;
    if(newTruckLoad.userList==null){
    }else{
      var userList = getUserListFromString(newTruckLoad.userList!);
      debugPrint(userList);
    }
    addedMemberIdList = addedUserListInPost;
  }

  editPost(BuildContext context, int? id) async {
    User user = authProvider.userDetailList[0];
    PostLoad postLoad = PostLoad();
    postLoad.contactNumber = user.mobileNumber!;
    postLoad.destination = destinationCity;
    postLoad.dnd = dnd ? 1 : 0;
    postLoad.emailId = user.emailId!;
    postLoad.fullLoadChoice = "I Have Vehicle";
    postLoad.instructions = selectedSI;
    postLoad.loadWeight = loadWeightController.text;
    postLoad.loggedUserName = user.userName;
    postLoad.mainTag = selectedRequriment;
    postLoad.os = 'App';
    postLoad.otherDetails = selectedSI;
    postLoad.source = sourceCity;
    postLoad.partLoad = selectedPostType == 'Part Load' ? 1 : 0;
    postLoad.privatePost = hideMyID ? 1 : 0;
    postLoad.rating = 5;
    postLoad.type = selectedPostType;
    postLoad.typeOfCargo = selectedCargo;
    postLoad.typeOfPayment = selectedPayment;
    postLoad.vehicleSize = vehicleSizeController.text;
    postLoad.tableName = "Full Load";
    postLoad.topicName = "Full Load Truck";
    postLoad.image = images;
    postLoad.listOfUserIds = addedMemberIdList;
    postLoad.id = id;
    postLoad.expireDate = expireDateController.text;
    final response = await ApiHelper()
        .ApiPutDataMapRequest(ApiConstant.BASE_URL + "UpdatePost", postLoad.toJson());
    print('the request is ${json.encode(postLoad.toJson())}');
    print('the resopnse is ${response.statusCode}');
    if (response.statusCode == 200) {
      showSimpleNotification(
          Text("Post Edited Successfully",style: TextStyle(color: Colors.white),),
          background: Colors.black
      );
      moreProvider.getOwnPostList(user.id.toString());
      dashProvider.getFullLoadTruckList("From", "To");
     //nch  Navigator.pop(context);
      Navigator.pop(context, 1);
    } else {
      showSimpleNotification(
          Text("Please try again",style: TextStyle(color: Colors.white),),
          background: Colors.black
      );
    }
  }

  editVehiclePost(BuildContext context,int? id) async {
    User user = authProvider.userDetailList[0];
    PostLoad postLoad = PostLoad();
    postLoad.contactNumber = user.mobileNumber!;
    postLoad.destination = destinationCity;
    postLoad.dnd = dnd ? 1 : 0;
    postLoad.emailId = user.emailId!;
    postLoad.fullLoadChoice = "I Want Vehicle";
    postLoad.id = id;
    postLoad.instructions = selectedSI;
    postLoad.loadWeight = loadWeightController.text;
    postLoad.loggedUserName = user.userName;
    postLoad.mainTag = selectedRequriment;
    postLoad.os = 'App';
    postLoad.otherDetails = selectedSI;
    postLoad.source = sourceCity;
    postLoad.partLoad = selectedRequriment == 'Part Load Vehicle' ? 1 : 0;
    postLoad.privatePost = hideMyID ? 1 : 0;
    postLoad.rating = 5;
    //  postLoad.customerName= '${authProvider.userDetailList[0].firstName} ${authProvider.userDetailList[0].lastName}';
    postLoad.type = selectedRequriment;
    postLoad.typeOfCargo = selectedCargo;
    postLoad.typeOfPayment = selectedPayment;
    postLoad.vehicleSize = vehicleSizeController.text;
    postLoad.tableName = "Full Load";
    postLoad.topicName = "Full Load Truck";
    postLoad.image = images;
    postLoad.listOfUserIds = addedMemberIdList;

    ApiResponse response = await ApiHelper()
        .ApiPutDataMapRequest(ApiConstant.BASE_URL + "UpdatePost", postLoad.toJson());
    if (response.statusCode == 200) {
      showSimpleNotification(
          Text("Post edited successfully!",style: TextStyle(color: Colors.white),),
          background: Colors.black
      );
      Navigator.pop(context);
      Navigator.pop(context, 1);
    } else {
      showSimpleNotification(
          Text("Please try again",style: TextStyle(color: Colors.white),),
          background: Colors.black
      );
    }
  }

  enble() {
    if (vehicleSizeController.text.isNotEmpty &&
        loadWeightController.text.isNotEmpty &&
        emailIdController.text.isNotEmpty &&
        mobileNumberController.text.isNotEmpty &&
        selectedSI.isNotEmpty &&
        checkdropDown(selectedCargo) &&
        checkdropDown(selectedRequriment) &&
        checkdropDown(selectedPayment) &&
        checkdropDown(sourceCity) &&
        checkdropDown(destinationCity)) {
      enableButton = true;
    } else {
      enableButton = false;
    }
    notifyListeners();
  }

  checkdropDown(String val) {
    if (val.allMatches("Select One") == 0) {
      return false;
    } else {
      return true;
    }
  }

  selectedRequrimentType(int index) {
    selectedRequriment = reqirement[index];
    enble();
    notifyListeners();
  }

  selectedRequrimentVehicaleType(int index) {
    selectedRequriment = reqirementVehicale[index];
    enble();
    notifyListeners();
  }

  selectedCargoType(int index) {
    selectedCargo = cargoList[index];
    enble();
    notifyListeners();
  }

  selectedPaymentType(int index) {
    selectedPayment = paymentList[index];
    enble();
    notifyListeners();
  }

  selecteGroup(int index) async {
    print(groupListByUserId[index].groupName!);
    selectedGroup = groupListByUserId[index].groupName!;
    await getGroupMember(groupListByUserId[index].id!);
    // enble();
  }

  List<String> listOptionShow = ["All User", "Select Group", "Verified user"];
  String selectOption = "Select Option";

  selecteOptiontoShow(int index, BuildContext context) async {
    notifyListeners();
    switch (index) {
      case 0:
        addedMemberIdList.clear();
        selectOption = listOptionShow[index];
        return;
      case 1:
        if (groupListName.isEmpty) {
          await getGroupListByUserId();
        }
        ItemBottomSheet itemBottomSheet = ItemBottomSheet();
        int a = await itemBottomSheet.showIteamHieght(
            context, groupListName, "Select Group");
        selecteGroup(a);
        selectOption = listOptionShow[index];
        notifyListeners();
        return;

      case 2:
        if (sourceCity == "Select One") {
          showSimpleNotification(
              Text("Please Select Source City",style: TextStyle(color: Colors.white),),
              background: Colors.black
          );
        } else {
          List<UserVerifiedData> verfiedUserList=[];
          if (verfiedUserList.isNotEmpty) {
            addedMemberIdList.clear();
            for (int i = 0; i < verfiedUserList.length; i++) {
              addedMemberIdList.add(verfiedUserList[i].id!);
            }
            selectOption = listOptionShow[index];
          }
        }

        return;
    }
  }

  selectedSourceCity(String city) {
    sourceCity = city;
    enble();
    notifyListeners();
  }

  selectedDestinationCity(String city) {
    destinationCity = city;
    enble();
    notifyListeners();
  }

  checkValidation(BuildContext context) {
    if (vehicleSizeController.text.isEmpty) {
      vehicleSize = false;
    } else {
      vehicleSize = true;
    }
    if (loadWeightController.text.isEmpty) {
      loadWieght = false;
    } else {
      loadWieght = true;
    }
    String;

    String;
    if (selectedRequriment == "Select One") {
      showSimpleNotification(
          Text("Please Select Load Type",style: TextStyle(color: Colors.white),),
          background: Colors.black
      );
    } else {
      if (sourceCity == "Select One") {
        showSimpleNotification(
            Text("Please Select Form City",style: TextStyle(color: Colors.white),),
            background: Colors.black
        );
      } else {
        if (destinationCity == "Select One") {
          showSimpleNotification(
              Text("Please Select To City",style: TextStyle(color: Colors.white),),
              background: Colors.black
          );
        } else {
          if (selectedCargo == "Select One") {
            showSimpleNotification(
                Text("Please Select Form City",style: TextStyle(color: Colors.white),),
                background: Colors.black
            );
          } else {
            if (loadWieght && vehicleSize) {
              editPost(context,0);
            } else {
              showSimpleNotification(
                  Text("Please fill the all information",style: TextStyle(color: Colors.white),),
                  background: Colors.black
              );
            }
          }
        }
      }
    }
    notifyListeners();
  }

  checkVehicaleValidation(BuildContext context) {
    if (vehicleSizeController.text.isEmpty) {
      vehicleSize = false;
    } else {
      vehicleSize = true;
    }
    if (loadWeightController.text.isEmpty) {
      loadWieght = false;
    } else {
      loadWieght = true;
    }
    if (selectedRequriment == "Select One") {
      showSimpleNotification(
          Text("Please Select Load Type",style: TextStyle(color: Colors.white),),
          background: Colors.black
      );
    } else {
      if (sourceCity == "Select One") {
        showSimpleNotification(
            Text("Please Select Form City",style: TextStyle(color: Colors.white),),
            background: Colors.black
        );
      } else {
        if (destinationCity == "Select One") {
          showSimpleNotification(
              Text("Please Select To City",style: TextStyle(color: Colors.white),),
              background: Colors.black
          );
        } else {
          if (selectedCargo == "Select One") {
            showSimpleNotification(
                Text("Please Select Cargo Type",style: TextStyle(color: Colors.white),),
                background: Colors.black
            );
          } else {
            if (loadWieght && vehicleSize) {
              editVehiclePost(context,0);
            } else {
              showSimpleNotification(
                  Text("Please fill the all information",style: TextStyle(color: Colors.white),),
                  background: Colors.black
              );
            }
          }
        }
      }
    }
    notifyListeners();
  }

  dndChange(bool val) {
    dnd = val;
    notifyListeners();
  }

  hideMyId(bool val) {
    hideMyID = val;
    notifyListeners();
  }
}
