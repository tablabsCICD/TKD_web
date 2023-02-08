
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tkd_app/locator.dart';
import 'package:tkd_app/provider/auth_provider.dart';
import 'package:tkd_app/util/ResponsiveWidget.dart';
import 'package:tkd_app/util/color-resource.dart';
import 'package:tkd_app/util/style.dart';
import 'package:tkd_app/view/base_widget/custom_textview.dart';
import 'package:tkd_app/view/localization/language_constrants.dart';

import '../screens/discussion/discussion_dashboard.dart';
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
const Job_Page = 'Job_Page';
const My_Account = 'My_Account';
const My_Post = 'My_Post';
const My_Routes = 'My_Routes';
const Feedback = 'Feedback';
const My_Bids = 'My_Bids';
const My_Plans = 'Plans';
const Company = 'Company';
const Discussion = 'Discussion';
const Fleets = 'Fleets';
const Chat = 'Chats';
const Received_Bids = 'Received Bids';
// ignore: must_be_immutable
class DrawerMenu extends StatefulWidget {
  StringValue callBack;
  DrawerMenu({Key? key, required this.callBack}) : super(key: key);

  @override
  _DrawerMenuState createState() => _DrawerMenuState();
}
  class _DrawerMenuState extends State<DrawerMenu>{
  final authProvider = locator<AuthProvider>();
  var selectedTab = 'Board';

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        //height: 50,//MediaQuery.of(context).size.height-70,
        width: ResponsiveWidget.isDesktop(context) ? 270 : null,
        color: Colors.white,
        child: ListView(
          children: [
            getTile('assets/images/navigation_image/icn_board_on.png', Dashboard, context, 'Board', (selectedTab == Dashboard)),
            getDivider(),
            getTile('assets/images/navigation_image/icn_directory_off.png', Transport, context, 'Transport Directory', (selectedTab == Transport)),
            getDivider(),
            if (authProvider.userDetailList[0].transporterOrAgent == 2 || authProvider.userDetailList[0].transporterOrAgent == 3) SizedBox.shrink()
            else getTile('assets/images/navigation_image/icn_vehicles_off.png',Buy_Sell_Vehicles, context, 'Buy/Sell Vehicles', (selectedTab == Buy_Sell_Vehicles)),
            authProvider.userDetailList[0].transporterOrAgent == 3 || authProvider.userDetailList[0].transporterOrAgent ==2 ?SizedBox.shrink(): getDivider(),
           /* if (authProvider.userDetailList[0].transporterOrAgent == 3) SizedBox.shrink()
            else getTile('assets/images/navigation_image/icn_board_off.png', "Insurance_Finance", context, 'insurance_finance', (selectedTab == Insurance_Finance)),*/
          //  authProvider.userDetailList[0].transporterOrAgent == 3?SizedBox.shrink():getDivider(),
            if (authProvider.userDetailList[0].transporterOrAgent == 3) SizedBox.shrink()
            else getTile('assets/images/navigation_image/icn_announce_off.png',Announcement , context, 'Broadcast', (selectedTab == Announcement)),
            authProvider.userDetailList[0].transporterOrAgent == 3?SizedBox.shrink(): getDivider(),
            //if (authProvider.userDetailList[0].transporterOrAgent == 2 || authProvider.userDetailList[0].transporterOrAgent == 3) SizedBox.shrink()
            //else getTile('assets/images/navigation_image/icn_pool_off.png', Pool_Purchase, context, 'Pool Purchase', (selectedTab == Pool_Purchase)),
          //  authProvider.userDetailList[0].transporterOrAgent == 3 || authProvider.userDetailList[0].transporterOrAgent ==2 ?SizedBox.shrink(): getDivider(),
           /* if (authProvider.userDetailList[0].transporterOrAgent == 2 || authProvider.userDetailList[0].transporterOrAgent == 3) SizedBox.shrink()
            else getTile('assets/images/navigation_image/jobs.png', "Job_Page", context, 'jobs', (selectedTab == Job_Page)),*/
            //authProvider.userDetailList[0].transporterOrAgent == 3 || authProvider.userDetailList[0].transporterOrAgent ==2 ?SizedBox.shrink():getDivider(),
            //getTile('assets/images/navigation_image/icn_discussion_off.png', Chat, context, 'Chat', (selectedTab == Chat)),
            //getDivider(),
            getTile('assets/images/navigation_image/icn_account_off.png', My_Account, context, 'My Profile', (selectedTab == My_Account)),
            getTile('assets/images/navigation_image/icn_bullet_01.png', My_Post, context, 'My Post', (selectedTab == My_Post)),
            getTile('assets/images/navigation_image/icn_bullet_01.png',My_Routes , context, 'My Route', (selectedTab == My_Routes)),
            if (authProvider.userDetailList[0].transporterOrAgent == 3) SizedBox.shrink()
            else getTile('assets/images/navigation_image/icn_bullet_01.png', My_Bids, context, 'My Bids', (selectedTab == My_Bids)),
            if (authProvider.userDetailList[0].transporterOrAgent == 3) SizedBox.shrink()
            else getTile('assets/images/navigation_image/icn_bullet_01.png', Received_Bids, context, 'Received Bids', (selectedTab == Received_Bids)),
           // authProvider.userDetailList[0].transporterOrAgent == 3?SizedBox.shrink(): getDivider(),
            getTile('assets/images/navigation_image/icn_bullet_01.png', Company, context, 'Company', (selectedTab == Company)),
           // getDivider(),
            if (authProvider.userDetailList[0].transporterOrAgent == 2 || authProvider.userDetailList[0].transporterOrAgent == 3) SizedBox.shrink()
            else getTile('assets/images/navigation_image/icn_bullet_01.png', Fleets, context, 'Fleet', (selectedTab == Fleets)),
            getTile('assets/images/navigation_image/icn_bullet_01.png', Discussion, context, 'Discussion', (selectedTab == Discussion)),
            getTile('assets/images/navigation_image/icn_bullet_01.png',Feedback , context, 'Feedback', (selectedTab == Feedback)),
           // authProvider.userDetailList[0].transporterOrAgent == 3 || authProvider.userDetailList[0].transporterOrAgent ==2 ?SizedBox.shrink():getDivider(),
           // getTile('assets/images/navigation_image/icn_bullet_01.png', My_Plans, context, 'Plan', (selectedTab == My_Plans)),
           // getDivider(),
           /* authProvider.userDetailList[0].transporterOrAgent == 3 || authProvider.userDetailList[0].transporterOrAgent ==2 ?SizedBox.shrink():getDivider(),
            getTile('assets/images/navigation_image/directory.png', "Chats", context, 'chat', (selectedTab == Chat)),*/
            getDivider(),

          ],
        ),
      ),
    );
  }

  getDivider(){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: Divider(height: 1,thickness: 1,),
    );
  }



  getTile(String img,String value,BuildContext context,String text, bool isSelected){
    return Container(
      height: img=='assets/images/navigation_image/icn_bullet_01.png'?35:50,
      color: isSelected ? ColorResources.SELECTED_MENU : Colors.white,
      child: InkWell(
        onTap: (){
      if(value==Discussion){
        setState(() {

        });
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DiscussionDashboard()),
        );}else{
        widget.callBack(value);
        setState(() {
          selectedTab = value;
        });
      }

        },
        child: Row(
          children: [
            Container(
              height: img=='assets/images/navigation_image/icn_bullet_01.png'?35:50,
              width: 5,
              color: isSelected ? ColorResources.PRIMARY_COLOR : Colors.transparent,
            ),
            SizedBox(width: 20,),
            //Image.asset(img,width: 20,height: 20,),
            Row(
              children: [
                Image.asset(img,width: img=='assets/images/navigation_image/icn_bullet_01.png'? 14 : 20,height: img=='assets/images/navigation_image/icn_bullet_01.png'?12:20,color: isSelected ? ColorResources.PRIMARY_COLOR : Colors.grey),
                SizedBox(width: 16,),
                CustomText(text,
                  /*style: isSelected
                      ? img == 'assets/images/navigation_image/icn_bullet_01.png'? Style.selectedArrowMenuHeading :Style.selectedMenuHeading
                      : img == 'assets/images/navigat ion_image/icn_bullet_01.png'? Style.menuArrowHeading : Style.menuHeading,),*/
                  style: img == 'assets/images/navigation_image/icn_bullet_01.png'
                      ? isSelected ? Style.selectedArrowMenuHeading :Style.menuArrowHeading
                      : isSelected ? Style.selectedMenuHeading : Style.menuHeading,),
              ],
            ),

          ],
        ),
      ),
    );
  }
}



