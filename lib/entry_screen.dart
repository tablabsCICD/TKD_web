import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tkd_app/model/shared_post_model.dart';
import 'package:tkd_app/model/version.dart';
import 'package:tkd_app/provider/auth_provider.dart';
import 'package:tkd_app/provider/dashboard_provider.dart';
import 'package:tkd_app/provider/org_provider.dart';
import 'package:tkd_app/util/app_constants.dart';
import 'package:tkd_app/util/custom_text_style.dart';
import 'package:tkd_app/view/screens/auth/login_screen.dart';
import 'package:tkd_app/view/screens/dashboard/sharedPostDetailsScreen.dart';
import 'package:tkd_app/view/screens/menu_page.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:uni_links/uni_links.dart';
import 'locator.dart';
import 'model/auth_api.dart';
import 'model/organization_model.dart';
import 'network/api_call.dart';
import 'view/screens/company/company_menu_page.dart';

class EntryScreen extends StatefulWidget {
  @override
  EntryState createState()=> EntryState();

}

class EntryState extends State<EntryScreen> {

  bool visitingFlag = true;
  List<User> userDetailList = [];
  final authProvider = locator<AuthProvider>();
  final dashboardProvider = locator<DashboardProvider>();
  final orgProvider = locator<OrgProvider>();
  bool companyLogin = false, userLogin = true;
  List<Organization> orgList = [];
  bool isDebug=true;

  @override
  void initState() {
    super.initState();
    // TODO: implement initState

    WidgetsBinding.instance.addPostFrameCallback((_){
      if (defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS){
        if(isDebug==true){
          versionControllApi();
        }else {
          //loginOrHome();
          initUniLinks();
        }
      }else {
       // loginOrHome();
        initUniLinks();
      }
    });
  }

  versionControllApi() async{
    ApiHelper api=ApiHelper();
    var result=await api.ApiGetData(ApiConstant.GET_CURRENT_VERSION);
    Version version=Version.fromJson(result);
    print('the version is ${version.version}');
    if(version.version! == ApiConstant.APP_VERSION){
      await initUniLinks();
    }else{
      upDateDailog();
    }
  }


  loginOrHome() async {
    visitingFlag = (await authProvider.getVisitingFlag())!;
    bool companyVisitingFlag = (await orgProvider.getCompanyVisitingFlag())!;
    if (visitingFlag == true) {
      int? empid = await authProvider.getEmpId();

        if (empid != null) {
        userDetailList = await authProvider.getUserDetails(empid);
        ApiConstant.USER_OBJECT=authProvider.userDetailList[0];
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (builder) =>
                    MenuPage(userDetailList: userDetailList,selectedTab:"Board")));
      }else{
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (builder) =>
                    Login_Screen()));
      }
    }
    else if( companyVisitingFlag == true){
      int? OrgId = await orgProvider.getCompanyOrgId();
      List<Organization> organization = await orgProvider.getCompanyDetails(OrgId!);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (builder) =>
                  CompanyMenuPage(organization[0])));
    }
    else{
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (builder) =>
                  Login_Screen()));
    }

  }

  SharedPostModel? truckLoad;
  loginOrDetails(String postId) async {
    visitingFlag = (await authProvider.getVisitingFlag())!;
    if (visitingFlag == true) {
      int? empid = await authProvider.getEmpId();
      if (empid != null) {
        truckLoad = await dashboardProvider.getRequirementDetails(int.parse(postId));
        authProvider.getUserUsingUserName(truckLoad?.loggedUserName,'','','');
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (builder) =>
                    SharedPostDetails(truckLoad!)));
      }else{
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (builder) =>
                    Login_Screen()));
      }
    }else {
      truckLoad = await dashboardProvider.getRequirementDetails(int.parse(postId));
      authProvider.getUserUsingUserName(truckLoad?.loggedUserName,'','','');
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (builder) =>
                  SharedPostDetails(truckLoad!)));
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold (
      backgroundColor: Colors.white,
    body: Center(
      child:CircularProgressIndicator() ,
    ),
    );

  }
  void upDateDailog() {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('TKDost Update',style: appbarTextStyle,),
        content: const Text('New application update is available on play store please update the app.',style: titleTextStyle,),
        actions: <Widget>[
          TextButton(
            onPressed:(){
              redirectionUrl();
            } ,
            child: const Text('Update',style:titleTextStyle,),
          ),
        ],
      ),
    );
  }
  void redirectionUrl() {
    launchUrlString("https://play.google.com/store/apps/details?id=com.pdk.tkd");
  }

  Future<void> initUniLinks() async {
    String postId='0';
    try {
      final initialLink = await getInitialLink();//"https://tkdost.com/tkd/?id=175509";//await getInitialLink();
      final initialUri = await getInitialUri();
      debugPrint('LINK::::$initialLink');
      debugPrint('$initialUri');
      if(initialLink==null){
        loginOrHome();
      }else
      {
        debugPrint("App open using Shared link............");
        var uri = Uri.parse(initialLink);
        uri.queryParameters.forEach((k, v) {
          print('key: $k - value: $v');
          if(k=='id'){
            postId = v;
          }
        });
        await loginOrDetails(postId);
      }
    } on PlatformException {

    }
  }
}


