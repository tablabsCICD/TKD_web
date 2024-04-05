import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';
import 'package:tkd_app/provider/auth_provider.dart';
import 'package:tkd_app/util/color-resource.dart';
import 'package:tkd_app/util/colors.dart';
import 'package:tkd_app/util/style.dart';
import 'package:tkd_app/view/base_widget/appbar.dart';
import 'package:tkd_app/view/base_widget/custom_textview.dart';
import 'package:tkd_app/view/base_widget/home_base_widgets.dart';
import 'package:tkd_app/view/screens/group/createNewGroup.dart';
import 'package:tkd_app/view/screens/group/groupChatScreen.dart';

import '../../../locator.dart';
import '../../../model/group_list_model.dart';
import '../../../provider/group/groupListProvider.dart';
import '../../../util/ResponsiveWidget.dart';
import '../../base_widget/getImage.dart';
import '../../base_widget/getLoader.dart';
import '../discussion/discussion_dashboard.dart';
import 'editGroupScreen.dart';

class GroupList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return GroupListState();
  }
}

class GroupListState extends State<GroupList> {
  ScrollController _scrollController = ScrollController();
  final groupListProvider = locator<GroupListProvider>();
  final userProvider = locator<AuthProvider>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  @override
  Widget build(BuildContext context) {

    callgetApi(context);
    return Consumer<GroupListProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          backgroundColor: ThemeColor.baground,
          appBar: AppBarCommon(context, title: "Group").appBarWithNewButton(() {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreateNewGroup()));
          }),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                getLoader(groupListProvider.isLoading),
                Expanded(
                  child: StaggeredGridView.countBuilder(
                      controller: _scrollController,
                      physics: ScrollPhysics(),
                      staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
                      shrinkWrap: true,

                      crossAxisCount: ResponsiveWidget.isDesktop(context)
                          ? 3
                          : ResponsiveWidget.isMobile(context)
                          ? 1
                          : 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 12,
                      itemCount: groupListProvider.listGroup.length,
                      itemBuilder: (context, index) {
                        return InkWell(onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => EditGroupScreen(groupContent: groupListProvider.listGroup[index]!)));
                         /* Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ChatPage(groupListProvider.listGroup[index]!,)));
*/
                        }, child: groupTile(groupListProvider.listGroup[index ]));
                      }),
                ),

              ],
            ),
          ),
        //  backgroundColor: ColorResources.HOME_BG,
        );
      },
    );
  }

  groupTile(GroupContent? objectGroup) {

    String img=objectGroup!.imageUrl!.replaceAll('"', '');
    print('the image is ${img}');
    return Card(
      color: Colors.white,

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,

        ),
        padding: EdgeInsets.all(8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
           /* CircleAvatar(
              radius: 25.0,
              backgroundImage:
              NetworkImage(objectGroup.groupName==null?img:objectGroup.groupName!),
             // backgroundColor: Colors.transparent,
            ),*/
            BaseWidget().getImageclip(img, height: 50 , width: 50 ),
            SizedBox(width: 10,),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          objectGroup!.groupName!,
                          style: Style.heading,
                        ),

                      ],
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.only(top: 2.0),
                    //   child: CustomText(
                    //     '',
                    //     style: Style.date,
                    //   ),
                    //)
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void callgetApi(context)async {
    groupListProvider.getAllGroup(userProvider.userDetailList[0].id,context);
  }
}
