import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../dialog/animated_custom_dialog.dart';
import '../../../dialog/my_dialog.dart';
import '../../../locator.dart';
import '../../../model/auth_api.dart';
import '../../../network/api_call.dart';
import '../../../provider/auth_provider.dart';
import '../../../provider/dashboard_provider.dart';
import '../../../util/app_constants.dart';
import '../../../util/style.dart';
import '../../base_widget/custom_button.dart';
import '../../base_widget/custom_textfeild.dart';
import 'package:http/http.dart' as http;

class NewDiscussion extends StatefulWidget {

  // const NewDiscussion({Key? key}) : super(key: key);

  @override
  _NewDiscussionState createState() => _NewDiscussionState();
}

class _NewDiscussionState extends State<NewDiscussion> {
  final authProvider = locator<AuthProvider>();
  final _formKey = GlobalKey<FormState>();
  final _toKey = GlobalKey<FormState>();

  TextEditingController additionalinfo = TextEditingController();
  TextEditingController topic = TextEditingController();


  @override
  Widget build(BuildContext context) {
    double screenSize = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.transparent,
      key: _toKey,
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      //   title: Text("New Discussion",style: Style.appheading,),
      //   shadowColor: Colors.white,
      //   leading: IconButton(icon:Icon(Icons.arrow_back,color: Colors.black,),onPressed:(){
      //     Navigator.pop(context,1);
      //   } ,),
      // ),

      body: Center(

        child: Align(
          alignment: Alignment.topCenter,
          child: Container(
            width: screenSize<600?screenSize:screenSize/3,
        child: Form(
          key: _formKey,
          child: Container(
              // margin: ResponsiveWidget.isDesktop(context)? EdgeInsets.symmetric(horizontal: 50,vertical: 10):EdgeInsets.symmetric(horizontal: 0,vertical: 0),
              child: SingleChildScrollView(
                child: Column(
                  children:[
                        AppBar(
                          backgroundColor: Colors.white,
                          title: Text("New Discussion",style: Style.appheading,),
                          shadowColor: Colors.white,
                          leading: IconButton(icon:Icon(Icons.arrow_back,color: Colors.black,),onPressed:(){
                            Navigator.pop(context,1);
                          } ,),
                        ),
                    Container(
                        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        alignment: Alignment.center,
                        child: Text('Requirement you post will be visible on the general board to vendors whose routes match to yours.',style: Style.appsubtitle,)),

                    CustomTextField(
                      hintText: 'Topic Name',
                      textInputType: TextInputType.text,
                      controller: topic,
                    ),
                    CustomTextField(
                      hintText: 'Additional Information',
                      textInputType: TextInputType.multiline,
                      maxLine: 7,
                      controller: additionalinfo,
                    ),
                    CustomButton(
                        onTap: () async{
                            sendPost();
                          },
                        buttonText: "Post Discussion")
                  ],
                ),


              ),
            ),

            ),
          ),
        ),
      ),
    );

  }

  savePost({int? mobile,String? additionalinfo,String? email,int? id,User? userList,String? name,int? userId}) async {

  /*  APIHelper api=APIHelper();
    var result= await api.ApiPOSTData(AppConstants.GET_DISCUSSION);*/
    String myUrl = AppConstants.GET_DISCUSSION;
    print(myUrl);
    Uri uri = Uri.parse(myUrl);
    Map<String, dynamic> data = {
      "contactNumber": mobile?? 0,
      //"date": "2022-07-04T08:55:23.783Z",
      "emailId": email,
      //"loggedTime": "2022-07-04T08:55:23.783Z",
      "loggedUserName": name,
      "description": additionalinfo,
      "topicName": topic,
    };
    var body = json.encode(data);
    print("request : ${data}");
    final response = await http.post(uri,
        headers: {"Content-Type": "application/json"}, body: body);
    print("response : ${response.statusCode}" + " --- " + response.body.toString());
    var jsonData = jsonDecode(response.body);

  }

  void sendPost() async{

    if (_formKey.currentState!.validate()) {

      print('call API');
      Map<String,dynamic>parameter= {
        "contactNumber": authProvider.userDetailList[0].mobileNumber,
        "emailId": authProvider.userDetailList[0].emailId,
        "firstName":authProvider.userDetailList[0].firstName,
        "loggedUserName": authProvider.userDetailList[0].userName,
        'lastName':authProvider.userDetailList[0].lastName,
        'profilePicture':authProvider.userDetailList[0].profilePicture,
        "description":additionalinfo.text.toString() ,
        "topic": topic.text.toString(),
        'companyName':authProvider.userDetailList[0].companyName
      };;
      print('the parameter${parameter}');

      APIHelper apiHelper=APIHelper();
      var result=await apiHelper.ApiAddPostDataMapRequest(AppConstants.GET_DISCUSSION, parameter);
      if(result == 200){
        SnackBar snackBar=SnackBar(content: Text("Discussion post Successfully"),duration: Duration(seconds: 2),);
        await ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Navigator.of(context).pop(1);
      }else{
        SnackBar snackBar=SnackBar(content: Text("Discussion post failed"),duration: Duration(seconds: 2),);
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }

  }


