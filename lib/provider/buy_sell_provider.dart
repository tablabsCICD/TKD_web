import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../locator.dart';
import '../model/comman_response.dart';
import '../model/truck_load_model.dart';
import '../network/api_call.dart';
import '../util/app_constants.dart';
import '../view/screens/gallery/image_picker_helper.dart';
import '../widgets/toast.dart';
import 'dashboard_provider.dart';
// adjust if path differs
import 'package:overlay_support/overlay_support.dart';

/// BuySellProvider
/// - Option B: uses ImagePickerHelper().pickAndUploadImage(context) which returns final URL.
/// - Manages buy & sell lists, pagination, image uploads, retries, create post.
/// - Pagination pages start at 0.
class BuySellProvider extends ChangeNotifier {
  BuySellProvider() {
    // initialize first pages
    _buyPage = 0;
    _sellPage = 0;
  }

  // -------------------------
  // Public state
  // -------------------------
  final List<TruckLoad> buyVehicleList = [];
  final List<TruckLoad> sellVehicleList = [];

  /// List of image URLs (final URLs). We keep ordering consistent.
  final List<String> buySellImages = [];

  /// Upload state per index while uploading (true = uploading, false = uploaded/idle)
  final Map<int, bool> _uploading = {};

  /// Upload error flag per index (true => last upload failed)
  final Map<int, String?> _uploadError = {};

  // getters for uploading / error
  bool isUploadingAt(int index) => _uploading[index] == true;
  String? uploadErrorAt(int index) => _uploadError[index];

  // -------------------------
  // Pagination state
  // -------------------------
  int _buyPage = 0;
  int _sellPage = 0;
  int buyTotalPages = 999999; // if server gives total pages, set it
  int sellTotalPages = 999999;
  bool isLoadingForBuyVehicles = false;
  bool isLoadingForSellVehicles = false;

  bool get hasMoreBuy => _buyPage < buyTotalPages - 1;
  bool get hasMoreSell => _sellPage < sellTotalPages - 1;

  // -------------------------
  // Helper providers
  // -------------------------
  final DashboardProvider _dashboardProvider = locator<DashboardProvider>();

  // -------------------------
  // Image upload methods (Option B)
  // -------------------------

  /// Adds a placeholder and starts upload using ImagePickerHelper.
  /// Since helper returns final URL only, we show a simple uploading flag.
  Future<void> uploadBuySellImage(BuildContext context) async {
    try {
      // Prevent adding more than 4 images
      if (buySellImages.length >= 4) {
        showSimpleNotification(
          const Text("Maximum 4 images allowed"),
          background: Colors.orange,
        );
        return;
      }

      // mark a new index as uploading and show placeholder (empty string)
      final int newIndex = buySellImages.length;
      buySellImages.add(''); // placeholder
      _uploading[newIndex] = true;
      _uploadError[newIndex] = null;
      notifyListeners();

      // call helper which picks file and uploads, returning final URL (Option B)
      String? uploadedUrl = await ImagePickerHelper().pickAndUploadImage(context);

      if (uploadedUrl != null && uploadedUrl.isNotEmpty) {
        buySellImages[newIndex] = uploadedUrl;
        _uploading[newIndex] = false;
        _uploadError[newIndex] = null;
        notifyListeners();
      } else {
        // upload failed or cancelled
        buySellImages.removeAt(newIndex);
        _uploading.remove(newIndex);
        _uploadError.remove(newIndex);
        notifyListeners();

        showSimpleNotification(
          const Text("Image upload cancelled or failed"),
          background: Colors.red,
        );
      }
    } catch (e) {
      // find last placeholder index (if any)
      final int idx = buySellImages.indexOf('');
      if (idx >= 0) {
        _uploading[idx] = false;
        _uploadError[idx] = e.toString();
      }
      notifyListeners();
      showSimpleNotification(
        Text("Upload error: $e"),
        background: Colors.red,
      );
    }
  }

  /// Retry upload for a given index (re-uploads and replaces URL).
  Future<void> retryUploadImage(BuildContext context, int index) async {
    if (index < 0 || index >= buySellImages.length) return;

    // replace current value with placeholder and set uploading
    buySellImages[index] = '';
    _uploading[index] = true;
    _uploadError[index] = null;
    notifyListeners();

    try {
      final String? uploadedUrl = await ImagePickerHelper().pickAndUploadImage(context);
      if (uploadedUrl != null && uploadedUrl.isNotEmpty) {
        buySellImages[index] = uploadedUrl;
        _uploading[index] = false;
        _uploadError[index] = null;
        notifyListeners();
      } else {
        _uploading[index] = false;
        _uploadError[index] = "Upload cancelled";
        // keep placeholder removed
        buySellImages.removeAt(index);
        _uploading.remove(index);
        notifyListeners();

        showSimpleNotification(
          const Text("Upload cancelled"),
          background: Colors.orange,
        );
      }
    } catch (e) {
      _uploading[index] = false;
      _uploadError[index] = e.toString();
      notifyListeners();

      showSimpleNotification(
        Text("Retry upload failed: $e"),
        background: Colors.red,
      );
    }
  }

  /// Remove image at index
  void removeImage(int index) {
    if (index < 0 || index >= buySellImages.length) return;
    buySellImages.removeAt(index);

    // shift _uploading and _uploadError maps down one index for keys greater than index
    final Map<int, bool> newUploading = {};
    final Map<int, String?> newErrors = {};
    int pos = 0;
    for (int i = 0; i <= buySellImages.length; i++) {
      if (_uploading.containsKey(i) && i != index) {
        newUploading[pos] = _uploading[i] ?? false;
        newErrors[pos] = _uploadError[i];
        pos++;
      }
    }
    _uploading
      ..clear()
      ..addAll(newUploading);
    _uploadError
      ..clear()
      ..addAll(newErrors);

    notifyListeners();
  }

  // -------------------------
  // GET LISTS (pagination)
  // -------------------------

  /// Get Buy vehicles (page starts at 0).
  /// If page == 0, it will clear existing list and reload.
  Future<void> getBuyVehicles({
    int currentPage = 0,
    String? companyName,
    String? nameOfPerson,
    String? location,
    String? model,
    String? mfgYear,
    String? vehicleSize,
    int? minPrice,
    int? maxPrice,
    String? searchText,
  }) async {
    try {
      if (isLoadingForBuyVehicles) return;

      isLoadingForBuyVehicles = true;
      notifyListeners();

      if (currentPage == 0) {
        buyVehicleList.clear();
        _buyPage = 0;
      }

      // -------------------------------
      // 🔥 BUILD PARAMETERS DYNAMICALLY
      // -------------------------------
      Map<String, String> params = {
        "type": "Buy",
        "page": currentPage.toString(),
        "size": "20",
      };

      if (searchText != null && searchText.trim().isNotEmpty)
        params["search"] = searchText;

      if (companyName != null && companyName.trim().isNotEmpty)
        params["companyName"] = companyName;

      if (nameOfPerson != null && nameOfPerson.trim().isNotEmpty)
        params["nameOfPerson"] = nameOfPerson;

      if (location != null && location.trim().isNotEmpty)
        params["location"] = location;

      if (model != null && model.trim().isNotEmpty)
        params["model"] = model;

      if (mfgYear != null && mfgYear.trim().isNotEmpty)
        params["mfgYear"] = mfgYear;

      if (vehicleSize != null && vehicleSize.trim().isNotEmpty)
        params["vehicleSize"] = vehicleSize;

      if (minPrice != null)
        params["minPrice"] = minPrice.toString();

      if (maxPrice != null)
        params["maxPrice"] = maxPrice.toString();

      // -------------------------------
      // 🔥 BUILD FINAL URL
      // -------------------------------
      final uri = Uri.parse(ApiConstant.BUY_SELL_ALL_CARD)
          .replace(queryParameters: params);

      print("BUY VEHICLES URL: $uri");

      // -------------------------------
      // 🔥 CALL API
      // -------------------------------
      final res = await http.get(uri);

      if (res.statusCode == 200) {
        final Map<String, dynamic> js = jsonDecode(res.body);

        final TruckLoadType type = TruckLoadType.fromJson(js);

        if (currentPage == 0) buyVehicleList.clear();
        buyVehicleList.addAll(type.content);

        // Only increment page if more data comes
        if (type.content.isNotEmpty) {
          _buyPage = currentPage + 1;
        }
      } else {
        showSimpleNotification(
          const Text("Failed to fetch buy vehicles"),
          background: Colors.red,
        );
      }
    } catch (e) {
      debugPrint("getBuyVehicles error: $e");
    } finally {
      isLoadingForBuyVehicles = false;
      notifyListeners();
    }
  }

  /// Get Sell vehicles (page starts at 0).
  Future<void> getSellVehicles({
    int currentPage = 0,
    String? companyName,
    String? nameOfPerson,
    String? location,
    String? model,
    String? mfgYear,
    String? vehicleSize,
    int? minPrice,
    int? maxPrice,
    String? searchText,
  }) async {
    try {
      if (isLoadingForSellVehicles) return;

      isLoadingForSellVehicles = true;
      notifyListeners();

      if (currentPage == 0) {
        sellVehicleList.clear();
        _sellPage = 0;
      }

      // -------------------------------
      // 🔥 BUILD PARAMETERS DYNAMICALLY
      // -------------------------------
      Map<String, String> params = {
        "type": "Sell",
        "page": currentPage.toString(),
        "size": "20",
      };

      if (searchText != null && searchText.trim().isNotEmpty)
        params["searchText"] = searchText;

      if (companyName != null && companyName.trim().isNotEmpty)
        params["companyName"] = companyName;

      if (nameOfPerson != null && nameOfPerson.trim().isNotEmpty)
        params["nameOfPerson"] = nameOfPerson;

      if (location != null && location.trim().isNotEmpty)
        params["location"] = location;

      if (model != null && model.trim().isNotEmpty)
        params["model"] = model;

      if (mfgYear != null && mfgYear.trim().isNotEmpty)
        params["mfgYear"] = mfgYear;

      if (vehicleSize != null && vehicleSize.trim().isNotEmpty)
        params["vehicleSize"] = vehicleSize;

      if (minPrice != null)
        params["minPrice"] = minPrice.toString();

      if (maxPrice != null)
        params["maxPrice"] = maxPrice.toString();

      // -------------------------------
      // 🔥 BUILD FINAL URL
      // -------------------------------
      final uri = Uri.parse(ApiConstant.BUY_SELL_ALL_CARD)
          .replace(queryParameters: params);

      print("SELL VEHICLES URL => $uri");

      final res = await http.get(uri);

      // -------------------------------
      // 🔥 HANDLE RESPONSE
      // -------------------------------
      if (res.statusCode == 200) {
        final Map<String, dynamic> js = jsonDecode(res.body);

        final TruckLoadType type = TruckLoadType.fromJson(js);

        if (currentPage == 0) sellVehicleList.clear();

        sellVehicleList.addAll(type.content);

        // increment page only if content exists
        if (type.content.isNotEmpty) {
          _sellPage = currentPage + 1;
        }
      } else {
        showSimpleNotification(
          const Text("Failed to fetch sell vehicles"),
          background: Colors.red,
        );
      }
    } catch (e) {
      debugPrint("getSellVehicles error: $e");
    } finally {
      isLoadingForSellVehicles = false;
      notifyListeners();
    }
  }


  /// convenience: load next page if available
  Future<void> loadMoreBuy() async {
    if (!hasMoreBuy) return;
    await getBuyVehicles(currentPage: _buyPage + 1);
  }

  Future<void> loadMoreSell() async {
    if (!hasMoreSell) return;
    await getSellVehicles(currentPage: _sellPage + 1);
  }

  // -------------------------
  // CREATE BUY/SELL
  // -------------------------
  /// Mirrors the mobile `createBuySell()` behavior (uses same body keys).
  /// Returns true on success and false on failure.
  Future<bool> createBuySell({
    required BuildContext context,
    required int userId,
    required String description,
    required String agentName,
    required String bodyType,
    required String buySellType,
    required String city,
    required String conditionOfTyre,
    required String conditionOfVehicle,
    required String mobile,
    required String price,
    required String mainTag,
    required String maker,
    required String mfgYear,
    required String model,
    required String loggedUserName,
    required String owner,
    required String registrationNumber,
    required String yearOfBuying,
      required List<String> images,
  }) async {
    try {
      final String url = ApiConstant.POST_BUY_SELL;

      // prepare payload like mobile code
      Map<String, dynamic> data = {
        "additionalInformation": description,
        "agentName": agentName,
        "bodyType": bodyType,
        "buySelltype": buySellType,
        "city": city,
        "conditionOfTyres": conditionOfTyre,
        "conditionOfVehicle": conditionOfVehicle,
        "contactNumber": mobile,
        "date": "2022-01-22T11:29:53.473Z",
        "estimatedPrice": price,
        "id": 0,
        "image1": images.isNotEmpty ? images[0] : "",
        "image2": images.length > 1 ? images[1] : "",
        "image3": images.length > 2 ? images[2] : "",
        "image4": images.length > 3 ? images[3] : "",
        "insaurancePaidUpto": mfgYear,
        "loggedTime": "2022-01-22T11:29:53.473Z",
        "loggedUserName": loggedUserName,
        "mainTag": buySellType,
        "maker": maker,
        "mfgYear": mfgYear,
        "model": model,
        "negotiable": 0,
        "os": "",
        "ownerName": owner,
        "postingTime": "2022-01-22T11:29:53.473Z",
        "privatePost": 0,
        "tableName": "Buy/Sell",
        "topicName": "",
        "type": buySellType,
        "userId": userId,
        "vehicleRegistrationNumber": registrationNumber,
        "yearOfBuying": yearOfBuying,
      };

      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );

      debugPrint("CreateBuySell response: ${response.statusCode} -> ${response.body}");

      if (response.statusCode == 200) {
        final jsonRes = jsonDecode(response.body);

        // If API returns 401 statusCode in body (mobile already handles this case)
        if (jsonRes is Map && jsonRes['statusCode'] == 401) {
          ToastMessage.show(context, "Please update your package");
          // optionally navigate to package page here
          return false;
        }

        // Parse TruckLoad / PostUpload object (mobile used PostUpload)
        try {
          // Some endpoints return object representing created post; try both
          // 1) Try parsing TruckLoad directly
          final TruckLoad created = TruckLoad.fromJson(jsonRes);
          // Add created to respective list
          if (buySellType == 'Buy Vehicle') {
            buyVehicleList.insert(0, created);
          } else {
            sellVehicleList.insert(0, created);
          }

          // Clear local images after successful submit
          buySellImages.clear();
          _uploading.clear();
          _uploadError.clear();

          notifyListeners();
          return true;
        } catch (e) {
          // If parsing fails, fallback to success message check
          // If jsonRes contains message/success flag, consider success
          if ((jsonRes is Map && (jsonRes['message'] != null || jsonRes['success'] == true))) {
            // Refresh lists
            await refreshLists();
            buySellImages.clear();
            _uploading.clear();
            _uploadError.clear();
            notifyListeners();
            return true;
          }

          // final fallback: treat as failure
          ToastMessage.show(context, "Post created but response couldn't be parsed");
          return false;
        }
      } else {
        ToastMessage.show(context, "Please try again");
        return false;
      }
    } catch (e) {
      debugPrint("createBuySell error: $e");
      ToastMessage.show(context, "Something went wrong");
      return false;
    }
  }

  // -------------------------
  // DELETE
  // -------------------------
  Future<void> deleteBuySell(int id, int index, bool isBuy) async {
    final String url = "${ApiConstant.POST_BUY_SELL}?id=$id";
    try {
      final res = await http.delete(Uri.parse(url));
      debugPrint("deleteBuySell status: ${res.statusCode}");
      if (res.statusCode == 200) {
        if (isBuy) {
          if (index >= 0 && index < buyVehicleList.length) buyVehicleList.removeAt(index);
        } else {
          if (index >= 0 && index < sellVehicleList.length) sellVehicleList.removeAt(index);
        }
        notifyListeners();
        // refresh dashboard counts if needed
        _dashboardProvider.getFullLoadTruckList("From", "To");
      } else {
        showSimpleNotification(
          const Text("Failed to delete post"),
          background: Colors.red,
        );
      }
    } catch (e) {
      debugPrint("deleteBuySell error: $e");
    }
  }

  // -------------------------
  // Refresh helper
  // -------------------------
  Future<void> refreshLists() async {
    await Future.wait([
      getBuyVehicles(currentPage: 0),
      getSellVehicles(currentPage: 0),
    ]);
  }
}
