import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:tkd_app/locator.dart';
import 'package:tkd_app/model/auth_api.dart';
import 'package:tkd_app/model/rating_model.dart';
import 'package:tkd_app/model/rating_request.dart';
import 'package:tkd_app/model/truck_load_model.dart';
import 'package:tkd_app/network/api_call.dart';
import 'package:tkd_app/provider/auth_provider.dart';
import 'package:tkd_app/util/app_constants.dart';
import 'package:tkd_app/widgets/toast.dart';
import '../../model/api_response.dart';

class RatingProvider extends ChangeNotifier {
  bool isLoading=true;
  RatingProvider(
      ):super(){


  }

  int rating = 0;
  TextEditingController commentController = TextEditingController();
  bool buttonEnable=false;
 final authProvider = locator<AuthProvider>();

  changeRating(int rating){
    this.rating = rating;
    notifyListeners();
  }

  callSetState(){
    notifyListeners();
  }

  postRatingRaviews(BuildContext context, TruckLoad? load) async {
    User user = authProvider.userDetailList[0];
    String myUrl = "http://ec2-13-234-76-107.ap-south-1.compute.amazonaws.com:8080/tkd3/api/companyRegistration/${load!.userId}";
    User? userData;
    var req = await APIHelper().ApiPostData(myUrl);
    print('the response is ${req.response}');
    if(req.status== 200){      // try{
      userData=User.fromJson(req.response);}

    RatingRequest ratingRequest = RatingRequest();
    ratingRequest.rating = rating;
    ratingRequest.userId = user.id;
    ratingRequest.review = commentController.text;
    ratingRequest.companyId = userData!.companyId;

    ApiResponseHelper apiResponse = await APIHelper().ApiAddPostDataMapRequest(AppConstants.GIVE_RATING_REVIEWS,ratingRequest.toJson());
    if(apiResponse.statusCode==200){
      print(apiResponse.response);
      RatingModel ratingModel=RatingModel.fromJson(apiResponse.response);

      isLoading=false;
      notifyListeners();
    }else{
      ToastMessage.show(context, "Please Try Again");
    }
  }
}