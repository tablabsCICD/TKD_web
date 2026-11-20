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
  State<SelectPlanScreen> createState() => _SelectPlanScreenState();
}

class _SelectPlanScreenState extends State<SelectPlanScreen> {
  final authProvider = locator<AuthProvider>();

  @override
  void initState() {
    super.initState();
    // any initial actions can remain (provider injection happens via Consumer below)
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final isNarrow = media.size.width < 420;

    return Scaffold(
      backgroundColor: ThemeColor.baground,
      body: SafeArea(
        child: Consumer<SelectPlanProvider>(builder: (context, provider, _) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 10,),
                LinearProgressBar(fillValue: 301),
                SizedBox(height: 10,),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Choose a plan that fits your business',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: isNarrow ? 13 : 14,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 16),

                // Cards list (scrollable)
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // Clear Pearl (Free)
                        _planCardWrapper(
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
                              provider.onDeatilsPlan(
                                  context,
                                  listLaugaes,
                                  selectLang,
                                  Images.pearls,
                                  "Clear pearl",
                                  "0",
                                  "Month");
                            },
                          ),
                          onTap: () => provider.selectClearPerl(),
                        ),
                        SizedBox(height: 12),

                        // Blue Pearl
                        _planCardWrapper(
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
                              provider.onDeatilsPlan(context, listLaugaes,
                                  selectLang, Images.pearls_blue, "Blue pearl", "2000", "Month");
                            },
                          ),
                          onTap: () => provider.selectBlue(2000),
                        ),
                        SizedBox(height: 12),

                        // Red Pearl
                        _planCardWrapper(
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

                              provider.onDeatilsPlan(context, listLaugaes, selectLang,
                                  Images.pearls_red, "Red pearl", "2500", "Half Year");
                            },
                          ),
                          onTap: () => provider.selectRed(2500),
                        ),
                        SizedBox(height: 12),

                        // Black Pearl
                        _planCardWrapper(
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
                              provider.onDeatilsPlan(context, listLaugaes, selectLang,
                                  Images.pearls_black, "Black pearl", "5000", "Annual");
                            },
                          ),
                          onTap: () => provider.selectBlack(5000),
                        ),

                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
      // Sticky Next button
      bottomSheet: Consumer<SelectPlanProvider>(
        builder: (context, provider, _) {
          return Container(
            color: Colors.transparent,
            padding: EdgeInsets.fromLTRB(16, 12, 16, 20),
            child: SafeArea(
              top: false,
              child: Button(
                width: double.infinity,
                height: 54,
                title: "Next",
                textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  fontWeight: FontWeight.w600,
                ),
                onClick: () async {
                  // <-- KEEP YOUR ORIGINAL PLAN PURCHASE LOGIC EXACTLY AS-IS
                  if (provider.previousPlan == provider.selectedPlanCode) {
                    ToastMessage.show(context, "You have already this plan");
                  } else {
                    if (provider.planAmount == 0) {
                      provider.selectedPlan(context);
                    } else {
                      startTran(provider);
                    }
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }

  /// light card wrapper for consistent styling (rounded + light shadow)
  Widget _planCardWrapper({required Widget child, void Function()? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            // Light shadow as requested
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              spreadRadius: 1,
              offset: Offset(0, 2),
            )
          ],
        ),
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: child,
      ),
    );
  }

  // DON'T CHANGE purchase logic — kept same
  startTran(SelectPlanProvider provider) async {
    User user = await authProvider.getLoginData();
    RazorPayClass(context).initalPay(provider.planAmount, user.mobileNumber!,
        user.emailId!, provider.selectPlan, provider.selectedPlanCode);
  }
}
