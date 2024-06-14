import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tkd_app/locator.dart';
import 'package:tkd_app/model/api_response.dart';
import 'package:tkd_app/model/auth_api.dart';
import 'package:tkd_app/network/api_call.dart';
import 'package:tkd_app/util/app_constants.dart';
import 'package:tkd_app/view/base_widget/app_constant.dart';
import 'package:tkd_app/view/screens/auth/login_screen.dart';
import 'package:tkd_app/view/screens/menu_page.dart';
import 'package:tkd_app/view/screens/plan/plan_details_screen.dart';
import 'package:tkd_app/widgets/toast.dart';

import '../auth_provider.dart';

class SelectPlanProvider extends ChangeNotifier{
  SelectPlanProvider(){
    checkPlan();
  }

  bool clearPearl = true;
  bool bluePearl = false;
  bool redPearl = false;
  bool blackPearl = false;
  String selectPlan = "CURRENT PLAN";
  int planAmount = 0;
  int selectedPlanCode=0;
  int previousPlan=0;
  static int previousPlanCheck=0;
  String expDate="";

  selectClearPerl() {

    selectedPlanCode=0;
    if(selectedPlanCode==previousPlanCheck){
      selectPlan = "CURRENT PLAN";
    }else{
      selectPlan = "You Select this";
    }
    clearPearl = true;
    bluePearl = false;
    redPearl = false;
    blackPearl = false;
    planAmount = 0;
    notifyListeners();
  }
  User? user;
  final authProvider = locator<AuthProvider>();
  checkPlan()async{
    user=await authProvider.getLoginData();
    previousPlan=user!.isPaid!;
    previousPlanCheck=user!.isPaid!;

    selectedPlanCode=previousPlan;
    planAmount = 0;
    clearPearl = false;
    bluePearl = false;
    redPearl = false;
    blackPearl = false;
    switch(previousPlanCheck){
      case 0:clearPearl=true;
      notifyListeners();
            return;
      case 10:
        bluePearl=true;
        notifyListeners();
        return;
      case 20:
        redPearl=true;
        notifyListeners();
        return;
      case 30:
        blackPearl=true;
        notifyListeners();
        return;
    }



  }

  selectBlue() {
    selectedPlanCode=10;
    if(selectedPlanCode==previousPlanCheck){
      selectPlan = "CURRENT PLAN";
    }else{
      selectPlan = "You Select this";
    }
    clearPearl = false;
    bluePearl = true;
    redPearl = false;
    blackPearl = false;
    planAmount = 1;
    notifyListeners();
  }

  selectRed() {
    if(selectedPlanCode==previousPlanCheck){
      selectPlan = "CURRENT PLAN";
    }else{
      selectPlan = "You Select this";
    }
    selectedPlanCode=20;
    clearPearl = false;
    bluePearl = false;
    redPearl = true;
    blackPearl = false;
    planAmount = 349;
    notifyListeners();
  }

  selectBlack() {
    if(selectedPlanCode==previousPlanCheck){
      selectPlan = "CURRENT PLAN";
    }else{
      selectPlan = "You Select this";
    }
    selectedPlanCode=30;
    clearPearl = false;
    bluePearl = false;
    redPearl = false;
    blackPearl = true;
    planAmount = 449;
    notifyListeners();
  }

  onDeatilsPlan(BuildContext context, List<String> listLaugaes,
      List<bool> selectLang, String image, String Title, String amount, String period) {
    showModalBottomSheet<void>(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return FractionallySizedBox(
              heightFactor: 0.9,
              child: PlanDetailsScreen(
                listLaugaes: listLaugaes,
                selectLang: selectLang,
                image: image,
                subtitle: Title,
                amount: amount,
                period: period
              ));
        });
  }

  /*void showBootomSheet(BuildContext context) {
    showModalBottomSheet<void>(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return FractionallySizedBox(heightFactor: 0.7, child: KYCScreenOne());
        });
  }
*/
  goHome(BuildContext context) async {
    bool isLogin = (await authProvider.getVisitingFlag())!;
    if (isLogin) {
      /*Navigator.pushNamedAndRemoveUntil(
          context, AppRoutes.home, (route) => false);*/
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder)=>MenuPage(userDetailList: [user!],selectedTab: "Board",)), (route) => false);
    } else {
     /* Navigator.pushNamedAndRemoveUntil(
          context, AppRoutes.login, (route) => false);*/
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder)=>Login_Screen()), (route) => false);
    }
  }



  selectedPlan(BuildContext context) async {
    User user=await authProvider.getLoginData();
    ApiResponse apiResponse = await ApiHelper().ApiPutData(ApiConstant.UPDATE_YOUR_PLAN(user.id,selectedPlanCode));
    if (apiResponse.statusCode == 200) {
      var list = AuthApi.fromJson(jsonDecode(apiResponse.response));
  // User user=User.fromJson(apiResponse.response);
      if(list.content!.length>0){
        SharedPreferences preferences=await SharedPreferences.getInstance();
        preferences.setBool(AppConstant.LOGIN_BOOl, true);
        preferences.setString(AppConstant.LOGIN_KEY, jsonEncode(apiResponse.response));
        ToastMessage.show(context, "Plan Update Sucesss");

      }
      goHome(context);
    } else {
      print('the fail is ');
      ToastMessage.show(context, "Try Again");
    }
  }
}
