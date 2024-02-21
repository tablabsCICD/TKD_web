import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:tkd_app/dialog/animated_custom_dialog.dart';
import 'package:tkd_app/dialog/my_dialog.dart';
import 'package:tkd_app/dialog/share_dialog_box.dart';
import 'package:tkd_app/locator.dart';
import 'package:tkd_app/model/truck_load_model.dart';
import 'package:tkd_app/provider/auth_provider.dart';
import 'package:tkd_app/provider/bid_provider.dart';
import 'package:tkd_app/view/base_widget/custom_button.dart';
import 'package:tkd_app/view/base_widget/custom_textfeild.dart';
import 'package:tkd_app/view/base_widget/custom_textview.dart';
import 'package:tkd_app/widgets/rating_dailog.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

class Utils {

  String getTranport(int val){
    switch(val){
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

  String mainTag(String tag){
    switch(tag){
      case 'Full load available':
        return 'Full load available';
      case 'Part load available':
        return 'Part load available';
      case 'Full load required':
        return 'Full vehicle required';
      case 'Part load required':
        return 'Part vehicle required';


      case '':

    }


    return "";
  }



  callFunction(String mobile)async{

    final call = Uri.parse('tel:+91$mobile');
    if (await canLaunchUrl(call)) {
      launchUrl(call);
    } else {
      throw 'Could not launch $call';
    }
  }

  callShareFunction(String des,TruckLoad load,context){
   // Share.share(des);
    showDialog(context: context,
        builder: (BuildContext context){
          return ShareDialogBox(
             load
          );
        }
    );
  }



  Future openwhatsapp(BuildContext context,int number,String text,) async{
    final link = WhatsAppUnilink(
      phoneNumber: "+91 ${number}",
      text: text,
    );
    await launch('$link');
  }

  final _formKey = GlobalKey<FormState>();
  final bidProvider = locator<BidProvider>();
  final authProvider = locator<AuthProvider>();
  TextEditingController bidAmtController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  openMenu(int a,TruckLoad load,BuildContext context)async{
    if(a==0){
      showAnimatedDialog(
          context,
          Dialog(
            shape:
            RoundedRectangleBorder(
                borderRadius:
                BorderRadius
                    .circular(
                    10)),
            child: Form(
              key: _formKey,
              child: Container(
                height: 250,
                width: 300,
                child: Stack(
                  children: [
                    Padding(
                      padding:
                      EdgeInsets.all(16),
                      child: Column(
                          children: [
                            CustomText(
                              'Place Your Quote',
                              style: TextStyle(
                                  fontSize:
                                  18,
                                  fontWeight:
                                  FontWeight
                                      .bold),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            CustomTextField(
                                controller:
                                bidAmtController,
                                hintText:
                                "Enter Your quote Amount",
                                isDigits:true,
                                textInputType:
                                TextInputType
                                    .number),
                            Visibility(
                              visible: false,
                              child: CustomTextField(
                                  controller:
                                  descriptionController,
                                  hintText:
                                  "Comments/Descriptions",
                                  textInputType:
                                  TextInputType
                                      .number),
                            ),
                            CustomButton(
                                onTap: () {
                                  if (_formKey.currentState!.validate()) {

                                    bidProvider
                                        .generateBid(
                                        mobile:
                                        authProvider.userDetailList[0].mobileNumber,
                                        description: "test",
                                        idOfPost:load.id,
                                        email: authProvider.userDetailList[0].emailId,
                                        amount: bidAmtController.text,
                                        id: 0,
                                        bidderUserName: authProvider.userDetailList[0].userName,
                                        userName: authProvider.userDetailList[0].userName,
                                        type: load.mainTag,
                                        loggedUserName: '${authProvider.userDetailList[0].firstName} ${authProvider.userDetailList[0].lastName}')
                                        .then((value) => {
                                      showAnimatedDialog(
                                          context,
                                          MyDialog(
                                            icon: Icons.check,
                                            title: 'Generate Quote',
                                            description: 'Your quote Created successfully',
                                            isFailed: false,
                                          ),
                                          dismissible: false,
                                          isFlip: false),
                                    });
                                    Navigator.of(
                                        context)
                                        .pop();
                                  }},
                                buttonText:
                                "Submit")
                          ]),
                    ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: IconButton(
                        icon: Icon(Icons.close,size: 18,),
                        onPressed: (){
                          Navigator.of(context).pop();
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          ));

    }else{
      String description= "${load
          .mobileNumber
          .toString()}'Type : ${load.type}, \nSubject : ${load.content}, \nSource : ${load.source}, \nDestination : ${load.destination}, \nLink : https://api.tkdost.com/bids/?id=${load.id}'";

      switch (a){
        case 1:
          Utils().openwhatsapp(context, load.mobileNumber!,description);
          return;
        case 2:
          await Utils().callFunction("${load.mobileNumber}");
          return;

        case 3:
          Utils().callShareFunction(description,load,context);
          return;

        case 4:
          Utils().callRatingAndReview(context,load);
          return;
      }
    }

  }

  callRatingAndReview(context,TruckLoad load){
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return FractionallySizedBox(
              heightFactor: 0.58, child: RatingDialog(load));
        });

  }


}