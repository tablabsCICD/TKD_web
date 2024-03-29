import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';
import 'package:tkd_app/dialog/animated_custom_dialog.dart';
import 'package:tkd_app/dialog/my_dialog.dart';
import 'package:tkd_app/util/color-resource.dart';
import 'package:tkd_app/view/base_widget/custom_textview.dart';
import 'package:tkd_app/view/localization/language_constrants.dart';

import '../../../locator.dart';
import '../../../model/group_list_model.dart';
import '../../../provider/auth_provider.dart';
import '../../../provider/group/groupListProvider.dart';
import '../../../util/ResponsiveWidget.dart';
import '../../../util/style.dart';
import '../../base_widget/appbar.dart';
import 'createNewGroup.dart';

class EditGroupScreen extends StatefulWidget {
  final GroupContent groupContent;

  const EditGroupScreen({Key? key, required this.groupContent})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return EditGroupState();
  }
}

class EditGroupState extends State<EditGroupScreen> {
  final groupListProvider = locator<GroupListProvider>();
  final userProvider = locator<AuthProvider>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    groupListProvider.changeImage(widget.groupContent.imageUrl!);
    groupListProvider.getGroupMember(widget.groupContent.id!);
  }

  @override
  Widget build(BuildContext context) {
    String img = groupListProvider.changeImageUrl.replaceAll('"', '');
    ;
    return Consumer<GroupListProvider>(
      builder: (context, provider, child) {
        return Scaffold(
         // appBar: AppBarCommon(context, title: "Group Info").appBar(),
          appBar: AppBarCommon(context, title: "Group Info").appBarWithDeleteButton(() async {
            showDialog(
                context: context,
                builder: (_) =>
                new CupertinoAlertDialog(
                  title: CustomText(
                    'Are you sure want to deleted your group?',
                    style: Style.heading,
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: CustomText(
                          getTranslated('yes',
                              context)!,
                          style:
                          Style.okButton),
                      onPressed: () async{
                       await groupListProvider.deleteGroup(context,widget.groupContent)
                        .then((value) => {
                          showAnimatedDialog(
                              context,
                              MyDialog(
                                icon:
                                Icons.check,
                                title:
                                'Group Delete',
                                description:
                                'Your group deleted successfully',
                                isFailed:
                                false,
                              ),
                              dismissible:
                              false,
                              isFlip:
                              false)
                        });
                       Navigator.of(context)
                           .pop();
                       Navigator.of(context)
                           .pop();
                       Navigator.of(context)
                           .pop();
                       Navigator.of(context)
                           .pop();
                      },
                    ),
                    TextButton(
                      child: CustomText('no',
                          style: Style
                              .cancelButton),
                      onPressed: () {
                        Navigator.of(context)
                            .pop();
                      },
                    ),
                  ],
                ));
          }),
          backgroundColor: ColorResources.HOME_BG,
          body: Column(
            children: [
              Center(
                child: InkWell(
                  onTap: (){
                    //groupListProvider.pickFile();
                  },
                  child: CircleAvatar(
                    radius: 80.0,
                    backgroundImage: NetworkImage(img),
                    backgroundColor: Colors.transparent,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                widget.groupContent.groupName!,
                style: Style.groupNameEdit,
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                color: Colors.black12,
                child: Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 15, left: 20),
                  child: Text(
                    "${groupListProvider.listAddedMember.length} Participants",
                    style: Style.heading,
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Visibility(
                  visible: widget.groupContent.createByUserId ==
                          userProvider.userDetailList[0].id
                      ? true
                      : false,
                  child: InkWell(onTap: (){
                    callAddedMember();
                  },child: addUser(),)),
              listViewUser(),
            ],
          ),
        );
      },
    );
  }

  listViewUser() {
    return Expanded(
      child: StaggeredGridView.countBuilder(
          //controller: _scrollController,
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
          itemCount: groupListProvider.listAddedMember.length,
          itemBuilder: (context, index) {
            return InkWell(onTap: () {}, child: groupTile(index));
          }),
    );
  }

  groupTile(int index) {
    return Container(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.account_circle,
                  size: 64.0,
                ),
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
                              groupListProvider
                                  .listAddedMember[index].displayName!,
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 20.0),
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                              maxLines: 2,
                            ),
                            Visibility(
                              visible: widget.groupContent.createByUserId ==
                                      userProvider.userDetailList[0].id
                                  ? true
                                  : false,
                              child: InkWell(
                                  onTap: () {
                                    groupListProvider.removeMemberFromGroup(
                                        groupListProvider
                                            .listAddedMember[index].id!,
                                        index);
                                  },
                                  child: Text(
                                    "Remove",
                                    style: Style.aleaready,
                                  )),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Divider(),
          ),
        ],
      ),
    );
  }

  addUser() {
    return Container(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 20),
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.add_circle_sharp,
                  size: 30.0,
                  color: ColorResources.PRIMARY_COLOR,
                ),
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
                              "Add User",
                              style: Style.addUser,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Divider(
              color: ColorResources.PRIMARY_COLOR,
            ),
          ),
        ],
      ),
    );
  }

  void callAddedMember()async {
    var result= await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CreateNewGroup(isFromEdit: true,)));
    if(result == 2){
      groupListProvider.callGroupMember(widget.groupContent.id!, userProvider.userDetailList[0].id, context, true);
    }
  }
}
