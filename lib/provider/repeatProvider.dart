import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tkd_app/locator.dart';
import 'package:tkd_app/model/load_model.dart';
import 'package:tkd_app/model/repeat_model.dart';
import 'package:tkd_app/model/truck_load_model.dart';
import 'package:http/http.dart' as http;
import 'package:tkd_app/provider/auth_provider.dart';
import 'package:tkd_app/provider/dashboard_provider.dart';
import 'package:tkd_app/util/app_constants.dart';

import '../model/postLoad.dart';

class RepeatProvider extends ChangeNotifier {
  List<RepeatModel> repeatPostList = [];
  var response;
  bool repeatFlag = false;

  setRepeatList(List<RepeatModel> repeatPostList) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final String encodedData = RepeatModel.encode(repeatPostList);
    await preferences.setString('AllRepeatPostList', encodedData);
  }

  Future<List<RepeatModel>> getRepeatList() async{
    SharedPreferences preferences=await SharedPreferences.getInstance();
    final String? allRepeatePostList = await preferences.getString('AllRepeatPostList');
    final List<RepeatModel> repeat = RepeatModel.decode(allRepeatePostList!);
    return repeat;
  }

  addToRepeatList(TruckLoad? obj) async {
    repeatPostList.add(RepeatModel(postId: obj!.id, startDate: resFromDateCnt, endDate: resToDateCnt, time: TimeCnt, isRepeat: true));
    print("Length : "+repeatPostList.length.toString());
    resFromDateCnt = '';
    resToDateCnt = '';
    TimeCnt = '';

    setRepeatList(repeatPostList);
    notifyListeners();
  }

  final dashboardProvider = locator<DashboardProvider>();
  final authProvider = locator<AuthProvider>();

  checkRepeatTim(context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? allRepeatePostList = await prefs.getString('AllRepeatPostList');
    final List<RepeatModel> repeat = RepeatModel.decode(allRepeatePostList!);
    print("repeat List : "+repeat.length.toString());
    DateTime now = DateTime.now();

    String minute = now.minute.toString();
    minute = minute.length == 1 ? "0$minute" : minute;

    String hour = now.hour.toString();
    hour = hour.length == 1 ? "0$hour" : hour;
    String currentTime = hour + " : " + minute;
    print("Current Time :"+currentTime);
    repeat.forEach((element) async {
      print("Repeat Time  :"+element.time.toString());
      DateTime startDate = DateTime.parse(element.startDate!);
      DateTime endDate = DateTime.parse(element.endDate!);
      if(startDate.isBefore(now)==true && endDate.isAfter(now)==true){
        if(currentTime == element.time.toString()){
          print('id'+element.postId.toString());
          TruckLoad load = await getFullLoadTruckById(element.postId!);
          print('object'+ load.nameOfPerson.toString());
          PostLoad postLoad = PostLoad();

// Basic info
          postLoad.contactNumber = authProvider.userDetailList[0].mobileNumber ?? 0;
          postLoad.destination = load.destination ?? "";
          postLoad.dnd = 0;
          postLoad.emailId = authProvider.userDetailList[0].emailId ?? "";
          postLoad.fullLoadChoice = load.fullLoadChoice ?? "";

// Instructions & details
          postLoad.instructions = load.otherDetails ?? "";
          postLoad.otherDetails = load.otherDetails ?? "";
          postLoad.loadWeight = load.loadWeight ?? "";
          postLoad.loggedUserName = authProvider.userDetailList[0].userName ?? "";
          postLoad.mainTag = load.mainTag ?? "";
          postLoad.os = "Web";

// Cities
          postLoad.source = load.source ?? "";

// Load type & privacy
          postLoad.partLoad = load.partLoadOrNot ?? 0;
          postLoad.privatePost = load.privatePost ?? 0;

// Rating & customer info
          postLoad.rating = 5.0;
          postLoad.transporterOrCustomerName =
          '${authProvider.userDetailList[0].firstName} ${authProvider.userDetailList[0].lastName}';

// Load types
          postLoad.type = load.type ?? "";
          postLoad.typeOfCargo = load.typeOfCargo ?? "";
          postLoad.typeOfPayment = load.typeOfPayment ?? "";
          postLoad.vehicleSize = load.vehicleSize ?? "";

// Optional values
          postLoad.expireDate = load.expireDate ?? "";
          postLoad.image = "";
          postLoad.tableName = "Full Load";
          postLoad.topicName = "Full Load Truck";

// Repeat settings
          postLoad.isRepeat = 0;
          postLoad.repeatStartDate = DateFormat("yyyy-MM-dd").format(DateTime.now());
          postLoad.repeatEndDate = "";

// Selected user list (group selection)
          postLoad.listOfUserIds = [];

// ID
          postLoad.id = 0;

          dashboardProvider.savePost(context,postLoad


          );
        }
      }

    });
    notifyListeners();
  }

  Timer? timer;
  startTimer(){
    if(timer== null) {
      timer = Timer.periodic(Duration(minutes: 1), (timer) {
      });
    }
  }

  stopTimer(){
    timer!.cancel();
  }

  TruckLoad? truckLoadObj;
  getFullLoadTruckById(int id) async {
    String myUrl = ApiConstant.BASE_URL +'fullTruckLoad/${id}';
    print(myUrl);
    var req = await http.get(Uri.parse(myUrl));
    if(req.statusCode == 200) {
      response = json.decode(req.body);
      var type = LoadModel.fromJson(response);
      truckLoadObj = type.content[0];
      return truckLoadObj;
    }
  }


  String resFromDateCnt = "";
  String TimeCnt = "";
  String resToDateCnt = "";
  String? _hour, _minute, _time;
  String? dateTime;
  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);
  DateTime _date = DateTime.now();

  selectTime(BuildContext context, String timeString) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null) selectedTime = picked;
    _hour = selectedTime.hour.toString();
    _minute = selectedTime.minute.toString();

    _hour = _hour!.length == 1 ? "0$_hour" : _hour;
    _minute = _minute!.length == 1 ? "0$_minute" : _minute;
    _time = _hour! + ' : ' + _minute!;

    if (picked?.periodOffset.toString() == '0') {
      TimeCnt = (_time).toString();
    } else if (picked?.periodOffset.toString() == '12') {
      TimeCnt = (_time).toString();
    }
    notifyListeners();
  }

  selectDate(BuildContext context, String controllerString) async {
    DateTime? _datePicker = await showDatePicker(
      initialDatePickerMode: DatePickerMode.day,
      context: context,
      initialDate: _date,
      firstDate: DateTime(1947),
      lastDate: DateTime(2030),
    );

    if (_datePicker != null && _datePicker != _date) {
      DateTime? date;

      if (controllerString == 'From Date') {
        if (_datePicker.isBefore(DateTime.now())) {
          date = _datePicker;
          resFromDateCnt = DateFormat('dd/MM/yyyy').format(DateTime.now());
          resToDateCnt = DateFormat('dd/MM/yyyy')
              .format(DateTime.now().add(Duration(days: 1)));
        } else {
          date = _datePicker;
          resFromDateCnt = DateFormat('dd/MM/yyyy').format(_datePicker);
          resToDateCnt = DateFormat('dd/MM/yyyy')
              .format(_datePicker.add(Duration(days: 1))); //resFromDateCnt;
        }
      } else if (controllerString == 'To Date') {
        if (_datePicker.isBefore(date!)) {
          resToDateCnt = DateFormat('dd/MM/yyyy').format(_datePicker);
        } else {
          resToDateCnt = DateFormat('dd/MM/yyyy').format(_datePicker);
        }
      }
      notifyListeners();
    }
    return _datePicker;
  }
}
