import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tkd_app/dialog/share_dialog_box.dart';
import 'package:tkd_app/model/truck_load_model.dart';
import 'package:tkd_app/provider/dashboard_provider.dart';
import 'package:tkd_app/provider/delete_interface.dart';
import 'package:tkd_app/util/ResponsiveWidget.dart';
import 'package:tkd_app/view/base_widget/utils.dart';
import 'package:tkd_app/view/screens/editPost/edit_post_load.dart';
import 'package:tkd_app/widgets/toast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import '../locator.dart';
import '../model/my_bids.dart';
import '../util/colors.dart';
import '../view/base_widget/app_constant.dart';
import '../view/base_widget/custom_textview.dart';
import 'base_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tkd_app/dialog/share_dialog_box.dart';
import 'package:tkd_app/model/truck_load_model.dart';
import 'package:tkd_app/provider/dashboard_provider.dart';
import 'package:tkd_app/provider/delete_interface.dart';
import 'package:tkd_app/util/ResponsiveWidget.dart';
import 'package:tkd_app/view/base_widget/utils.dart';
import 'package:tkd_app/view/screens/editPost/edit_post_load.dart';
import 'package:tkd_app/widgets/toast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import '../locator.dart';
import '../util/colors.dart';
import '../view/base_widget/app_constant.dart';
import '../view/base_widget/custom_textview.dart';
import 'base_widgets.dart';

class DashbordCards {
  cardLoad(int index, BuildContext context, TruckLoad load, {int userId = 0}) {
    return Container(
      width: 335,
      padding: EdgeInsets.all(12),
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        shadows: [
          BoxShadow(
            color: Color(0x114A5568),
            blurRadius: 8,
            offset: Offset(0, 3),
            spreadRadius: 0,
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Container(
              width: 100,
              height: 18,
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: ShapeDecoration(
                color: Color(0xFF2C8FEA),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)),
              ),
              child: Center(
                child: Text(
                  load.mainTag!,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 8),
          BaseWidget().profile(
              load.companyLogo!, load.nameOfPerson!, load.companyName!,
              verify: load.isPaid!, rating: load.ratings??4.5),
          BaseWidget().routes(load.source!, load.destination!),
          SizedBox(
            height: 12,
          ),
        //  imageLoad(load),
          BaseWidget().heading(
              load.topicName!, getDateObject(load.postingTime), load.content!),
          load.userId == userId
              ? BaseWidget().deleteButton((val) {
            if (val == 10) {
            } else {
              Utils().openMenu(val, load, context);
            }
          }, load)
              : BaseWidget().bidButton(load, (val) {
            if (load.dnd == 1) {
              ToastMessage.show(context, "This is DND Post");
            } else {
              Utils().openMenu(val, load, context);
            }
          })

      ],
      ),
    );
  }

  cardLoadHome(int index, BuildContext context, TruckLoad load, int userId,
      DeletePostInf postDelete, DashboardProvider provider, bool isOwnPost) {
    return Opacity(
      opacity: Utils().isExpired(load.expireDate!) || (load.isCompleted == 1)
          ? 0.5
          : 1.0,
      child: Container(
        width: 335,
        padding: EdgeInsets.all(12),
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          shadows: [
            BoxShadow(
              color: Color(0x114A5568),
              blurRadius: 8,
              offset: Offset(0, 3),
              spreadRadius: 0,
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Visibility(
                  visible: load.expireDate == '' ? false : true,
                  child: Container(
                    width: 120,
                    height: 20,
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(2)),
                      border: Border.all(
                        width: 0.5,
                        color: ThemeColor.red,
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "valid till: ${load.expireDate == '' ? "-" : load.expireDate!}",
                        style: TextStyle(
                          color: ThemeColor.black,
                          fontSize: 8,
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                Spacer(),
                Align(
                  alignment: Alignment.topRight,
                  child: SizedBox(
                    height: 53,
                    width: 140,
                    child: Column(
                      children: [
                        Text(
                          "TKD${load.id}",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 10,
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Container(
                          width: 120,
                          height: 18,
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: ShapeDecoration(
                            color: Color(0xFF2C8FEA),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4)),
                          ),
                          child: Center(
                            child: Text(
                              Utils().mainTag(load.mainTag!),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                                fontFamily: GoogleFonts.poppins().fontFamily,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 3,),
                        Container(
                          width: 120,
                          height: 18,
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: ShapeDecoration(
                            color: Color(0xFF2C8FEA),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4)),
                          ),
                          child: Center(
                            child: Text(
                              "Payment Mode : ${load.typeOfPayment}",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                                fontFamily: GoogleFonts.poppins().fontFamily,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: load.privatePost == 1 ? 10 : 5),
            load.privatePost == 1
                ? SizedBox.shrink()
                : BaseWidget().profileWithUser(
                load.companyLogo!, load.nameOfPerson!, load.companyName!,
                verify: load.isverified!,
                transporterOrAgent: load.transporterOrAgent!, ratings: load.ratings??4.5,isJob: false,email: ''),
            BaseWidget().routes(load.source!, load.destination!),
            SizedBox(
              height: 12,
            ),
            //imageLoad(load),
            BaseWidget().heading(
              load.topicName!,
              getDateObject(load.postingTime),
              load.content!,
            ),
            load.userId == userId
                ? BaseWidget().deleteButton((val) {
              if (val == 5) {
                postDelete.rePost(load, false);
              } else if (val == 6) {
                postDelete.rePost(load, true);
              } else if (val == 10) {
                postDelete.deleteOwnPost(load.id!, index);
              } else if (val == 11) {
                _showCompleteDialog(context, load.id!);
              } else if (val == 7) {
                showDialog(
                    context: context,
                    builder: (_) => Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      elevation: 0.0,
                      insetPadding: ResponsiveWidget.isMobile(context)
                          ? EdgeInsets.symmetric(
                          vertical: 50, horizontal: 10)
                          : ResponsiveWidget.isTablet(context)
                          ? EdgeInsets.symmetric(
                          vertical: 50, horizontal: 50)
                          : EdgeInsets.symmetric(
                          vertical: 50, horizontal: 50),
                      backgroundColor: Colors.white,
                      child: Container(
                        width: ResponsiveWidget.isMobile(context)
                            ? MediaQuery.of(context).size.width - 50
                            : ResponsiveWidget.isDesktop(context)
                            ? 500
                            : 400,
                        child: Stack(
                          children: [
                            EditPostLoadScreen(load),
                            Positioned(
                              top: 7,
                              right: 7,
                              child: IconButton(
                                icon: Icon(
                                  Icons.close,
                                  size: 18,
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ));
              } else {
                if (load.dnd == 1) {
                  ToastMessage.show(context, "This is DND Post");
                } else {
                  Utils().openMenu(val, load, context);
                }
              }
            }, load, isOwnPost: isOwnPost)
                : BaseWidget().bidButton(load, (val) {
              if (load.dnd == 1) {
                if(val ==0){ Utils() .openMenu(val, load, context); }else{ ToastMessage.show(context, "This is DND Post"); }
              } else {
                Utils().openMenu(val, load, context);
              }
            })


          ],
        ),
      ),
    );
  }



  final dashboardProvider = locator<DashboardProvider>();
  Future<void> _showCompleteDialog(BuildContext context, int id) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Complete Post",
              style: TextStyle(
                  fontFamily: AppConstant.FONTFAMILY,
                  color: ThemeColor.theme_blue)),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                CustomText(
                  "Do you want to complete this post.",
                  style: TextStyle(
                      fontFamily: AppConstant.FONTFAMILY,
                      color: ThemeColor.theme_blue),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: CustomText("Complete",
                  style: TextStyle(
                      fontFamily: AppConstant.FONTFAMILY,
                      color: ThemeColor.red)),
              onPressed: () {
                dashboardProvider.completePost(id, context);
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: CustomText("No",
                  style: TextStyle(
                      fontFamily: AppConstant.FONTFAMILY,
                      color: ThemeColor.green)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  generalPost(TruckLoad truckLoad, BuildContext context) {
    return Container(
      width: 335,
      padding: EdgeInsets.all(12),
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        shadows: [
          BoxShadow(
            color: Color(0x114A5568),
            blurRadius: 8,
            offset: const Offset(0, 3),
            spreadRadius: 0,
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
              alignment: Alignment.topRight,
              child: InkWell(
                onTap: () async {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return ShareDialogBox(truckLoad);
                      });
                },
                child: SvgPicture.asset(
                  'assets/images/share_icon.svg',
                  height: 25,
                  width: 25,
                ),
              )),
          Container(
              transform: Matrix4.translationValues(0.0, -25.0, 00),
              child: BaseWidget().profileWithUser(
                  truckLoad.companyLogo!, truckLoad.nameOfPerson!, truckLoad.companyName!,
                  verify: truckLoad.isverified!,
                  transporterOrAgent: truckLoad.transporterOrAgent!, ratings: truckLoad.ratings??0.0,isJob: false,email: ''),),
          SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            transform: Matrix4.translationValues(0.0, -25.0, 00),
            child: BaseWidget().heading(truckLoad.topicName!,
                truckLoad.postingTime!, truckLoad.content!),
          ),
          truckLoad.images != null &&
              truckLoad.images!.isNotEmpty &&
              truckLoad.images![0] != null
              ? BaseWidget().image(context,
              image: (truckLoad.images![0])):SizedBox(),
          Divider(),
          SizedBox(
            height: 5,
          ),
          BaseWidget()
              .likeComment(truckLoad, context, likeCount: truckLoad.likes!, commentCount: truckLoad.comment!.length)
        ],
      ),
    );
  }

  getDateObject(String? dateTime) {
    try {
      DateTime formatedDate = DateTime.parse(dateTime!);
      print(formatedDate);
      var date1 = DateFormat("yyyy-MM-dd").format(formatedDate);
      var todayDate = DateFormat("yyyy-MM-dd").format(DateTime.now());
      if (date1 == todayDate) {
        date1 = DateFormat("H:mm").format(formatedDate);
      }
      return date1;
    } catch (e) {
      return dateTime;
    }
  }

  imagePost(TruckLoad load, BuildContext context) {
    if (load.postImages!.length == 0) {
      return Column(
        children: [
          Container(
            transform: Matrix4.translationValues(0.0, -20.0, 00),
            width: 311,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 311,
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 0.50,
                        strokeAlign: BorderSide.strokeAlignCenter,
                        color: Color(0x332C363F),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Container(
              transform: Matrix4.translationValues(0.0, -10.0, 00),
              child: BaseWidget().likeComment(
                load,
                context,
                likeCount: 0,
                commentCount: 0,
              ))
        ],
      );
    } else if (load.postImages!.length == 1) {
      return Column(
        children: [
          BaseWidget().image(context,image: load.postImages!.first),
          SizedBox(
            height: 9,
          ),
          Container(
            //transform: Matrix4.translationValues(0.0, -5.0, 00),
              child: BaseWidget()
                  .likeComment(load, context, likeCount: 0, commentCount: 0))
        ],
      );
    } else {
      return Column(
        children: [
          Container(
              transform: Matrix4.translationValues(0.0, -25.0, 00),
              child: BaseWidget()
                  .carouseImage(context,new List<String>.from(load.postImages!))),
          SizedBox(
            height: 9,
          ),
          Container(
              transform: Matrix4.translationValues(0.0, -10.0, 00),
              child: BaseWidget().likeComment(
                load,
                context,
                likeCount: 0,
                commentCount: 0,
              ))
        ],
      );
    }
  }

  // ADV card (unchanged from your code)
  getAdvCard(BuildContext context, String companyName,String mobileNumber,String website,List<String>? imageUrl,String type) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (_) => imageDialog(companyName, imageUrl![0], context),
        );
      },
      child: Container(
        width: 335,
        padding: EdgeInsets.all(12),
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          shadows: [
            BoxShadow(color: Color(0x114A5568), blurRadius: 8, offset: Offset(0, 3), spreadRadius: 0),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Container(
                width: 100,
                height: 18,
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: ShapeDecoration(
                  color: Color(0xFFD9462A),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                ),
                child: Center(
                  child: Text(
                    type ?? '',
                    style: TextStyle(color: Colors.white, fontSize: 8, fontFamily: GoogleFonts.poppins().fontFamily, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
            SizedBox(height: 8),
            Text(
              companyName ?? '',
              style: TextStyle(color: Colors.black, fontSize: 12, fontFamily: GoogleFonts.poppins().fontFamily, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8),
            imageUrl != null &&
                imageUrl.isNotEmpty &&
                imageUrl[0] != null
                ? BaseWidget().image(context,
                image: (imageUrl![0])):SizedBox(),
            InkWell(
              onTap: () async {
                final url = Uri.parse('http://${website}');
                if (!await launchUrl(url)) {
                  throw Exception('Could not launch $url');
                }
              },
              child: Container(
                padding: EdgeInsets.all(4),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text(companyName ?? '', style: TextStyle(color: Colors.black, fontSize: 12, fontFamily: GoogleFonts.poppins().fontFamily, fontWeight: FontWeight.w600)),
                      Text(mobileNumber.toString() ?? '', style: TextStyle(color: Colors.black, fontSize: 12, fontFamily: GoogleFonts.poppins().fontFamily, fontWeight: FontWeight.w400)),
                    ]),
                    SizedBox(height: 4),
                    SizedBox(width: double.infinity, child: Text(website ?? '', style: TextStyle(color: Color(0x99001E49), fontSize: 12, fontFamily: GoogleFonts.poppins().fontFamily, fontWeight: FontWeight.w400))),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  // image dialog + loaders + image helpers (kept mostly the same)
  Widget imageDialog(text, path, context, ) {
    return Dialog(
      backgroundColor: ThemeColor.baground,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('$text', style: TextStyle(fontWeight: FontWeight.bold)),
              IconButton(onPressed: () => Navigator.of(context).pop(), icon: Icon(Icons.close_rounded), color: Colors.red),
            ]),
          ),
          imageLoadAdd([path],context),
        ],
      ),
    );
  }

  imageLoadAdd(List<String> images, BuildContext context) {
    if (images!.length == 0) {
      return Column(children: [SizedBox(height: 0)]);
    } else if (images!.length == 1) {
      return Column(children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: CachedNetworkImage(
            imageUrl: images!.first,
            placeholder: (context, url) => SvgPicture.asset("assets/svg/logo.svg"),
            errorWidget: (context, url, error) => ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network("https://igps.net/wp-content/uploads/2018/08/shutterstock_711168088.jpg", fit: BoxFit.fill, width: MediaQuery.of(context).size.width - 100, height: MediaQuery.of(context).size.height - 100)),
            fit: BoxFit.fill,
            width: 500,
            height: 500,
          ),
        ),
        SizedBox(height: 9),
      ]);
    } else {
      return Column(children: [
        Container(
          transform: Matrix4.translationValues(0.0, -25.0, 00),
          child: Container(
            child: CarouselSlider(
              options: CarouselOptions(padEnds: false, pageSnapping: false, enableInfiniteScroll: false),
              items: images!
                  .map((item) => Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(child: imageLink(item!)),
                ),
              ))
                  .toList(),
            ),
          ),
        ),
        SizedBox(height: 9),
      ]);
    }
  }

  Widget imageLink(String link) {
    return CachedNetworkImage(
      imageUrl: link,
      placeholder: (context, url) => SvgPicture.asset("assets/svg/logo.svg"),
      errorWidget: (context, url, error) => ClipRRect(borderRadius: BorderRadius.circular(8.0), child: Image.network("https://igps.net/wp-content/uploads/2018/08/shutterstock_711168088.jpg", fit: BoxFit.fill, width: 311, height: 200)),
      fit: BoxFit.fill,
      width: 311,
      height: 200,
    );
  }

  imageLoad(context,List<String> images) {
    if (images!.length == 0) {
      return Column(children: [SizedBox(height: 0)]);
    } else if (images!.length == 1) {
      return Column(children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: CachedNetworkImage(
            imageUrl: images!.first,
            placeholder: (context, url) => SvgPicture.asset("assets/svg/logo.svg"),
            errorWidget: (context, url, error) => ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network("https://igps.net/wp-content/uploads/2018/08/shutterstock_711168088.jpg", fit: BoxFit.fill, width: MediaQuery.of(context).size.width, height: 200)),
            fit: BoxFit.fill,
            width: MediaQuery.of(context).size.width,
            height: 200,
          ),
        ),
        SizedBox(height: 9),
      ]);
    } else {
      return Column(children: [
        Container(
          transform: Matrix4.translationValues(0.0, -25.0, 00),
          child: Container(
            child: CarouselSlider(
              options: CarouselOptions(padEnds: false, pageSnapping: false, enableInfiniteScroll: false),
              items: images!
                  .map((item) => Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(child: imageLink(item!)),
                ),
              ))
                  .toList(),
            ),
          ),
        ),
        SizedBox(height: 9),
      ]);
    }
  }

}
