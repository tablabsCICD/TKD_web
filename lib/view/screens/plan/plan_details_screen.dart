import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tkd_app/util/colors.dart';
import 'package:tkd_app/util/images.dart';
import 'package:tkd_app/util/textview.dart';
import 'package:tkd_app/widgets/button.dart';



class PlanDetailsScreen extends StatefulWidget{
 final List<String>listLaugaes;
 final List<bool>selectLang;
 final String image;
 final String subtitle;
 final String amount;
 final String period;

  const PlanDetailsScreen({ required this.listLaugaes, required this.selectLang, required this.image, required this.subtitle, required this.amount, required this.period});

  @override
  State<StatefulWidget> createState() {
   return _PlanDetailsScreen();
  }

}

class _PlanDetailsScreen extends State<PlanDetailsScreen>{



  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
        color: Colors.white,
        child: Container(
          margin: EdgeInsets.only(left: 20,top: 12,right: 20),
          child: Column(
            children: [

              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 36,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Plan Details',
                      style:TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontFamily:GoogleFonts.poppins().fontFamily,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    InkWell(onTap:(){
                      Navigator.pop(context);
                    },child: SvgPicture.asset(Images.close_circle))
                  ],
                ),
              ),
              SizedBox(height: 24,),
              selectedPlan( widget.image, widget.subtitle, widget.amount,widget.period),

              Expanded(
                child: ListView.builder(
                    itemCount: widget.listLaugaes.length,
                    itemBuilder: (BuildContext context, int index) {
                      return laguagesList(index);
                    }),
              )

            ],

          ),
        ),
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.only(bottom: 60,left: 20,right: 20),
        child: Button(title: "Choose plan", width: MediaQuery.of(context).size.width,height: 52,textStyle: TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontFamily: GoogleFonts.poppins().fontFamily,
          fontWeight: FontWeight.w600,
        ), onClick: (){
          //Navigator.pushReplacementNamed(context, AppRoutes.intro_one);
          Navigator.pop(context);


        },),
      ),

    );
  }



  laguagesList(int index){
    return Container(

      width: MediaQuery.of(context).size.width,
      height: 52,
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: ThemeColor.white,
        border: Border(

          bottom: BorderSide(width: 0.50, color: ThemeColor.border_grey),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: SizedBox(
              height: 52,
              child: Text(
                widget.listLaugaes[index],
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontFamily:GoogleFonts.poppins().fontFamily,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),

          ),
          widget.selectLang[index]? SvgPicture.asset(Images.green_tick,height: 24,width: 24,):Textview(TextStyle(
            color: Colors.black,
            fontSize: 12,
            fontFamily: GoogleFonts.poppins().fontFamily,
            fontWeight: FontWeight.w600,
          ), title: "No")
        ],
      ),
    );
  }

  selectedPlan(String image,String title,String amount, String period){
    return Container(
      width: 335,
      height: 80,
      padding: EdgeInsets.only(left: 12,right: 12,top: 12,bottom: 12),
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: ThemeColor.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 0.50, color:ThemeColor.white),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

         SvgPicture.asset(image),

          Expanded(
            child: Container(
              height: 52,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(

                      margin: EdgeInsets.only(left: 12),child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Basic plan',
                          style: TextStyle(
                            color: Color(0x99001E49),
                            fontSize: 12,
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            width: double.infinity,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '₹',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontFamily: GoogleFonts.poppins().fontFamily,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                    amount+"/$period",
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontFamily: GoogleFonts.poppins().fontFamily,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                           SizedBox(height: 4),

                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );

  }



}