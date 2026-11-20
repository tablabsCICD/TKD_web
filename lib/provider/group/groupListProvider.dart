import 'dart:convert';

import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:tkd_app/locator.dart';
import 'package:tkd_app/model/api_response.dart';
import 'package:tkd_app/model/create_group.dart';
import 'package:tkd_app/model/group_list_model.dart';
import 'package:tkd_app/model/searchUserResponse.dart';
import 'package:tkd_app/network/api_call.dart';
import 'package:http/http.dart' as http;
import 'package:tkd_app/provider/auth_provider.dart';
import '../../model/auth_api.dart';
import '../../model/group_added_member.dart';
import '../../model/group_member.dart';
import '../../util/app_constants.dart';
import '../../view/base_widget/loader.dart';

class GroupListProvider extends ChangeNotifier {
  bool isLoading = false;
  bool isFirstLoading = false;
  List<User> allUserList = [];
  List<User> filterByName = [];
  List<User> selectedUsers = [];
  List<GroupMemberContent> listAddedMember = [];
  bool createGroup = false;
  String imageUrl =
      'https://cdn.pixabay.com/photo/2016/03/23/22/26/user-1275780_1280.png';
  List<GroupContent?> listGroup = [];
  String changeImageUrl = '';
  final authProvider = locator<AuthProvider>();

  getAllUserList(bool isFromEdit,String char) async {
    filterByName.clear();
    allUserList.clear();
    if (!isFromEdit && (char == null || char.trim().isEmpty)) {
      selectedUsers.clear();
    }
    isLoading = true;
    notifyListeners();
    if (allUserList.length == 0) {
      //String myUrl = ApiConstant.BASE_URL +'companyRegistration?page=${0}&size=6000';
      String myUrl = ApiConstant.CHAT_USER_LIST_COMPANY(char);
      print(myUrl);
      var responseBody = await ApiHelper().ApiGetData(myUrl);
      isFirstLoading = false;
      var type = SearchApiResponse.fromJson(responseBody);
      allUserList.addAll(type.data!);
    }
    isLoading = false;
    //filterByName.addAll(allUserList);
    if (isFromEdit == true) {
      for (int i = 0; i < allUserList.length; i++) {
        allUserList[i].addedIngroup = false;
        for (int j = 0; j < listAddedMember.length; j++) {
          if (allUserList[i].id == listAddedMember[j].userId) {
            allUserList[i].addedIngroup = true;
            allUserList[i].isSelected = true;

            // avoid duplicate add
            if (!selectedUsers.any((u) => u.id == allUserList[i].id)) {
              selectedUsers.add(allUserList[i]);
            }
          }
        }

        if (allUserList[i].id != ApiConstant.USER_OBJECT.id) {
          filterByName.add(allUserList[i]);
        }
      }
    } else {
      for (int i = 0; i < allUserList.length; i++) {
        allUserList[i].isSelected = false;
        if (allUserList[i].id != ApiConstant.USER_OBJECT.id) {
          filterByName.add(allUserList[i]);
        }
      }
    }

    notifyListeners();
  }

  changeImage(String imageUrl) {
    changeImageUrl = imageUrl;
    notifyListeners();
  }

  filterUser(String name) {
    filterByName.clear();
    if (name.length > 2) {
      filterByName.clear();
      notifyListeners();
      for (int i = 0; i < allUserList.length; i++) {
        if (allUserList[i]
                    .firstName!
                    .toLowerCase()
                    .contains(name.toLowerCase()) ==
                true ||
            allUserList[i]
                    .lastName!
                    .toLowerCase()
                    .contains(name.toLowerCase()) ==
                true) {
          filterByName.add(allUserList[i]);
        }
      }
    } else {
      filterByName.addAll(allUserList);
    }
    notifyListeners();
  }

  void resetSelection() {
    selectedUsers.clear();
    filterByName.clear();
    allUserList.clear();

    // Also reset addedIngroup flags if needed
    for (var user in allUserList) {
      user.addedIngroup = false;
      user.isSelected = false;
    }

    notifyListeners();
  }

  selectedUser(bool? value, User userObj) {
    userObj.isSelected = value;

    if (value == true) {
      selectedUsers.add(userObj);
    } else {
      selectedUsers.remove(userObj);
    }
    notifyListeners();
  }

  callCreateGroupApi(
      int? userId, String groupName, BuildContext context) async {
    isLoading = true;
    showLoader(context);
    ApiHelper apiHelper = ApiHelper();
    String date =
        DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(DateTime.now());
    Map<String, dynamic> parameter = {
      'createByUserId': userId,
      'groupName': groupName,
      'isPrivate': 0,
      'imageUrl': imageUrl,
      'date': date
    };
    ApiResponse response = await apiHelper.ApiAddPostDataMapRequestCall(
        ApiConstant.GROUP, parameter);
    isLoading = false;
    showLoader(context);
    if (response.statusCode == 200) {
      GroupCreateModel model = GroupCreateModel.fromJson(response.response);
      callGroupMember(model.id, userId, context, false);
    } else {
      notifyListeners();
    }
  }

  void callGroupMember(
      int? groupId, int? userId, BuildContext context, bool isFrom) async {
    String date =
        DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(DateTime.now());
    List<GroupMember> selectedUserId = [];
    for (int i = 0; i < selectedUsers.length; i++) {
      String? dpName =
          selectedUsers[i].firstName! + " " + selectedUsers[i].lastName!;
      selectedUserId
          .add(GroupMember(displayName: dpName, userId: selectedUsers[i].id));
    }
    ApiHelper apiHelper = ApiHelper();
    Map<String, dynamic> parameter = {
      'addedByUserId': userId,
      'groupId': groupId,
      'date': date,
      'listOfUsers': selectedUserId,
    };
    var response = await apiHelper.ApiAddPostDataMapRequest(
        ApiConstant.GROUP_MEMBER_BULK, parameter);
    if (response == 200) {
      createGroup = true;

      if (isFrom == true) {
        getGroupMember(groupId!);
      } else {
        await getAllGroup(userId, context);
      }
    } else {
      isLoading = false;
      notifyListeners();
    }
  }

  pickFile() async {
    var result = await FilePicker.platform.pickFiles(
      withReadStream: true,
      allowMultiple: false,
    );
    if (result != null) {
      try {
        String fileName = result.files.first.name;
        print(result.files.first.toString());
        var objFile = result.files.single;
        var imageBytes = result.files.first.bytes;
        print(fileName);
        var docs = await uploadGroupPhoto(
            imageFilePath: fileName,
            imageBytes: imageBytes,
            objectFile: objFile);
        print("Uploaded Img:" + docs.toString());
        imageUrl = docs.toString();
      } catch (ex) {
        throw Exception("Exception Occurred ${ex.toString()}");
      }
    }
  }

  uploadGroupPhoto(
      {String? imageFilePath,
      Uint8List? imageBytes,
      PlatformFile? objectFile}) async {
    String myUrl = ApiConstant.IMG_UPLOAD;
    var postUri = Uri.parse(myUrl);
    var request = new http.MultipartRequest("POST", postUri);
    Map<String, String> headers = {"Content-Type": "multipart/form-data"};
    request.files.add(new http.MultipartFile(
        "profilePicture", objectFile!.readStream!, objectFile.size,
        filename: objectFile.name));
    request.headers.addAll(headers);
    var response = await request.send();
    print(response.statusCode);
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
      imageUrl = value;
    });

    notifyListeners();
  }

  showLoader(context) {
    if (isLoading) {
      Loader().showLoaderDialog(context);
    } else {
      Loader().dismissLoader(context);
    }
  }

  goToNextPage(BuildContext context) {
    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }

  getAllGroup(int? userId, context) async {
    print('the id is +${ApiConstant.USER_OBJECT.id}');
    listGroup.clear();
    isLoading = true;
    ApiHelper apiHelper = ApiHelper();
    var response = await apiHelper.ApiGetData(
        ApiConstant.GROUP_BY_USER + userId!.toString() + "?page=0&size=1000");
    isLoading = false;

    GroupListModel groupListModel = GroupListModel.fromJson(response);
    listGroup.addAll(groupListModel.content!);
    notifyListeners();
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

  removeMemberFromGroup(int memberId, int index) async {
    ApiHelper apiHelper = ApiHelper();
    var response = await apiHelper.ApiDeleteData(
        ApiConstant.GROUP_MEMBER_DELETE + memberId.toString());
    ;
    if (response.statusCode == 200) {
      listAddedMember.removeAt(index);
      notifyListeners();
    }
  }

  deleteGroup(BuildContext context, GroupContent groupContent) async {
    String myUrl =
        "${ApiConstant.DELETE_GROUP}" + "${groupContent.id.toString()}";
    print(myUrl);
    var res = await http.delete(Uri.parse(myUrl));
    print(res.body);
    if (res.statusCode == 200) {
      listGroup.remove(groupContent.id);
      getAllGroup(authProvider.userDetailList[0].id, context);
      notifyListeners();
    }
  }
}
