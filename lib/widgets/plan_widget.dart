import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tkd_app/util/colors.dart';

class PlanWidget extends StatelessWidget{
  bool isSelected;
  String title;
  String amount;
  String image;
  String subtitle;
  Function? onClick;
  String period;

  PlanWidget({required this.isSelected, required this.title, required this.amount, required this.image,required this.subtitle,this.onClick,required this.period});


  @override
  Widget build(BuildContext context) {
    return Container(
     width: 400,
     height: 80,
     padding: EdgeInsets.only(left: 12,right: 12,top: 12,bottom: 12),
     clipBehavior: Clip.antiAlias,
     decoration: ShapeDecoration(
       color: isSelected ? ThemeColor.select_green_plan:ThemeColor.white,
       shape: RoundedRectangleBorder(
         side: BorderSide(width: 0.50, color: isSelected ?ThemeColor.select_green_plan:ThemeColor.white),
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
                         InkWell(
                           onTap: (){

                             onClick!();
                             // showModalBottomSheet<void>(
                             //     isScrollControlled: true,
                             //     context: context,
                             //     builder: (BuildContext context) {
                             //       return FractionallySizedBox(heightFactor: 0.9,child: PlanDetailsScreen());
                             //     });
                           },
                           child: Text(
                             'Click here',
                             style: TextStyle(
                               color: ThemeColor.red,
                               fontSize: 12,
                               fontFamily: GoogleFonts.poppins().fontFamily,
                               fontWeight: FontWeight.w600,
                             ),
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
                         const SizedBox(height: 4),
                         Visibility(
                           visible: isSelected,
                           child: Container(
                             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                             decoration: ShapeDecoration(
                               color: Color(0x19001E49),
                               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                             ),
                             child: Row(
                               mainAxisSize: MainAxisSize.min,
                               mainAxisAlignment: MainAxisAlignment.center,
                               crossAxisAlignment: CrossAxisAlignment.center,
                               children: [
                                 Text(
                                   subtitle,
                                   style: TextStyle(
                                     color: Color(0xCC001E49),
                                     fontSize: 10,
                                     fontFamily: 'Poppins',
                                     fontWeight: FontWeight.w600,
                                   ),
                                 ),
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
           ),
         ),
       ],
     ),
   );
  }


}