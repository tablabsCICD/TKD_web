import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tkd_app/locator.dart';
import 'package:tkd_app/provider/auth_provider.dart';
import 'package:tkd_app/util/ResponsiveWidget.dart';
import 'package:tkd_app/util/color-resource.dart';
import 'package:tkd_app/util/style.dart';
import 'package:tkd_app/view/base_widget/custom_button.dart';
import 'package:tkd_app/view/base_widget/custom_textview.dart';
import 'package:tkd_app/view/localization/language_constrants.dart';
import 'package:tkd_app/view/screens/auth/login_screen.dart';

import '../screens/discussion/discussion_dashboard.dart';
import '../screens/group/groupListScreen.dart';
import '../screens/transport/transport_search_screen.dart';

typedef StringValue = Function(String);

const Dashboard = 'Board';
const Markets = 'Markets';
const Transport = 'Transport Directory';
const Discussions = 'Discussions';
const Buy_Sell_Vehicles = 'Buy_Sell_Vehicles';
const Insurance_Finance = 'Insurance_Finance';
const Announcement = 'Announcement';
const Pool_Purchase = 'Pool_Purchase';
const Job_Page = 'Jobs';
const My_Account = 'My_Account';
const My_Post = 'My_Post';
const My_Routes = 'My_Routes';
const Feedback = 'Feedback';
const My_Quotes = 'My Quotes';
const My_Plans = 'Plans';
const Company = 'Company';
const Discussion = 'Discussion';
const Fleets = 'Fleets';
const Package_Change = "Package Change";
const Chat = 'Chats';
const Received_Quotes = 'Received Quotes';
const Logout = 'Logout';
const Call = "Call";
const Group = "Group";
const Privacy_Policy = "Privacy Policy";

// ignore: must_be_immutable
class DrawerMenu extends StatefulWidget {
  StringValue callBack;
  String selectedTab;
  DrawerMenu({Key? key, required this.callBack, required this.selectedTab}) : super(key: key);

  @override
  _DrawerMenuState createState() => _DrawerMenuState();
}

class _DrawerMenuState extends State<DrawerMenu> {
  final authProvider = locator<AuthProvider>();
  String selectedTab = "Board";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedTab = widget.selectedTab;
  }

  @override
  Widget build(BuildContext context) {

    return Drawer(
      child: Container(
        //height: 50,//MediaQuery.of(context).size.height-70,
        width: ResponsiveWidget.isDesktop(context) ? 270 : null,
        color: Colors.white,
        child: ListView(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Center(
                  child: SvgPicture.asset(
                "assets/svg/logo.svg",
                height: 77,
                width: 133,
              )),
            ),
            SizedBox(
              height: 47,
            ),
            getTile('assets/images/navigation_image/icn_board_on.png',
                Dashboard, context, 'Board', (selectedTab == Dashboard)),
            getDivider(),
            getTile(
                'assets/images/navigation_image/icn_directory_off.png',
                Transport,
                context,
                'Transport Directory',
                (selectedTab == Transport)),
            getDivider(),
            if (authProvider.userDetailList[0].transporterOrAgent == 3 ||
                authProvider.userDetailList[0].transporterOrAgent == 2)
              SizedBox.shrink()
            else
              getTile(
                  'assets/images/navigation_image/icn_vehicles_off.png',
                  Buy_Sell_Vehicles,
                  context,
                  'Buy/Sell Vehicles',
                  (selectedTab == Buy_Sell_Vehicles)),
            authProvider.userDetailList[0].transporterOrAgent == 3 ||
                    authProvider.userDetailList[0].transporterOrAgent == 2
                ? SizedBox.shrink()
                : getDivider(),
            if (authProvider.userDetailList[0].transporterOrAgent == 3)
              SizedBox.shrink()
            else
              getTile('assets/images/navigation_image/jobs.png', Job_Page,
                  context, 'Jobs', (selectedTab == Job_Page)),
            getDivider(),
            getTile('assets/images/navigation_image/jobs.png', Package_Change,
                context, 'Package Change', (selectedTab == Package_Change)),
            authProvider.userDetailList[0].transporterOrAgent == 3 ||
                    authProvider.userDetailList[0].transporterOrAgent == 2
                ? SizedBox.shrink()
                : getDivider(),
            getTile('assets/images/navigation_image/icn_account_off.png',
                My_Account, context, 'My Profile', (selectedTab == My_Account)),
            getTile('assets/images/navigation_image/icn_bullet_01.png', My_Post,
                context, 'My Post', (selectedTab == My_Post)),
            getTile('assets/images/navigation_image/icn_bullet_01.png',
                My_Routes, context, 'My Route', (selectedTab == My_Routes)),
            if (authProvider.userDetailList[0].transporterOrAgent == 3)
              SizedBox.shrink()
            else
              getTile('assets/images/navigation_image/icn_bullet_01.png',
                  My_Quotes, context, 'My Quotes', (selectedTab == My_Quotes)),
            if (authProvider.userDetailList[0].transporterOrAgent == 3)
              SizedBox.shrink()
            else
              getTile(
                  'assets/images/navigation_image/icn_bullet_01.png',
                  Received_Quotes,
                  context,
                  'Received Quotes',
                  (selectedTab == Received_Quotes)),
            //  getTile('assets/images/navigation_image/icn_bullet_01.png', Company, context, 'Company', (selectedTab == Company)),
            /* if (authProvider.userDetailList[0].transporterOrAgent == 3) SizedBox.shrink()
            else getTile('assets/images/navigation_image/icn_bullet_01.png', Fleets, context, 'Owner Data', (selectedTab == Fleets)),
            getTile('assets/images/navigation_image/icn_bullet_01.png', Discussion, context, 'Discussion', (selectedTab == Discussion)),*/
            getTile('assets/images/navigation_image/icn_bullet_01.png', Group,
                context, 'Group', (selectedTab == Group)),

            //   getTile('assets/images/navigation_image/icn_bullet_01.png',Feedback , context, 'Feedback', (selectedTab == Feedback)),

            getDivider(),
            getTile('assets/images/call.png', Call, context, 'Call To Support',
                (selectedTab == Call)),
            getDivider(),
            getTile('assets/images/privacy_policy.png', Privacy_Policy, context,
                'Privacy Policy', (selectedTab == Privacy_Policy)),
            getDivider(),
            getTile('assets/images/navigation_image/icn_board_on.png', Logout,
                context, 'Logout', (selectedTab == Logout)),
            SizedBox(
              height: 50,
            )
          ],
        ),
      ),
    );
  }

  void getLogoutFunction() {
    showDialog(
        context: context,
        builder: (_) => new CupertinoAlertDialog(
              title: CustomText("Logout"),
              actions: <Widget>[
                TextButton(
                  child: CustomText("Yes",
                      style: TextStyle(color: ColorResources.RED)),
                  onPressed: () {
                    logoutFunction(authProvider);
                  },
                ),
                TextButton(
                  child: CustomText(
                    "No",
                    style: TextStyle(color: ColorResources.GREEN),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
  }

  Future<void> logoutFunction(AuthProvider authProvider) async {
    await authProvider.setVisitingFlag(false);
    await authProvider.setEmpId(0);
    Navigator.push(
        context, MaterialPageRoute(builder: (builder) => Login_Screen()));
  }

  getDivider() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: Divider(
        height: 1,
        thickness: 1,
      ),
    );
  }

  getTile(String img, String value, BuildContext context, String text,
      bool isSelected) {
    return Container(
      height:
          img == 'assets/images/navigation_image/icn_bullet_01.png' ? 35 : 50,
      color: isSelected ? ColorResources.SELECTED_MENU : Colors.white,
      child: InkWell(
        onTap: () {
          selectedTab = value;
          if (value == Call) {
            calltoSupport(context);
          } else {
            if (value == Discussion) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DiscussionDashboard()),
              );
            } else
              if (value == Transport) {
                selectedTab = Dashboard;
              setState(() {});
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TransportSearchScreen()),
              );
            } else
              if (value == Logout) {
               getLogoutFunction();
              } else
              if (value == Group) {
                selectedTab = Dashboard;
              setState(() {});
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => GroupList()),
              );
            }
              else {
              widget.callBack(value);
            }
          }

          /*setState(() {
            if(value== Call){
            calltoSupport(context);
            }
                selectedTab = value;

          });*/
        },
        child: Row(
          children: [
            Container(
              height: img == 'assets/images/navigation_image/icn_bullet_01.png'
                  ? 35
                  : 50,
              width: 5,
              color: isSelected
                  ? ColorResources.PRIMARY_COLOR
                  : Colors.transparent,
            ),
            SizedBox(
              width: 20,
            ),
            //Image.asset(img,width: 20,height: 20,),
            Row(
              children: [
                Image.asset(img,
                    width: img ==
                            'assets/images/navigation_image/icn_bullet_01.png'
                        ? 14
                        : 20,
                    height: img ==
                            'assets/images/navigation_image/icn_bullet_01.png'
                        ? 12
                        : 20,
                    color: isSelected
                        ? ColorResources.PRIMARY_COLOR
                        : Colors.grey),
                SizedBox(
                  width: 16,
                ),
                CustomText(
                  text,
                  /*style: isSelected
                      ? img == 'assets/images/navigation_image/icn_bullet_01.png'? Style.selectedArrowMenuHeading :Style.selectedMenuHeading
                      : img == 'assets/images/navigat ion_image/icn_bullet_01.png'? Style.menuArrowHeading : Style.menuHeading,),*/
                  style:
                      img == 'assets/images/navigation_image/icn_bullet_01.png'
                          ? isSelected
                              ? Style.selectedArrowMenuHeading
                              : Style.menuArrowHeading
                          : isSelected
                              ? Style.selectedMenuHeading
                              : Style.menuHeading,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  calltoSupport(context) {
    showDialog(
        context: context,
        builder: (_) => new CupertinoAlertDialog(
              title: CustomText('Contact Number : 8123004666 and 8123006888',
                  style: TextStyle(
                      color: ColorResources.BOTTOM_HEADING,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              actions: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0),
                  child: CustomButton(
                    buttonText:'Ok' ,
                    onTap: () {
                      /* widget.callBack("Back");
                  setState(() {

                  });*/
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ));
  }
}
