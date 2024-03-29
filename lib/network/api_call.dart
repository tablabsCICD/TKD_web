import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:tkd_app/model/api_response.dart';
class ApiHelper {


  Future<ApiResponse> apiWithoutDecodeGet(String URL) async{
    try{
      var request = await http.get(Uri.parse(URL));
      ApiResponse apiResponseHelper = returnNotDecodeResponse(request);
      return apiResponseHelper;
    }catch (e){
      print(e);
      return ApiResponse(500, null);
    }

  }

  ApiResponse returnNotDecodeResponse<T>(Response request){
    if(request.statusCode==200){

      ApiResponse apiResponseHelper = ApiResponse(request.statusCode!, request.body);
      return apiResponseHelper;
    }else{
      ApiResponse apiResponseHelper = ApiResponse(request.statusCode!, null);
      return apiResponseHelper;
    }
  }

  ApiGetData(String URL) async{
    var req = await http.get(Uri.parse(URL));

    var response = json.decode(req.body);
    print('$URL response ${response}');
    return response;
  }

  ApiPOSTData(String URL) async{
    var req = await http.post(Uri.parse(URL));
    var response = json.decode(req.body);
    return response;
  }
  ApiPostData(String URL) async{
    var req = await http.post(Uri.parse(URL));
    var response = json.decode(req.body);
    print("Post response:::"+response);
    return response;
  }
  ApiPutData(String URL) async{
    var req = await http.put(Uri.parse(URL));
    var response = json.decode(req.body);
    return response;
  }

  ApiDeleteData(String URL) async{
    var req = await http.delete(Uri.parse(URL));
    var response = json.decode(req.body);
    return req.statusCode;
  }


  Future<dynamic> ApiAddPostDataMapRequest(String url,Map<String,dynamic>data) async{
    var body = json.encode(data);
    final response = await http.post(Uri.parse(url),
        headers: {"Content-Type": "application/json"}, body: body);
    print("response : ${response.statusCode}" + " --- " + response.body.toString());
    return response;
  }


  Future<dynamic> ApiPutDataMapRequest(String url,Map<String,dynamic>data) async{
    var body = json.encode(data);
    final response = await http.put(Uri.parse(url),
        headers: {"Content-Type": "application/json"}, body: body);
    print("response : ${response.statusCode}" + " --- " + response.body.toString());
    return response;
  }


  Future<ApiResponse> ApiAddPostDataMapRequestCall(String url,Map<String,dynamic>data) async{
    var body = json.encode(data);
    final request = await http.post(Uri.parse(url),headers: {"Content-Type": "application/json"}, body: body);
    var response = json.decode(request.body);
    print('the status code is ${request.statusCode}');
    ApiResponse apiResponseHelper = ApiResponse(request.statusCode, response);
    return apiResponseHelper;
  }




}