import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:tkd_app/model/api_response.dart';
import 'package:tkd_app/model/job_model.dart';
import 'package:http/http.dart' as http;
import 'package:tkd_app/model/post_job.dart';
import 'package:tkd_app/network/api_call.dart';
import 'package:tkd_app/provider/auth_provider.dart';
import 'package:tkd_app/util/app_constants.dart';

class JobProvider extends ChangeNotifier{
  List<String> cityList = [];
  List<Job> jobList = [];
  List<Job> candidateList = [];
  List<JobData>listJobs=[];
  var response;
int jobPages = 0;
  int totalpages = 0;
  bool isLoadingJob = false;
  bool isLoadingCandidate = false;

  getCard({int currentPage = 0}) async {
    isLoadingJob = true;
    notifyListeners();
    if(currentPage == 0){
      jobList.clear();
    }
    String myUrl = ApiConstant.JOBS_ALL_CARD +'?type=Job&page=${currentPage}';
    var req = await http.get(Uri.parse(myUrl));
    isLoadingJob = false;
    response = json.decode(req.body);
    var res = JobModel.fromJson(response);
    jobList.addAll(res.content);
    jobPages = res.totalPages;
    notifyListeners();
  }

  getCandidates({int currentPage = 0}) async {
    isLoadingCandidate = true;
    notifyListeners();
    if(currentPage==0){
    candidateList.clear();
    }
    String myUrl = ApiConstant.JOBS_ALL_CARD +'?type=Candidates&page=${currentPage}';
    var req = await http.get(Uri.parse(myUrl));
    isLoadingCandidate = false;
    response = json.decode(req.body);
    var res = JobModel.fromJson(response);
    candidateList.addAll(res.content);
    totalpages = res.totalPages;
    notifyListeners();
  }

  deleteJob(Job job) async {
    String myUrl = ApiConstant.POST_JOB +'?id=${job.id}';
    var req = await http.delete(Uri.parse(myUrl));
    response = json.decode(req.body);
    if(job.type=='Buy Vehicle'){
      jobList.remove(job);
    }
    else{
      candidateList.remove(job);
    }
    notifyListeners();
  }

  Future<List<String>> getCityList() async {
    String myUrl =
        ApiConstant.GET_ALL_CITY;
    var req = await http.get(Uri.parse(myUrl));
    var response = jsonDecode(req.body);
     cityList = response;
    return cityList;
  }

  saveJobs(BuildContext context,{String? salary,String? description,String? experience,String? position,String? jonTitle,AuthProvider? model}) async {
    String myUrl = ApiConstant.POST_JOB;
    Uri uri = Uri.parse(myUrl);
    Map<String, dynamic> data = {
      "companyName": model!.userDetailList[0].companyName,
      "contactNumber": model.userDetailList[0].mobileNumber,
      "emailId": model.userDetailList[0].emailId,
      "experience": experience,
      "isSalaryNegotiable": 1,
      "isSelected": 0,
      "jobDepartment": jonTitle,
      "jobDescription": description,
      "jobLocation": "city",
      "jobType": position,
      "loggedTime":'',// DateFormat("dd/MM/yyyy hh:mm").format(DateTime.now()), //+" "+DateTime.now().hour.toString() +":" +DateTime.now().minute.toString() ,
      "loggedUserName":model.userDetailList[0].userName,
      "mainTag": "Job Seeker",
      "message": description,
      "os": "window",
      "postingTime": '',//DateTime.now(),// DateFormat("dd/MM/yyyy hh:mm").format(DateTime.now()), // +" "+DateTime.now().hour.toString() +":" +DateTime.now().minute.toString() ,
      "privatePost": 0,
      "removedDate": '' ,
      "salary": salary,
      "tableName": " ",
      "topicName": " ",
      "type":  "Job Seeker",
      "userId":model.userDetailList[0].id
    };
    var body = json.encode(data);
    print(data);
    final response = await http.post(uri,
        headers: {"Content-Type": "application/json"}, body: body);
    print("${response.statusCode}" + " --- " + response.body.toString());

    if(response.statusCode==200){
      showSimpleNotification(
          Text("Post job successfull",style: TextStyle(color: Colors.white),),
          background: Colors.black
      );
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    }else{
      showSimpleNotification(
          Text("Please try again",style: TextStyle(color: Colors.white),),
          background: Colors.red
      );
    }
    notifyListeners();
  }

  int selectedPage=0;
  ScrollController scrollController=ScrollController();

  getAllJobs({
    int currentPage = 0,
    String? search,
    String? role,
    String? experience,
    String? salary,
    String? date, String? department,
  }) async {

    isLoadingCandidate = true;
    notifyListeners();

    if (currentPage == 0) {
      listJobs.clear();
    }

    // Base URL
    String baseUrl = ApiConstant.BASE_URL + 'postJob/getAllJobsWithSearch';

    // BUILD QUERY MAP
    Map<String, dynamic> query = {
      "page": currentPage.toString(),
      "size": "20",
    };

    // ONLY ADD NON-NULL AND NON-EMPTY FIELDS
    if (search != null && search.trim().isNotEmpty) query["search"] = search;
    if (role != null && role.trim().isNotEmpty) query["role"] = role;
    if (experience != null && experience.trim().isNotEmpty) query["experience"] = experience;
    if (salary != null && salary.trim().isNotEmpty) query["salary"] = salary;
    if (date != null && date.trim().isNotEmpty) query["date"] = date;
    if (department != null && department.trim().isNotEmpty) query["department"] = department;

    // BUILD FINAL URL
    final uri = Uri.parse(baseUrl).replace(queryParameters: query);
    print("FINAL URL => $uri");

    // CALL API
    ApiResponse apiResponse = await ApiHelper().apiWithoutDecodeGet(uri.toString());
    print("Response ::: ${apiResponse.response}");

    isLoadingCandidate = false;

    if (apiResponse.statusCode == 200) {
      JobList jobList = JobList.fromJson(jsonDecode(apiResponse.response));
      listJobs.addAll(jobList.content!);
      currentPage++;
      notifyListeners();
    }
  }

  pagenation(){
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        getAllJobs(currentPage: 0, search: '');
      }
    });
  }
}