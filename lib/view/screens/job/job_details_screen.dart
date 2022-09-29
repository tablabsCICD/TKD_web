
import 'package:tkd_app/util/style.dart';
import 'package:tkd_app/view/base_widget/getImage.dart';
import 'package:universal_html/html.dart' as html;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tkd_app/dialog/animated_custom_dialog.dart';
import 'package:tkd_app/locator.dart';
import 'package:tkd_app/model/job_model.dart';
import 'package:tkd_app/model/truck_load_model.dart';
import 'package:tkd_app/open_whatsapp.dart';
import 'package:tkd_app/provider/auth_provider.dart';
import 'package:tkd_app/provider/bid_provider.dart';
import 'package:tkd_app/share_data.dart';
import 'package:tkd_app/util/ResponsiveWidget.dart';
import 'package:tkd_app/util/color-resource.dart';
import 'package:tkd_app/util/custom_text_style.dart';
import 'package:tkd_app/util/date_converter.dart';
import 'package:tkd_app/util/star_display.dart';
import 'package:tkd_app/view/base_widget/custom_button.dart';
import 'package:tkd_app/view/base_widget/custom_textfeild.dart';
import 'package:tkd_app/view/base_widget/rating_star.dart';

class JobDetailsScreen extends StatefulWidget {
  Job job;
  JobDetailsScreen(this.job);

  @override
  _JobDetailsScreenState createState() => _JobDetailsScreenState();
}

class _JobDetailsScreenState extends State<JobDetailsScreen> {
  final bidProvider = locator<BidProvider>();
  final authProvider = locator<AuthProvider>();
  TextEditingController bidAmtController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController sourceController = TextEditingController();
  TextEditingController destinationController = TextEditingController();
  TextEditingController filterController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorResources.PRIMARY_COLOR,
        title: Text('Job Details'),),
      body: Container(
        child: ResponsiveWidget.isMobile(context)
            ? Stack(children: [
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fill,
                image: NetworkImage('assets/images/truck.png'),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                getCart(),
              ],
            ),
          ),
        ])
            : Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage('assets/images/truck.png'),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: getCart(),
            ),

          ],
        ),
      ),

    );
  }

  getCart(){
    return Container(
      width: ResponsiveWidget.isMobile(context) ? MediaQuery.of(context).size.width : MediaQuery.of(context).size.width/2,
      child: Card(
        color: Colors.transparent,
        elevation: 5,
        margin: EdgeInsets.all(10),
        child: ListView(
          children: [
            ListTile(
              contentPadding:
              EdgeInsets.symmetric(vertical: 0, horizontal: 5),
              horizontalTitleGap: 5,
              minVerticalPadding: 0,
              leading: Stack(
                children: [
                  getImage(widget.job.companyLogo.toString()),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Image.asset(
                      widget.job.isPaid == 30
                          ? 'assets/images/diamond.png'
                          : widget.job.isPaid == 20
                          ? 'assets/images/gold_badge.png'
                          : 'assets/images/ruby_badge.png',
                      width: 15,
                      height: 20,
                    ),
                  )
                ],
              ),
              title: Row(
                children: [
                  Text(
                      widget.job.nameOfPerson
                          .toString(),
                      style: titleTextStyle),
                  SizedBox(
                    width: 10,
                  ),
                  widget.job.isVerifiedByCompany ==
                      null
                      ? Image.asset(
                    'assets/images/membership.png',
                    width: 15,
                    height: 15,
                  )
                      : Image.asset(
                    'assets/images/membership.png',
                    width: 15,
                    height: 15,
                  )
                ],
              ),
              subtitle: Text(
                  widget.job.companyName.toString(),
                  style: subTitleTextStyle),
              trailing: ConvertStringToDate(widget
                  .job.postingTime
                  .toString()),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 10.0, vertical: 7),
              child: Text(
                  widget.job.topicName.toString(),
                  style: titilliumSemiBold),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 10.0, bottom: 10, right: 10),
              child: Text(
                widget.job.content.toString(),
                style: regularTextStyle,
              ),
            ),
            Divider(
              height: 1.5,
              thickness: 1.5,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 10.0, vertical: 7),
              child: Text(
                  'Other Details',
                  style: titilliumSemiBold),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 10.0, bottom: 10, right: 10),
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Email_Id',
                        style: regularTextStyle,
                      ),
                      Text('Alternate Number', style: regularTextStyle),
                      Text('Vehicle Size', style: regularTextStyle),
                      Text('User Type', style: regularTextStyle),
                    ],
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ': ${widget.job.companyName.toString()}',
                        style: TextStyle(
                            color: ColorResources.PRIMARY_COLOR),
                      ),
                      Text(
                        ': ${widget.job.alterativeNumber.toString()}',
                        style: TextStyle(
                            color: ColorResources.PRIMARY_COLOR),
                      ),
                      Text(
                        ': ${widget.job.vehicleSize.toString()}',
                        style: TextStyle(
                            color: ColorResources.PRIMARY_COLOR),
                      ),
                      Text(
                        ': ${widget.job.type.toString()}',
                        style: TextStyle(
                            color: ColorResources.PRIMARY_COLOR),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Divider(
              height: 1.5,
              thickness: 1.5,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: () {
                      showAnimatedDialog(
                          context,
                          Dialog(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(10)),
                            child: Container(
                              height: 300,
                              width: 300,
                              child: Padding(
                                padding: EdgeInsets.all(16),
                                child: Column(children: [
                                  Text(
                                    'Place Your Bid',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight:
                                        FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  CustomTextField(
                                      controller: bidAmtController,
                                      hintText:
                                      "Enter Your Bid Amount",
                                      textInputType:
                                      TextInputType.number),
                                  CustomTextField(
                                      controller:
                                      descriptionController,
                                      hintText:
                                      "Comments/Descriptions",
                                      textInputType:
                                      TextInputType.number),
                                  CustomButton(
                                      onTap: () {
                                        bidProvider.generateBid(
                                            mobile: widget.job.mobileNumber,
                                            description: descriptionController.text,
                                            id: 0,
                                            email: authProvider.userDetailList[0].emailId,
                                            amount: bidAmtController.text,
                                            idOfPost: widget.job.userId,
                                            bidderUserName: widget.job.nameOfPerson,
                                            userName: authProvider.userDetailList[0].userName,
                                            type: 'Bid',
                                            loggedUserName: authProvider.userDetailList[0].userName);
                                        Navigator.of(context).pop();
                                      },
                                      buttonText: "Submit")
                                ]),
                              ),
                            ),
                          ));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/bid.png',
                          color: ColorResources.PRIMARY_COLOR,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Bid',
                          style: Style.bottomHeading
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: 1.5,
                    height: 30,
                    color: Colors.grey,
                  ),
                  InkWell(
                    onTap: () async {
                      openwhatsapp(context, widget.job.mobileNumber.toString(), 'please contact for more details');
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat,
                          color: ColorResources.PRIMARY_COLOR,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Chat',
                          style: Style.bottomHeading
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: 1.5,
                    height: 30,
                    color: Colors.grey,
                  ),
                  InkWell(
                    onTap: () async {
                      var shareData = {
                        "title": widget.job.nameOfPerson,
                        "text": widget.job.mobileNumber,
                        "url": widget.job.sharableLink,
                      };
                      try{
                        await html.window.navigator.share(shareData);
                      }catch(e){
                        print(e);
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.share,
                          color: ColorResources.PRIMARY_COLOR,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Share',
                          style: Style.bottomHeading
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            Divider(
              height: 1.5,
              thickness: 1.5,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Center(child: RatingStar()),
            ),
          ],
        ),
      ),
    );
  }
}
