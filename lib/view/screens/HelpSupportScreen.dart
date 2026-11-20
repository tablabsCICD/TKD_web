import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tkd_app/provider/help_support_provider.dart';
import 'package:tkd_app/util/colors.dart';
import 'package:tkd_app/util/images.dart';
import 'package:tkd_app/view/base_widget/home_base_widgets.dart';
import 'package:tkd_app/view/base_widget/utils.dart';
import 'package:tkd_app/widgets/button.dart';

class HelpSupportScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => HelpSupportProvider(),
      builder: (context, child) => _buildPage(context),
    );
  }

  _buildPage(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          color: Colors.white,
         
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HomeBaseWidget().appBar(context, "Help And Support"),
              Container(
                height: 20,
                color: ThemeColor.baground,
              ),

              Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    titleText("Email Id"),
                    SizedBox(
                      height: 2,
                    ),
                    subTitle('support@tkdconnect.in'),
                    SizedBox(
                      height: 8,
                    ),

                    titleText("Traffic"),
                    SizedBox(
                      height: 2,
                    ),
                    Row(
                      children: [
                        InkWell(

                          onTap: (){
                            Utils().callFunction(context,"8123006888");
                          },child: subTitle('(+91)  8123006888 '),
                        ),
                        Text(" / "),
                        InkWell(

                          onTap: (){
                            Utils().callFunction(context,"8123004666");
                          },child:   subTitle('(+91)  8123004666 '),
                        ),
                     ],
                    ),
                    SizedBox(
                      height: 8,
                    ),

                    titleText("Website"),
                    SizedBox(
                      height: 2,
                    ),
                    subTitle('www.tkdconnect.in'),
                    SizedBox(
                      height: 20,
                    ),
                    orView(),
                    SizedBox(
                      height: 20,
                    ),

                    titleText("Raise A Ticket"),
                    SizedBox(
                      height: 5,
                    ),
                    // dropList(context),
                    Consumer<HelpSupportProvider>(
                      builder: (context, provider, child) {
                        return popUpmenu(
                                (val) => () {
                              provider.changeDropDown(val);
                            },
                            context);
                      },
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    editTextBox(context),
                    SizedBox(
                      height: 5,
                    ),
                    Consumer<HelpSupportProvider>(
                      builder: (context, provider, child) {
                        return Text(
                          provider.remaningText,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            fontWeight: FontWeight.w400,
                            height: 0,
                          ),
                        );
                      },
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: Consumer<HelpSupportProvider>(
        builder: (context, provider, child) {
          return Button(
              width: 335,
              height: 52,
              title: "Submit",
              textStyle: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontFamily: GoogleFonts.poppins().fontFamily,
                fontWeight: FontWeight.w400,
                height: 0,
              ),
              isEnbale: provider.enableButton,
              onClick: () {
                provider.sumbitTicket(context);
              });
        },
      ),
    );
  }

  titleText(String title) {
    return Text(
      title,
      style: TextStyle(
        color: Colors.black,
        fontSize: 12,
        fontFamily: GoogleFonts.poppins().fontFamily,
        fontWeight: FontWeight.w600,
        height: 0,
      ),
    );
  }

  subTitle(String subtitle) {
    return Text(
      subtitle,
      style: TextStyle(
        color: Color(0xFFC3262C),
        fontSize: 12,
        fontFamily: GoogleFonts.poppins().fontFamily,
        fontWeight: FontWeight.w600,
        height: 0,
      ),
    );
  }

  drwaLine() {
    return Container(
      width: 89,
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1,
            strokeAlign: BorderSide.strokeAlignCenter,
            color: Color(0x332C363F),
          ),
        ),
      ),
    );
  }

  orView() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        drwaLine(),
        SizedBox(
          width: 20,
        ),
        Text(
          "OR",
          style: TextStyle(
            color: Color(0x99001E49),
            fontSize: 12,
            fontFamily: GoogleFonts.poppins().fontFamily,
            fontWeight: FontWeight.w400,
            height: 0,
          ),
        ),
        SizedBox(
          width: 20,
        ),
        drwaLine(),
      ],
    );
  }

  dropList(BuildContext context) {
    return Consumer<HelpSupportProvider>(
      builder: (context, provider, child) {
        return Container(
          width: MediaQuery.of(context).size.width,
          height: 52,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 52,
                padding: EdgeInsets.symmetric(horizontal: 12),
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 1, color: Color(0x332C363F)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: SizedBox(
                              child: Text(
                                provider.dropValue,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontFamily: GoogleFonts.poppins().fontFamily,
                                  fontWeight: FontWeight.w400,
                                  height: 0,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          Container(
                            width: 24,
                            height: 24,
                            child: Stack(children: [
                              SvgPicture.asset(Images.dwon_arrow)
                            ]),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  editTextBox(BuildContext context) {
    return Consumer<HelpSupportProvider>(
      builder: (context, provider, child) {
        return Container(
          width: MediaQuery.of(context).size.width,
          height: 145,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 1, color: Color(0x332C363F)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: SizedBox(
                                child: TextField(
                                  controller: provider.textEditingController,
                                  onChanged: (value) {
                                    provider.countText();
                                  },
                                  maxLines: 5,
                                  maxLength: 300,
                                  obscureText: false,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                      counter: Offstage(),
                                      hintText: "Explain Your Concern",
                                      border: InputBorder.none,
                                      hintStyle: TextStyle(
                                        color: Color(0x662C363F),
                                        fontSize: 14,
                                        fontFamily:
                                            GoogleFonts.poppins().fontFamily,
                                        fontWeight: FontWeight.w400,
                                      )),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontFamily:
                                        GoogleFonts.poppins().fontFamily,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  popUpmenu(Function(String) onMenuTap, BuildContext context) {
    return Consumer<HelpSupportProvider>(
      builder: (context, provider, child) {
        return PopupMenuButton(
          position: PopupMenuPosition.values[1],
          constraints:
              BoxConstraints.tightFor(width: MediaQuery.of(context).size.width),
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 1, color: Color(0x332C363F)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Container(
              width: MediaQuery.of(context).size.width,
              child: dropList(context)),
          onSelected: (dynamic val) {
            //onMenuTap(val);
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              onTap: () {
                provider.changeDropDown("Create Post Load Issue");
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  children: [
                    Text(
                      "Create Post Load Issue",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontWeight: FontWeight.w600,
                        height: 0,
                      ),
                    ),
                    SizedBox(
                      width: 13,
                    ),
                  ],
                ),
              ),
            ),
            PopupMenuItem(
                onTap: () {
                  provider.changeDropDown("App Crash");
                },
                child: Row(
                  children: [
                    Text(
                      "App Crash",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontWeight: FontWeight.w600,
                        height: 0,
                      ),
                    )
                  ],
                )),
            PopupMenuItem(
                onTap: () {
                  provider.changeDropDown("Create Job Post");
                },
                child: Row(
                  children: [
                    Text(
                      "Create Job Post",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontWeight: FontWeight.w600,
                        height: 0,
                      ),
                    )
                  ],
                )),
            PopupMenuItem(
                onTap: () {
                  provider.changeDropDown("Buysell Issue");
                },
                child: Row(
                  children: [
                    Text(
                      "Buysell Issue",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontWeight: FontWeight.w600,
                        height: 0,
                      ),
                    )
                  ],
                )),

            PopupMenuItem(
                onTap: () {
                  provider.changeDropDown("Other");
                },
                child: Row(
                  children: [
                    Text(
                      "Other",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontWeight: FontWeight.w600,
                        height: 0,
                      ),
                    )
                  ],
                )),
          ],
        );
      },
    );
  }
}
