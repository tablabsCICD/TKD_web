import 'package:flutter/material.dart';
import 'package:tkd_app/locator.dart';
import 'package:tkd_app/model/auth_api.dart';
import 'package:tkd_app/model/organization_model.dart';
import 'package:tkd_app/provider/auth_provider.dart';
import 'package:tkd_app/provider/org_provider.dart';
import 'package:tkd_app/view/screens/auth/login_screen.dart';
import 'package:tkd_app/view/screens/company/company_menu_page.dart';
import 'package:tkd_app/view/screens/menu_page.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {

  bool visitingFlag = true;
  List<User> userDetailList = [];
  final authProvider = locator<AuthProvider>();
  final orgProvider = locator<OrgProvider>();
  bool companyLogin=false,userLogin=true;
  List<Organization> orgList = [];
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    try {
      loginOrHome();
      companyLoginOrHome();
    } catch (e) {
      e.toString();
    }
  }

  loginOrHome() async{
    visitingFlag = (await authProvider.getVisitingFlag())!;
    if(visitingFlag == true){
      int? empid = await authProvider.getEmpId();
      if(empid != null){
        userDetailList = await authProvider.getUserDetails(empid);
        Navigator.push(context, MaterialPageRoute(builder: (builder)=>MenuPage(userDetailList: userDetailList)));
      }
    }
    else
      {
        Navigator.push(context, MaterialPageRoute(builder: (builder)=>Login_Screen()));
      }
  }

  companyLoginOrHome() async{
    visitingFlag = (await orgProvider.getCompanyVisitingFlag())!;
    print("visiting flag "+ visitingFlag.toString());
    if(visitingFlag == true){
      int? orgId = await orgProvider.getCompanyOrgId();
      print("visiting flag Id "+ orgId.toString());
      if(orgId != null){
        orgList  = await orgProvider.getCompanyDetails(orgId);
        Navigator.push(context, MaterialPageRoute(builder: (builder)=>CompanyMenuPage(orgList[0])));
      }
    }
    else
    {
      Navigator.push(context, MaterialPageRoute(builder: (builder)=>Login_Screen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
             /* SvgPicture.asset(
                'assets/svg/path_130788.svg',
                width: 60,
              ),*/
              const SizedBox(height: 50),
              CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(Theme.of(context).hintColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
