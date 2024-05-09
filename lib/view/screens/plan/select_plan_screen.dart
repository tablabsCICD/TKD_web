import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tkd_app/locator.dart';
import 'package:tkd_app/model/auth_api.dart';
import 'package:tkd_app/provider/auth_provider.dart';
import 'package:tkd_app/provider/plan/select_plan.dart';
import 'package:tkd_app/util/colors.dart';
import 'package:tkd_app/util/images.dart';
import 'package:tkd_app/view/payment/razor_pay.dart';
import 'package:tkd_app/widgets/button.dart';
import 'package:tkd_app/widgets/linear_progress.dart';
import 'package:tkd_app/widgets/plan_widget.dart';
import 'package:tkd_app/widgets/toast.dart';



class SelectPlanScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SelectPlanScreen();
  }
}

class _SelectPlanScreen extends State<SelectPlanScreen> {
  @override
  Widget build(BuildContext context) {
    return  _buildPage(context);
  }

  _buildPage(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.baground,
      body: SafeArea(
        child: Consumer<SelectPlanProvider>(
          builder: (context, provider, child) {
            return Container(
              margin: EdgeInsets.only(left: 20, right: 20),
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                SizedBox(
                  height: 21.5,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SvgPicture.asset(Images.arrow_back),
                    Text(
                      'Select Plan',
                     style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox()
                  ],
                ),
                SizedBox(
                  height: 21,
                ),
                LinearProgressBar(fillValue: 301),
                SizedBox(
                  height: 21,
                ),
                InkWell(
                    onTap: () {
                     provider.selectClearPerl();
                    },
                    child: PlanWidget(
                      isSelected: provider.clearPearl,
                      title: 'Clear pearl',
                      amount: '0',
                      image: Images.pearls,
                      subtitle: 'CURRENT PLAN',
                      onClick: () {
                        List<String> listLaugaes = [
                          "Post a Load/Post a Vechlie (Only 5 Post)",
                          'Email Notifications',
                          'SMS Notifications',
                          'WHATSAPP Notifications',
                          'Sponsered Ad/Google ad+ User posted add',
                          'SELL POST (Only 1 Post)',
                          'DIRECTORY ACCESS',
                          'JOB POSTING',
                          'BIDDING (Only 5 Post)',
                          "PRIORITY DIRECTORY",
                          "VERIFIED GREEN MARK",
                          "VERIFIED BLUE MARK(TRUSTED)",
                          "GOOGLE Business SET UP"
                        ];

                        List<bool> selectLang = [
                          true,
                          false,
                          false,
                          false,
                          true,
                          true,
                          true,
                          false,
                          true,
                          false,
                          false,
                          false,
                          false
                        ];
                        provider.onDeatilsPlan(context,listLaugaes, selectLang, Images.pearls,
                            "Clear pearl", "0");
                      },
                    )),
                SizedBox(
                  height: 12,
                ),
                InkWell(
                    onTap: () {
                     provider.selectBlue();
                    },
                    child: PlanWidget(
                      isSelected:provider. bluePearl,
                      title: 'Blue pearl',
                      amount: '1',
                      image: Images.pearls_blue,
                      subtitle: 'RECOMMENDED',
                      onClick: () {
                        List<String> listLaugaes = [
                          "Post a Load/Post a Vechlie (Only 50)",
                          'Email Notifications',
                          'SMS Notifications',
                          'WHATSAPP Notifications',
                          'Sponsered Ad/Google ad+ User posted add',
                          'SELL POST Only(5)',
                          'DIRECTORY ACCESS',
                          'JOB POSTING',
                          'BIDDING Only (50)',
                          "PRIORITY DIRECTORY",
                          "VERIFIED GREEN MARK",
                          "VERIFIED BLUE MARK(TRUSTED)",
                          "GOOGLE Business SET UP"
                        ];

                        List<bool> selectLang = [
                          true,
                          false,
                          false,
                          false,
                          true,
                          true,
                          true,
                          false,
                          true,
                          false,
                          false,
                          false,
                          false
                        ];
                        provider. onDeatilsPlan(context,listLaugaes, selectLang,
                            Images.pearls_blue, "Blue pearl", "1");
                      },
                    )),
                SizedBox(
                  height: 12,
                ),
                InkWell(
                    onTap: () {
                     provider.selectRed();
                    },
                    child: PlanWidget(
                      isSelected: provider.redPearl,
                      title: 'Red pearl',
                      amount: '349',
                      image: Images.pearls_red,
                      subtitle: provider.selectPlan,
                      onClick: () {
                        List<String> listLaugaes = [
                          "Post a Load/Post a Vechlie (Only 100 Post)",
                          'Email Notifications',
                          'SMS Notifications',
                          'WHATSAPP Notifications',
                          'Sponsered Ad/Google ad+ User posted add',
                          'SELL POST (Only 10 Post)',
                          'DIRECTORY ACCESS',
                          'JOB POSTING',
                          'BIDDING (Only 100 Post)',
                          "PRIORITY DIRECTORY",
                          "VERIFIED GREEN MARK",
                          "VERIFIED BLUE MARK(TRUSTED)",
                          "GOOGLE Business SET UP"
                        ];

                        List<bool> selectLang = [
                          true,
                          true,
                          true,
                          false,
                          true,
                          true,
                          true,
                          false,
                          true,
                          false,
                          false,
                          false,
                          false
                        ];

                        provider.onDeatilsPlan(context,listLaugaes, selectLang,
                            Images.pearls_red, "Red pearl", "349");
                      },
                    )),
                SizedBox(
                  height: 12,
                ),
                InkWell(
                    onTap: () {
                     provider.selectBlack();
                    },
                    child: PlanWidget(
                      isSelected:provider. blackPearl,
                      title: 'Black pearl',
                      amount: '449',
                      image: Images.pearls_black,
                      subtitle:provider. selectPlan,
                      onClick: () {
                        List<String> listLaugaes = [
                          "Post a Load/Post a Vechlie (Unlimited Post)",
                          'Email Notifications',
                          'SMS Notifications',
                          'WHATSAPP Notifications',
                          'Sponsered Ad/Google ad+ User posted add',
                          'SELL POST (Only 20 Post)',
                          'DIRECTORY ACCESS',
                          'JOB POSTING',
                          'BIDDING (Unlimited Post)',
                          "PRIORITY DIRECTORY",
                          "VERIFIED GREEN MARK",
                          "VERIFIED BLUE MARK(TRUSTED)",
                          "GOOGLE Business SET UP"
                        ];

                        List<bool> selectLang = [
                          true,
                          true,
                          true,
                          true,
                          true,
                          true,
                          true,
                          true,
                          true,
                          true,
                          true,
                          true,
                          true
                        ];
                        provider.onDeatilsPlan(context,listLaugaes, selectLang,
                            Images.pearls_black, "Black pearl", "449");
                      },
                    )),
                SizedBox(
                  height: 161,
                ),
                Button(
                    width: 335,
                    height: 49,
                    title: "Next",
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      fontWeight: FontWeight.w600,
                    ),
                    onClick: () {
                      //showBootomSheet();
                      if(provider.previousPlan==provider.selectedPlanCode){
                        ToastMessage.show(context, "You have already this plan");
                      }else{
                        if (provider.planAmount == 0) {
                          //provider.goHome(context);
                          provider.selectedPlan(context);
                        } else {
                          //provider.selectedPlan(context);
                         // print('verfiy data string ${PhonePayPayment().getSaltVerfy(100)}');

                          startTran(provider);
                        }
                      }

                    }),
                // SizedBox(height: 60.h,),
                // AlredayAccountWidget()
              ]),
            );
          },
        ),
      ),
    );
  }

  final authProvider = locator<AuthProvider>();

  startTran(SelectPlanProvider provider) async {

    User user=await authProvider.getLoginData();
    RazorPayClass(context).initalPay(provider.planAmount,user.mobileNumber!,user.emailId!,provider.selectPlan,provider.selectedPlanCode);


  }


}
