// edit_profile_dialog.dart
import 'package:flutter/material.dart';
import 'package:tkd_app/util/style.dart';
import '../../../dialog/CustomCityListDialog.dart';
import '../../../dialog/CustomStateListDialog.dart';
import '../../../locator.dart';
import '../../../provider/auth_provider.dart';
import '../../../util/color-resource.dart';
import '../../../util/ResponsiveWidget.dart';
import '../../../view/base_widget/app_constant.dart';
import '../../base_widget/custom_button.dart';
import '../../base_widget/custom_dropdown_list.dart';
import '../../base_widget/custom_textfeild.dart';
import '../../base_widget/cutom_city_textfield.dart';
import '../../base_widget/utils.dart';

class EditProfileDialog extends StatefulWidget {
  final AuthProvider model;
  EditProfileDialog(this.model);

  @override
  State<EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<EditProfileDialog> {
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController mobile = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController company = TextEditingController();
  TextEditingController website = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController businessTypeController = TextEditingController();
  String? selectedCity, selectedState;
  String? selectedBusinessType;
  static final List<String> itemList = [
    AppConstant().BUSINESS_TYPE_AGENT,
    AppConstant().BUSINESS_TYPE_TRANSPORTER,
    AppConstant().BUSINESS_TYPE_MANUFACTURER,
    AppConstant().BUSINESS_TYPE_DRIVER,
  ];


  @override
  void initState() {
    var user = widget.model.userDetailList[0];

    firstName.text = user.firstName ?? '';
    lastName.text = user.lastName ?? '';
    mobile.text = user.mobileNumber.toString();
    email.text = user.emailId ?? '';
    company.text = user.companyName ?? '';
    website.text = user.website ?? '';
    address.text = user.companyAddress ?? '';

    selectedCity = user.city;
    selectedState = user.state;

    selectedBusinessType = Utils().getTransport(user.transporterOrAgent!);
    businessTypeController.text = selectedBusinessType!;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        padding: EdgeInsets.all(20),
        width: ResponsiveWidget.isDesktop(context) ? 500 : double.infinity,
        child: ListView(
          shrinkWrap: true,
          children: [
            Row(
              children: [
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Icon(Icons.arrow_back_ios, size: 20),
                ),
                SizedBox(width: 10),
                Text("Edit Profile", style: Style.heading),
                Spacer(),
                IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close))
              ],
            ),

            SizedBox(height: 20),

            CustomTextField(controller: firstName, hintText: "Enter First Name", textInputType: TextInputType.text,),

            CustomTextField(controller: lastName, hintText: "Enter Last Name", textInputType: TextInputType.text,),

            CustomTextField(controller: mobile, hintText: "Enter Mobile", textInputType: TextInputType.number),

            CustomTextField(controller: email, hintText: "Enter Email", textInputType: TextInputType.emailAddress,),

            CustomTextField(controller: company, hintText: "Enter Company Name", textInputType: TextInputType.text,),

            CustomTextField(controller: website, hintText: "Enter Website", textInputType: TextInputType.text,),

            CustomDropdownList(
              hintText: "Role",
              items: itemList,
              selectedType: selectedBusinessType!,
              onChange: (value) {
                setState(() {
                  selectedBusinessType = value;
                  businessTypeController.text = value;
                });
              },
            ),

            CustomTextField(controller: address, hintText: "Enter Address", textInputType: TextInputType.text,),

            CustomCityTextField(
              value: selectedState ?? '',
              label: "Select State",
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) => CustomStateListDialog(
                    onTap: (value) {
                      setState(() => selectedState = value);
                    },
                  ),
                );
              },
            ),

            CustomCityTextField(
              value: selectedCity ?? '',
              label: "Select City",
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) => CustomCityListDialog(
                    onTap: (value) {
                      setState(() => selectedCity = value);
                    },
                  ),
                );
              },
            ),


            SizedBox(height: 20),

            CustomButton(
              buttonText: "Save",
              onTap: () async {
                await widget.model.updateUser(
                  firstName: firstName.text,
                  lastName: lastName.text,
                  mobileNumber: int.parse(mobile.text),
                  emailId: email.text,
                  companyName: company.text,
                  companyAddress: address.text,
                  city: selectedCity,
                  state: selectedState,
                  website: website.text,
                  transporterOrAgent:
                  businessTypeController.text == AppConstant().BUSINESS_TYPE_TRANSPORTER
                      ? 0
                      : businessTypeController.text == AppConstant().BUSINESS_TYPE_AGENT
                      ? 1
                      : businessTypeController.text == AppConstant().BUSINESS_TYPE_MANUFACTURER
                      ? 2
                      : 3,
                );

                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
    );
  }

  Widget buildLabel(String text) {
    return Padding(
      padding: EdgeInsets.only(top: 12, bottom: 6),
      child: Text(text, style: Style.heading1),
    );
  }
}