import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tkd_app/util/colors.dart';
import 'package:tkd_app/util/images.dart';

class ItemBottomSheet{
   int count=-1;

  Future<int> showIteam(BuildContext context,List<String> item,String title) async {

    await showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          margin: EdgeInsets.all(10),
          child: Center(
            
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 36,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style:TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontFamily:GoogleFonts.poppins().fontFamily,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      InkWell(onTap: (){
                        Navigator.of(context).pop();
                      },child: SvgPicture.asset(Images.close_circle))
                    ],
                  ),
                ),

                //listLang()

                Expanded(
                  child: ListView.builder(
                      itemCount: item.length,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: (){
                            count=index;
                            Navigator.pop(context);
                          },
                          child: Container(

                            width: MediaQuery.of(context).size.width,
                            height: 52,
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                            decoration: BoxDecoration(
                              color: ThemeColor.white,
                              border: Border(

                                bottom: BorderSide(width: 0.50, color: Color(0x332C363F)),
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
                                      item[index],
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontFamily:GoogleFonts.poppins().fontFamily,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),

                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                )

              ],
            ),
          ),
        );
      },
    );

    return count;
  }

  listLang() {
    return   Expanded(
      child: ListView.builder(
          itemCount: 5,
          itemBuilder: (BuildContext context, int index) {
            return laguagesList(index,context);
          }),
    );

  }


   Future<int> showIteamHieght(BuildContext context,List<String> item,String title) async {

     await showModalBottomSheet<void>(
       context: context,
       builder: (BuildContext context) {
         return Container(
           height: MediaQuery.of(context).size.height/2,
           margin: EdgeInsets.all(10),
           child: Center(

             child: Column(
               mainAxisAlignment: MainAxisAlignment.center,
               mainAxisSize: MainAxisSize.min,
               children: <Widget>[
                 SizedBox(
                   width: MediaQuery.of(context).size.width,
                   height: 36,
                   child: Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       Text(
                         title,
                         style:TextStyle(
                           color: Colors.black,
                           fontSize: 20,
                           fontFamily:GoogleFonts.poppins().fontFamily,
                           fontWeight: FontWeight.w600,
                         ),
                       ),
                       InkWell(onTap: (){
                         Navigator.of(context).pop();
                       },child: SvgPicture.asset(Images.close_circle))
                     ],
                   ),
                 ),

                 //listLang()

                 Expanded(
                   child: ListView.builder(
                       itemCount: item.length,
                       itemBuilder: (BuildContext context, int index) {
                         return InkWell(
                           onTap: (){
                             count=index;
                             Navigator.pop(context);
                           },
                           child: Container(

                             width: MediaQuery.of(context).size.width,
                             height: 52,
                             padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                             decoration: BoxDecoration(
                               color: ThemeColor.white,
                               border: Border(

                                 bottom: BorderSide(width: 0.50, color: Color(0x332C363F)),
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
                                       item[index],
                                       style: TextStyle(
                                         color: Colors.black,
                                         fontSize: 12,
                                         fontFamily:GoogleFonts.poppins().fontFamily,
                                         fontWeight: FontWeight.w400,
                                       ),
                                     ),
                                   ),

                                 ),
                               ],
                             ),
                           ),
                         );
                       }),
                 )

               ],
             ),
           ),
         );
       },
     );

     return count;
   }


  laguagesList(int index,BuildContext context){
    return InkWell(
      onTap: (){


      },
      child: Container(

        width: MediaQuery.of(context).size.width,
        height: 52,
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: ThemeColor.white,
          border: Border(

            bottom: BorderSide(width: 0.50, color: Color(0x332C363F)),
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
                  "Names",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontFamily:GoogleFonts.poppins().fontFamily,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),

            ),
          ],
        ),
      ),
    );
  }


}