import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tkd_app/dialog/CustomCityListDialog.dart';
import 'package:tkd_app/locator.dart';
import 'package:tkd_app/model/truck_load_model.dart';
import 'package:tkd_app/provider/auth_provider.dart';
import 'package:tkd_app/provider/edit_post_provider.dart';
import 'package:tkd_app/util/color-resource.dart';
import 'package:tkd_app/util/colors.dart';
import 'package:tkd_app/util/style.dart';
import 'package:tkd_app/view/base_widget/app_constant.dart';
import 'package:tkd_app/view/base_widget/custom_button.dart';
import 'package:tkd_app/view/base_widget/custom_dropdown_list.dart';
import 'package:tkd_app/view/base_widget/custom_textfeild.dart';
import 'package:tkd_app/view/base_widget/cutom_city_textfield.dart';
import 'package:tkd_app/view/base_widget/home_base_widgets.dart';

class EditPostLoadScreen extends StatefulWidget {
  TruckLoad postBidData;
  final editProvider = locator<EditPostLoadProvider>();

  EditPostLoadScreen(this.postBidData, {Key? key}) : super(key: key) {
    editProvider.initData(postBidData);
  }

  @override
  State<StatefulWidget> createState() {
    return _EditPostLoadScreen();
  }
}

class _EditPostLoadScreen extends State<EditPostLoadScreen> {
  final authProvider = locator<AuthProvider>();
  final editProvider = locator<EditPostLoadProvider>();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    //setData();
    editProvider.getAllUserList();
    super.initState();
  }

  Future<void> getAddedUserList(EditPostLoadProvider provider) async {
    await provider.getUserListFromString(widget.postBidData.userList!);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Do something here
        print("After clicking the Android Back Button");
        Navigator.pop(context, 1);
        return false;
      },
      child: Scaffold(
        backgroundColor: ThemeColor.baground,

        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            "Edit Post load/vehicle requirement",
            style: Style.appheading,
          ),
          shadowColor: Colors.white,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context, 1);
            },
          ),
        ),
        body: Container(
          child: Form(
              key: _formKey,
              child: Consumer<EditPostLoadProvider>(
                  builder: (context, model, child) {
                getAddedUserList(model);
                return Container(
                  // margin: ResponsiveWidget.isDesktop(context)? EdgeInsets.symmetric(horizontal: 50,vertical: 10):EdgeInsets.symmetric(horizontal: 0,vertical: 0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            alignment: Alignment.center,
                            child: Text(
                              'Requirement you post will be visible on the general board to vendors whose routes match to yours.',
                              style: Style.appsubtitle,
                            )),
                        CustomDropdownList(
                          hintText: model.selectedRequriment,//"Select Requirement",
                          items: model.requirementList,
                          selectedType: model.selectedRequriment,
                          onChange: (String value) {
                            // setState(() {
                            //   selectedRequirementType = value;
                            // });
                            model.selectedRequriment = value;
                          },
                        ),
                        CustomDropdownList(
                          hintText: model.selectedPostType,//"Select Post Type",
                          items: model.postTypeList,
                          selectedType: model.selectedPostType,
                          onChange: (String value) {
                            setState(() {
                              model.selectedPostType = value;
                            });
                          },
                        ),
                        CustomCityTextField(
                          hintText: 'Select City From',
                          controller: model.sourceCity,
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return CustomCityListDialog(
                                      onTap: (String value) {
                                    setState(() {
                                      model.sourceCity = value;
                                    });
                                  });
                                });
                          },
                        ),
                        CustomCityTextField(
                          hintText: 'Select City To',
                          controller: model.destinationCity,
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return CustomCityListDialog(
                                      onTap: (String value) {
                                    setState(() {
                                      model.destinationCity = value;
                                    });
                                  });
                                });
                          },
                        ),
                        CustomDropdownList(
                          hintText: model.selectedCargo,//"Select Cargo Type",
                          items: model.cargoList,
                          selectedType: model.selectedCargo,
                          onChange: (String value) {
                            setState(() {
                              model.selectedCargo = value;
                            });
                          },
                        ),
                        CustomTextField(
                          hintText: 'Vehicle Size',
                          controller: model.vehicleSizeController,
                          textInputType: TextInputType.text,
                        ),
                        CustomTextField(
                            hintText: 'Load Weight (In Tons)',
                            controller: model.loadWeightController,
                            textInputType: TextInputType.text,
                            onValueChange: () {
                              setState(() {});
                            }),
                        CustomTextField(
                            hintText: 'Special Instruction',
                            controller: model.specialInstructionController,
                            textInputType: TextInputType.text,
                            onValueChange: () {
                              setState(() {});
                            }),
                        CustomTextField(
                          hintText: 'Mobile',
                          controller: TextEditingController(
                              text: authProvider.userDetailList[0].mobileNumber
                                  .toString()),
                          textInputType: TextInputType.phone,
                          readOnly: true,
                        ),
                        CustomTextField(
                          hintText: 'Email',
                          controller: TextEditingController(
                              text:
                                  authProvider.userDetailList[0].emailId ?? ''),
                          textInputType: TextInputType.emailAddress,
                          readOnly: true,
                          onValueChange: () {
                            setState(() {});
                          },
                        ),
                        CustomDropdownList(
                          hintText: model.selectedPayment,//"Select Type Of Payment",
                          items: model.paymentList,
                          selectedType: model.selectedPayment,
                          onChange: (String value) {
                            setState(() {
                              model.selectedPayment = value;
                            });
                          },
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          height: 25,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Hide My Identity', style: Style.heading1),
                              FlutterSwitch(
                                showOnOff: true,
                                valueFontSize: 12,
                                activeColor: ColorResources.PRIMARY_COLOR,
                                activeTextColor: Colors.black,
                                inactiveTextColor: Colors.red,
                                value: model.identitySwitch,
                                onToggle: (val) {
                                  setState(() {
                                    model.identitySwitch = val;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          height: 25,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Do Not Disturb', style: Style.heading1),
                              FlutterSwitch(
                                showOnOff: true,
                                valueFontSize: 12,
                                activeColor: ColorResources.PRIMARY_COLOR,
                                activeTextColor: Colors.black,
                                inactiveTextColor: Colors.red,
                                value: model.disturbSwitch,
                                onToggle: (val) {
                                  setState(() {
                                    model.disturbSwitch = val;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        Text("Show Post To:",style: TextStyle(fontFamily: GoogleFonts.poppins().fontFamily,fontSize: 16),),

                        editProvider.addedUserListIdInPost.length == 0
                            ? Text("All Users")
                            : Visibility(
                                visible: true,
                                child: Container(
                                  color: Colors.grey.shade50,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Container(
                                          child: selectedUsers(),
                                          height: 60,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                        CustomButton(
                            onTap: () async {
                              if (_formKey.currentState!.validate()) {
                                 await model.editPost(
                                    context, widget.postBidData.id
                                    );
                              }
                            },
                            buttonText: "Edit Post")
                      ],
                    ),
                  ),
                );
              })),
        ),
      ),
    );
  }

  ScrollController horizantalControllet = ScrollController();

  selectedUsers() {
    return Consumer<EditPostLoadProvider>(
      builder: (context, model, child) => ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          controller: horizantalControllet,
          itemCount: model.addedUsers.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              height: 50,
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Column(
                  children: <Widget>[
                    BaseWidget().getImageclip(
                      model.addedUsers[index].profilePicture.toString(),
                      height: 34,
                      width: 34,
                    ),
                    Text(
                      model.addedUsers[index].firstName!,
                      style: TextStyle(
                        color: Color(0xCC001E49),
                        fontSize: 14,
                        fontFamily: AppConstant.FONTFAMILY,
                        fontWeight: FontWeight.w400,
                      ),
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }
}

class RadioModel {
  bool isSelected;
  final String text;

  RadioModel(this.isSelected, this.text);
}

class RadioItem extends StatelessWidget {
  final RadioModel _item;

  RadioItem(this._item);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15, horizontal: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width - 165,
            margin: EdgeInsets.only(left: 5.0),
            child: Text(
              _item.text,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
              maxLines: 2,
            ),
          ),
          Container(
            height: 20.0,
            width: 20.0,
            child: Center(
              child: Icon(
                Icons.check,
                color: _item.isSelected ? Colors.white : Colors.transparent,
                size: 15,
              ),
            ),
            decoration: BoxDecoration(
              color: _item.isSelected ? Colors.blueAccent : Colors.transparent,
              border: Border.all(
                  width: 1.0,
                  color: _item.isSelected ? Colors.blueAccent : Colors.grey),
              borderRadius: const BorderRadius.all(const Radius.circular(50.0)),
            ),
          ),
        ],
      ),
    );
  }
}
