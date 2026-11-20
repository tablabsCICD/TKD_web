import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';
import 'package:tkd_app/provider/auth_provider.dart';
import 'package:tkd_app/util/color-resource.dart';
import 'package:tkd_app/util/colors.dart';
import 'package:tkd_app/util/style.dart';
import 'package:tkd_app/view/base_widget/appbar.dart';
import 'package:tkd_app/view/base_widget/home_base_widgets.dart';
import 'package:tkd_app/view/screens/group/createNewGroup.dart';
import 'package:tkd_app/view/screens/group/editGroupScreen.dart';

import '../../../locator.dart';
import '../../../model/group_list_model.dart';
import '../../../provider/group/groupListProvider.dart';
import '../../../util/ResponsiveWidget.dart';
import '../../base_widget/getImage.dart';
import '../../base_widget/getLoader.dart';

class GroupList extends StatefulWidget {
  @override
  State<GroupList> createState() => GroupListState();
}

class GroupListState extends State<GroupList> {
  final groupListProvider = locator<GroupListProvider>();
  final userProvider = locator<AuthProvider>();
  final ScrollController _scrollController = ScrollController();

  bool _apiCalled = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_apiCalled) {
      _apiCalled = true;
      groupListProvider.getAllGroup(
        userProvider.userDetailList[0].id,
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GroupListProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          backgroundColor: ThemeColor.baground,
         /* appBar: AppBarCommon(context, title: "Group")
              .appBarWithNewButton(() {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => CreateNewGroup(isFromEdit: false,)),
            );
          }),*/
          floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
          floatingActionButton: FloatingActionButton.extended(
            heroTag: "create_group",
            backgroundColor: ThemeColor.theme_blue,
            icon: const Icon(Icons.group_add, color: Colors.white),
            label: const Text(
              "Create Group",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CreateNewGroup(isFromEdit: false),
                ),
              );
            },
          ),

          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                getLoader(provider.isLoading),

                Expanded(
                  child: provider.listGroup.isEmpty
                      ? Center(
                    child: Text(
                      "No groups found",
                      style: Style.heading,
                    ),
                  )
                      : StaggeredGridView.countBuilder(
                    controller: _scrollController,
                    crossAxisCount: ResponsiveWidget.isDesktop(context)
                        ? 3
                        : ResponsiveWidget.isMobile(context)
                        ? 1
                        : 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    itemCount: provider.listGroup.length,
                    staggeredTileBuilder: (_) => StaggeredTile.fit(1),

                    itemBuilder: (context, index) {
                      final group = provider.listGroup[index];
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  EditGroupScreen(groupContent: group!),
                            ),
                          );
                        },
                        child: groupTile(group),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget groupTile(GroupContent? group) {
    String imgUrl = group?.imageUrl?.replaceAll('"', '') ?? "";

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      shadowColor: Colors.black12,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: Row(
          children: [
            HomeBaseWidget().getImageclip(
              imgUrl,
              height: 55,
              width: 55,
            ),
            const SizedBox(width: 12),

            /// Group Name
            Expanded(
              child: Text(
                group?.groupName ?? "",
                style: Style.heading,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
