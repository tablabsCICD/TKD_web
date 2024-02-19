import 'dart:convert';
import 'dart:ui';
import 'package:http/http.dart';
import 'package:number_pagination/number_pagination.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:share/share.dart';
import 'package:staggered_grid_view_flutter/widgets/sliver.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';
import 'package:tkd_app/dialog/animated_custom_dialog.dart';
import 'package:tkd_app/locator.dart';
import 'package:tkd_app/multi_select.dart';
import 'package:tkd_app/open_whatsapp.dart';
import 'package:tkd_app/provider/auth_provider.dart';
import 'package:tkd_app/provider/bid_provider.dart';
import 'package:tkd_app/provider/dashboard_provider.dart';
import 'package:tkd_app/provider/plan_provider.dart';
import 'package:tkd_app/share_data.dart';
import 'package:tkd_app/show_bid.dart';
import 'package:tkd_app/util/style.dart';
import 'package:tkd_app/view/base_widget/custom_textfeild.dart';
import 'package:tkd_app/view/base_widget/custom_textview.dart';
import 'package:tkd_app/view/base_widget/getImage.dart';
import 'package:tkd_app/view/localization/language_constrants.dart';
import 'package:tkd_app/view/screens/dashboard/create_requirement.dart';
import 'package:tkd_app/view/screens/dashboard/requirementDeatils.dart';
import 'package:tkd_app/view/screens/menu_page.dart';
import 'package:universal_html/html.dart' as html;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:tkd_app/model/truck_load_model.dart';
import 'package:tkd_app/util/ResponsiveWidget.dart';
import 'package:tkd_app/util/color-resource.dart';
import 'package:tkd_app/util/custom_text_style.dart';
import 'package:tkd_app/util/date_converter.dart';
import 'package:tkd_app/util/star_display.dart';
import 'package:tkd_app/view/base_widget/custom_button.dart';
import 'package:tkd_app/view/screens/dashboard/allRequirement.dart';

class PlanScreen extends StatefulWidget {
  final dashboardProvider = locator<PlanProvider>();

  PlanScreen({Key? key}) : super(key: key) {
    dashboardProvider.getFullLoadTruckList();
  }

  @override
  _PlanScreenState createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
          color: ColorResources.HOME_BG,
          child: ResponsiveWidget(
            desktop: WebScreenDashBoard(),
            mobile:WebScreenDashBoard(),
            tablet: WebScreenDashBoard(),
          )),
    );
  }
}

class WebScreenDashBoard extends StatefulWidget {
  @override
  _WebScreenDashBoardState createState() => _WebScreenDashBoardState();
}

class _WebScreenDashBoardState extends State<WebScreenDashBoard> {
  final bidProvider = locator<BidProvider>();
  final authProvider = locator<AuthProvider>();
  TextEditingController bidAmtController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController sourceController = TextEditingController();
  TextEditingController destinationController = TextEditingController();
  TextEditingController filterController = TextEditingController();
  int counter = 0;
  var selectedPageNumber = 1;
  final dashboardProvider = locator<DashboardProvider>();
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Consumer<PlanProvider>(
      builder: (context, model, child) => Container(
          margin: ResponsiveWidget.isDesktop(context)?EdgeInsets.symmetric(
            horizontal: 35,vertical: 50
          ):ResponsiveWidget.isTablet(context)?EdgeInsets.symmetric(
              horizontal: 35,vertical: 50
          ):EdgeInsets.symmetric(
              horizontal: 10,vertical: 10
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomText(getTranslated('plan_msg', context)!,style: Style.title,),
                SizedBox(height: 20,),
                getPlanCard('diamond_plan','plan_msg','3,000','assets/images/diamond.png',Color(0xff0087ba),Color(0xff10c9d9)),
                getPlanCard('ruby_plan','plan_msg','2,000','assets/images/platinum.png',Color(0xffab34e0),Color(0xff8fabff)),
                getPlanCard('gold_plan','plan_msg','1,000','assets/images/gold.png',Color(0xffde8b02),Color(0xfffacf5a)),
                getPlanCard('silver_plan','plan_msg','Free','assets/images/silver.png',Color(0xff3d3d3d),Color(0xff9a9a9a))
              ],
            ),
          )
      ),
    );
  }

  getPlanCard(String plan, String planDetails, String price, String image, Color color1, Color color2) {
    return Card(
      elevation: 5,
      margin: ResponsiveWidget.isMobile(context)?EdgeInsets.symmetric(horizontal: 10,vertical: 10):EdgeInsets.symmetric(horizontal: 50,vertical: 10),
      child: Container(
       // height: ResponsiveWidget.isDesktop(context)?100:130,
        width: 500,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          gradient: LinearGradient(
            colors: [
              color1,
              color2
            ],
          ),
        ),
        child:ListTile(
          minVerticalPadding: 0,
          leading: Image.asset(image,height: 50,width: 50,),
          title: CustomText(getTranslated(plan, context)!,style: Style.planTitle,),
          subtitle: CustomText(getTranslated(planDetails, context)!,style: Style.planSubtitle,),
          trailing: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                width: 91,
                height: 30,
                child: Row(
                  children: [
                    Icon(Icons.currency_rupee,size: 30,color: Colors.white,),
                    CustomText(price,style: Style.price,),
                  ],
                ),
              ),
              CustomText('year',style: Style.planSubtitle,)
            ],
          ),
        ),
      ),
    );
  }
}
