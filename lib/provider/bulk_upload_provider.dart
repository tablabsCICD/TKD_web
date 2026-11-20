import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:tkd_app/provider/auth_provider.dart';
import 'package:tkd_app/view/screens/dashboard/dashboard.dart';
import 'package:tkd_app/view/screens/menu_page.dart';

import '../../model/api_response.dart';
import '../../widgets/bottomsheet.dart';
import '../model/auth_api.dart';
import '../model/group_member.dart';
import '../model/group_member_list.dart' hide GroupMember;
import '../model/group_response.dart';
import '../network/api_call.dart';
import '../util/app_constants.dart';
import '../widgets/toast.dart';

class BulkUploadProvider extends ChangeNotifier{
  String selectedGroup = "Select One";
  String selectOption = "Select Option";
  bool isLoad = true;

  List<GroupData> groupListByUserId = [];
  List<String> groupListName = [];
  List<String> listOptionShow = ["All User", "Group"];
  List<GroupMember> listAddedMember = [];
  List<int> addedMemberIdList = [];
AuthProvider authProvider = AuthProvider();
  BulkUploadProvider() : super();

  // ================= FILE PICK =================

  Future<void> selectFile(BuildContext context) async {
    if (selectedGroup == "Select One") {
      ToastMessage.show(context, "Please select Show Post to");
      return;
    }

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      withData: true, // REQUIRED for web
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'xls'],
    );

    if (result == null) return;

    PlatformFile file = result.files.first;
    _confirmAndUpload(context, file);
  }

  // ================= CONFIRM DIALOG =================

  void _confirmAndUpload(BuildContext context, PlatformFile file) async {
    User user = await authProvider.getLoginData();

    String numbersString =
    addedMemberIdList.isNotEmpty ? addedMemberIdList.join(',') : "null";

    Map<String, String> fields = {
      "loggedUsername": user.userName!,
      "mobileNumber": user.mobileNumber.toString(),
      "email": user.emailId!,
      "tableName": "FullTruckLoad",
      "mainTag": isLoad ? "I Have Vehicle" : "I Want Vehicle",
      "images": "",
      "transporterOrCustomerName": user.userName!,
      if (addedMemberIdList.isNotEmpty) "listOfUserIds": numbersString,
    };

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Bulk Post"),
        content: const Text("Are you sure you want to upload document?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("No"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              uploadFile(
                context,
                ApiConstant.BULK_UPLOAD,
                file,
                fields,
              );
            },
            child: const Text("Yes", style: TextStyle(color: Colors.green)),
          ),
        ],
      ),
    );
  }

  // ================= UPLOAD =================

  Future<void> uploadFile(
      BuildContext context,
      String url,
      PlatformFile file,
      Map<String, String> fields,
      ) async {
    showUploadLoader(context);

    try {
      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.fields.addAll(fields);

      if (kIsWeb) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'file',
            file.bytes!,
            filename: file.name,
          ),
        );
      } else {
        request.files.add(
          await http.MultipartFile.fromPath(
            'file',
            file.path!,
            filename: file.name,
          ),
        );
      }

      final response = await request.send();


      if (response.statusCode == 200) {
        // ✅ Show success
        ToastMessage.show(context, "File uploaded successfully");

        // ✅ Small delay so message is visible
        await Future.delayed(const Duration(milliseconds: 700));

        if (!context.mounted) return;

        // ✅ Navigate to Home (clear stack)
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => MenuPage(selectedTab: "Dashboard"),
          ),
              (route) => false,
        );

      } else {
        ToastMessage.show(context, "File upload failed");
      }
    } catch (e) {
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }

      if (!context.mounted) return;

      debugPrint("Upload error: $e");
      ToastMessage.show(context, "Something went wrong");
    }
  }


  // ================= GROUP LIST =================

  Future<void> getGroupListByUserId() async {
    User user = await authProvider.getLoginData();

    ApiResponse response = await ApiHelper()
        .apiWithoutDecodeGet(ApiConstant.GET_GROUP_LIST(user.id));

    if (response.status == 200) {
      GroupListResponse data = GroupListResponse.fromJson(response.response);
      groupListByUserId = List<GroupData>.from(data.content ?? []);
      groupListName = groupListByUserId.map((e) => e.groupName!).toList();
    }
    notifyListeners();
  }

  Future<void> getGroupMember(int groupId) async {
    listAddedMember.clear();
    addedMemberIdList.clear();

    ApiResponse response = await ApiHelper()
        .apiWithoutDecodeGet(ApiConstant.GROUP_MEMBER_LIST + groupId.toString());

    GroupMemberListResponse data =
    GroupMemberListResponse.fromJson(response.response);

    listAddedMember.addAll((data.content ?? []) as Iterable<GroupMember>);
    addedMemberIdList.addAll(
      listAddedMember.map((e) => e.userId!).toList(),
    );
    notifyListeners();
  }

  Future<void> selecteGroup(int index) async {
    selectedGroup = groupListByUserId[index].groupName!;
    await getGroupMember(groupListByUserId[index].id!);
  }

  Future<void> selecteOptiontoShow(int index, BuildContext context) async {
    notifyListeners();

    if (index == 0) {
      addedMemberIdList.clear();
      selectedGroup = listOptionShow[index];
      return;
    }

    if (index == 1) {
      if (groupListName.isEmpty) await getGroupListByUserId();
      ItemBottomSheet sheet = ItemBottomSheet();
      int selected = await sheet.showIteamHieght(
        context,
        groupListName,
        "Select Group",
      );
      await selecteGroup(selected);
      selectedGroup = listOptionShow[index];
    }
  }

  void changeTab() {
    notifyListeners();
  }

  void showUploadLoader(BuildContext context, {String text = "Uploading..."}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(width: 20),
              Text(text),
            ],
          ),
        ),
      ),
    );
  }

}
