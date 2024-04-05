
import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tkd_app/locator.dart';
import 'package:tkd_app/model/api_response.dart';
import 'package:tkd_app/model/auth_api.dart';
import 'package:tkd_app/model/group_added_member.dart';
import 'package:tkd_app/model/group_list_model.dart';
import 'package:tkd_app/model/verified_user.dart';
import 'package:tkd_app/network/api_call.dart';
import 'package:tkd_app/provider/auth_provider.dart';
import 'package:tkd_app/provider/dashboard_provider.dart';
import 'package:tkd_app/provider/edit_post_provider.dart';
import 'package:tkd_app/util/app_constants.dart';
import 'package:tkd_app/util/color-resource.dart';
import 'package:tkd_app/util/style.dart';
import 'package:tkd_app/view/base_widget/custom_textview.dart';
import 'package:tkd_app/view/screens/dashboard/create_requirement.dart';

class ShowOptionDropDown extends StatefulWidget {
  String? sourceCity;

  ShowOptionDropDown(this.sourceCity);

  @override
  State<ShowOptionDropDown> createState() => _ShowOptionDropDownState();
}

class _ShowOptionDropDownState extends State<ShowOptionDropDown> {
  final _multiKey = GlobalKey<DropdownSearchState<String>>();

  List<RadioModel> sampleData = <RadioModel>[
    RadioModel(true, 'Show to All'),
    RadioModel(false, 'Show to only Groups'),
    RadioModel(false, 'Show to only verified Transporters')
  ];

  final authProvider = locator<AuthProvider>();
  ScrollController _scrollController = ScrollController();
  var selectedPageNumber = 0;


  List<GroupContent> groupList = [];
  List<UserVerifiedData> verifiedUserList = [];

  List<String> groupNameList =[];
  List<String> selectedGroupNameList =[];
  List<String> verifiedUserNameList = [];
  List<String> selectedVerifiedUserNameList =[];

  List<int> selectedUserIdList = [];

  getAllGroup(int? userId,context)async{
    ApiHelper apiHelper=ApiHelper();
   // var response=await apiHelper.ApiGetData(ApiConstant.GROUP_BY_USER+userId!.toString());
    ApiResponse apiResponse=await ApiHelper().apiWithoutDecodeGet(ApiConstant.GROUP_BY_USER+userId!.toString());
    if (apiResponse.statusCode == 200) {
      GroupListModel groupListModel=GroupListModel.fromJson(jsonDecode(apiResponse.response));
      groupList.clear();
      groupList.addAll(groupListModel.content!);
      groupList.forEach((element) {
        groupNameList.add(element.groupName!);
      });
    }
     }



  getListOfVefiyUser(String sourceCity) async {
    verifiedUserList.clear();
    String myUrl = ApiConstant.GET_USER_SOURCE_LIST(sourceCity);
    ApiResponse apiResponse=await ApiHelper().apiWithoutDecodeGet(myUrl);
    if(apiResponse.statusCode==200){
      VerifiedUser verifiedUser =VerifiedUser.fromJson(jsonDecode(apiResponse.response));
      verifiedUserList.addAll(verifiedUser.data!);
      verifiedUserList.forEach((element) {
        verifiedUserNameList.add('${element.firstName} ${element.lastName}');
      });
      print(verifiedUserNameList.length.toString() + "length ");
    }
  }

  getData()async{
   await getListOfVefiyUser(widget.sourceCity!);
   await getAllGroup(authProvider.userDetailList[0].id, context);
   setState(() {
   });
  }

  @override
  void initState() {
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (context, model, child) => AlertDialog(
        title: Center(child: Text('Select Option')),
        content: Container(
          width: 400,
          height: 500,
          child: Column(
            children: [
              Container(
                height: 170,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: sampleData.length,
                  itemBuilder: (BuildContext context, int index) {
                    return new InkWell(
                      //highlightColor: Colors.red,
                      splashColor: Colors.blueAccent,
                      onTap: () async{
                        sampleData.forEach((element) => element.isSelected = false);
                        sampleData[index].isSelected = true;
                        if(index==1){
                          await getAllGroup(authProvider.userDetailList[0].id, context);
                        }
                        if(index==2){
                          getListOfVefiyUser(widget.sourceCity!);
                        }
                        setState(() {
                        });
                      },
                      child: new RadioItem(sampleData[index]),
                    );
                  },
                ),
              ),
              sampleData[0].isSelected==true ? SizedBox.shrink()
                  :DropdownSearch<String>.multiSelection(
                key: _multiKey,
                dropdownSearchDecoration: InputDecoration(
                  contentPadding: const EdgeInsets.fromLTRB(12, 12, 30, 30),
                  border: const OutlineInputBorder(),
                  labelStyle: const TextStyle(fontSize: 14),
                  floatingLabelStyle: const TextStyle(fontSize: 14),
                  hintStyle: const TextStyle(fontSize: 14),
                  label: RichText(
                    text: TextSpan(
                      text: "Show to",
                      style: const TextStyle( fontSize: 14, color: Colors.grey),
                    ),
                  ),
                ),
                items: sampleData[2].isSelected == true ? verifiedUserNameList : groupNameList,

                popupProps: const PopupPropsMultiSelection.menu(
                  title: Center(child: Text("Search here")),
                  searchFieldProps: TextFieldProps(),
                  showSelectedItems: true,
                  showSearchBox: true,
                  textStyle: TextStyle(fontSize: 14),
                ),
                onChanged: (value) {
                  selectedVerifiedUserNameList.clear();
                  selectedGroupNameList.clear();
                  sampleData[2].isSelected == true ? selectedVerifiedUserNameList.addAll(value): selectedGroupNameList.addAll(value);
                  sampleData[2].isSelected == true ? getUserId(selectedVerifiedUserNameList):getGroupMemberId(selectedGroupNameList);
                  setState(() {

                  });
                },
                /*dropdownBuilder: (context, value) {
                  return Wrap(
                    children: value.map((e) => _getMultiSelectedWidget(e)).toList(),
                  );
                },*/
                dropdownBuilder: null,
                selectedItems: sampleData[2].isSelected == true ?selectedVerifiedUserNameList:selectedGroupNameList,
               // onBeforeChange: (list1, list2) => checkBeforeChange(list1, list2),*/
                dropdownSearchTextStyle:
                const TextStyle(fontSize: 14,color: Colors.black,backgroundColor: Colors.grey),
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white, backgroundColor: Color(0xFF001E49),
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
            ),
            child: CustomText(
              "Ok",
            ),
            onPressed: () {
              /*if(sampleData[2]==true){
                model.getSelectedUserId(widget.selectedItems);}*/
              Navigator.of(context).pop(selectedUserIdList);
            },
          ),

        ],
      ),
    );
  }

  getUserId(List<String> selectedVerifiedUserNameList) {
    selectedUserIdList.clear();
    for (int i = 0; i < verifiedUserList.length; i++) {
      for(int j=0;j<selectedVerifiedUserNameList.length;j++){
        if(selectedVerifiedUserNameList[j]=="${verifiedUserList[i].firstName} ${verifiedUserList[i].lastName}"){
          selectedUserIdList.add(verifiedUserList[i].id!);
        }
      }
    }
    print("Selected User Id List :"+selectedUserIdList.length.toString());
  }

  getGroupMemberId(List<String> selectedGroupNameList) {
    selectedUserIdList.clear();
    for (int i = 0; i < groupList.length; i++) {
      for(int j=0;j<selectedGroupNameList.length;j++){
        if(selectedGroupNameList[j]=="${groupList[i].groupName}"){
          callGroupMember(groupList[i].id!);
        }
      }
    }
  }

  List<GroupMemberContent> listAddedMember=[];
  callGroupMember(int groupId)async{
    ApiHelper apiHelper=ApiHelper();
    var response=await apiHelper.ApiGetData(ApiConstant.GROUP_MEMBER_LIST+groupId!.toString());
    GroupMemberModel groupListModel=GroupMemberModel.fromJson(response);
    listAddedMember.addAll(groupListModel.content!);
    listAddedMember.forEach((element) {
      selectedUserIdList.add(element.userId!);
    });
  }


}
