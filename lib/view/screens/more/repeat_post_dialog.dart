

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:tkd_app/constant.dart';
import 'package:tkd_app/locator.dart';
import 'package:tkd_app/model/repeat_model.dart';
import 'package:tkd_app/model/transport_serach_model.dart';
import 'package:tkd_app/model/truck_load_model.dart';
import 'package:tkd_app/provider/more_provider.dart';
import 'package:tkd_app/provider/repeatProvider.dart';
import 'package:tkd_app/provider/route_provider.dart';
import 'package:tkd_app/util/ResponsiveWidget.dart';
import 'package:tkd_app/util/color-resource.dart';
import 'package:tkd_app/util/style.dart';
import 'package:tkd_app/view/base_widget/custom_textview.dart';
import 'package:tkd_app/view/localization/language_constrants.dart';
import 'package:tkd_app/view/screens/dashboard/create_requirement.dart';

class RepeatDialogBox extends StatefulWidget {
  TruckLoad? obj;

  RepeatDialogBox(this.obj);

  @override
  _RepeatDialogBoxState createState() => _RepeatDialogBoxState();
}

class _RepeatDialogBoxState extends State<RepeatDialogBox> {
  final _formKey = GlobalKey<FormState>();
  List<RadioModel> repeatList = <RadioModel>[
    RadioModel(true, 'Repeat Once'),
    RadioModel(false, 'Repeat Multiple')
  ];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Please Select Date and Time For Repeat Post"),
      content: Container(
          height: ResponsiveWidget.isDesktop(context) ? 330 : 300,
          width: ResponsiveWidget.isMobile(context)
              ? MediaQuery.of(context).size.width - 100
              : ResponsiveWidget.isDesktop(context)
              ? 150
              : 150,
        child:Column(
          children: [
            Container(
              height: 130,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: repeatList.length,
                itemBuilder: (BuildContext context, int index) {
                  return new InkWell(
                    //highlightColor: Colors.red,
                    splashColor: Colors.blueAccent,
                    onTap: () {
                      setState(() {
                        repeatList.forEach((element) => element.isSelected = false);
                        repeatList[index].isSelected = true;
                        //model.selectedSampleData = repeatList[index].text;
                      });
                    },
                    child: new RadioItem(repeatList[index]),
                  );
                },
              ),
            ),
            repeatList[1].isSelected == true ?
            Form(
              key: _formKey,
              child: Container(
                child: Consumer<RepeatProvider>(
                  builder: (context, model, child) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        onTap: () {
                          setState(() {
                            model.selectDate(context, "From Date");
                          });
                        },
                        controller: TextEditingController(text: model.resFromDateCnt),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select start date';
                          }
                          return null;
                        },
                        readOnly: true,
                        cursorColor: Colors.brown,
                        decoration: InputDecoration(
                            hintText: 'Select From Date',
                            labelText: 'From Date',
                            labelStyle: TextStyle(
                              color: Colors.brown,
                              fontSize: 16,
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                            border: const OutlineInputBorder()),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                        onTap: () {
                          model.selectDate(context, "To Date");
                        },
                        controller: TextEditingController(text: model.resToDateCnt),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select end date';
                          }
                          return null;
                        },
                        readOnly: true,
                        cursorColor: Colors.brown,
                        decoration: InputDecoration(
                            hintText: 'Select To Date',
                            labelText: 'To Date',
                            labelStyle: TextStyle(
                              color: Colors.brown,
                              fontSize: 16,
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                            border: const OutlineInputBorder()),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                        onTap: () {
                          model.selectTime(context, "RepeatTime");
                        },
                        controller: TextEditingController(text: model.TimeCnt),
                        autofocus: false,
                        readOnly: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select time';
                          }
                          return null;
                        },
                        //autovalidate: true,
                        cursorColor: Colors.brown,
                        decoration: InputDecoration(
                            hintText: 'Time',
                            labelText: "Repeat Posting Time",
                            labelStyle: TextStyle(
                              color: Colors.brown,
                              //  fontSize: 16,
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                            border: const OutlineInputBorder()),
                      ),
                    ],
                  ),
                ),
              ),
            )
            :Form(
              key: _formKey,
              child: Container(

                child: Consumer<RepeatProvider>(
                  builder: (context, model, child) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        onTap: () {
                          setState(() {
                            model.selectDate(context, "From Date");
                          });
                        },
                        controller: TextEditingController(text: model.resFromDateCnt),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select start date';
                          }
                          return null;
                        },
                        readOnly: true,
                        cursorColor: Colors.brown,
                        decoration: InputDecoration(
                            hintText: 'Select From Date',
                            labelText: 'From Date',
                            labelStyle: TextStyle(
                              color: Colors.brown,
                              fontSize: 16,
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                            border: const OutlineInputBorder()),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                        onTap: () {
                          model.selectTime(context, "RepeatTime");
                        },
                        controller: TextEditingController(text: model.TimeCnt),
                        autofocus: false,
                        readOnly: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select time';
                          }
                          return null;
                        },
                        //autovalidate: true,
                        cursorColor: Colors.brown,
                        decoration: InputDecoration(
                            hintText: 'Time',
                            labelText: "Repeat Posting Time",
                            labelStyle: TextStyle(
                              color: Colors.brown,
                              //  fontSize: 16,
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                            border: const OutlineInputBorder()),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        )
        /* */
      ),
      actions: [
        Consumer<RepeatProvider>(
          builder: (context, model, child) => ElevatedButton(
            child: CustomText(
              "Ok",
            ),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white, backgroundColor: Colors.green,
              elevation: 3,
            ),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                showDialog(
                    context: context,
                    builder: (_) => new CupertinoAlertDialog(
                          title: CustomText(
                              'Are you sure want to repeat your post?',
                              style: Style.heading),
                          actions: <Widget>[
                            TextButton(
                              child: CustomText(getTranslated('yes', context)!,
                                  style: Style.okButton),
                              onPressed: () {
                                model.addToRepeatList(widget.obj);
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: CustomText(
                                getTranslated('no', context)!,
                                style: Style.cancelButton,
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        )
                );
              }
            },
          ),
        ),
        ElevatedButton(
          onPressed: (){
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white, backgroundColor: Colors.red,
            elevation: 3,
          ),
          child: CustomText("Cancel",style: Style.button,),
        ),
      ],
    );
  }
}
