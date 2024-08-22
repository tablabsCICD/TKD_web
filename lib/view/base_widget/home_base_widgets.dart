import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tkd_app/model/truck_load_model.dart';
import 'package:tkd_app/util/color-resource.dart';
import 'package:tkd_app/util/colors.dart';
import 'package:tkd_app/util/images.dart';
import 'package:tkd_app/view/localization/language_constrants.dart';
import 'package:tkd_app/view/screens/dashboard/post_comment.dart';
import 'package:tkd_app/widgets/verified_tag.dart';

class BaseWidget {


  Widget likeComment(TruckLoad truckLoad, BuildContext context,
      {int likeCount = 0, int commentCount = 0}) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (builder) => PostCommentList(truckLoad)));
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
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (builder) =>
                                    PostCommentList(truckLoad)));
                          },
                          child: Container(
                            width: 16,
                            height: 16,
                            child: Stack(
                                children: [
                                  SvgPicture.asset("assets/svg/like.svg")
                                ]),
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
                            fontFamily: GoogleFonts
                                .poppins()
                                .fontFamily,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 2),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (builder) => PostCommentList(truckLoad)));
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
                                children: [
                                  SvgPicture.asset("assets/svg/message.svg")
                                ]),
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
                              fontFamily: GoogleFonts
                                  .poppins()
                                  .fontFamily,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 2),
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
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                                fontFamily:
                                                GoogleFonts
                                                    .poppins()
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
                                              child: VerifiedTag()
                                                  .onVeriedTag(),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          width: double.infinity,
                                          child: Text(
                                            companyName,
                                            style: TextStyle(
                                              color: Color(0x99001E49),
                                              fontSize: 10,
                                              fontFamily: GoogleFonts
                                                  .poppins()
                                                  .fontFamily,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                        RatingBar.builder(
                                          itemSize: 10,
                                          initialRating: 4.5,
                                          ignoreGestures: true,
                                          minRating: 1,
                                          direction: Axis.horizontal,
                                          allowHalfRating: true,
                                          itemCount: 5,
                                          itemPadding: EdgeInsets.symmetric(
                                              horizontal: 1.0),
                                          itemBuilder: (context, _) =>
                                              Icon(
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

  Widget heading(String title, String subTitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.black,
            fontSize: 12,
            fontFamily: GoogleFonts
                .poppins()
                .fontFamily,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 5),
        Text(
          subTitle,
          style: TextStyle(
            color: Color(0x99001E49),
            fontSize: 12,
            fontFamily: GoogleFonts
                .poppins()
                .fontFamily,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }


  Widget likeCommentDetails(TruckLoad truckLoad, BuildContext context,
      Function onTabLikeCount,
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
                          onTabLikeCount();
                        },
                        child: Container(
                            width: 16,
                            height: 16,
                            child: Stack(
                                children: [
                                  SvgPicture.asset("assets/images/like.svg"),
                                ])
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8),
                Container(
                  child: InkWell(
                    onTap: () {
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
                            fontFamily: GoogleFonts
                                .poppins()
                                .fontFamily,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '( ${likeCount} )',
                          style: TextStyle(
                            color: Color(0xFF001E49),
                            fontSize: 12,
                            fontFamily: GoogleFonts
                                .poppins()
                                .fontFamily,
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
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (builder) => PostCommentList(truckLoad)));
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
                              children: [
                                SvgPicture.asset("assets/images/message.svg")
                              ]),
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
                            fontFamily: GoogleFonts
                                .poppins()
                                .fontFamily,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '( ${commentCount} )',
                          style: TextStyle(
                            color: Color(0xFF001E49),
                            fontSize: 12,
                            fontFamily: GoogleFonts
                                .poppins()
                                .fontFamily,
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
      width: MediaQuery
          .of(context)
          .size
          .width,
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
      width: MediaQuery
          .of(context)
          .size
          .width,
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
          fontFamily: GoogleFonts
              .poppins()
              .fontFamily,
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
                  fontFamily: GoogleFonts
                      .poppins()
                      .fontFamily,
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
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: CachedNetworkImage(
        imageUrl: image,
        placeholder: (context, url) => SvgPicture.asset("assets/svg/logo.svg"),
        errorWidget: (context, url, error) =>
            ClipRRect(
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
              .map((item) =>
              Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(child: imageLink(item!)),
                ),
              ))
              .toList(),
        ));
  }

  Widget headingWithDescription(String title, String date, String field1,
      String field2, String field3, bool isJobPost) {
    return Container(
      width: double.infinity,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(4),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontFamily: GoogleFonts
                                .poppins()
                                .fontFamily,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          date,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: Color(0x99001E49),
                            fontSize: 12,
                            fontFamily: GoogleFonts
                                .poppins()
                                .fontFamily,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 4),
                  SizedBox(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              isJobPost ? "Experience : " : "Mfg Year : ",
                              style: TextStyle(
                                color: Color(0x99001E49),
                                fontSize: 12,
                                fontFamily: GoogleFonts
                                    .poppins()
                                    .fontFamily,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              field1,
                              style: TextStyle(
                                color: Color(0x99001E49),
                                fontSize: 12,
                                fontFamily: GoogleFonts
                                    .poppins()
                                    .fontFamily,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              isJobPost ? "Role : " : "Model : ",
                              style: TextStyle(
                                color: Color(0x99001E49),
                                fontSize: 12,
                                fontFamily: GoogleFonts
                                    .poppins()
                                    .fontFamily,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              field2,
                              style: TextStyle(
                                color: Color(0x99001E49),
                                fontSize: 12,
                                fontFamily: GoogleFonts
                                    .poppins()
                                    .fontFamily,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        isJobPost ? SizedBox.shrink() : Row(
                          children: [
                            Text(
                              "Price : ",
                              style: TextStyle(
                                color: Color(0x99001E49),
                                fontSize: 12,
                                fontFamily: GoogleFonts
                                    .poppins()
                                    .fontFamily,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              field3,
                              style: TextStyle(
                                color: Color(0x99001E49),
                                fontSize: 12,
                                fontFamily: GoogleFonts
                                    .poppins()
                                    .fontFamily,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
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

  Widget jobHeadingWithDescription(String title, String date, String exp,
      String role, String desc, bool isJobPost) {
    return Container(
      width: double.infinity,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(4),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontFamily: GoogleFonts
                                .poppins()
                                .fontFamily,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          date,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: Color(0x99001E49),
                            fontSize: 12,
                            fontFamily: GoogleFonts
                                .poppins()
                                .fontFamily,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 4),
                  SizedBox(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Department : ",
                              style: TextStyle(
                                color: Color(0x99001E49),
                                fontSize: 12,
                                fontFamily: GoogleFonts
                                    .poppins()
                                    .fontFamily,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              exp,
                              style: TextStyle(
                                color: Color(0x99001E49),
                                fontSize: 12,
                                fontFamily: GoogleFonts
                                    .poppins()
                                    .fontFamily,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "Role : ",
                              style: TextStyle(
                                color: Color(0x99001E49),
                                fontSize: 12,
                                fontFamily: GoogleFonts
                                    .poppins()
                                    .fontFamily,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              role,
                              style: TextStyle(
                                color: Color(0x99001E49),
                                fontSize: 12,
                                fontFamily: GoogleFonts
                                    .poppins()
                                    .fontFamily,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          "Job Description:",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontFamily: GoogleFonts
                                .poppins()
                                .fontFamily,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          desc,
                          style: TextStyle(
                            color: Color(0x99001E49),
                            fontSize: 12,
                            fontFamily: GoogleFonts
                                .poppins()
                                .fontFamily,
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

  Widget applyButton(Function(int) onMenuTap) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(right: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              onMenuTap(0);
            },
            child: Container(
              height: 38,
              width: 253,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 0.50, color: Color(0x33001E49)),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Apply Now",
                    style: TextStyle(
                      color: Color(0xFF001E49),
                      fontSize: 12,
                      fontFamily: GoogleFonts
                          .poppins()
                          .fontFamily,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SvgPicture.asset("assets/svg/arrow_right.svg")
                ],
              ),
            ),
          ),
          SizedBox(width: 8),
          InkWell(onTap: () {}, child: popUpmenu(onMenuTap))
        ],
      ),
    );
  }

  Widget deleteButton(Function(int) onMenuTap, bool isOwnPost) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(right: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              onMenuTap(10);
            },
            child: Container(
              height: 38,
              width: 253,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 0.50, color: Color(0x33001E49)),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Delete",
                    style: TextStyle(
                      color: ColorResources.PRIMARY_COLOR,
                      fontSize: 12,
                      fontFamily: GoogleFonts
                          .poppins()
                          .fontFamily,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SvgPicture.asset("assets/svg/delete.svg")
                ],
              ),
            ),
          ),
          SizedBox(width: 8),
          InkWell(onTap: () {},
              child: isOwnPost ? popUpmenuForOwnPost(onMenuTap) : popUpmenu(
                  onMenuTap))
        ],
      ),
    );
  }

  Widget profileWithUser(String profileLink, String name, String companyName,
      {int verify = 0, int transporterOrAgent = 0}) {
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
                getImageclip(profileLink, height: 40, width: 40)
              ],
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Container(
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
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                                fontFamily:
                                                GoogleFonts
                                                    .poppins()
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
                                              child: VerifiedTag()
                                                  .onVeriedTag(),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          width: double.infinity,
                                          child: Text(
                                            companyName,
                                            style: TextStyle(
                                              color: Color(0x99001E49),
                                              fontSize: 10,
                                              fontFamily: GoogleFonts
                                                  .poppins()
                                                  .fontFamily,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: double.infinity,
                                          child: Text(
                                            getTranport(
                                                transporterOrAgent),
                                            style: TextStyle(
                                              color: Color(0x99001E49),
                                              fontSize: 10,
                                              fontFamily: GoogleFonts
                                                  .poppins()
                                                  .fontFamily,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                        RatingBar.builder(
                                          itemSize: 10,
                                          initialRating: 4.5,
                                          ignoreGestures: true,
                                          minRating: 1,
                                          direction: Axis.horizontal,
                                          allowHalfRating: true,
                                          itemCount: 5,
                                          itemPadding: EdgeInsets.symmetric(
                                              horizontal: 1.0),
                                          itemBuilder: (context, _) =>
                                              Icon(
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

  popUpmenu(Function(int) onMenuTap) {
    return PopupMenuButton(
      shape: RoundedRectangleBorder(
        side: BorderSide(width: 1, color: Color(0x332C363F)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(child: SvgPicture.asset("assets/svg/post_menu.svg")),
      onSelected: (dynamic val) {
        onMenuTap(val);
      },
      itemBuilder: (context) =>
      [
        PopupMenuItem(
          onTap: () {
            onMenuTap(1);
          },
          child: Row(
            children: [
              SvgPicture.asset(
                "assets/svg/message.svg",
                color: Colors.black,
                width: 20,
                height: 20,
              ),
              SizedBox(
                width: 12,
              ),
              Text(
                getTranslated('chat', context)!,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontFamily: GoogleFonts
                      .poppins()
                      .fontFamily,
                  fontWeight: FontWeight.w400,
                  height: 0,
                ),
              ),
              SizedBox(
                width: 13,
              ),
            ],
          ),
        ),
        PopupMenuItem(
            onTap: () {
              onMenuTap(2);
            },
            child: Row(
              children: [
                SvgPicture.asset(
                  "assets/svg/call_white.svg",
                  color: Colors.black,
                  width: 20,
                  height: 20,
                ),
                SizedBox(
                  width: 12,
                ),
                Text(
                  getTranslated('call', context)!,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontFamily: GoogleFonts
                        .poppins()
                        .fontFamily,
                    fontWeight: FontWeight.w400,
                    height: 0,
                  ),
                )
              ],
            )),
        PopupMenuItem(
            onTap: () {
              onMenuTap(3);
            },
            child: Row(
              children: [
                SvgPicture.asset(
                  "assets/svg/share_white.svg",
                  color: Colors.black,
                  width: 20,
                  height: 20,
                ),
                SizedBox(
                  width: 12,
                ),
                Text(
                  getTranslated('share', context)!,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontFamily: GoogleFonts
                        .poppins()
                        .fontFamily,
                    fontWeight: FontWeight.w400,
                    height: 0,
                  ),
                )
              ],
            )),
        PopupMenuItem(
            onTap: () {
              onMenuTap(4);
            },
            child: Row(
              children: [
                Icon(
                  Icons.star_border,
                  color: Colors.black,
                  size: 20,
                ),
                SizedBox(
                  width: 12,
                ),
                Text(
                  getTranslated('share', context)!,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontFamily: GoogleFonts
                        .poppins()
                        .fontFamily,
                    fontWeight: FontWeight.w400,
                    height: 0,
                  ),
                )
              ],
            )),

      ],
    );
  }


  popUpmenuForOwnPost(Function(int) onMenuTap) {
    return PopupMenuButton(
      shape: RoundedRectangleBorder(
        side: BorderSide(width: 1, color: Color(0x332C363F)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(child: SvgPicture.asset("assets/svg/post_menu.svg")),
      onSelected: (dynamic val) {
        onMenuTap(val);
      },
      itemBuilder: (context) =>
      [
        PopupMenuItem(
          onTap: () {
            onMenuTap(1);
          },
          child: Row(
            children: [
              SvgPicture.asset(
                "assets/svg/message.svg",
                color: Colors.black,
                width: 20,
                height: 20,
              ),
              SizedBox(
                width: 12,
              ),
              Text(
                getTranslated('chat', context)!,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontFamily: GoogleFonts
                      .poppins()
                      .fontFamily,
                  fontWeight: FontWeight.w400,
                  height: 0,
                ),
              ),
              SizedBox(
                width: 13,
              ),
            ],
          ),
        ),
        PopupMenuItem(
            onTap: () {
              onMenuTap(2);
            },
            child: Row(
              children: [
                SvgPicture.asset(
                  "assets/svg/call_white.svg",
                  color: Colors.black,
                  width: 20,
                  height: 20,
                ),
                SizedBox(
                  width: 12,
                ),
                Text(
                  getTranslated('call', context)!,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontFamily: GoogleFonts
                        .poppins()
                        .fontFamily,
                    fontWeight: FontWeight.w400,
                    height: 0,
                  ),
                )
              ],
            )),
        PopupMenuItem(
            onTap: () {
              onMenuTap(3);
            },
            child: Row(
              children: [
                SvgPicture.asset(
                  "assets/svg/share_white.svg",
                  color: Colors.black,
                  width: 20,
                  height: 20,
                ),
                SizedBox(
                  width: 12,
                ),
                Text(
                  getTranslated('share', context)!,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontFamily: GoogleFonts
                        .poppins()
                        .fontFamily,
                    fontWeight: FontWeight.w400,
                    height: 0,
                  ),
                )
              ],
            )),
        PopupMenuItem(
            onTap: () {
              onMenuTap(4);
            },
            child: Row(
              children: [
                Icon(
                  Icons.star_border,
                  color: Colors.black,
                  size: 20,
                ),
                SizedBox(
                  width: 12,
                ),
                Text(
                  getTranslated('rating', context)!,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontFamily: GoogleFonts
                        .poppins()
                        .fontFamily,
                    fontWeight: FontWeight.w400,
                    height: 0,
                  ),
                )
              ],
            )),
        PopupMenuItem(
            onTap: () {
              onMenuTap(5);
            },
            child: Row(
              children: [
                SvgPicture.asset(
                  "assets/svg/return_route.svg",
                  width: 20,
                  height: 20,
                ),
                SizedBox(
                  width: 12,
                ),
                Text(
                  getTranslated('re_post', context)!,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontFamily: GoogleFonts
                        .poppins()
                        .fontFamily,
                    fontWeight: FontWeight.w400,
                    height: 0,
                  ),
                )
              ],
            )),

      ],
    );
  }

  Widget getInTouchButton(Function(int) onMenuTap) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(right: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              onMenuTap(2);
            },
            child: Container(
              height: 38,
              width: 253,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 0.50, color: Color(0x33001E49)),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Get In Touch",
                    style: TextStyle(
                      color: Color(0xFF001E49),
                      fontSize: 12,
                      fontFamily: GoogleFonts
                          .poppins()
                          .fontFamily,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 5,),
                  Icon(Icons.call, size: 15)
                ],
              ),
            ),
          ),
          SizedBox(width: 8),
          InkWell(onTap: () {}, child: popUpmenu(onMenuTap))
        ],
      ),
    );
  }

  String getTranport(int val) {
    switch (val) {
      case 0:
        return "Transporters";

      case 1:
        return "Agents/Brokers";

      case 2:
        return "PACKERS AND MOVERS";
      case 3:
        return "MANUFACTURERS";
      case 4:
        return "DISTRIBUTORS";
      case 5:
        return "CLEARING AND FORWARDING AGENTS";
      default:
        return "";
    }
  }


  Widget routes(String fromCity, String toCity) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 8),
      decoration: ShapeDecoration(
        color: Color(0xFFF4F6F6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: SizedBox(
              child: Text(
                fromCity,
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: Color(0xCC001E49),
                  fontSize: 12,
                  fontFamily: GoogleFonts
                      .poppins()
                      .fontFamily,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 5,
          ),
          Icon(
            Icons.arrow_circle_right_rounded,
            color: Colors.grey,
          ),
          SizedBox(
            width: 5,
          ),
          Expanded(
            child: SizedBox(
              child: Text(
                toCity,
                style: TextStyle(
                  color: Color(0xCC001E49),
                  fontSize: 12,
                  fontFamily: GoogleFonts
                      .poppins()
                      .fontFamily,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget heading1(String title, String date, String subTitle) {
    return Container(
      width: double.infinity,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(4),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontFamily: GoogleFonts
                                  .poppins()
                                  .fontFamily,
                              fontWeight: FontWeight.w600,
                            ),
                            // overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          date,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: Color(0x99001E49),
                            fontSize: 12,
                            fontFamily: GoogleFonts
                                .poppins()
                                .fontFamily,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 4),
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      subTitle,
                      style: TextStyle(
                        color: Color(0x99001E49),
                        fontSize: 12,
                        fontFamily: GoogleFonts
                            .poppins()
                            .fontFamily,
                        fontWeight: FontWeight.w400,
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

  Widget onlyBidButton(Function onTab) {
    return InkWell(
      onTap: () {
        onTab();
      },
      child: Container(
        height: 38,
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 0.50, color: Color(0x33001E49)),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Withdraw quote",
              style: TextStyle(
                color: Color(0xFF001E49),
                fontSize: 12,
                fontFamily: GoogleFonts
                    .poppins()
                    .fontFamily,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget deleteMyPostButton(Function(int) onMenuTap) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(right: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              onMenuTap(10);
            },
            child: Container(
              height: 38,
              width: 253,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 0.50, color: Color(0x33001E49)),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Delete",
                    style: TextStyle(
                      color: ThemeColor.red,
                      fontSize: 12,
                      fontFamily: GoogleFonts
                          .poppins()
                          .fontFamily,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SvgPicture.asset(Images.delete)
                ],
              ),
            ),
          ),
          SizedBox(width: 8),
          InkWell(onTap: () {}, child: popUpmenuOwnPost(onMenuTap))
        ],
      ),
    );
  }

  popUpmenuOwnPost(Function(int) onMenuTap) {
    return PopupMenuButton(
      shape: RoundedRectangleBorder(
        side: BorderSide(width: 1, color: Color(0x332C363F)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(child: SvgPicture.asset(Images.post_menu)),
      onSelected: (dynamic val) {
        onMenuTap(val);
      },
      itemBuilder: (context) =>
      [
        PopupMenuItem(
          onTap: () {
            onMenuTap(1);
          },
          child: Row(
            children: [
              SvgPicture.asset(
                Images.delete,
                color: Colors.black,
                width: 20,
                height: 20,
              ),
              SizedBox(
                width: 12,
              ),
              Text(
                getTranslated('delete', context)!,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontFamily: GoogleFonts
                      .poppins()
                      .fontFamily,
                  fontWeight: FontWeight.w400,
                  height: 0,
                ),
              ),
              SizedBox(
                width: 13,
              ),
            ],
          ),
        ),
        PopupMenuItem(
            onTap: () {
              onMenuTap(3);
            },
            child: Row(
              children: [
                SvgPicture.asset(
                  Images.share_white,
                  color: Colors.black,
                  width: 20,
                  height: 20,
                ),
                SizedBox(
                  width: 12,
                ),
                Text(
                  getTranslated('share', context)!,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontFamily: GoogleFonts
                        .poppins()
                        .fontFamily,
                    fontWeight: FontWeight.w400,
                    height: 0,
                  ),
                )
              ],
            )),
      ],
    );
  }
}
