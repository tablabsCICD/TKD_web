import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tkd_app/model/truck_load_model.dart';
import 'package:tkd_app/view/screens/dashboard/post_comment.dart';

class BaseWidget {



  Widget likeComment(TruckLoad truckLoad,BuildContext context,
      {int likeCount = 0, int commentCount = 0}) {
    return InkWell(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (builder)=>PostCommentList(truckLoad)));
      },
      child: Container(
        height: 20,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              width: 155.50,
              height: 18,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (builder)=>PostCommentList(truckLoad)));
                          },
                          child: Container(
                            width: 16,
                            height: 16,
                            child: Stack(
                                children: [SvgPicture.asset("assets/svg/like.svg")]),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8),
                  Container(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "like",
                          style: TextStyle(
                            color: Color(0xFF001E49),
                            fontSize: 12,
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 2),
                        // Text(
                        //   '( ${likeCount} )',
                        //   style: TextStyle(
                        //     color: Color(0xFF001E49),
                        //     fontSize: 12,
                        //     fontFamily: GoogleFonts.poppins().fontFamily,
                        //     fontWeight: FontWeight.w400,
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (builder)=>PostCommentList(truckLoad)));
              },
              child: Container(
                width: 155.50,
                height: 18,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 16,
                      height: 16,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 16,
                            height: 16,
                            child: Stack(
                                children: [SvgPicture.asset("assets/svg/message.svg")]),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 8),
                    Container(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "comment",
                            style: TextStyle(
                              color: Color(0xFF001E49),
                              fontSize: 12,
                              fontFamily: GoogleFonts.poppins().fontFamily,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 2),
                          // Text(
                          //   '( ${commentCount} )',
                          //   style: TextStyle(
                          //     color: Color(0xFF001E49),
                          //     fontSize: 12,
                          //     fontFamily: GoogleFonts.poppins().fontFamily,
                          //     fontWeight: FontWeight.w400,
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget profile(String profileLink, String name, String companyName,
      {int verify = 0}) {
    return Container(
      width: double.infinity,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            clipBehavior: Clip.antiAlias,
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Container(
                //   width: 40,
                //   height: 40,
                //   child: Image.network(profileLink),
                // ),
                //getImage(profileLink,height: 40,width: 40.w)
                getImageclip(profileLink, height: 40, width: 40)
              ],
            ),
          ),
          SizedBox(width: 8),
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
                                  child: Container(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                      MainAxisAlignment.start,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              name,
                                              style:TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                                fontFamily:
                                                GoogleFonts.poppins()
                                                    .fontFamily,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 4,
                                            ),
                                            Visibility(
                                                visible:
                                                verify != 0 ? true : false,
                                                child: Image.asset(
                                                  'assets/images/shield.png',
                                                  height: 12,
                                                  width: 12,
                                                ))
                                          ],
                                        ),
                                        SizedBox(
                                          width: double.infinity,
                                          child: Text(
                                            companyName,
                                            style:TextStyle(
                                              color: Color(0x99001E49),
                                              fontSize: 10,
                                              fontFamily: GoogleFonts.poppins()
                                                  .fontFamily,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                        RatingBar.builder(
                                          itemSize: 10,
                                          initialRating: 3,
                                          minRating: 1,
                                          direction: Axis.horizontal,
                                          allowHalfRating: true,
                                          itemCount: 5,
                                          itemPadding: EdgeInsets.symmetric(
                                              horizontal: 1.0),
                                          itemBuilder: (context, _) => Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                            size: 5,
                                          ),
                                          onRatingUpdate: (rating) {
                                            print(rating);
                                          },
                                        )
                                      ],
                                    ),
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

Widget heading(String title,String subTitle){
 return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: TextStyle(
          color: Colors.black,
          fontSize: 12,
          fontFamily: GoogleFonts.poppins().fontFamily,
          fontWeight: FontWeight.w600,
        ),
      ),
      SizedBox(height:5),
      Text(
        subTitle,
        style: TextStyle(
          color: Color(0x99001E49),
          fontSize: 12,
          fontFamily: GoogleFonts.poppins().fontFamily,
          fontWeight: FontWeight.w400,
        ),
      ),
    ],
  );
}


  Widget likeCommentDetails(TruckLoad truckLoad,BuildContext context,Function onTabLikeCount,
      {int likeCount = 0, int commentCount = 0}) {
    return Container(
      height: 20,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            width: 155.50,
            height: 18,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 16,
                  height: 16,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          // provider.likeIncreamentApi(truckLoad.id!, context);
                          onTabLikeCount();

                        },
                        child: Container(
                          width: 16,
                          height: 16,
                          child: Stack(
                              children: [SvgPicture.asset("assets/images/like.svg"),])
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8),
                Container(
                  child: InkWell(
                    onTap: (){
                      print('this is like ');
                      onTabLikeCount();

                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "like",
                          style: TextStyle(
                            color: Color(0xFF001E49),
                            fontSize: 12,
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '( ${likeCount} )',
                          style: TextStyle(
                            color: Color(0xFF001E49),
                            fontSize: 12,
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (builder)=>PostCommentList(truckLoad)));
            },
            child: Container(
              width: 155.50,
              height: 18,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 16,
                          height: 16,
                          child: Stack(
                              children: [SvgPicture.asset("assets/images/message.svg")]),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8),
                  Container(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "comment",
                          style: TextStyle(
                            color: Color(0xFF001E49),
                            fontSize: 12,
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '( ${commentCount} )',
                          style: TextStyle(
                            color: Color(0xFF001E49),
                            fontSize: 12,
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            fontWeight: FontWeight.w400,
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
  }

  getImage(String src, {double? height, double? width}) {
    return src == ""
        ? Container(
        width: height == null ? 35 : height,
        height: width == null ? 35 : width,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey[100],
            image: new DecorationImage(
                fit: BoxFit.contain,
                image: AssetImage('assets/images/my_profile.png'))))
        : Container(
        width: height == null ? 35 : height,
        height: width == null ? 35 : width,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey[100],
            image: new DecorationImage(
                fit: BoxFit.contain, image: NetworkImage(src))));
  }

  getImageclip(String src, {double? height, double? width}) {
    return src == ""
        ? Container(
        width: height == null ? 35 : height,
        height: width == null ? 35 : width,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey[100],
            image: new DecorationImage(
                fit: BoxFit.contain,
                image: AssetImage('assets/images/my_profile.png'))))
        : CircleAvatar(
      radius: width == null ? 35 : width / 2,
      backgroundColor: Colors.white,
      // borderRadius: BorderRadius.circular(width==null?35:width),

      child: ClipOval(
        child: CachedNetworkImage(
          imageUrl: src,
          placeholder: (context, url) =>
              Image.asset("assets/images/my_profile.png"),
          fit: BoxFit.cover,
          width: height == null ? 35 : height,
          height: width == null ? 35 : width,
        ),
      ),
    );
  }

  appBar(BuildContext context, String title) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(left: 20),
      height: 50,
      color: Colors.white,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: textFiled(title),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: SvgPicture.asset(
                "assets/images/arrow_back.svg",
                height: 24,
                width: 24,
              ),
            ),
          ),
          SizedBox(width: 8),
          SizedBox(width: 8),
        ],
      ),
    );
  }

  appBarSearchFilter(BuildContext context, String title) {
    return Container(
      width: MediaQuery.of(context).size.width,
      // padding: EdgeInsets.only(left: 20.w),

      height: 50,
      color: Colors.white,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: textFiled(title),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Padding(
                padding: EdgeInsets.only(left: 20),
                child: SvgPicture.asset("assets/images/arrow_back.svg",
                  height: 24,
                  width: 24,
                ),
              ),
            ),
          ),
          SizedBox(width: 8),
          Align(
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                //SvgPicture.asset(Images.search_normal),
                SizedBox(width: 20),
                // SvgPicture.asset(Images.filter),
                SizedBox(width: 20),
              ],
            ),
          )
        ],
      ),
    );
  }

  textFiled(String title) {
    return Center(
      child: Text(
        title,
        style: TextStyle(
          color: Colors.black,
          fontSize: 14,
          fontFamily: GoogleFonts.poppins().fontFamily,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget jobHeading(String fromCity) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 8),
      decoration: ShapeDecoration(
        color: Color(0xFFF4F6F6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: SizedBox(
              child: Text(
                fromCity,
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: Color(0xCC001E49),
                  fontSize: 12,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget image({String image = ""}) {
    // return Container(
    //   width: 311 ,
    //   height: 200.h,
    //   decoration: ShapeDecoration(
    //     image: DecorationImage(
    //       image: NetworkImage(
    //         image,
    //       ),fit: BoxFit.fill,
    //     ),
    //     shape: RoundedRectangleBorder(
    //       borderRadius: BorderRadius.circular(12),
    //     ),
    //   ),
    // );
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: CachedNetworkImage(
        imageUrl: image,
        placeholder: (context, url) => SvgPicture.asset("assets/svg/logo.svg"),
        errorWidget: (context, url, error) => ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(
              "https://igps.net/wp-content/uploads/2018/08/shutterstock_711168088.jpg",
              fit: BoxFit.fill,
              width: 311,
              height: 200,
            )),
        fit: BoxFit.fill,
        width: 311,
        height: 200,
      ),
    );
  }

  Widget imageLink(String link) {
    // return Container(
    //   width: 311 ,
    //   height: 200.h,
    //   decoration: ShapeDecoration(
    //     image: DecorationImage(
    //       image: NetworkImage(
    //           link),
    //       fit: BoxFit.fill,
    //     ),
    //     shape: RoundedRectangleBorder(
    //       borderRadius: BorderRadius.circular(12),
    //     ),
    //   ),
    // );

    return image(image: link);
  }

  Widget carouseImage(List<String?> imgList) {
    return Container(
        child: CarouselSlider(
          options: CarouselOptions(
            padEnds: false,
            pageSnapping: false,
            enableInfiniteScroll: false,
          ),
          items: imgList
              .map((item) => Container(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(child: imageLink(item!)),
            ),
          ))
              .toList(),
        ));
  }

}
