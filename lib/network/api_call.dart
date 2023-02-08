import 'dart:convert';

import 'package:http/http.dart' as http;
class APIHelper {
  ApiGetData(String URL) async{
    print('url is $URL');
    var req = await http.get(Uri.parse(URL));
    var response = json.decode(req.body);
    print('response $response');
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
    return response;
  }


  Future<int> ApiAddPostDataMapRequest(String url,Map<String,dynamic>data) async{
    var body = json.encode(data);
    final response = await http.post(Uri.parse(url),
        headers: {"Content-Type": "application/json"}, body: body);
    print("response : ${response.statusCode}" + " --- " + response.body.toString());
    return response.statusCode;
  }





}