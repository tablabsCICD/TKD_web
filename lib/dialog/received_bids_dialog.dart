import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:tkd_app/constant.dart';
import 'package:tkd_app/locator.dart';
import 'package:tkd_app/model/truck_load_model.dart';
import 'package:tkd_app/provider/bid_provider.dart';
import 'package:tkd_app/util/ResponsiveWidget.dart';
import 'package:tkd_app/util/color-resource.dart';
import 'package:tkd_app/util/style.dart';
import 'package:tkd_app/view/base_widget/custom_textview.dart';

class ReceivedBidsDialogBox extends StatefulWidget {
  TruckLoad truckLoad;
  final bidProvider = locator<BidProvider>();

  ReceivedBidsDialogBox(this.truckLoad,{Key? key}) : super(key: key) {
    bidProvider.getReceivedBidingList(truckLoad.mainTag!, truckLoad.id!);
  }

  @override
  _ReceivedBidsDialogBoxState createState() => _ReceivedBidsDialogBoxState();
}

class _ReceivedBidsDialogBoxState extends State<ReceivedBidsDialogBox> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constants.padding),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
          padding: ResponsiveWidget.isMobile(context)
              ?EdgeInsets.all(10)
              :EdgeInsets.all(20
          ),
          margin: ResponsiveWidget.isDesktop(context)
              ?EdgeInsets.only(top: Constants.avatarRadius,left: 250,right: 250)
              :EdgeInsets.only(top: Constants.avatarRadius,left: 10,right: 10),
          width: ResponsiveWidget.isMobile(context)?MediaQuery.of(context).size.width-50:ResponsiveWidget.isDesktop(context)?500:400,
          height: 320,
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(color: Colors.black,offset: Offset(0,10),
                    blurRadius: 10
                ),
              ]
          ),
          child:Stack(
            children: [
              Consumer<BidProvider>(
                builder: (context, model, child) => SizedBox(
                  height: 250,
                  child: model.receivedBidingList.length>0?Container(
                    child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: model.receivedBidingList.length,
                    itemBuilder: (context,index){
                      return Card(
                        elevation: 3,
                        color: Colors.grey[100],
                        child: Container(
                          padding: EdgeInsets.all(9),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("${model.receivedBidingList[index].firstName.toString()} ${model.receivedBidingList[index].lastName.toString()}",style: Style.selectedMenuHeading,),
                                Text(model.receivedBidingList[index].bidings!.mobileNumber.toString(),style: Style.selectedMenuHeading,),
                                Row(
                                  children: [
                                    CustomText('Bid Amount Is : ',
                                        style: TextStyle(
                                            color: ColorResources
                                                .PRIMARY_COLOR,
                                            fontWeight: FontWeight.bold)),
                                    CustomText(
                                        model.receivedBidingList[index].bidings!.amount
                                            .toString(),
                                        style: TextStyle(
                                            color: ColorResources
                                                .PRIMARY_COLOR,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                Text(model.receivedBidingList[index].bidings!.description.toString(),style: Style.selectedMenuHeading,),
                              ]
                          ),

                        ),
                      );
                    },
                  )

                  ):Center(child: Text("No Bids!")),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Colors.black,
                    elevation: 3,
                    side: BorderSide(color: ColorResources.THEME_COLOR, width: 2),
                  ),
                  child: Icon(Icons.close,size: 18,color: Colors.white,),
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                ),
              )

    ],
          )
      )
    );
  }

}
