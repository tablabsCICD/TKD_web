
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tkd_app/locator.dart';
import 'package:tkd_app/model/auth_api.dart';
import 'package:tkd_app/model/verified_user.dart';
import 'package:tkd_app/provider/auth_provider.dart';
import 'package:tkd_app/provider/dashboard_provider.dart';
import 'package:tkd_app/provider/edit_post_provider.dart';
import 'package:tkd_app/util/color-resource.dart';
import 'package:tkd_app/util/style.dart';
import 'package:tkd_app/view/base_widget/custom_textview.dart';
import 'package:tkd_app/view/screens/dashboard/create_requirement.dart';

class CustomDropdownSearchMultiSelection extends StatefulWidget {
  final String labelText;
  final List<String> itemList;
  final List<String> selectedItems;
  String sourceCity;
  final int? maxLimit;
  final bool? required;
  List<UserVerifiedData> allUserList;

  CustomDropdownSearchMultiSelection(
      { required this.labelText, required this.itemList, required this.selectedItems,
        this.maxLimit, this.required, Key? key, required this.allUserList, required this.sourceCity})
      : super(key: key);

  @override
  State<CustomDropdownSearchMultiSelection> createState() => _CustomDropdownSearchMultiSelectionState();
}

class _CustomDropdownSearchMultiSelectionState extends State<CustomDropdownSearchMultiSelection> {
  final _multiKey = GlobalKey<DropdownSearchState<String>>();

  List<RadioModel> sampleData = <RadioModel>[
    RadioModel(true, 'Show to All'),
    RadioModel(false, 'Show to only Groups'),
    RadioModel(false, 'Show to only verified Transporters')

  ];

  /*List<String> allVerifiedUserList = [];

  getList(){
    widget.allUserList.forEach((element) {
      if(element.isUserVerifiedByCompany == 1) {
        allVerifiedUserList.add('${element.firstName} ${element.lastName}');
      }
    });
  }*/

  final editProvider = locator<EditPostLoadProvider>();
  final authProvider = locator<AuthProvider>();
  ScrollController _scrollController = ScrollController();
  var selectedPageNumber = 0;

  @override
  void initState() {
   // getList();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        editProvider.getAllUserList(currentPage: selectedPageNumber);
        selectedPageNumber++;
      }
    });
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
                      onTap: () {
                        setState(() {
                          sampleData.forEach((element) => element.isSelected = false);
                          sampleData[index].isSelected = true;
                          model.selectedSampleData = sampleData[index].text;
                          model.selecteOptiontoShow(index, context,widget.sourceCity);
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
                      text: widget.labelText,
                      style: const TextStyle( fontSize: 14, color: Colors.grey),
                      children: <TextSpan>[
                        widget.required != null ? widget.required! ?
                        const TextSpan(text: ' *', style: TextStyle(color:  ColorResources.PRIMARY_COLOR, fontWeight: FontWeight.bold))
                            : const TextSpan(text: '') : const TextSpan(text: '')
                      ],
                    ),
                  ),
                ),
                items: sampleData[2].isSelected == true ? model.allVerifiedUserNameList : model.groupListName,

                popupProps: const PopupPropsMultiSelection.menu(
                  title: Center(child: Text("Search here")),
                  searchFieldProps: TextFieldProps(),
                  showSelectedItems: true,
                  showSearchBox: true,
                  textStyle: TextStyle(fontSize: 14),
                ),
                onChanged: (value) {

                  widget.selectedItems.clear();
                  widget.selectedItems.addAll(value);
                  model.searchingList.clear();
                  model.searchingList.addAll(value);

                },
                /*dropdownBuilder: (context, value) {
                  return Wrap(
                    children: value.map((e) => _getMultiSelectedWidget(e)).toList(),
                  );
                },*/
                dropdownBuilder: null,
                selectedItems: widget.selectedItems,
                onBeforeChange: (list1, list2) => checkBeforeChange(list1, list2),
                dropdownSearchTextStyle:
                    const TextStyle(fontSize: 14,color: Colors.black,backgroundColor: Colors.grey),
              ),
            ],
          ),
        ),
        actions: [
           ElevatedButton(
              child: CustomText(
                "Ok",
              ),
              onPressed: () {
                if(sampleData[2]==true){
                model.getSelectedUserId(widget.selectedItems);}
                Navigator.of(context).pop(widget.selectedItems);
              },
            ),

        ],
      ),
    );
  }

  Future<bool> checkBeforeChange(List list1, List list2) async{
    if(widget.maxLimit == null){
      return true;
    }
    if(list1.length<=widget.maxLimit! && list2.length<=widget.maxLimit!) {
      debugPrint('List 1 : ${list1.toString()}');
      debugPrint('List 2 : ${list2.toString()}');
      if(list1.length < list2.length) {
        list1.clear();
        list1.addAll(list2);
      }
      return true;
    }
    return false;
  }
}
