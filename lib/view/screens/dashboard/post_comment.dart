import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:intl/intl.dart';
import 'package:tkd_app/locator.dart';
import 'package:tkd_app/model/truck_load_model.dart';
import 'package:tkd_app/provider/comment_provider.dart';
import 'package:tkd_app/util/ResponsiveWidget.dart';
import 'package:tkd_app/util/color-resource.dart';
import 'package:tkd_app/view/base_widget/appbar.dart';
import 'package:tkd_app/view/base_widget/home_base_widgets.dart';
import 'package:tkd_app/view/base_widget/utils.dart';

class PostCommentList extends StatefulWidget {
  TruckLoad truckLoad;

  PostCommentList(this.truckLoad);

  @override
  State<StatefulWidget> createState() {
    return _PostCommentListState();
  }
}

class _PostCommentListState extends State<PostCommentList> {
  final commentProvider = locator<CommentProvider>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    commentProvider.getCommentByPostId(widget.truckLoad.id!);
  }

  @override
  Widget build(BuildContext context) {
    return _buildPage(context);
  }

  _buildPage(BuildContext context) {
    return Scaffold(
      backgroundColor:ColorResources.HOME_BG,
      appBar: AppBarCommon(context, title: "Like and Comments").appBar(),
      body: SafeArea(
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Consumer<CommentProvider>(
              builder: (context, provider, child) {
                return

                  RefreshIndicator(
                    onRefresh: () async {
                      provider.selectedPage = 0;
                      provider.getCommentByPostId(
                          widget.truckLoad.id!);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        generalPost(widget.truckLoad),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: ResponsiveWidget.isMobile(context)?MediaQuery.of(context).size.width:500,
                          margin: EdgeInsets.only(left: 20, right: 20),
                          padding: EdgeInsets.only(top: 12, left: 16),
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(16),
                                  topRight: Radius.circular(16)),
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
                          child: Text(
                            'Comments',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff000000),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            color: Colors.white,
                            width: ResponsiveWidget.isMobile(context)?MediaQuery.of(context).size.width:500,
                            margin: EdgeInsets.only(left: 20, right: 20),
                            padding: EdgeInsets.all(12),
                            child: !provider.isLoading && provider.commentList.length==0?Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("No any Comment")
                              ],
                            ) :ListView.builder(
                              shrinkWrap: true,
                              controller: provider.scrollController,
                              itemCount: provider.commentList.length,
                              itemBuilder: (context, i) {
                                return Column(
                                  children: [
                                    ListTile(
                                      //leading: getImage("${generalPost.images==[]?'':generalPost.images![0]}"),

                                      title: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          BaseWidget().getImageclip(
                                              provider
                                                  .commentList[i].profileImage!,
                                              height: 20,
                                              width: 20),
                                          SizedBox(
                                            width: 7,
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                provider
                                                    .commentList[i].userName!,
                                                style:TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 10,
                                                  fontFamily:
                                                  GoogleFonts.poppins()
                                                      .fontFamily,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              Text(
                                                "${provider.commentList[i].comment}",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontFamily:
                                                  GoogleFonts.poppins()
                                                      .fontFamily,
                                                  fontWeight: FontWeight.w400,
                                                  color: Color(0xff1f1f1f),
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                      trailing: Text(
                                        "${readTimestamp(provider.commentList[i].date!)}",
                                        style: TextStyle(
                                          fontSize: 9,
                                          fontFamily:
                                          GoogleFonts.poppins().fontFamily,
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xff1f1f1f),
                                        ),
                                      ),
                                    ),
                                    Divider(
                                      height: 0.2,
                                      thickness: 0.5,
                                    )
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                        Container(
                          color: ColorResources.HOME_BG,
                          height: 90,
                          width: ResponsiveWidget.isMobile(context)?MediaQuery.of(context).size.width:500,
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: TextField(
                              controller: provider.commentController,
                              style: TextStyle(
                                color: Color(0xff1B1B1B),
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  hintText: "Add a comment..",
                                  hintStyle: TextStyle(
                                      color: ColorResources.PRIMARY_COLOR,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w300),
                                  suffixIcon: InkWell(
                                      onTap: () {
                                        provider.createCommentApi(
                                            widget.truckLoad.id!,
                                            provider.commentController.text);
                                      },
                                      child: Icon(
                                        Icons.send,
                                        color: ColorResources.PRIMARY_COLOR,
                                      ))),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
              },
            ),
          )),
    );
  }

  String readTimestamp(int timestamp) {
    var now = DateTime.now();
    var format = DateFormat('HH:mm ');
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    var diff = now.difference(date);
    var time = '';

    if (diff.inSeconds <= 0 ||
        diff.inSeconds > 0 && diff.inMinutes == 0 ||
        diff.inMinutes > 0 && diff.inHours == 0 ||
        diff.inHours > 0 && diff.inDays == 0) {
      time = format.format(date);
    } else if (diff.inDays > 0 && diff.inDays < 7) {
      if (diff.inDays == 1) {
        time = diff.inDays.toString() + ' DAY AGO';
      } else {
        time = diff.inDays.toString() + ' DAYS AGO';
      }
    } else {
      if (diff.inDays == 7) {
        time = (diff.inDays / 7).floor().toString() + ' WEEK AGO';
      } else {
        time = (diff.inDays / 7).floor().toString() + ' WEEKS AGO';
      }
    }

    return time;
  }

  generalPost(TruckLoad truckLoad) {
    return Container(
      width: 335,
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.all(12),
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
            child: InkWell(
              onTap: () {
                String des = truckLoad.topicName! + "\n " + truckLoad.content!;
                Utils().callShareFunction(des);
              },
              child: Container(
                width: 38,
                height: 38,
                child: Image.asset(
                  "assets/images/share.png",
                  height: 38,
                  width: 38,
                ),
              ),
            ),
          ),
          Container(
              transform: Matrix4.translationValues(0.0, -25.0, 00),
              child: BaseWidget
                ().profile(truckLoad.companyLogo!,
                  truckLoad.nameOfPerson!, truckLoad.companyName!,
                  verify: truckLoad.isPaid!)),
          // SizedBox(
          //   height: 12,
          // ),
          Container(
              transform: Matrix4.translationValues(0.0, -25.0, 00),
              child: BaseWidget()
                  .heading(truckLoad.topicName!, truckLoad.content!)),
          SizedBox(
            height: 5,
          ),

          imagePost(truckLoad),
        ],
      ),
    );
  }

  imagePost(TruckLoad load) {
    if (load.postImages!.length == 0) {
      return Consumer<CommentProvider>(
        builder: (context, provider, child) {
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
                  child: BaseWidget().likeCommentDetails(

                      load,
                      context,(){
                    provider.likeIncreamentApi(load.id!, context);
                  }, likeCount: provider.countLike,
                    commentCount: provider.countComment,)),
            ],
          );
        },
      );
    } else if (load.postImages!.length == 1) {
      return Consumer<CommentProvider>(
        builder: (context, provider, child) {
          return Column(
            children: [
              BaseWidget().image(image: load.postImages!.first),
              SizedBox(
                height: 9,
              ),
              Container(
                //transform: Matrix4.translationValues(0.0, -5.0, 00),
                  child: BaseWidget().likeCommentDetails(

                      load,
                      context,(){
                    provider.likeIncreamentApi(load.id!, context);
                  },likeCount: provider.countLike,
                    commentCount: provider.countComment))
            ],
          );
        },
      );
    } else {
      return Consumer<CommentProvider>(
        builder: (context, provider, child) {
          return Column(
            children: [
              Container(
                  transform: Matrix4.translationValues(0.0, -25.0, 00),
                  child: BaseWidget()
                      .carouseImage(new List<String>.from(load.postImages!))),
              SizedBox(
                height: 9,
              ),
              Container(
                  transform: Matrix4.translationValues(0.0, -10.0, 00),
                  child: BaseWidget().likeCommentDetails(
                       load, context,(){

                    provider.likeIncreamentApi(load.id!, context);
                  },likeCount: provider.countLike, commentCount: provider.countComment))
            ],
          );
        },
      );
    }
  }
}
