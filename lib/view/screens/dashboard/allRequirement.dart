import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';
import 'package:tkd_app/dialog/animated_custom_dialog.dart';
import 'package:tkd_app/locator.dart';
import 'package:tkd_app/model/truck_load_model.dart';
import 'package:tkd_app/multi_select.dart';
import 'package:tkd_app/open_whatsapp.dart';
import 'package:tkd_app/provider/auth_provider.dart';
import 'package:tkd_app/provider/bid_provider.dart';
import 'package:tkd_app/provider/dashboard_provider.dart';
import 'package:tkd_app/share_data.dart';
import 'package:tkd_app/util/ResponsiveWidget.dart';
import 'package:tkd_app/util/color-resource.dart';
import 'package:tkd_app/util/custom_text_style.dart';
import 'package:tkd_app/util/date_converter.dart';
import 'package:tkd_app/util/star_display.dart';
import 'package:tkd_app/util/style.dart';
import 'package:tkd_app/view/base_widget/custom_button.dart';
import 'package:tkd_app/view/base_widget/custom_textfeild.dart';
import 'package:tkd_app/view/base_widget/getImage.dart';
import 'package:tkd_app/view/localization/language_constrants.dart';
import 'package:tkd_app/view/screens/dashboard/create_requirement.dart';
import 'package:tkd_app/view/screens/dashboard/requirementDeatils.dart';

class Requirements extends StatefulWidget {

  @override
  _RequirementsState createState() => _RequirementsState();
}

class _RequirementsState extends State<Requirements> {
  final bidProvider = locator<BidProvider>();
  final authProvider = locator<AuthProvider>();
  TextEditingController bidAmtController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController sourceController = TextEditingController();
  TextEditingController destinationController = TextEditingController();
  TextEditingController filterController = TextEditingController();
  int counter = 0;
  var selectedPageNumber = 1;
  final dashboardProvider = locator<DashboardProvider>();
  ScrollController _scrollController = ScrollController();


  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if(_scrollController.position.pixels == _scrollController.position.maxScrollExtent){
        dashboardProvider.getFullLoadTruckList("All","All",currentPage: selectedPageNumber);
        selectedPageNumber++;

      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Consumer<DashboardProvider>(
      builder: (context, model, child) => Container(
          margin: EdgeInsets.symmetric(horizontal: 35,),
          child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 50,
                      margin: EdgeInsets.all(5),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            offset: Offset(0, 0),
                            blurRadius: 5,
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      width: ResponsiveWidget.isDesktop(context)
                          ? 295
                          : screenSize.width / 3.5,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: InkWell(
                          onTap: () {
                            _showMultiSelect(context);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                getText(selectedValues),
                                style: Style.filtterHeading,
                              ),
                              Icon(
                                Icons.arrow_drop_down_sharp,
                                size: 30,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            showAnimatedDialog(
                                context,
                                Dialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Container(
                                    height: 350,
                                    width: 300,
                                    child: Padding(
                                      padding: EdgeInsets.all(16),
                                      child: Column(children: [
                                        CustomTextField(
                                            controller: nameController,
                                            hintText: getTranslated(
                                                'enter_name', context)!,
                                            textInputType: TextInputType.number),
                                        CustomTextField(
                                            controller: sourceController,
                                            hintText:
                                            getTranslated('source', context)!,
                                            textInputType: TextInputType.number),
                                        CustomTextField(
                                            controller: destinationController,
                                            hintText: getTranslated(
                                                'destination', context)!,
                                            textInputType: TextInputType.number),
                                        CustomButton(
                                            onTap: () {
                                              model.getSearchByNameList(
                                                  nameController.text,
                                                  sourceController.text,
                                                  destinationController.text);
                                              Navigator.of(context).pop();
                                            },
                                            buttonText: getTranslated(
                                                'search_here', context)!)
                                      ]),
                                    ),
                                  ),
                                ));
                          },
                          child: Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(60),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Image.asset(
                                  'assets/images/filter.png',
                                  height: 22,
                                  width: 22,
                                ),
                              )),
                        ),
                        Container(
                          // height: 50,
                          margin: EdgeInsets.only(right: 10),
                          width: ResponsiveWidget.isDesktop(context)
                              ? 146
                              : screenSize.width / 4,
                          child: CustomButton(
                              onTap: () async{
                                String result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (builder) =>
                                            CreateRequirement('Full Load')));
                                print('in ${result} method');
                                if(result.contains('refresh')){
                                  print('out ${result} method');

                                  model.getFullLoadTruckList("All","All");
                                  setState(() {

                                  });
                                }

                              },
                              buttonText:
                              getTranslated('post_requirement', context)),
                        ),
                      ],
                    ),
                  ],
                ),
                model.truckLoadTypeList.isEmpty
                    ? Expanded(
                    child: Container(height:MediaQuery.of(context).size.height-200,child: Center(child: CircularProgressIndicator())))
                    : Expanded(
                  child: StaggeredGridView.countBuilder(
                      controller: _scrollController,
                      physics: ScrollPhysics(),
                      staggeredTileBuilder: (int index) =>
                          StaggeredTile.fit(1),
                      shrinkWrap: true,
                      crossAxisCount: ResponsiveWidget.isDesktop(context)
                          ? 3
                          : ResponsiveWidget.isMobile(context)
                          ? 1
                          : 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 12,
                      itemCount: model.truckLoadTypeList.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (builder) =>
                                          RequirementDetails(model
                                              .truckLoadTypeList[index])));
                            },
                            child: Card(
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15)),
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
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
                                              color: model
                                                  .truckLoadTypeList[
                                              index]
                                                  .mainTag ==
                                                  "Full load required"
                                                  ? ColorResources
                                                  .FULL_LOAD_REQUIRED
                                                  : model
                                                  .truckLoadTypeList[
                                              index]
                                                  .mainTag ==
                                                  "Part load required"
                                                  ? ColorResources
                                                  .PART_LOAD_REQUIRED
                                                  : model
                                                  .truckLoadTypeList[
                                              index]
                                                  .mainTag ==
                                                  "Full load available"
                                                  ? ColorResources
                                                  .FULL_LOAD_AVAILABLE
                                                  : ColorResources
                                                  .PART_LOAD_AVAILABLE,
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(15),
                                                  bottomRight:
                                                  Radius.circular(15))),
                                          child: Text(
                                              model.truckLoadTypeList[index]
                                                  .mainTag
                                                  .toString(),
                                              style: Style.loadHeading),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 8.0),
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                height: 5,
                                              ),
                                              ConvertStringToDate(model
                                                  .truckLoadTypeList[index]
                                                  .postingTime
                                                  .toString()),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              StarDisplay(
                                                  value: model
                                                      .truckLoadTypeList[
                                                  index]
                                                      .ratings!
                                                      .toInt()),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    ListTile(
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 0, horizontal: 5),
                                      horizontalTitleGap: 5,
                                      minVerticalPadding: 0,
                                      leading: Stack(
                                        children: [
                                          getImage(model.truckLoadTypeList[index].companyLogo.toString()),
                                          Positioned(
                                            bottom: 0,
                                            right: 0,
                                            child: Image.asset(
                                              model.truckLoadTypeList[index]
                                                  .isPaid ==
                                                  30
                                                  ? 'assets/images/diamond.png'
                                                  : model
                                                  .truckLoadTypeList[
                                              index]
                                                  .isPaid ==
                                                  20
                                                  ? 'assets/images/gold_badge.png' :
                                              model.truckLoadTypeList[index]
                                                  .isPaid ==
                                                  0
                                                  ? 'assets/images/silver.png'
                                                  : 'assets/images/ruby_badge.png',
                                              width: 20,
                                              height: 20,
                                            ),
                                          )
                                        ],
                                      ),
                                      title: Row(
                                        children: [
                                          Text(
                                              model.truckLoadTypeList[index]
                                                  .nameOfPerson
                                                  .toString(),
                                              style: Style.title),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          model.truckLoadTypeList[index]
                                              .isVerifiedByCompany ==
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
                                          model.truckLoadTypeList[index]
                                              .companyName
                                              .toString(),
                                          style: Style.subtitle),
                                    ),
                                    Container(
                                      alignment: Alignment.center,
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 45),
                                      height: 30,
                                      decoration: new BoxDecoration(
                                          color: Color(0xffcacdd0),
                                          borderRadius:
                                          BorderRadius.circular(5)),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            model.truckLoadTypeList[index]
                                                .source
                                                .toString(),
                                            style: Style.cityHeading,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                              "to",
                                              style: Style.content
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            model.truckLoadTypeList[index]
                                                .destination
                                                .toString(),
                                            style: Style.cityHeading,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0, vertical: 7),
                                      child: Text(
                                          model.truckLoadTypeList[index]
                                              .topicName
                                              .toString(),
                                          style: Style.title),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10.0, bottom: 10, right: 10),
                                      child: Text(
                                        model.truckLoadTypeList[index].content
                                            .toString(),
                                        style: Style.content,
                                      ),
                                    ),
                                    Divider(
                                      height: 1.5,
                                      thickness: 1.5,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              showAnimatedDialog(
                                                  context,
                                                  Dialog(
                                                    shape:
                                                    RoundedRectangleBorder(
                                                        borderRadius:
                                                        BorderRadius
                                                            .circular(
                                                            10)),
                                                    child: Container(
                                                      height: 300,
                                                      width: 300,
                                                      child: Padding(
                                                        padding:
                                                        EdgeInsets.all(
                                                            16),
                                                        child: Column(
                                                            children: [
                                                              Text(
                                                                'Place Your Bid',
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
                                                                  "Enter Your Bid Amount",
                                                                  textInputType:
                                                                  TextInputType
                                                                      .number),
                                                              CustomTextField(
                                                                  controller:
                                                                  descriptionController,
                                                                  hintText:
                                                                  "Comments/Descriptions",
                                                                  textInputType:
                                                                  TextInputType
                                                                      .number),
                                                              CustomButton(
                                                                  onTap: () {
                                                                    bidProvider.generateBid(
                                                                        mobile: model
                                                                            .truckLoadTypeList[
                                                                        index]
                                                                            .mobileNumber,
                                                                        description: descriptionController
                                                                            .text,
                                                                        id: model
                                                                            .truckLoadTypeList[
                                                                        index]
                                                                            .userId,
                                                                        email: authProvider
                                                                            .userDetailList[
                                                                        0]
                                                                            .emailId,
                                                                        amount: bidAmtController
                                                                            .text,
                                                                        idOfPost:
                                                                        0,
                                                                        bidderUserName: model
                                                                            .truckLoadTypeList[
                                                                        index]
                                                                            .nameOfPerson,
                                                                        userName: authProvider
                                                                            .userDetailList[
                                                                        0]
                                                                            .userName,
                                                                        type:
                                                                        'Bid',
                                                                        loggedUserName: authProvider
                                                                            .userDetailList[0]
                                                                            .userName);
                                                                    Navigator.of(
                                                                        context)
                                                                        .pop();
                                                                  },
                                                                  buttonText:
                                                                  "Submit")
                                                            ]),
                                                      ),
                                                    ),
                                                  ));
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.bakery_dining,
                                                  color: Colors.grey,
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  'Bid',
                                                  style: Style.bottomHeading,
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
                                              openwhatsapp(
                                                  context,
                                                  model
                                                      .truckLoadTypeList[
                                                  index]
                                                      .mobileNumber
                                                      .toString(),
                                                  'please contact for more details');
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.chat,
                                                  color: Colors.grey,
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  'Chat',
                                                  style: Style.bottomHeading,
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
                                              //share_data(widget.loadTypeList[index]);
                                              Share.share(
                                                  model
                                                      .truckLoadTypeList[
                                                  index]
                                                      .sharableLink
                                                      .toString(),
                                                  subject: model
                                                      .truckLoadTypeList[
                                                  index]
                                                      .nameOfPerson
                                                      .toString());
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.share,
                                                  color: Colors.grey,
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  'Share',
                                                  style: Style.bottomHeading,
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ));
                      }),
                ),
                /*NumberPagination(
              onPageChanged: (int pageNumber) {
                setState(() {
                  selectedPageNumber = pageNumber;
                });
                model.getFullLoadTruckList(currentPage: selectedPageNumber);
              },
              pageTotal: model.totalPages - 1,
              pageInit: selectedPageNumber,
              // picked number when init page
              colorPrimary: Colors.black,
              colorSub: Colors.white,
            ),*/
              ])),
    );
  }

  Set<int>? selectedValues = [1, 2, 3, 4, 5].toSet();

  void _showMultiSelect(BuildContext context) async {
    final items = <MultiSelectDialogItem<int>>[
      MultiSelectDialogItem(1, 'All Requirements'),
      MultiSelectDialogItem(2, 'Required - Full load vehicle'),
      MultiSelectDialogItem(3, 'Required - Part load vehicle'),
      MultiSelectDialogItem(4, 'Available - Full load vehicle'),
      MultiSelectDialogItem(5, 'Available - Part load vehicle'),
    ];

    selectedValues = await showDialog<Set<int>>(
      context: context,
      builder: (BuildContext context) {
        return MultiSelectDialog(
          items: items,
          initialSelectedValues: selectedValues,
        );
      },
    );
    print(selectedValues!.length);
    print(selectedValues);
  }

  String getText(Set<int>? selectedValues) {
    int count = selectedValues!.length;
    String message = getTranslated('all_requirements', context)!;
    if (count == 5)
      return message;
    else
      return '${count} ' + getTranslated('requirements_selected', context)!;
  }
}
