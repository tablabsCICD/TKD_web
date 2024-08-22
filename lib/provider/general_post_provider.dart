import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:tkd_app/locator.dart';
import 'package:tkd_app/model/own_genral_post.dart';
import 'package:tkd_app/model/request/genral_post.dart';
import 'package:tkd_app/provider/auth_provider.dart';
import 'package:tkd_app/provider/dashboard_provider.dart';
import 'package:tkd_app/provider/more_provider.dart';
import 'package:tkd_app/util/app_constants.dart';

class GeneralPostProvider extends ChangeNotifier {
  List<String> images = [];
  final authProvider = locator<AuthProvider>();
  final dashboardProvider = locator<DashboardProvider>();
  final moreProvider = locator<MoreProvider>();
  List<GernralPostOwnData> listOwnPost = [];
  bool isLoading = false;

  callGeneralPostApi({int currentPage = 0}) async {
    isLoading = true;
    notifyListeners();
    if (currentPage == 0) {
      listOwnPost.clear();
    }

    String url =
        "${ApiConstant.BASE_URL}getBuySellByUserId?userId=${authProvider.userDetailList[0].id}";
    print("the url ${url}");
    var apiResponse = await http.get(Uri.parse(url));
    print("the url ${apiResponse.body}");
    isLoading = false;
    if (apiResponse.statusCode == 200) {
      OwnGenralPostList ownGenralPostList =
          OwnGenralPostList.fromJson(jsonDecode(apiResponse.body));
      listOwnPost.addAll(ownGenralPostList.data!);
      print('the lenghth is ${listOwnPost.length}');
      notifyListeners();
    } else {
      notifyListeners();
    }
  }

  deleteGeneralPost(int id, int index, BuildContext context) async {
    String myUrl = ApiConstant.BASE_URL +
        'GeneralPost/deleteById?id=${listOwnPost[index].id!}';
    var apiResponse = await http.delete(Uri.parse(myUrl));
    if (apiResponse.statusCode == 200) {
      listOwnPost.removeAt(index);
    } else {}
    notifyListeners();
  }

  void createGeneralPost(
      BuildContext context, String title, String description) async {
    GeneralPost generalPost = GeneralPost();
    generalPost.images = images;
    generalPost.description = description;
    generalPost.title = title;
    generalPost.typeName = "General Post";
    generalPost.comment = 0;
    generalPost.likes = 0;
    generalPost.loggedUserName = authProvider.userDetailList[0].id!;
    generalPost.disLikes = 0;
    final response = await http.post(
        Uri.parse(ApiConstant.BASE_URL + "GeneralPost/save"),
        headers: {"Content-Type": "application/json"},
        body: json.encode(generalPost.toJson()));
    print("response : ${response.statusCode}" +
        " --- " +
        response.body.toString());
    if (response.statusCode == 200) {
      showSimpleNotification(
          Text(
            "Post submitted successfully!",
            style: TextStyle(color: Colors.white),
          ),
          background: Colors.black);
      dashboardProvider.getFullLoadTruckList("From", "To", currentPage: 0);
      callGeneralPostApi();
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pop(context);
    } else {
      showSimpleNotification(
          Text(
            "Please try again!",
            style: TextStyle(color: Colors.white),
          ),
          background: Colors.black);
    }
    notifyListeners();
  }

  uploadImages(BuildContext context) async {
    await pickFile();
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
        print("Final img url:" + docs);
        return docs;
      } catch (ex) {
        throw Exception("Exception Occurred ${ex.toString()}");
      }
    }
  }

  String imageUrl = '';

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
      print("Original string:::" + value);
      imageUrl = imageUrl.replaceAll("\\", "").replaceAll("\"", "");

      print("Cleaned String:::" + imageUrl);
      images.add(imageUrl);

      print("uploaded images size " + images.length.toString());
    });
    notifyListeners();
    return imageUrl;
  }
}
