import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:tkd_app/locator.dart';
import 'package:tkd_app/model/auth_api.dart';
import 'package:tkd_app/model/comment_response.dart';
import 'package:tkd_app/provider/auth_provider.dart';
import 'package:tkd_app/util/app_constants.dart';

class CommentProvider extends ChangeNotifier {
  int countComment=0;
  int countLike=0;
  bool isLoading=true;


  int selectedPage=0;
  List<Comments> commentList = [];
  TextEditingController commentController = TextEditingController();
  ScrollController scrollController=ScrollController();
  final authProvider = locator<AuthProvider>();

  getCommentByPostId(int PostId) async {
    String url=AppConstants.BASE_URL+"/getGerenalPostComments?generalPostId=$PostId";

    print('the url $url');

    var apiResponse = await http.get(Uri.parse(url));
    if(apiResponse.statusCode==200){
      CommentResponse commentResponse=CommentResponse.fromJson(jsonDecode(apiResponse.body));
      countComment=commentResponse.data!.commentCount!;
      countLike=commentResponse.data!.generalPost!.likes!;
      commentList.clear();
      commentList.addAll(commentResponse.data!.comments as Iterable<Comments>);
      selectedPage++;
      isLoading=false;
      notifyListeners();
    }else{

    }
  }



  createCommentApi(int postId, String comment)async{

    User user = await authProvider.getLoginData();
    String url=AppConstants.BASE_URL+"comments";

    print('the url $url');

    Map<String, dynamic> requestParameter = {
      "comment": comment,
      "date": "string",
      "discussionId": postId,
      "firstName": user.firstName,
      "lastName": user.lastName,
      "userId": user.id!
    };
    print(requestParameter);
    /*  ApiResponse apiResponse=await ApiHelper().postParameter(url, requestParameter);
    print(apiResponse.status);*/
    var response = await http.post(Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestParameter));
    if(response.statusCode==200){
      commentController.clear();
      notifyListeners();
      getCommentByPostId(postId);

    } else{
      print("Comment not save successfully");
    }
    notifyListeners();

  }

  likeIncreamentApi(int postId, BuildContext context)async{

    User user = await authProvider.getLoginData();
    String url=AppConstants.BASE_URL+"GeneralPost/incrementLike?postId=${postId}&userId=${user.id}";

    print('the url $url');

    var req = await http.post(Uri.parse(url));
    if(req.statusCode == 200) {
      var response = json.decode(req.body);
      if(response['success']==true){
        print(response['message']);
        countLike=countLike+1;

      }else{
        print(response['message']);
      }
      notifyListeners();
    }else{
      if(req.statusCode==405){
        //ToastMessage.show(context, "You already like this post");
      }
      //print('the status code is ${req.statusCode}');
     // EasyLoading.dismiss();
    }

  }



}