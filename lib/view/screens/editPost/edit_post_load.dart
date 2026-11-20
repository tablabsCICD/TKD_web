// Updated version of your EditPostLoadScreen with proper labels added to every
// TextField, Dropdown, and City Picker. Only UI labels added — logic unchanged.

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
import 'package:tkd_app/widgets/datepicker.dart';

class EditPostLoadScreen extends StatefulWidget {
  TruckLoad postBidData;
  final editProvider = locator<EditPostLoadProvider>();

  EditPostLoadScreen(this.postBidData, {Key? key}) : super(key: key) {
    editProvider.initData(postBidData);
  }

  @override
  State<StatefulWidget> createState() => _EditPostLoadScreen();
}

class _EditPostLoadScreen extends State<EditPostLoadScreen> {
  final authProvider = locator<AuthProvider>();
  final editProvider = locator<EditPostLoadProvider>();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
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
        Navigator.pop(context, 1);
        return false;
      },
      child: Scaffold(
        backgroundColor: ThemeColor.baground,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text("Edit Post Load / Vehicle Requirement", style: Style.appheading),
          shadowColor: Colors.white,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context, 1),
          ),
        ),

        body: Form(
          key: _formKey,
          child: Consumer<EditPostLoadProvider>(
            builder: (context, model, child) {
              getAddedUserList(model);

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // INFO TEXT
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Text(
                        'Your posted requirement will be visible to vendors whose routes match yours.',
                        style: Style.appsubtitle,
                      ),
                    ),

                    // REQUIREMENT TYPE LABEL
                    CustomDropdownList(
                      hintText: "Select Requirement",
                      items: model.requirementList,
                      selectedType: model.selectedRequriment,
                      onChange: (value) => model.selectedRequriment = value,
                    ),

                    // POST TYPE LABEL
                    CustomDropdownList(
                      hintText: "Post Type",
                      items: model.postTypeList,
                      selectedType: model.selectedPostType,
                      onChange: (value) => setState(() => model.selectedPostType = value),
                    ),

                    // CITY FROM
                    CustomCityTextField(
                      label: 'Select City From',
                      value: model.sourceCity,
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (_) => CustomCityListDialog(
                            onTap: (value) => setState(() => model.sourceCity = value),
                          ),
                        );
                      },
                    ),

                    // CITY TO
                    CustomCityTextField(
                      label: 'Select City To',
                      value: model.destinationCity,
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (_) => CustomCityListDialog(
                            onTap: (value) => setState(() => model.destinationCity = value),
                          ),
                        );
                      },
                    ),

                    // CARGO TYPE
                    CustomDropdownList(
                      hintText: "Select Cargo Type",
                      items: model.cargoList,
                      selectedType: model.selectedCargo,
                      onChange: (value) => setState(() => model.selectedCargo = value),
                    ),

                    // VEHICLE SIZE
                    CustomTextField(
                      hintText: 'Vehicle Size',
                      controller: model.vehicleSizeController,
                      textInputType: TextInputType.text,
                    ),

                    // LOAD WEIGHT
                    CustomTextField(
                      hintText: 'Load Weight (In Tons)',
                      controller: model.loadWeightController,
                      textInputType: TextInputType.number,
                    ),

                  /*  // SPECIAL INSTRUCTION
                    CustomTextField(
                      hintText: 'Special Instruction',
                      controller: model.specialInstructionController,
                      textInputType: TextInputType.text,
                    ),
*/
                    // CARGO TYPE
                    CustomDropdownList(
                      hintText: "Select Special Instruction",
                      items: model.specialInstructionList,
                      selectedType: model.specialInstructionList.contains(model.selectedSI)
                          ? model.selectedSI
                          : null,
                      onChange: (value) => setState(() => model.selectedSI = value),
                    ),

                    // MOBILE
                    CustomTextField(
                      hintText: 'Mobile',
                      controller: TextEditingController(text: authProvider.userDetailList[0].mobileNumber.toString()),
                      textInputType: TextInputType.phone,
                      readOnly: true,
                    ),

                    // EMAIL
                    CustomTextField(
                      hintText: 'Email',
                      controller: TextEditingController(text: authProvider.userDetailList[0].emailId ?? ''),
                      textInputType: TextInputType.emailAddress,
                      readOnly: true,
                    ),

                    // PAYMENT TYPE
                    CustomDropdownList(
                      hintText: "Select Payment",
                      items: model.paymentList,
                      selectedType: model.selectedPayment,
                      onChange: (value) => setState(() => model.selectedPayment = value),
                    ),

                    // EXPIRY DATE
                    CustomTextField(
                      hintText: 'Post Expiry Date (YYYY-MM-DD)',
                      controller: editProvider.expireDateController,
                      textInputType: TextInputType.text,
                      isValidator: false,
                      onTap: () async {
                        String date = await DateTimePickerDialog().pickDateDialog(context);
                        editProvider.setDate(date);
                      },
                    ),

                    // SWITCHES
                    settingSwitch("Hide My Identity", model.identitySwitch, (val) {
                      setState(() => model.identitySwitch = val);
                    }),

                    settingSwitch("Do Not Disturb", model.disturbSwitch, (val) {
                      setState(() => model.disturbSwitch = val);
                    }),

                    // SHOW TO USERS
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Text(
                        "Show Post To:",
                        style: TextStyle(
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    editProvider.addedUserListIdInPost.isEmpty
                        ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text("All Users", style: Style.heading1),
                    )
                        : Container(
                      color: Colors.grey.shade50,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: SizedBox(height: 60, child: selectedUsers()),
                      ),
                    ),

                    // SUBMIT BUTTON
                    CustomButton(
                      onTap: () async {
                        if (_formKey.currentState!.validate()) {
                          await model.editPost(context, widget.postBidData.id);
                        }
                      },
                      buttonText: "Edit Post",
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }


  // SWITCH UI
  Widget settingSwitch(String label, bool value, Function(bool) onToggle) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      height: 25,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Style.heading1),
          FlutterSwitch(
            showOnOff: true,
            valueFontSize: 12,
            activeColor: ColorResources.PRIMARY_COLOR,
            activeTextColor: Colors.black,
            inactiveTextColor: Colors.red,
            value: value,
            onToggle: onToggle,
          ),
        ],
      ),
    );
  }

  // SELECTED USERS LIST
  ScrollController horizantalControllet = ScrollController();

  Widget selectedUsers() {
    return Consumer<EditPostLoadProvider>(
      builder: (context, model, child) {
        return ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          controller: horizantalControllet,
          itemCount: model.addedUsers.length,
          itemBuilder: (context, index) {
            return Container(
              padding: EdgeInsets.only(left: 10),
              child: Column(
                children: [
                  HomeBaseWidget().getImageclip(
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
                    ),
                  )
                ],
              ),
            );
          },
        );
      },
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
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: _item.isSelected ? Color(0xFFE8F0FE) : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _item.isSelected ? Color(0xFF1A73E8) : Colors.grey.shade300,
          width: 1.3,
        ),
      ),

      child: Row(
        children: [
          Icon(
            _item.isSelected
                ? Icons.radio_button_checked
                : Icons.radio_button_off,
            color: _item.isSelected ? Color(0xFF1A73E8) : Colors.grey,
            size: 22,
          ),

          SizedBox(width: 12),

          Expanded(
            child: Text(
              _item.text ?? "",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 15,
                fontWeight:
                _item.isSelected ? FontWeight.w600 : FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

