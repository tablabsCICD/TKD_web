import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:tkd_app/util/colors.dart';
import 'package:tkd_app/view/base_widget/border_button.dart';
import '../../../../locator.dart';
import '../../../../provider/auth_provider.dart';
import '../../../../util/style.dart';
import '../../../../util/color-resource.dart';
import '../../base_widget/custom_textview.dart';

import '../gallery/image_picker_helper.dart';
import 'edit_profile.dart';

class MyProfile extends StatefulWidget {
  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  final authProvider = locator<AuthProvider>();

  @override
  void initState() {
    super.initState();
    authProvider.getUserDetails(authProvider.userDetailList[0].id!);
  }

  @override
  Widget build(BuildContext context) {
    final isWeb = kIsWeb;
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: ThemeColor.baground,
      body: Consumer<AuthProvider>(
        builder: (context, model, child) {
          final data = model.userDetailList[0];

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 20 : 80,
              vertical: 30,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // --------------------------
                // PROFILE IMAGE + EDIT ICON
                // --------------------------
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: isMobile ? 50 : 60,
                      backgroundColor: Colors.grey.shade300,
                      backgroundImage: data.companyLogo.toString().isNotEmpty
                          ? NetworkImage(data.companyLogo.toString())
                          : null,
                      child: data.companyLogo.toString().isEmpty
                          ? Icon(Icons.person,
                          size: isMobile ? 50 : 60, color: Colors.white)
                          : null,
                    ),
                    GestureDetector(
                      onTap: () async {
                        String? image = await ImagePickerHelper().pickAndUploadImage(context);

                        if (image != null && image.isNotEmpty) {
                          model.updateUser(id: data.id,companyLogo: image,profilePicture: image);
                        }
                      }, // open image picker if you have
                      child: CircleAvatar(
                        radius: isMobile ? 15 : 18,
                        backgroundColor: Colors.black,
                        child: Icon(Icons.camera_alt_outlined,
                            size: isMobile ? 14 : 17, color: Colors.white),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 16),

                Text(
                  data.companyName ?? "",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: isMobile ? 18 : 22,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),

                SizedBox(height: 6),
                Container(
                  height: 2,
                  width: 60,
                  color: Colors.black26,
                ),

                SizedBox(height: 30),

                // --------------------------
                // PROFILE DETAILS CARD
                // --------------------------
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                      horizontal: 20, vertical: isMobile ? 20 : 30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 10,
                        color: Colors.black.withOpacity(0.05),
                        offset: Offset(0, 4),
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      profileTile(
                        title: "Email",
                        value: data.emailId.toString(),
                        icon: Icons.email_outlined,
                      ),
                      Divider(),
                      profileTile(
                        title: "Mobile",
                        value: data.mobileNumber.toString(),
                        icon: Icons.phone_outlined,
                      ),
                      Divider(),
                      profileTile(
                        title: "Address",
                        value: data.companyAddress.toString(),
                        icon: Icons.location_on_outlined,
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 40),

                // --------------------------
                // BUTTONS
                // --------------------------
                isWeb
                    ? ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => EditProfileDialog(authProvider),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(isMobile ? 200 : 260, 48),
                    backgroundColor: ColorResources.THEME_COLOR,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text(
                    "Edit Profile Info",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                )
                    : BorderButton(
                  buttonText: "Edit Profile Info",
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) => EditProfileDialog(authProvider),
                    );
                  },
                ),

                SizedBox(height: 50),
              ],
            ),
          );
        },
      ),
    );
  }

  // ------------------------------------------------
  // BEAUTIFUL TILE FOR EACH PROFILE INFORMATION ROW
  // ------------------------------------------------
  Widget profileTile({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(icon, color: Colors.black54, size: 22),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                      fontSize: 13,
                      color: Colors.black54,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    color: ColorResources.PRIMARY_COLOR,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
