import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tkd_app/model/my_bids.dart';
import 'package:tkd_app/model/truck_load_model.dart';
import 'package:tkd_app/util/colors.dart';
import 'package:tkd_app/util/images.dart';
import 'package:tkd_app/view/base_widget/utils.dart';
import 'package:tkd_app/view/localization/language_constrants.dart';
import 'package:tkd_app/view/screens/dashboard/post_comment.dart';
import 'package:tkd_app/widgets/toast.dart';
import 'package:tkd_app/widgets/verified_tag.dart';

import '../util/textview.dart';
import '../view/base_widget/custom_textview.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class BaseWidget {
  Widget profile(String profileLink, String name, String companyName,
      {int verify = 0,required double rating}) {
    return SizedBox(
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
                //   width: 40.w,
                //   height: 40.h,
                //   child: Image.network(profileLink),
                // ),
                //getImage(profileLink,height: 40.h,width: 40.w)
                getImageclip(profileLink, height: 40.h, width: 40.w)
              ],
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: SizedBox(
              height: 52.h,
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
                          SizedBox(
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
                                            Textview(
                                              title: name,
                                              TextStyle(
                                                color: Colors.black,
                                                fontSize: 14.sp,
                                                fontFamily:
                                                GoogleFonts.poppins()
                                                    .fontFamily,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 4.w,
                                            ),
                                            Visibility(
                                                visible:
                                                verify != 0 ? true : false,
                                                child: SvgPicture.asset(
                                                  Images.verified,
                                                  height: 12.h,
                                                  width: 12.w,
                                                ))
                                          ],
                                        ),
                                        SizedBox(
                                          width: double.infinity,
                                          child: Textview(
                                            title: companyName,
                                            TextStyle(
                                              color: const Color(0x99001E49),
                                              fontSize: 10.sp,
                                              fontFamily: GoogleFonts.poppins()
                                                  .fontFamily,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                        RatingBar.builder(
                                          itemSize: 10,
                                          initialRating: rating,
                                          minRating: 1,
                                          direction: Axis.horizontal,
                                          allowHalfRating: true,
                                          itemCount: 5,
                                          itemPadding: const EdgeInsets.symmetric(
                                              horizontal: 1.0),
                                          itemBuilder: (context, _) => const Icon(
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
                          SizedBox(height: 4.h),
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

  Widget profileWithUser(String profileLink, String name, String companyName,
      {int verify = 0, int transporterOrAgent = 0,required double ratings,required bool isJob,required String email}) {
    return SizedBox(
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
                //   width: 40.w,
                //   height: 40.h,
                //   child: Image.network(profileLink),
                // ),
                //getImage(profileLink,height: 40.h,width: 40.w)
                getImageclip(profileLink, height: 40.h, width: 40.w)
              ],
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Container(
              // height: 52.h,
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
                          SizedBox(
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
                                            Textview(
                                              title: name,
                                              TextStyle(
                                                color: Colors.black,
                                                fontSize: 14.sp,
                                                fontFamily:
                                                GoogleFonts.poppins()
                                                    .fontFamily,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 4.w,
                                            ),
                                            Visibility(
                                              visible:
                                              verify != 0 ? true : false,
                                              // child: SvgPicture.asset(
                                              //   Images.verified,
                                              //   height: 12.h,
                                              //   width: 12.w,
                                              // ))
                                              child: VerifiedTag().onVeriedTag(),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          width: double.infinity,
                                          child: Textview(
                                            title: companyName,
                                            TextStyle(
                                              color: const Color(0x99001E49),
                                              fontSize: 12.sp,
                                              fontFamily: GoogleFonts.poppins()
                                                  .fontFamily,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: double.infinity,
                                          child: Textview(
                                            title: Utils().getTransport(
                                                transporterOrAgent),
                                            TextStyle(
                                              color: const Color(0xFF000000),
                                              fontSize: 12.sp,
                                              fontFamily: GoogleFonts.poppins()
                                                  .fontFamily,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        isJob?Text(
                                          email,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 10,
                                            fontFamily: GoogleFonts.poppins().fontFamily,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ):RatingBar.builder(
                                          itemSize: 12,
                                          initialRating: ratings,
                                          minRating: 1,
                                          direction: Axis.horizontal,
                                          allowHalfRating: true,
                                          itemCount: 5,
                                          itemPadding: const EdgeInsets.symmetric(
                                              horizontal: 1.0),
                                          itemBuilder: (context, _) => const Icon(
                                            Icons.star,
                                            color: Colors.red,
                                            size: 5,
                                          ),
                                          onRatingUpdate: (rating) {
                                            //print(rating);
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 4.h),
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

  Widget profileDirectory(String profileLink, String name, String companyName,
      {int verify = 0}) {
    return SizedBox(
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
                //   width: 40.w,
                //   height: 40.h,
                //   child: Image.network(profileLink),
                // ),
                getImageclip(profileLink, height: 56.h, width: 40.w)
              ],
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: SizedBox(
              height: 52.h,
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
                          SizedBox(
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
                                            Textview(
                                              title: name,
                                              TextStyle(
                                                color: Colors.black,
                                                fontSize: 14.sp,
                                                fontFamily:
                                                GoogleFonts.poppins()
                                                    .fontFamily,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 4.w,
                                            ),
                                            Visibility(
                                                visible:
                                                verify != 0 ? true : false,
                                                child: SvgPicture.asset(
                                                  Images.verified,
                                                  height: 12.h,
                                                  width: 12.w,
                                                ))
                                          ],
                                        ),
                                        SizedBox(
                                          width: double.infinity,
                                          child: Textview(
                                            title: companyName,
                                            TextStyle(
                                              color: const Color(0x99001E49),
                                              fontSize: 10.sp,
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
                                          itemPadding: const EdgeInsets.symmetric(
                                              horizontal: 1.0),
                                          itemBuilder: (context, _) => const Icon(
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
                          SizedBox(height: 4.h),
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

  Widget routes(String fromCity, String toCity) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 8.h),
      decoration: ShapeDecoration(
        color: const Color(0xFFF4F6F6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
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
                  color: const Color(0xCC001E49),
                  fontSize: 12.sp,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          const Icon(
            Icons.arrow_circle_right_rounded,
            color: Colors.grey,
          ),
          const SizedBox(
            width: 5,
          ),
          Expanded(
            child: SizedBox(
              child: Text(
                toCity,
                style: TextStyle(
                  color: const Color(0xCC001E49),
                  fontSize: 12.sp,
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

  Widget heading(String title, String date, String subTitle) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(4),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
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
                              fontSize: 12.sp,
                              fontFamily: GoogleFonts.poppins().fontFamily,
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
                            color: const Color(0x99001E49),
                            fontSize: 12.sp,
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 4.h),
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      subTitle,
                      style: TextStyle(
                        color: const Color(0x99001E49),
                        fontSize: 12.sp,
                        fontFamily: GoogleFonts.poppins().fontFamily,
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

  Widget headingWithoutDate(String title, String subTitle) {
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
                            fontSize: 14,
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            fontWeight: FontWeight.w600,
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
                        fontFamily: GoogleFonts.poppins().fontFamily,
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

  Widget bidButton(TruckLoad load, Function(int) onMenuTap) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(right: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Opacity(
            opacity: load.isOpenForBid == 0 ? 0.5 : 1,
            child: InkWell(
              onTap: load.isOpenForBid == 0
                  ? null
                  : () {
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
                      "Quote Now",
                      style: TextStyle(
                        color: Color(0xFF001E49),
                        fontSize: 12,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SvgPicture.asset(Images.bid)
                  ],
                ),
              ),
            ),
          ),
          SizedBox(width: 8),
          InkWell(
            onTap: () {},
            child: popUpmenu(onMenuTap),
          )
        ],
      ),
    );
  }


  Widget deleteButton(Function(int) onMenuTap, TruckLoad load, {bool isOwnPost = false}) {
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
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SvgPicture.asset(Images.delete)
                ],
              ),
            ),
          ),
          SizedBox(width: 8),
          InkWell(
              onTap: () {},
              child: isOwnPost
                  ? popUpmenuForMyPost(onMenuTap,load)
                  : popUpmenuForOwnPost(onMenuTap,load))
        ],
      ),
    );
  }



  Widget buyOnlyDeleteButton(Function(int) onMenuTap, bool isDeleteVisible) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(right: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Visibility(
            visible: isDeleteVisible,
            child: InkWell(
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
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    // SvgPicture.asset(Images.delete)
                  ],
                ),
              ),
            ),
          ),
          SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget buyDeleteButton(Function(int) onMenuTap, bool isDeleteVisible) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(right: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Visibility(
            visible: isDeleteVisible,
            child: InkWell(
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
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    // SvgPicture.asset(Images.delete)
                  ],
                ),
              ),
            ),
          ),
          SizedBox(width: 8),
          InkWell(onTap: () {}, child: popUpmenu(onMenuTap))
        ],
      ),
    );
  }

  Widget showBidButton(Function(int) onMenuTap, bool isBid, PostBidData postBidData,) {
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
                    "Show All Quotes",
                    style: TextStyle(
                      color: Color(0xFF001E49),
                      fontSize: 12,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 8),
          InkWell(
              onTap: () {},
              child: isBid
                  ? popUpmenuOwnBid(onMenuTap)
                  : popUpmenuOwnPost(onMenuTap,postBidData))
        ],
      ),
    );
  }

  popUpmenuOwnPost(Function(int) onMenuTap,PostBidData postBidData) {
    return PopupMenuButton(
      shape: RoundedRectangleBorder(
        side: BorderSide(width: 1, color: Color(0x332C363F)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(child: SvgPicture.asset(Images.post_menu)),
      onSelected: (dynamic val) {
        onMenuTap(val);
      },
      itemBuilder: (context) => [
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
                "Delete",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontFamily: GoogleFonts.poppins().fontFamily,
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
            postBidData.genericCardsDto!.isOpenForBid==1? onMenuTap(8):ToastMessage.show(context, "Your Post already Completed Successfully");;
          },
          child: Row(
            children: [
              /* SvgPicture.asset(
                Images.delete,
                color: Colors.black,
                width: 20,
                height: 20,
              ),*/
              Icon(Icons.done,color: postBidData.genericCardsDto!.isOpenForBid==1?Colors.black:Colors.green,),
              SizedBox(
                width: 12,
              ),
              Text(
                postBidData.genericCardsDto!.isOpenForBid==1?"Complete":"Completed",
                style: TextStyle(
                  color: postBidData.genericCardsDto!.isOpenForBid==1?Colors.black:Colors.green,
                  fontSize: 14,
                  fontFamily: GoogleFonts.poppins().fontFamily,
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
                  "Share",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    fontWeight: FontWeight.w400,
                    height: 0,
                  ),
                )
              ],
            )),
      ],
    );
  }

/*  Widget showBidRepostButton(Function(int) onMenuTap, bool isBid) {
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
                    "Show All Quotes",
                    style: TextStyle(
                      color: Color(0xFF001E49),
                      fontSize: 12,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 8),
          InkWell(
              onTap: () {},
              child: isBid
                  ? popUpmenuOwnBid(onMenuTap)
                  : popUpmenuOwnRepostPost(onMenuTap))
        ],
      ),
    );
  }*/

  popUpmenuOwnRepostPost(Function(int) onMenuTap) {
    return PopupMenuButton(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        side: BorderSide(width: 1, color: Colors.white),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(child: SvgPicture.asset(Images.post_menu)),
      onSelected: (dynamic val) {
        onMenuTap(val);
      },
      itemBuilder: (context) => [
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
                getTranslated("delete", context)!,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontFamily: GoogleFonts.poppins().fontFamily,
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
            onMenuTap(11);
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
              CustomText(
                "Complete",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontFamily: GoogleFonts.poppins().fontFamily,
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
                  getTranslated("share", context)!,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontFamily: GoogleFonts.poppins().fontFamily,
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
                  getTranslated("re_post", context)!,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    fontWeight: FontWeight.w400,
                    height: 0,
                  ),
                )
              ],
            )),
      ],
    );
  }

  popUpmenuOwnBid(Function(int) onMenuTap) {
    return PopupMenuButton(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        side: BorderSide(width: 1, color: Colors.white),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(child: SvgPicture.asset(Images.post_menu)),
      onSelected: (dynamic val) {
        onMenuTap(val);
      },
      itemBuilder: (context) => [
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
                  getTranslated("share", context)!,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    fontWeight: FontWeight.w400,
                    height: 0,
                  ),
                )
              ],
            )),
      ],
    );
  }

  popUpmenuForMyPost(Function(int) onMenuTap, TruckLoad load) {
    return PopupMenuButton(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        side: BorderSide(width: 1, color: Colors.white),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(child: SvgPicture.asset(Images.post_menu)),
      onSelected: (dynamic val) {
        onMenuTap(val);
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          onTap: () {
            load.isOpenForBid==1? onMenuTap(11):ToastMessage.show(context, "Your Post already Completed Successfully");;
          },
          child: Row(
            children: [
              /* SvgPicture.asset(
                Images.delete,
                color: Colors.black,
                width: 20,
                height: 20,
              ),*/
              Icon(Icons.done,color: load.isOpenForBid==1?Colors.black:Colors.green,),
              SizedBox(
                width: 12,
              ),
              Text(
                load.isOpenForBid==1?"Complete":"Completed",
                style: TextStyle(
                  color:load.isOpenForBid==1?Colors.black:Colors.green,
                  fontSize: 14,
                  fontFamily: GoogleFonts.poppins().fontFamily,
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
                  getTranslated("share", context)!,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontFamily: GoogleFonts.poppins().fontFamily,
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
                  getTranslated("rating", context)!,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontFamily: GoogleFonts.poppins().fontFamily,
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
                  Images.return_route,
                  width: 20,
                  height: 20,
                ),
                SizedBox(
                  width: 12,
                ),
                Text(
                  getTranslated("re_post", context)!,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    fontWeight: FontWeight.w400,
                    height: 0,
                  ),
                )
              ],
            )),
        PopupMenuItem(
            onTap: () {
              onMenuTap(6);
            },
            child: Row(
              children: [
                Image.asset(
                  "assets/images/two_way_arrow.png",
                  width: 20,
                  height: 20,
                ),
                SizedBox(
                  width: 12,
                ),
                Text(
                  getTranslated("city_interchange", context)!,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    fontWeight: FontWeight.w400,
                    height: 0,
                  ),
                )
              ],
            )),
        PopupMenuItem(
            onTap: () {
              onMenuTap(7);
            },
            child: Row(
              children: [
                Icon(
                  Icons.edit_outlined,
                  color: Colors.black,
                  size: 20,
                ),
                SizedBox(
                  width: 12,
                ),
                Text(
                  getTranslated("edit", context)!,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    fontWeight: FontWeight.w400,
                    height: 0,
                  ),
                )
              ],
            )),
      ],
    );
  }

  popUpmenuForOwnPost(Function(int) onMenuTap,TruckLoad load) {
    return PopupMenuButton(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        side: BorderSide(width: 1, color: Colors.white),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(child: SvgPicture.asset(Images.post_menu)),
      onSelected: (dynamic val) {
        onMenuTap(val);
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          onTap: () {
            load.isOpenForBid==1? onMenuTap(11):ToastMessage.show(context, "Your Post already Completed Successfully");;
          },
          child: Row(
            children: [
              /* SvgPicture.asset(
                Images.delete,
                color: Colors.black,
                width: 20,
                height: 20,
              ),*/
              Icon(Icons.done,color: load.isOpenForBid==1?Colors.black:Colors.green,),
              SizedBox(
                width: 12,
              ),
              Text(
                load.isOpenForBid==1?"Complete":"Completed",
                style: TextStyle(
                  color:load.isOpenForBid==1?Colors.black:Colors.green,
                  fontSize: 14,
                  fontFamily: GoogleFonts.poppins().fontFamily,
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
                  getTranslated("share", context)!,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontFamily: GoogleFonts.poppins().fontFamily,
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
                  Images.return_route,
                  width: 20,
                  height: 20,
                ),
                SizedBox(
                  width: 12,
                ),
                Text(
                  getTranslated("re_post", context)!,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    fontWeight: FontWeight.w400,
                    height: 0,
                  ),
                )
              ],
            )),
        PopupMenuItem(
            onTap: () {
              onMenuTap(6);
            },
            child: Row(
              children: [
                Image.asset(
                  "assets/images/two_way_arrow.png",
                  width: 20,
                  height: 20,
                ),
                SizedBox(
                  width: 12,
                ),
                Text(
                  getTranslated("city_interchange", context)!,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    fontWeight: FontWeight.w400,
                    height: 0,
                  ),
                )
              ],
            )),
        PopupMenuItem(
            onTap: () {
              onMenuTap(7);
            },
            child: Row(
              children: [
                Icon(
                  Icons.edit_outlined,
                  color: Colors.black,
                  size: 20,
                ),
                SizedBox(
                  width: 12,
                ),
                Text(
                  getTranslated('edit', context)!,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    fontWeight: FontWeight.w400,
                    height: 0,
                  ),
                )
              ],
            )),
      ],
    );
  }

  popUpmenu(Function(int) onMenuTap) {
    return PopupMenuButton(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        side: BorderSide(width: 1, color: Colors.white),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(child: SvgPicture.asset(Images.post_menu)),
      onSelected: (dynamic val) {
        onMenuTap(val);
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          onTap: () {
            onMenuTap(1);
          },
          child: Row(
            children: [
              SvgPicture.asset(
                Images.message,
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
                  fontFamily: GoogleFonts.poppins().fontFamily,
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
                  Images.call_white,
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
                    fontFamily: GoogleFonts.poppins().fontFamily,
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
                    fontFamily: GoogleFonts.poppins().fontFamily,
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
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    fontWeight: FontWeight.w400,
                    height: 0,
                  ),
                )
              ],
            )),
      ],
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
              "Withdraw Quotes",
              style: TextStyle(
                color: Color(0xFF001E49),
                fontSize: 12,
                fontFamily: GoogleFonts.poppins().fontFamily,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget image(BuildContext context,{required String image}) {
    print("Loading Image: $image");

    final placeholderImage = SvgPicture.asset(Images.logo);
    final errorImage = ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: Image.network(
        "https://igps.net/wp-content/uploads/2018/08/shutterstock_711168088.jpg",
        fit: BoxFit.fill,
        width: 311,
        height: 200,
      ),
    );

    return InkWell(
      onTap: () {
        showZoomImageDialog(context, image);
      },
      child: Center(
        child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(
              image,
              fit: BoxFit.fill,
              width: 311,
              height: 200,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return CircularProgressIndicator();
              },
              errorBuilder: (context, error, stackTrace) {
                print("Error loading image: $image, Error: $error");
                return errorImage;
              },
            )
        ),
      ),
    );
  }

  void showZoomImageDialog(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          insetPadding: EdgeInsets.zero,
          backgroundColor: Colors.black87,
          child: Stack(
            children: [
              InteractiveViewer(
                panEnabled: true,
                minScale: 1,
                maxScale: 4,
                child: Center(
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              // Close Button
              Positioned(
                top: 30,
                right: 20,
                child: InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black54,
                    ),
                    child: const Icon(Icons.close, color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }



  Widget imageLink(BuildContext context,String link) {
    return image(context,image: link);
  }

  Widget carouseImage(BuildContext context,List<String?> imgList) {
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
              child: Center(child: imageLink(context,item!)),
            ),
          ))
              .toList(),
        ));
  }

  Widget carouseImageDelete(BuildContext context,List<String?> imgList, Function(String) onDelete) {
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
              child: Stack(
                children: [
                  Center(child: imageLinkDelete(context,item!)),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: InkWell(
                      onTap: () {
                        onDelete(item);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SvgPicture.asset(
                          Images.delete,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ))
              .toList(),
        ));
  }

  Widget imageLinkDelete(BuildContext context,String link) {
    return image(context,image: link);
  }

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
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (builder) => PostCommentList(truckLoad)));
                      },
                      child: Container(
                        width: 16,
                        height: 16,
                        child: SvgPicture.asset(Images.like),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Container(
                    child: Text(
                      "Like",
                      style: TextStyle(
                        color: Color(0xFF001E49),
                        fontSize: 12,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontWeight: FontWeight.w600,
                      ),
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
                      child:
                      Stack(children: [SvgPicture.asset(Images.message)]),
                    ),
                    SizedBox(width: 8),
                    Container(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Comment",
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
      ),
    );
  }

  Widget likeCommentDetails(
      TruckLoad truckLoad, BuildContext context, Function onTabLikeCount,
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
                          child:
                          Stack(children: [SvgPicture.asset(Images.like)]),
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
                          "Like",
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
                              children: [SvgPicture.asset(Images.message)]),
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
                          "Comment",
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
                Images.arrow_back,
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
                child: SvgPicture.asset(
                  Images.arrow_back,
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
}
