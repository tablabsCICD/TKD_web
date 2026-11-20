import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../locator.dart';
import '../model/api_response.dart';
import '../model/auth_api.dart';
import '../model/getAllReportIncidentResponse.dart';
import '../model/request/reportIncidentRequest.dart';
import '../network/api_call.dart';
import '../util/app_constants.dart';
import '../view/screens/gallery/image_picker_helper.dart';
import '../widgets/toast.dart';
import 'auth_provider.dart';

class ReportIncidentProvider extends ChangeNotifier {
  ReportIncidentProvider() {
    loadAllIncidents();
  }

  // =========================================================================
  // STATE VARIABLES
  // =========================================================================

  bool isLoading = false;
  bool isSearching = false;
  bool isMyIncident = false;

  int page = 0;                // Future pagination support
  bool hasMore = true;         // Tracks if more data exists

  List<IncidentObject> allIncidents = [];
  List<IncidentObject> backupIncidents = [];

  // Form Fields
  TextEditingController vehicleNo = TextEditingController();
  TextEditingController incidentLocation = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController amountLost = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  TextEditingController searchController = TextEditingController();

  List<String> incidentTypes = [];
  List<String> cheatedByList = [];
  bool? isFirLaunched;
  bool isAccepted = false;

  List<String> images = [];

  final authProvider = locator<AuthProvider>();

  // =========================================================================
  // LOADING HELPERS
  // =========================================================================

  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  void setSearching(bool value) {
    isSearching = value;
    notifyListeners();
  }

  // =========================================================================
  // TOGGLE ALL / MY INCIDENTS
  // =========================================================================

  void toggleMyIncidents(bool value, BuildContext context) {
    isMyIncident = value;

    if (value) {
      loadMyIncidents(context);
    } else {
      loadAllIncidents(reset: true);
    }
  }

  // =========================================================================
  // LOAD ALL INCIDENTS
  // =========================================================================

  Future<void> loadAllIncidents({bool reset = false}) async {
    if (reset) {
      page = 0;
      allIncidents.clear();
      backupIncidents.clear();
      hasMore = true;
    }

    if (!hasMore) return;

    setLoading(true);
    final url = ApiConstant.GET_REPORT_LIST(page);
    print("Fetching all incidents → $url");

    try {
      final res = await http.get(Uri.parse(url));

      if (res.statusCode == 200) {
        final jsonMap = jsonDecode(res.body);

        if (jsonMap is Map && jsonMap.containsKey("content")) {
          List<dynamic> list = jsonMap["content"];

          if (list.isNotEmpty) {
            final incidents =
            list.map((e) => IncidentObject.fromJson(e)).toList();

            allIncidents.addAll(incidents);
            backupIncidents.addAll(incidents);
            page++;
          } else {
            hasMore = false;
          }
        }
      }
    } catch (e) {
      print("ERROR LOADING ALL INCIDENTS → $e");
    }

    setLoading(false);
  }

  // =========================================================================
  // LOAD MY INCIDENTS
  // =========================================================================

  Future<void> loadMyIncidents(BuildContext context) async {
    setLoading(true);

    try {
      final user = await authProvider.getLoginData();
      final url = ApiConstant.MY_INCIDENT(user.id);

      print("Fetching my incidents → $url");

      final res = await http.get(Uri.parse(url));

      if (res.statusCode == 200) {
        final jsonMap = jsonDecode(res.body);

        if (jsonMap is Map && jsonMap.containsKey("content")) {
          List<dynamic> list = jsonMap["content"];

          allIncidents.clear();

          if (list.isNotEmpty) {
            final myIncList =
            list.map((e) => IncidentObject.fromJson(e)).toList();
            allIncidents.addAll(myIncList);
          }
        }
      } else {
        ToastMessage.show(context, "Failed to fetch your incidents");
      }
    } catch (e) {
      print("ERROR LOADING MY INCIDENTS → $e");
    }

    setLoading(false);
  }

  // =========================================================================
  // SEARCH INCIDENTS
  // =========================================================================

  Future<void> searchIncidents() async {
    final query = searchController.text.trim();

    if (query.length < 3) {
      allIncidents = List.from(backupIncidents);
      notifyListeners();
      return;
    }

    setSearching(true);

    try {
      final user = await authProvider.getLoginData();
      final url = ApiConstant.SEARCH_REPORT(query, user.id);

      print("SEARCH URL → $url");

      final res = await http.get(Uri.parse(url));

      if (res.statusCode == 200) {
        final jsonResponse = jsonDecode(res.body);

        if (jsonResponse is Map && jsonResponse["content"] is List) {
          allIncidents = (jsonResponse["content"] as List)
              .map((e) => IncidentObject.fromJson(e))
              .toList();
        } else {
          print("Unexpected search response structure");
          allIncidents = [];
        }
      }
    } catch (e) {
      print("SEARCH ERROR → $e");
    }

    setSearching(false);
  }


  // =========================================================================
  // ADD INCIDENT
  // =========================================================================
  String? selectedApiDate;

  Future<void> addIncident(BuildContext context) async {
    final user = await authProvider.getLoginData();

    String cheatedByStr = cheatedByList.join(", ");
    String incidentTypeStr = incidentTypes.join(", ");

    final req = ReportIncidentRequest(
      userId: user.id,
      topic: incidentTypes.isNotEmpty ? incidentTypes.first : "",
      image: (isFirLaunched == true && images.isNotEmpty) ? images.first : null,
      date: selectedApiDate,
      description: description.text,
      isResolved: false,
      amountLost: amountLost.text,
      vehicleNumber: vehicleNo.text,
      cheatedBy: cheatedByStr,
      incidentType: incidentTypeStr,
      isFirLounched: isFirLaunched,
      resolutionDetails: "",
    );
    var body = json.encode(req);
    print(ApiConstant.ADD_REPORT);
    print("Request::::"+body.toString());
    final response = await http.post(Uri.parse(ApiConstant.ADD_REPORT),
        headers: {"Content-Type": "application/json"}, body: body);
    print("Response::::"+response.body);
    print("Response::::"+response.statusCode.toString());
    if (response.statusCode == 200) {
      ToastMessage.show(context, "Incident reported successfully!");
      toggleMyIncidents(true, context);
      Navigator.pop(context);
    } else {
      ToastMessage.show(context, "Something went wrong");
    }
  }

  // =========================================================================
  // DELETE INCIDENT
  // =========================================================================

  Future<void> deleteIncident(
      IncidentObject incident, BuildContext context) async {
    final url = ApiConstant.DELETE_INCIDENT(incident.id);

    final res = await ApiHelper().ApiDeleteData(url);

    if (res.statusCode == 200) {
      ToastMessage.show(context, "Incident deleted");
      toggleMyIncidents(true, context);
    } else {
      ToastMessage.show(context, "Delete failed");
    }
  }

  // =========================================================================
  // FORM HELPERS
  // =========================================================================

  void toggleIncidentType(String type) {
    incidentTypes.contains(type)
        ? incidentTypes.remove(type)
        : incidentTypes.add(type);
    notifyListeners();
  }

  void toggleCheatedBy(String value) {
    cheatedByList.contains(value)
        ? cheatedByList.remove(value)
        : cheatedByList.add(value);
    notifyListeners();
  }

  void setFirStatus(bool? value) {
    isFirLaunched = value;
    notifyListeners();
  }

  void setAccepted(bool value) {
    isAccepted = value;
    notifyListeners();
  }

  void addImage(String url) {
    images.add(url);
    notifyListeners();
  }

  // Use your existing ImagePickerHelper upload
  Future<void> uploadImage(BuildContext context) async {
    try {
      String? image = await ImagePickerHelper().pickAndUploadImage(context);

      if (image != null && image.isNotEmpty) {
        images.add(image);
        print("Image uploaded successfully: $image");
        notifyListeners();
      } else {
        print("Image upload failed or cancelled.");
      }
    } catch (e) {
      print("Upload error: $e");
    }
  }


  void clearForm() {
    incidentTypes.clear();
    cheatedByList.clear();
    isFirLaunched = null;
    isAccepted = false;

    vehicleNo.clear();
    incidentLocation.clear();
    description.clear();
    amountLost.clear();
    dateController.clear();
    phoneController.clear();
    images.clear();

    notifyListeners();
  }
}
