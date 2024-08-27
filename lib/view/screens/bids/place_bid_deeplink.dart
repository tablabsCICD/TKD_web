import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tkd_app/entry_screen.dart';
import 'package:tkd_app/locator.dart';
import 'package:tkd_app/model/api_response.dart';
import 'package:tkd_app/model/bid_state_response.dart';
import 'package:tkd_app/model/deep_link_load.dart';
import 'package:tkd_app/model/post_upload.dart';
import 'package:tkd_app/model/request/bid_place.dart';
import 'package:tkd_app/model/shared_post_model.dart';
import 'package:tkd_app/network/api_call.dart';
import 'package:tkd_app/provider/auth_provider.dart';
import 'package:tkd_app/util/app_constants.dart';
import 'package:tkd_app/util/colors.dart';
import 'package:tkd_app/util/images.dart';
import 'package:tkd_app/view/base_widget/app_constant.dart';
import 'package:tkd_app/view/base_widget/custom_button.dart';
import 'package:tkd_app/view/base_widget/custom_textfeild.dart';
import 'package:tkd_app/view/base_widget/home_base_widgets.dart';
import 'package:tkd_app/view/screens/dashboard/dashboard.dart';
import 'package:tkd_app/view/screens/plan/select_plan_screen.dart';
import 'package:tkd_app/widgets/toast.dart';

class PlaceDeepBidScreen extends StatefulWidget{
  final TruckLoadDeepLink truckLoad;

  const PlaceDeepBidScreen({required this.truckLoad});
  @override
  State<StatefulWidget> createState() {
    return _PlaceDeepBidScreen();
  }

}

class _PlaceDeepBidScreen extends State<PlaceDeepBidScreen> {

  TextEditingController controller=TextEditingController();
  bool buttonEnable=false;
  String bidState="";
  String avgBid="";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    callAvrageBid();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: ListView(
            controller: null,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 36.h,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Quote Now",
                      style:TextStyle(
                        color: Colors.black,
                        fontSize: 20.sp,
                        fontFamily:AppConstant.FONTFAMILY,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    InkWell(onTap:(){Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder)=>DashBoardScreen()));},child: SvgPicture.asset(Images.close_circle))
                  ],
                ),
              ),
              SizedBox(height: 50.h,),
              Text(
                "Vehicale Size ${widget.truckLoad.vehicleSize!} Cargo Type ${widget.truckLoad.typeOfCargo!}",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.sp,
                  fontFamily: AppConstant.FONTFAMILY,
                  fontWeight: FontWeight.w600,
                  height: 0,
                ),
              ),
              SizedBox(height: 8.h,),
              BaseWidget().routes(widget.truckLoad.source!,widget.truckLoad.destination!),
              SizedBox(height: 8.h,),
              Text(
                widget.truckLoad.otherDetails!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0x99001E49),
                  fontSize: 14.sp,
                  fontFamily: AppConstant.FONTFAMILY,
                  fontWeight: FontWeight.w400,
                  height: 0,
                ),
              ),
              SizedBox(height: 10.h,),
              avgBid=="0"?const SizedBox.shrink():Text(
                "Average Bid is $avgBid",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14.sp,
                  fontFamily: AppConstant.FONTFAMILY,
                  fontWeight: FontWeight.w400,
                  height: 0,
                ),
              ),
              SizedBox(height: 36.h,),
              Text(
                "Enter Amount",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12.sp,
                  fontFamily: AppConstant.FONTFAMILY,
                  fontWeight: FontWeight.w400,
                  height: 0,
                ),

              ),
              SizedBox(height: 8.h,),
              SizedBox(height:49.w,child: CustomTextField(
                hintText: "\u{20B9}", controller: controller,
                textInputType: TextInputType.number,
                onValueChange: (val){
                  if(val==0){
                    buttonEnable=false;
                  }else{
                    buttonEnable=true;
                    callApiBidState();
                  }

                  callSetState();


                },)),
              const SizedBox(height: 8,),
              Text(
                bidState,
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 14.sp,
                  fontFamily: AppConstant.FONTFAMILY,
                  fontWeight: FontWeight.w400,
                  height: 0,
                ),

              ),

            ],
          ),
        ),

      ),
      bottomNavigationBar: Padding(padding: const EdgeInsets.all(20),child: CustomButton(buttonText: "Submit", onTap: (){

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Quote',style: TextStyle(
                color: Colors.black,
                fontSize: 16.sp,
                fontFamily: GoogleFonts.poppins().fontFamily,
                fontWeight: FontWeight.w600,
              ),),
              content: Text('Are you sure you want to quote this post?',style: TextStyle(
                color: Colors.black,
                fontSize: 12.sp,
                fontFamily: GoogleFonts.poppins().fontFamily,
                fontWeight: FontWeight.w400,
              ),),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Text('No',style: TextStyle(color: ThemeColor.theme_blue, fontSize: 12.sp,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    fontWeight: FontWeight.w600,),),
                ),
                TextButton(
                  onPressed: () {
                    callYes();
                  },
                  child: Text(
                    'Yes',
                    style: TextStyle(color: Colors.green, fontSize: 12.sp,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      fontWeight: FontWeight.w600,),
                  ),
                ),
              ],
            );
          },
        );
        //  callApi(controller.text.toString());

      },),),
    );
  }

  final authProvider = locator<AuthProvider>();
  callApi(String amount)async{
    BidPlace bidPlace=BidPlace();
    bidPlace.amount=amount;
    bidPlace.idOfPost=widget.truckLoad.id;
    bidPlace.id=0;
    bidPlace.mobileNumber=authProvider.userList.first.mobileNumber;
    bidPlace.userName=authProvider.userList.first.userName;
    bidPlace.bidderUserName=authProvider.userList.first.userName;
    bidPlace.emailId=authProvider.userList.first.emailId;
    bidPlace.description="No ANY";
    bidPlace.loggedUserName=authProvider.userList.first.userName;
    bidPlace.type=widget.truckLoad.type;

    ApiResponse apiResponse=await ApiHelper().ApiAddPostDataMapRequestCall(ApiConstant.PLACED_BID, bidPlace.toJson());
    if(apiResponse.status==200){
        PostUpload postUpload=PostUpload.fromJson(apiResponse.response);
      if(postUpload.statusCode==401){
        ToastMessage.show(context, "Please update your package");
        Navigator.push(context, MaterialPageRoute(builder: (builder)=>SelectPlanScreen()));
      }else{
        ToastMessage.show(context, "Quote submitted successfully");
       Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder)=>EntryScreen()));
      }

    }else{
      ToastMessage.show(context, "Please try again");
    }
  }

  callSetState(){
    setState(() {

    });
  }

  callApiBidState()async{
    ApiResponse apiResponse=await ApiHelper().apiWithoutDecodeGet(ApiConstant.GET_BID_STATE(widget.truckLoad.id,controller.text.toString()));
    if(apiResponse.status==200){
      BidState bidStateObj=BidState.fromJson(jsonDecode(apiResponse.response));
      if(bidStateObj.data=="0"){

      }else{
        bidState="Your Bid Range is in ${bidStateObj.data} position";
      }
      setState(() {
      });
    }else{
    }

  }

  void callYes() {
    Navigator.pop(context);
    callApi(controller.text.toString());

  }

  callAvrageBid() async{
    ApiResponse apiResponse=await ApiHelper().apiWithoutDecodeGet(ApiConstant.AVG_BID(widget.truckLoad.id));
    print('apires${apiResponse.response}');
    if(apiResponse.status==200){
      BidState bidStateObj=BidState.fromJson(jsonDecode(apiResponse.response));
      if(bidStateObj.data=="0"){
        avgBid = "0";
      }else{
        avgBid = bidStateObj.data.toString();
      }
      setState(() {
      });
    }else{
    }
  }




}