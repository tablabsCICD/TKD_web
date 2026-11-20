import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:tkd_app/locator.dart';
import 'package:tkd_app/model/group_list_model.dart';
import 'package:tkd_app/provider/auth_provider.dart';
import 'package:tkd_app/provider/dashboard_provider.dart';
import 'package:tkd_app/provider/group/groupChatProvider.dart';
import 'package:tkd_app/util/style.dart';
import 'package:tkd_app/view/base_widget/custom_button.dart';
import 'package:tkd_app/view/screens/dashboard/dashboard.dart';
import 'package:tkd_app/view/screens/menu_page.dart';
import '../../util/ResponsiveWidget.dart';
import '../../widgets/button.dart';
import '../screens/group/editGroupScreen.dart';

class AppBarCommon {
  final String title;
  final BuildContext context;
  final String appBarWord;

  AppBarCommon(this.context, {this.appBarWord = "New", required this.title});

  AppBar appBar() {
    return AppBar(
      title: Text(
        title,
        style: Style.appheading,
      ),
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_new,
          color: Colors.black,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
  final authProvider = locator<AuthProvider>();
  AppBar appBarWithoutBackButton() {
    return AppBar(
      title: Text(
        title,
        style: Style.appheading,
      ),
      backgroundColor: Colors.white,
      elevation: 0,

      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_new,
          color: Colors.black,
        ),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (builder)=>MenuPage(userDetailList: authProvider.userDetailList,selectedTab:"Home")));
        },
      ),
    );
  }


  AppBar appBarWithTextField(
      TextEditingController _controller,
      String hintText,
      ValueChanged<String> onChangeVal,
      bool backShow, {
        Widget? filterIcon,
        List<String>? selectedFilterLabel,  // 🔵 NEW PARAM
      }) {
    return AppBar(
      leadingWidth: 25,
      centerTitle: true,
      title: Container(
        alignment: Alignment.center,
        width: 500,
        child: Row(
          children: [
            // 🔍 SEARCH FIELD
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.black12,
                  contentPadding: EdgeInsets.all(1),
                  hintText: hintText,
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    borderSide: BorderSide(width: 0, style: BorderStyle.none),
                  ),
                ),
                style: Style.searchHint,
                onChanged: onChangeVal,
              ),
            ),

            SizedBox(width: 10),

            // 🔵 SHOW SELECTED FILTER LABEL
            if (selectedFilterLabel != null && selectedFilterLabel!.isNotEmpty)
              Wrap(
                spacing: 6,
                children: selectedFilterLabel!.map((label) {
                  return Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveWidget.isMobile(context) ? 8 : 12,
                      vertical: ResponsiveWidget.isMobile(context) ? 3 : 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade400),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          label,
                          style: TextStyle(
                            fontSize: ResponsiveWidget.isMobile(context) ? 11 : 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(width: 4),

                        // ❌ Small clear icon per chip
                        GestureDetector(
                          onTap: () {
                            selectedFilterLabel!.remove(label);
                            // You must call setState from parent screen
                            (context as Element).markNeedsBuild();
                          },
                          child: Icon(Icons.close, size: 14, color: Colors.black54),
                        )
                      ],
                    ),
                  );
                }).toList(),
              ),



            // 🔵 FILTER BUTTON
            if (filterIcon != null) filterIcon!,
          ],
        ),
      ),
      backgroundColor: Colors.white,
      leading: Visibility(
        visible: backShow,
        child: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }

  final userProvider = locator<AuthProvider>();

  AppBar appBarWithNewButton(Function ontap) {
    return AppBar(
      title: Text(
        title,
        style: Style.appheading,
      ),
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_new,
          color: Colors.black,
        ),
        onPressed: () {
          if (title == "Group") {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MenuPage(
                          userDetailList: userProvider.userDetailList,
                          selectedTab: "Home",
                        )));
          } else {
            Navigator.pop(context);
          }
        },
      ),
      actions: [
        Button(onClick: (){ ontap();},  width: 100, height: 40, title: appBarWord, textStyle: TextStyle(color: Colors.white)),
       /* Center(
          child: Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
            child: RichText(
              text: TextSpan(
                  text: appBarWord,
                  style: Style.newheadingappbar,
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      ontap();
                    }),
            ),
          ),
        )*/
      ],
    );
  }

  AppBar appBarWithDeleteButton(Function ontap) {
    return AppBar(
      title: Text(
        title,
        style: Style.appheading,
      ),
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_new,
          color: Colors.black,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      actions: [
        Center(
          child: Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
            child: RichText(
              text: TextSpan(
                  text: "Delete",
                  style: Style.newheadingappbar,
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      ontap();
                    }),
            ),
          ),
        )
      ],
    );
  }

  AppBar appBarWithNotification(Function ontap) {
    return AppBar(
      title: Text(
        title,
        style: Style.appheading,
      ),
      backgroundColor: Colors.white,
      elevation: 0,
      actions: [
        Center(
          child: Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
              child: IconButton(
                  onPressed: ontap(), icon: Icon(Icons.notifications))),
        )
      ],
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_new,
          color: Colors.black,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget appBarWithSearch(TextEditingController _controller, String hintText,
      Function onChangeVal(value), bool backShow) {
    return TextField(
      controller: _controller,
      decoration: InputDecoration(
          filled: true,
          fillColor: Colors.black12,
          contentPadding: EdgeInsets.all(1),
          hintText: hintText,
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              const Radius.circular(15.0),
            ),
            borderSide: BorderSide(
              width: 0,
              style: BorderStyle.none,
            ),
          )),
      style: Style.searchHint,
      onChanged: (value) {
        onChangeVal(value);
      },
    );
  }

  AppBar appBarImage(String img, GroupContent content, BuildContext context,
      GroupChatProvider groupChatProvider) {
    img = img.replaceAll('"', '');
    return AppBar(
      title: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      EditGroupScreen(groupContent: content)));
        },
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 5),
              child: CircleAvatar(
                radius: 25.0,
                backgroundImage: NetworkImage(img),
                backgroundColor: Colors.transparent,
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Text(
              title,
              style: Style.appheading,
            )
          ],
        ),
      ),
      backgroundColor: Colors.white,
      actions: [
        IconButton(
          icon: Icon(
            Icons.refresh,
            color: Colors.black,
          ),
          onPressed: () {
            groupChatProvider.loadMessage(content.id!);
            return;
          },
        )
      ],
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_new,
          color: Colors.black,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
