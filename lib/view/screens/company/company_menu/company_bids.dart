import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';
import 'package:tkd_app/dialog/animated_custom_dialog.dart';
import 'package:tkd_app/dialog/my_dialog.dart';
import 'package:tkd_app/locator.dart';
import 'package:tkd_app/model/organization_model.dart';
import 'package:tkd_app/provider/org_provider.dart';
import 'package:tkd_app/util/ResponsiveWidget.dart';
import 'package:tkd_app/util/color-resource.dart';
import 'package:tkd_app/util/custom_text_style.dart';
import 'package:tkd_app/util/star_display.dart';
import 'package:tkd_app/util/style.dart';
import 'package:tkd_app/view/base_widget/custom_textview.dart';
import 'package:tkd_app/view/base_widget/getImage.dart';
import 'package:tkd_app/view/base_widget/getLoader.dart';
import 'package:tkd_app/view/localization/language_constrants.dart';

class CompanyBidsScreen extends StatefulWidget {
  final bidProvider = locator<OrgProvider>();


  Organization organization;
  CompanyBidsScreen(this.organization,{Key? key}) : super(key: key) {
    bidProvider.getOrgBidingList(organization.id!);
  }

  @override
  _CompanyBidsScreenState createState() => _CompanyBidsScreenState();
}

class _CompanyBidsScreenState extends State<CompanyBidsScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: ColorResources.HOME_BG,
        child: ResponsiveWidget(
          desktop: WebScreenForBid(),
          mobile: WebScreenForBid(),
          tablet: WebScreenForBid(),
        ),
      ),
    );
  }
}

class WebScreenForBid extends StatefulWidget {
  @override
  _WebScreenForBidState createState() => _WebScreenForBidState();
}

class _WebScreenForBidState extends State<WebScreenForBid> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Consumer<OrgProvider>(
        builder: (context, model, child) => Container(
          margin: const EdgeInsets.symmetric(
              horizontal: 35,vertical: 10
          ),
          child: model.orgBigingList.isEmpty && model.isLoading == false
              ? Expanded(
              child: Container(
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height - 200,
                  child: Center(child: Text(getTranslated('no_post', context)!,style: Style.heading,))))
              :Column(
            children: [
              Expanded(
                child: StaggeredGridView.countBuilder(
                  crossAxisCount: ResponsiveWidget.isDesktop(context)
                      ? 3
                      : ResponsiveWidget.isMobile(context)
                      ? 1
                      : 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 12,
                  itemCount: model.orgBigingList.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        // Navigator.push(context, MaterialPageRoute(builder: (builder)=> RequirementDetails(widget.loadTypeList[index])));
                      },
                      child: Card(
                        elevation: 5,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 140,
                                    height: 20,
                                    alignment: Alignment.center,
                                    decoration: new BoxDecoration(
                                        color: model.orgBigingList[index].mainTag ==
                                            "Full load required"
                                            ? ColorResources
                                            .FULL_LOAD_REQUIRED
                                            : model.orgBigingList[index].mainTag ==
                                            "Part load required"
                                            ? ColorResources
                                            .PART_LOAD_REQUIRED
                                            : model.orgBigingList[index].mainTag ==
                                            "Full load available"
                                            ? ColorResources
                                            .FULL_LOAD_AVAILABLE
                                            : ColorResources
                                            .PART_LOAD_AVAILABLE,
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(5),
                                            bottomRight:
                                            Radius.circular(10))),
                                    child: CustomText(model.orgBigingList[index].mainTag.toString(),
                                        style: TextStyle(fontSize: 12,fontFamily: 'RobotoMedium',color: model
                                            .orgBigingList[
                                        index]
                                            .mainTag ==
                                            "Full load required"
                                            ? ColorResources
                                            .FLR_TEXT
                                            : model
                                            .orgBigingList[
                                        index]
                                            .mainTag ==
                                            "Part load required"
                                            ? ColorResources
                                            .PLR_TEXT
                                            : model
                                            .orgBigingList[
                                        index]
                                            .mainTag ==
                                            "Full load available"
                                            ? ColorResources
                                            .FLA_TEXT
                                            : ColorResources
                                            .PLA_TEXT)),
                                  ),
                                  /*Padding(
                                              padding:
                                                  const EdgeInsets.only(right: 8.0),
                                              child: ConvertStringToDate(
                                                  model.truckLoadTypeList[index].postingTime.toString()),
                                            ),*/
                                ],
                              ),
                              ListTile(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 5),
                                horizontalTitleGap: 5,
                                minVerticalPadding: 0,
                                leading: getImage(''),
                                // model.truckLoadTypeList[index].companyLogo.toString()),
                                title: CustomText(model.orgBigingList[index].nameOfPerson.toString() == ''?
                                model.orgBigingList[index].type.toString():model.orgBigingList[index].nameOfPerson.toString(),
                                    style: titleTextStyle),
                                subtitle: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    CustomText(model.orgBigingList[index].mobileNumber.toString(),
                                        style: subTitleTextStyle),
                                    StarDisplay(
                                        value:
                                        double.parse(model.orgBigingList[index].ratings!.toString())),
                                  ],
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.symmetric(
                                    horizontal: 45, vertical: 10),
                                height: 30,
                                decoration: new BoxDecoration(
                                    color: Color(0xfff0f0f0),
                                    borderRadius:
                                    BorderRadius.circular(5)),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  children: [
                                    CustomText(
                                      model.orgBigingList[index].source.toString(),
                                      style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 14,
                                          fontFamily: 'RobotoSlab',
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    // CustomText("to", style: Style.content),
                                    Image.asset(
                                      'assets/images/right-arrow.png',
                                      height: 15,
                                      width: 25,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    CustomText(
                                      model.orgBigingList[index].destination.toString(),
                                      style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 14,
                                          fontFamily: 'RobotoSlab',
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 7),
                                child: CustomText(
                                    model.orgBigingList[index].topicName.toString(),
                                    style: titilliumSemiBold),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 7),
                                child: Row(
                                  children: [
                                    CustomText('Your Bid : ',
                                        style: TextStyle(
                                            color: ColorResources
                                                .PRIMARY_COLOR,
                                            fontWeight: FontWeight.bold)),
                                    CustomText(
                                        model.orgBigingList[index].amount
                                            .toString(),
                                        style: TextStyle(
                                            color: ColorResources
                                                .PRIMARY_COLOR,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0, bottom: 10, right: 10),
                                child: CustomText(
                                  model.orgBigingList[index].description
                                      .toString(),
                                  style: regularTextStyle,
                                ),
                              ),
                              Divider(
                                height: 1.5,
                                thickness: 1.5,
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 10),
                                alignment: Alignment.center,
                                child: ElevatedButton(
                                  onPressed: (){
                                    showDialog(
                                        context: context,
                                        builder: (_) =>
                                        new CupertinoAlertDialog(
                                          title: CustomText(
                                              'Are you sure want to deleted your job?'),
                                          actions: <Widget>[
                                            TextButton(
                                              child: Text(
                                                  getTranslated(
                                                      'yes',
                                                      context)!,
                                                  style: TextStyle(
                                                      color:
                                                      ColorResources
                                                          .RED)),
                                              onPressed: () {
                                                model
                                                    .deleteBid(model
                                                    .orgBigingList[
                                                index])
                                                    .then(
                                                        (value) => {
                                                      showAnimatedDialog(
                                                          context,
                                                          MyDialog(
                                                            icon: Icons.check,
                                                            title: 'Bid Delete',
                                                            description: 'Your bid deleted successfully',
                                                            isFailed: false,
                                                          ),
                                                          dismissible: false,
                                                          isFlip: false)
                                                    });
                                                Navigator.of(
                                                    context)
                                                    .pop();
                                              },
                                            ),
                                            TextButton(
                                              child: Text(
                                                getTranslated(
                                                    'no', context)!,
                                                style: TextStyle(
                                                    color:
                                                    ColorResources
                                                        .GREEN),
                                              ),
                                              onPressed: () {
                                                Navigator.of(
                                                    context)
                                                    .pop();
                                              },
                                            ),
                                          ],
                                        ));
                                  },
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white, backgroundColor: Colors.red[200],
                                    elevation: 3,
                                  ),
                                  child: Text(getTranslated('delete', context)!,style: Style.button,),
                                ),
                              ),
                              /*Center(
                                          child: CustomButton(
                                              onTap: () {
                                                showDialog(
                                                    context: context,
                                                    builder: (_) =>
                                                        new CupertinoAlertDialog(
                                                          title: Text(
                                                              'Are you sure want to deleted your job?'),
                                                          actions: <Widget>[
                                                            TextButton(
                                                              child: Text(
                                                                  getTranslated(
                                                                      'yes',
                                                                      context)!,
                                                                  style: TextStyle(
                                                                      color:
                                                                          ColorResources
                                                                              .RED)),
                                                              onPressed: () {
                                                                model
                                                                    .deleteBid(model
                                                                            .allBidingList[
                                                                        index])
                                                                    .then(
                                                                        (value) => {
                                                                              showAnimatedDialog(
                                                                                  context,
                                                                                  MyDialog(
                                                                                    icon: Icons.check,
                                                                                    title: 'Bid Delete',
                                                                                    description: 'Your bid deleted successfully',
                                                                                    isFailed: false,
                                                                                  ),
                                                                                  dismissible: false,
                                                                                  isFlip: false)
                                                                            });
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                            ),
                                                            TextButton(
                                                              child: Text(
                                                                getTranslated(
                                                                    'no', context)!,
                                                                style: TextStyle(
                                                                    color:
                                                                        ColorResources
                                                                            .GREEN),
                                                              ),
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                            ),
                                                          ],
                                                        ));
                                              },
                                              buttonText: getTranslated(
                                                  'delete', context)!),
                                        )*/
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  physics: ScrollPhysics(),
                  shrinkWrap: true,
                  staggeredTileBuilder: (int index) =>
                      StaggeredTile.fit(1),
                ),
              ),
              getLoader(model.isLoading)
            ],
          ),
        )
    );
  }
}
