import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:tkd_app/locator.dart';
import 'package:tkd_app/model/auth_api.dart';
import 'package:tkd_app/model/rating_model.dart';
import 'package:tkd_app/model/rating_request.dart';
import 'package:tkd_app/model/truck_load_model.dart';
import 'package:tkd_app/provider/auth_provider.dart';
import 'package:tkd_app/util/app_constants.dart';
import 'package:tkd_app/widgets/toast.dart';

class RatingProvider extends ChangeNotifier {
  bool isLoading = true;

  RatingProvider() : super() {}

  int rating = 0;
  TextEditingController commentController = TextEditingController();
  bool buttonEnable = false;
  final authProvider = locator<AuthProvider>();

  changeRating(int rating) {
    this.rating = rating;
    notifyListeners();
  }

  callSetState() {
    notifyListeners();
  }

  postRatingRaviews(BuildContext context, TruckLoad? load) async {
    User user = authProvider.userDetailList[0];
    User? userData;
    String myUrl = ApiConstant.REGISTRATION + '/${load!.userId}';
    print(myUrl);
    var req = await http.get(Uri.parse(myUrl));
    var response = await json.decode(req.body);
    print(response);
    if (req.statusCode == 200) {
      // try{
      var list = AuthApi.fromJson(response);
      userData = list.content![0];
    }

    RatingRequest ratingRequest = RatingRequest();
    ratingRequest.rating = rating;
    ratingRequest.userId = user.id;
    ratingRequest.review = commentController.text;
    ratingRequest.companyId = userData!.companyId;

    var apiResponse = await http.post(
        Uri.parse(ApiConstant.GIVE_RATING_REVIEWS),
        body: ratingRequest.toJson());
    print(apiResponse.body);
    if (apiResponse.statusCode == 200) {
      print(apiResponse.body);
      RatingModel ratingModel =
          RatingModel.fromJson(jsonDecode(apiResponse.body));
      debugPrint(ratingModel.message);
      ToastMessage.show(context, "Rating submitted");
      isLoading = false;
      notifyListeners();
    } else {
      ToastMessage.show(context, "Please Try Again");
    }
  }
}
