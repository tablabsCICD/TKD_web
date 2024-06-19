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
    return _buildPage(context);
  }

  _buildPage(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.baground,
      body: SafeArea(
        child: Consumer<SelectPlanProvider>(
          builder: (context, provider, child) {
            return Container(
              margin: EdgeInsets.all(20),
              alignment: Alignment.center,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 21.5,
                    ),
                    Text(
                      'Select Plan',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(),
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
                          subtitle: provider.selectPlan,
                          period: "Month",
                          onClick: () {
                            List<String> listLaugaes = [
                              "Post a Load/Post a Vehicle (Only 5 Post)",
                              'Email Notifications',
                              'SMS Notifications',
                              'WHATSAPP Notifications',
                              'Sponsored Ad/Google ad+ User posted add',
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
                            provider.onDeatilsPlan(context, listLaugaes,
                                selectLang, Images.pearls, "Clear pearl", "0","Month");
                          },
                        )),
                    SizedBox(
                      height: 12,
                    ),
                    InkWell(
                        onTap: () {
                          provider.selectBlue(2000);
                        },
                        child: PlanWidget(
                          isSelected: provider.bluePearl,
                          title: 'Blue pearl',
                          amount: '2000',
                          image: Images.pearls_blue,
                          subtitle: provider.selectPlan,
                          period: "Month",
                          onClick: () {
                            List<String> listLaugaes = [
                              "View Unlimited Client Loads",
                              'Post Unlimited Loads',
                              'SMS Notifications',
                              'WHATSAPP Notifications',
                              'Add Your company Website Link With Visiting',
                              'One Month Color Advertisement',
                              'DIRECTORY ACCESS',
                              'JOB POSTING',
                              "PRIORITY DIRECTORY",
                              "VERIFIED GREEN MARK"
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
                              true
                            ];
                            provider.onDeatilsPlan(
                                context,
                                listLaugaes,
                                selectLang,
                                Images.pearls_blue,
                                "Blue pearl",
                                "2000","Month");
                          },
                        )),
                    SizedBox(
                      height: 12,
                    ),
                    InkWell(
                        onTap: () {
                          provider.selectRed(2500);
                        },
                        child: PlanWidget(
                          isSelected: provider.redPearl,
                          title: 'Red pearl',
                          amount: '2500',
                          image: Images.pearls_red,
                          subtitle: provider.selectPlan,
                          period: "Half Year",
                          onClick: () {
                            List<String> listLaugaes = [
                              "View Unlimited Client Loads / Transporters",
                              'Post Unlimited Loads',
                              'SMS Notifications',
                              'WHATSAPP Notifications',
                              'Add Your Company Website Link With Visiting',
                              'Six Month Color Advertisement',
                              'DIRECTORY ACCESS',
                              'JOB POSTING',
                              "PRIORITY DIRECTORY",
                              "VERIFIED GREEN MARK"
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
                              true
                            ];

                            provider.onDeatilsPlan(
                                context,
                                listLaugaes,
                                selectLang,
                                Images.pearls_red,
                                "Red pearl",
                                "2500","Half Year");
                          },
                        )),
                    SizedBox(
                      height: 12,
                    ),
                    InkWell(
                        onTap: () {
                          provider.selectBlack(5000);
                        },
                        child: PlanWidget(
                          isSelected: provider.blackPearl,
                          title: 'Black pearl',
                          amount: '5000',
                          image: Images.pearls_black,
                          subtitle: provider.selectPlan,
                          period: "Annual",
                          onClick: () {
                            List<String> listLaugaes = [
                              "View Unlimited Client Loads / Transporters",
                              'Post Unlimited Loads',
                              'SMS Notifications',
                              'Get More Loads with Verified Listing',
                              'Add Your company Website Link With Visiting',
                              'Be Top On Search In Transport Directory',
                              'JOB POSTING',
                              "PRIORITY DIRECTORY",
                              "VERIFIED GREEN MARK"
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
                              true
                            ];
                            provider.onDeatilsPlan(
                                context,
                                listLaugaes,
                                selectLang,
                                Images.pearls_black,
                                "Black pearl",
                                "5000","Annual");
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
                          if (provider.previousPlan ==
                              provider.selectedPlanCode) {
                            ToastMessage.show(
                                context, "You have already this plan");
                          } else {
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
    User user = await authProvider.getLoginData();
    RazorPayClass(context).initalPay(provider.planAmount, user.mobileNumber!,
        user.emailId!, provider.selectPlan, provider.selectedPlanCode);
  }
}
