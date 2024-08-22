import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tkd_app/util/ResponsiveWidget.dart';
import 'package:tkd_app/util/app_constants.dart';
import 'package:tkd_app/view/base_widget/getLoader.dart';

class CustomCityListDialog extends StatefulWidget {
  Function onTap;
  CustomCityListDialog({required this.onTap});


  @override
  _CustomCityListDialogState createState() => _CustomCityListDialogState();
}

class _CustomCityListDialogState extends State<CustomCityListDialog> {
  List<dynamic> foundCity = [];
  List<dynamic> uniquFoundCity = [];
  List<dynamic> cityList = [];

  ScrollController _scrollController = ScrollController();
  int selectedPageNumber = 1;
  int size = 100;
  bool isLoading = false;

  getCity(String searchChar,int page,int size) async {
    isLoading = true;
    setState(() {
      if(page==0){
        foundCity.clear();
      }
    });
   // String myUrl = 'https://api.tkdost.com/tkd2/api/get/cities/db';
    String myUrl = ApiConstant.BASE_URL + "get/cities/db/page/search?city=${searchChar}&page=${page}&size=${size}";
    print(myUrl);
    var req = await http.get(Uri.parse(myUrl));
    var response = json.decode(req.body);
      cityList = response;
    foundCity = cityList.toSet().toList();
    selectedPageNumber++;
    isLoading = false;
    setState(() {

    });
  }



  @override
  initState() {
    getCity('',0,size);
    foundCity = cityList..toSet().toList();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        getCity('',selectedPageNumber,size);
      }
    });
    super.initState();
  }

  // This function is called whenever the text field changes
  void _runFilter(String enteredKeyword) {
    List<dynamic> results = [];
    if (enteredKeyword.isEmpty) {
      results = cityList;
    } else {
      results = cityList
          .where((user) =>
          user.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
    }
    setState(() {
      foundCity = results.toSet().toList();
      //  foundCity = uniquFoundCity;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Select City'),
      content: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) => getCity(value,0,size),
                decoration: const InputDecoration(
                    labelText: 'Search', suffixIcon: Icon(Icons.search)),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                height: ResponsiveWidget.isDesktop(context)?500:400,
                width: 300,
                child: foundCity.isNotEmpty
                    ? ListView.builder(
                  controller: _scrollController,
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemCount: foundCity.length,
                  itemBuilder: (context, index) =>
                      Column(
                        children: [
                          ListTile(
                            onTap: () {
                             // Navigator.pop(context,[foundCity[index].toString(),foundCity[index].toString()]);
                              widget.onTap(foundCity[index].toString());
                              Navigator.of(context).pop();
                            },
                             title: Text(foundCity[index]),
                          ),
                          Divider(),
                        ],
                      ),

                )
                    : const Text(
                  'No results found',
                  style: TextStyle(fontSize: 18,color: Colors.black),
                ),
              ),
              getLoader(isLoading)
            ],
          ),
        ),
      ),
    );
  }

}
