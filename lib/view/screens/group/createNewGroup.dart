import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tkd_app/provider/group/groupListProvider.dart';
import 'package:tkd_app/util/color-resource.dart';
import 'package:tkd_app/util/colors.dart';
import 'package:tkd_app/util/style.dart';
import 'package:tkd_app/view/base_widget/appbar.dart';
import 'package:tkd_app/view/base_widget/home_base_widgets.dart';
import 'package:tkd_app/view/screens/group/groupDeatilsScreen.dart';

import '../../../locator.dart';
import '../../../util/ResponsiveWidget.dart';
import '../../../util/images.dart';
import '../../base_widget/getImage.dart';

class CreateNewGroup extends StatefulWidget {
  final bool isFromEdit;

  const CreateNewGroup({Key? key, required this.isFromEdit}) : super(key: key);

  @override
  State<CreateNewGroup> createState() => CreateNewGroupState();
}

class CreateNewGroupState extends State<CreateNewGroup> {
  final groupListProvider = locator<GroupListProvider>();
  final TextEditingController searchCtrl = TextEditingController();
  final ScrollController selectedScroll = ScrollController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    if (widget.isFromEdit) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        groupListProvider.getAllUserList(true, "");
      });
    } else {
      groupListProvider.resetSelection(); // for new group
      groupListProvider.getAllUserList(false, "");
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    searchCtrl.dispose();
    selectedScroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.baground,

      appBar: AppBarCommon(
        context,
        title: "Add Participants",
        appBarWord: "Next",
      ).appBarWithNewButton(onNextTap),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          searchBar(),

          // Rebuild ONLY when selected members change
          Consumer<GroupListProvider>(
            builder: (context, provider, child) {
              if (provider.selectedUsers.isEmpty) return SizedBox();
              return selectedUsersSection(provider);
            },
          ),

          // Rebuild ONLY user grid, not search bar
          Expanded(
            child: Consumer<GroupListProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                return userGrid(provider);
              },
            ),
          ),
        ],
      ),

      bottomNavigationBar: bottomNextButton(),
    );
  }

  // SEARCH BAR — Does NOT rebuild -> cursor stays
  Widget searchBar() {
    return Container(
      margin: const EdgeInsets.all(20),
      height: 52,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 0.5, color: Color(0x332C363F)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const SizedBox(width: 10),
          SvgPicture.asset(Images.search_normal, width: 24, height: 24),
          const SizedBox(width: 8),

          Expanded(
            child: TextField(
              controller: searchCtrl,
              decoration: InputDecoration(
                hintText: "Search users",
                border: InputBorder.none,
                hintStyle: TextStyle(
                  color: Color(0x662C363F),
                  fontSize: 14,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                ),
              ),

              onChanged: (value) {
                if (_debounce?.isActive ?? false) _debounce!.cancel();

                _debounce = Timer(const Duration(milliseconds: 350), () {
                  groupListProvider.getAllUserList(false, searchCtrl.text);
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  // SELECTED USERS – Only this part rebuilds
  Widget selectedUsersSection(GroupListProvider provider) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      color: Colors.grey.shade200,
      height: 140,
      child: ListView.builder(
        controller: selectedScroll,
        scrollDirection: Axis.horizontal,
        itemCount: provider.selectedUsers.length,
        itemBuilder: (context, index) {
          final user = provider.selectedUsers[index];
          return Container(
            width: 100,
            margin: const EdgeInsets.only(right: 12),
            child: Column(
              children: [
                HomeBaseWidget().getImageclip(
                  user.profilePicture ?? "",
                  height: 48,
                  width: 48,
                ),
                const SizedBox(height: 5),
                Text(
                  "${user.firstName} ${user.lastName}",
                  maxLines: 1,
                  style: TextStyle(fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 5),
                Text(
                  user.mobileNumber.toString() ?? "",
                  maxLines: 1,
                  style: TextStyle(fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 5),
                Text(
                  user.city ?? "",
                  maxLines: 1,
                  style: TextStyle(fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // USER GRID – Only this rebuilds
  Widget userGrid(GroupListProvider model) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: model.filterByName.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: ResponsiveWidget.isDesktop(context)
            ? 3
            : ResponsiveWidget.isTablet(context)
            ? 2
            : 1,

        /// ✅ RESPONSIVE HEIGHT CONTROL
        childAspectRatio: ResponsiveWidget.isDesktop(context)
            ? 6.5
            : ResponsiveWidget.isTablet(context)
            ? 4.5
            : 3.2,

        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, index) => userTile(model, index),
    );

  }

  // USER TILE
  Widget userTile(GroupListProvider model, int index) {
    final user = model.filterByName[index];
    String img = (user.profilePicture ?? "").replaceAll('"', '');

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            blurRadius: 4,
            color: Colors.black12.withOpacity(0.08),
          ),
        ],
      ),

      child: Row(
        children: [
          HomeBaseWidget().getImageclip(img, height: 45, width: 45),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${user.firstName} ${user.lastName}",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(height: 1,),
                Text(
                  "${user.mobileNumber}",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12),
                ),
                SizedBox(height: 1,),
                Text(
                  "${user.city}",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),

        /*  widget.isFromEdit
              ? Visibility(
            visible: user.addedIngroup == true,
            child: Checkbox(
              value: user.isSelected,
              onChanged: (v) => selectUser(v, user, model),
            ),
          )
              :*/ Checkbox(
            value: user.addedIngroup == true? true:user.isSelected,
            onChanged: (v) => selectUser(v, user, model),
          ),
        ],
      ),
    );
  }

  // SELECT USER
  void selectUser(bool? selected, dynamic user, GroupListProvider model) {
    model.selectedUser(selected, user);

    if (selected == true) {
      Future.delayed(const Duration(milliseconds: 100), () {
        selectedScroll.animateTo(
          selectedScroll.position.maxScrollExtent + 120,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  // BOTTOM NEXT BUTTON
  Widget bottomNextButton() {
    return Container(
      height: 48,
      color: ColorResources.PRIMARY_COLOR,
      child: Center(
        child: InkWell(
          onTap: onNextTap,
          child: Text("Next", style: Style.button),
        ),
      ),
    );
  }

  // NEXT LOGIC
  void onNextTap() {
    if (groupListProvider.selectedUsers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select at least one member.")),
      );
      return;
    }

    if (widget.isFromEdit) {
      Navigator.pop(context, 2);
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => GroupDetailsScreen()),
      );
    }
  }
}
