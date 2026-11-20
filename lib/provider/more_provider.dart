// more_provider.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:http/http.dart' as http;
import 'package:tkd_app/locator.dart';
import 'package:tkd_app/model/api_response.dart';
import 'package:tkd_app/model/comman_response.dart';
import 'package:tkd_app/model/feedback_model.dart';
import 'package:tkd_app/model/gallary_model.dart';
import 'package:tkd_app/model/my_job_list.dart';
import 'package:tkd_app/model/pool_purchase_model.dart';
import 'package:tkd_app/model/truck_load_model.dart';
import 'package:tkd_app/network/api_call.dart';
import 'package:tkd_app/provider/auth_provider.dart';
import 'package:tkd_app/provider/buy_sell_provider.dart';
import 'package:tkd_app/provider/dashboard_provider.dart';
import 'package:tkd_app/util/app_constants.dart';

import '../model/discussion_model.dart';

class MoreProvider extends ChangeNotifier {
  // --- Dependencies ---
  final DashboardProvider dashboardProvider = locator<DashboardProvider>();
  final BuySellProvider buySellProvider = locator<BuySellProvider>();
  final AuthProvider authProvider = locator<AuthProvider>();

  // --- Lists ---
  final List<TruckLoad> allPostList = [];
  final List<TruckLoad> myFullLoadTypeList = [];
  final List<TruckLoad> myPartLoadTypeList = [];
  final List<MyJobData> myJobList = [];
  final List<TruckLoad> myBuyVehicleList = [];
  final List<PoolPurchase> myPoolPurchaseList = [];
  final List<Gallery> myGalleryList = [];
  final List<FeedBack> feedbackList = [];
  final List<FeedBack> fullLoadFeedbackList = [];
  final List<FeedBack> partLoadFeedbackList = [];
  final List<FeedBack> galleryFeedbackList = [];
  final List<FeedBack> buySellFeedbackList = [];
  final List<DiscussionContent> discussionList = [];

  // --- States & flags ---
  bool isMoreLoading = false;
  bool isMoreFirstLoading = false;
  bool isFeedbackLoading = false;
  bool isFirstFeedbackLoading = false;
  bool isRepostLoading = false;

  // Fine-grained flags (kept if other code uses them)
  bool jobFlag = false,
      fullLoadFlag = false,
      buySellFlag = false,
      poolPurchaseFlag = false,
      partLoadFlag = false,
      galleryFlag = false;

  // cached requirement detail
  TruckLoad? truckLoad;

  // Helper - show overlay notification
  void _notify(String text, {Color background = Colors.black}) {
    showSimpleNotification(Text(text, style: TextStyle(color: Colors.white)), background: background);
  }

  // -----------------------
  // HTTP helpers
  // -----------------------
  Future<http.Response> _get(String url) async {
    final uri = Uri.parse(url);
    return await http.get(uri);
  }

  Future<http.Response> _post(String url, {Object? body}) async {
    final uri = Uri.parse(url);
    if (body == null) return await http.post(uri);
    return await http.post(uri, headers: {"Content-Type": "application/json"}, body: jsonEncode(body));
  }

  Future<http.Response> _delete(String url) async {
    final uri = Uri.parse(url);
    return await http.delete(uri);
  }

  // -----------------------
  // Get own posts (paged)
  // -----------------------
  Future<void> getOwnPostList(String userId, {int currentPage = 0, int size = 100}) async {
    try {
      if (currentPage == 0) {
        isMoreFirstLoading = true;
        allPostList.clear();
        myFullLoadTypeList.clear();
        myPartLoadTypeList.clear();
        myBuyVehicleList.clear();
        notifyListeners();
      } else {
        isMoreLoading = true;
        notifyListeners();
      }

      final String url = '${ApiConstant.GET_OWNPOST}?userId=${userId}&page=$currentPage&size=$size';
      print(url);
      final res = await _get(url);

      if (res.statusCode == 200) {
        final decoded = json.decode(res.body);
        final type = TruckLoadType.fromJson(decoded);

        // append or set
        if (currentPage == 0) allPostList.clear();
        allPostList.addAll(type.content ?? []);

        // split lists
        myFullLoadTypeList.clear();
        myPartLoadTypeList.clear();
        myBuyVehicleList.clear();

        for (final p in allPostList) {
          if (p.type == 'Full Load')
            myFullLoadTypeList.add(p);
          else if (p.type == 'Part Load')
            myPartLoadTypeList.add(p);
          else if (p.type == 'Jobs')
            continue; // jobs handled separately
          else
            myBuyVehicleList.add(p);
        }
      } else {
        _notify('Failed to fetch posts', background: Colors.red);
      }
    } catch (e) {
      _notify('Something went wrong while fetching posts', background: Colors.red);
    } finally {
      isMoreLoading = false;
      isMoreFirstLoading = false;
      notifyListeners();
    }
  }

  // -----------------------
  // Get own job list
  // -----------------------
  Future<void> getOwnJobList(String userId, {int currentPage = 0}) async {
    try {
      if (currentPage == 0) myJobList.clear();
      notifyListeners();

      final url = '${ApiConstant.BASE_URL}getPostJobsByUserId/${authProvider.userDetailList[0].id}';
      final res = await _get(url);

      if (res.statusCode == 200) {
        final decoded = jsonDecode(res.body);
        final jobList = MyJobList.fromJson(decoded);
        myJobList.addAll(jobList.data ?? []);
      } else {
        _notify('Failed to fetch jobs', background: Colors.red);
      }
    } catch (e) {
      _notify('Error fetching jobs', background: Colors.red);
    } finally {
      notifyListeners();
    }
  }

  // -----------------------
  // Repost (normal)
  // adds loader, refresh list on success
  // -----------------------
  Future<bool> reSendPost(BuildContext context, TruckLoad postBidData) async {
    isRepostLoading = true;
    notifyListeners();
    try {
      final url = '${ApiConstant.BASE_URL}repost?id=${postBidData.id}&interchange=false';
      final res = await _post(url);

      if (res.statusCode == 200) {
        final jsonData = jsonDecode(res.body);
        final CommonResponse commonResponse = CommonResponse.fromJson(jsonData);

        if (commonResponse.success == true) {
          // refresh lists
          await getOwnPostList(authProvider.userDetailList[0].id.toString(), currentPage: 0);
          _notify("Re-post submitted successfully!", background: Colors.black);
          return true;
        } else {
          _notify(commonResponse.message ?? 'Failed', background: Colors.orange);
          return false;
        }
      } else if (res.statusCode == 402) {
        _notify("Please update your package", background: Colors.orange);
        return false;
      } else {
        _notify("Please try again", background: Colors.red);
        return false;
      }
    } catch (e) {
      _notify("Error while reposting", background: Colors.red);
      return false;
    } finally {
      isRepostLoading = false;
      notifyListeners();
    }
  }

  // -----------------------
  // Repost with interchange (city interchange)
  // -----------------------
  Future<bool> interChnageSendPost(BuildContext context, TruckLoad postBidData) async {
    isRepostLoading = true;
    notifyListeners();
    try {
      final url = '${ApiConstant.BASE_URL}repost?id=${postBidData.id}&interchange=true';
      final res = await _post(url);

      if (res.statusCode == 200) {
        await getOwnPostList(authProvider.userDetailList[0].id.toString(), currentPage: 0);
        _notify("Intercity post submitted successfully!", background: Colors.black);
        return true;
      } else {
        _notify("Please try again", background: Colors.red);
        return false;
      }
    } catch (e) {
      _notify("Error while reposting (interchange)", background: Colors.red);
      return false;
    } finally {
      isRepostLoading = false;
      notifyListeners();
    }
  }

  // -----------------------
  // Get requirement details (single)
  // -----------------------
  Future<TruckLoad?> getRequirementDetails(int id) async {
    try {
      final url = '${ApiConstant.BASE_URL}fullTruckLoad/$id';
      final res = await _get(url);
      if (res.statusCode == 200) {
        final decoded = json.decode(res.body);
        final list = TruckLoadType.fromJson(decoded);
        truckLoad = list.content.first;
        notifyListeners();
        return truckLoad;
      } else {
        _notify('Failed to fetch requirement details', background: Colors.red);
        return null;
      }
    } catch (e) {
      _notify('Error fetching requirement details', background: Colors.red);
      return null;
    }
  }

  // -----------------------
  // Delete full load (and refresh)
  // -----------------------
  Future<bool> deleteFullLoad(int id, int index) async {
    try {
      final url = '${ApiConstant.BASE_URL}fullTruckLoad?id=$id';
      final res = await _delete(url);

      if (res.statusCode == 200) {
        myFullLoadTypeList.removeWhere((e) => e.id == id);
        myPartLoadTypeList.removeWhere((e) => e.id == id);
        allPostList.removeWhere((e) => e.id == id);

        // refresh
        await getOwnPostList(authProvider.userDetailList[0].id.toString(), currentPage: 0);
        _notify('Post deleted', background: Colors.black);
        return true;
      } else {
        _notify('Failed to delete post', background: Colors.red);
        return false;
      }
    } catch (e) {
      _notify('Error deleting post', background: Colors.red);
      return false;
    } finally {
      notifyListeners();
    }
  }

  // -----------------------
  // Delete job
  // -----------------------
  Future<bool> deleteJob(MyJobData job) async {
    try {
      if (job.postJob == null || job.postJob!.id == null) {
        _notify('Invalid job id', background: Colors.red);
        return false;
      }

      final url = '${ApiConstant.POST_JOB}?id=${job.postJob!.id}';
      final res = await _delete(url);

      if (res.statusCode == 200) {
        myJobList.removeWhere((j) => j.postJob?.id == job.postJob?.id);
        _notify('Job deleted', background: Colors.black);
        notifyListeners();
        return true;
      } else {
        _notify('Failed to delete job', background: Colors.red);
        return false;
      }
    } catch (e) {
      _notify('Error deleting job', background: Colors.red);
      return false;
    }
  }

  // -----------------------
  // Delete buy/sell
  // -----------------------
  Future<bool> deleteBuySell(int id, int index) async {
    try {
      final url = '${ApiConstant.POST_BUY_SELL}?id=$id';
      final res = await _delete(url);

      if (res.statusCode == 200) {
        myBuyVehicleList.removeWhere((e) => e.id == id);
        buySellProvider.notifyListeners();
        _notify('Post deleted', background: Colors.black);
        notifyListeners();
        return true;
      } else {
        _notify('Failed to delete buy/sell post', background: Colors.red);
        return false;
      }
    } catch (e) {
      _notify('Error deleting buy/sell post', background: Colors.red);
      return false;
    }
  }

  // -----------------------
  // Delete gallery
  // -----------------------
  Future<bool> deleteGallery(Gallery gallery) async {
    try {
      final url = '${ApiConstant.GALLERY}?id=${gallery.id}';
      final res = await _delete(url);
      if (res.statusCode == 200) {
        myGalleryList.removeWhere((g) => g.id == gallery.id);
        _notify('Gallery item deleted', background: Colors.black);
        notifyListeners();
        return true;
      } else {
        _notify('Failed to delete gallery item', background: Colors.red);
        return false;
      }
    } catch (e) {
      _notify('Error deleting gallery', background: Colors.red);
      return false;
    }
  }

  // -----------------------
  // Delete pool purchase
  // -----------------------
  Future<bool> deletePoolPurchase(PoolPurchase obj) async {
    try {
      final url = '${ApiConstant.BULK_DATA}?id=${obj.id}';
      final res = await _delete(url);
      if (res.statusCode == 200) {
        myPoolPurchaseList.removeWhere((p) => p.id == obj.id);
        _notify('Pool purchase deleted', background: Colors.black);
        notifyListeners();
        return true;
      } else {
        _notify('Failed to delete pool purchase', background: Colors.red);
        return false;
      }
    } catch (e) {
      _notify('Error deleting pool purchase', background: Colors.red);
      return false;
    }
  }

  // -----------------------
  // Get pool purchase list
  // -----------------------
  Future<void> getPoolPurchaseList(String userName, {int page = 0, int size = 50}) async {
    try {
      final url = '${ApiConstant.BULK_DATA}/byUserName?userName=$userName&page=$page&size=$size';
      final res = await _get(url);
      if (res.statusCode == 200) {
        final decoded = json.decode(res.body);
        final type = PoolPurchaseModel.fromJson(decoded);
        myPoolPurchaseList.clear();
        myPoolPurchaseList.addAll(type.content ?? []);
      } else {
      //  _notify('Failed to fetch pool purchases', background: Colors.red);
      }
    } catch (e) {
    //  _notify('Error fetching pool purchases', background: Colors.red);
    } finally {
      notifyListeners();
    }
  }

  // -----------------------
  // Get gallery list
  // -----------------------
  Future<void> getGalleryList(String userId, {int page = 0, int size = 50}) async {
    try {
      final url = '${ApiConstant.GALLERY}/byUserId?userId=$userId&page=$page&size=$size';
      final res = await _get(url);
      if (res.statusCode == 200) {
        final decoded = json.decode(res.body);
        final type = GalleryModel.fromJson(decoded);
        myGalleryList.clear();
        myGalleryList.addAll(type.content ?? []);
      } else {
    //    _notify('Failed to fetch gallery', background: Colors.red);
      }
    } catch (e) {
      //_notify('Error fetching gallery', background: Colors.red);
    } finally {
      notifyListeners();
    }
  }

  // -----------------------
  // Save feedback
  // -----------------------
  Future<bool> saveFeedback({int? id, String? feedbackDetails, int? postId, int? userId, String? type, int? rating}) async {
    try {
      final url = '${ApiConstant.BASE_URL}Feedback';
      final body = <String, dynamic>{
        if (id != null) "id": id,
        "feedbackDetails": feedbackDetails,
        "postId": postId,
        "ratings": rating,
        "type": type,
        "userId": userId,
        "date": DateTime.now().toIso8601String(),
      };

      final res = await _post(url, body: body);
      if (res.statusCode == 200 || res.statusCode == 201) {
        final decoded = json.decode(res.body);
        final dataObj = FeedBack.fromJson(decoded);
        feedbackList.add(dataObj);
        notifyListeners();
        _notify('Feedback saved', background: Colors.black);
        return true;
      } else {
       // _notify('Failed to save feedback', background: Colors.red);
        return false;
      }
    } catch (e) {
   //   _notify('Error saving feedback', background: Colors.red);
      return false;
    }
  }

  // -----------------------
  // Get all feedback (paged)
  // -----------------------
  Future<void> getAllFeedBackList({int currentPage = 0, int size = 10, int? userId}) async {
    try {
      if (currentPage == 0) {
        isFirstFeedbackLoading = true;
        feedbackList.clear();
        fullLoadFeedbackList.clear();
        partLoadFeedbackList.clear();
        galleryFeedbackList.clear();
        buySellFeedbackList.clear();
        notifyListeners();
      } else {
        isFeedbackLoading = true;
        notifyListeners();
      }

      final url = '${ApiConstant.BASE_URL}Feedback?page=$currentPage&size=$size';
      final res = await _get(url);

      if (res.statusCode == 200) {
        final decoded = json.decode(res.body);
        final type = FeedbackModel.fromJson(decoded);
        feedbackList.addAll(type.content ?? []);

        // categorize
        fullLoadFeedbackList.clear();
        partLoadFeedbackList.clear();
        galleryFeedbackList.clear();
        buySellFeedbackList.clear();

        for (final f in feedbackList) {
          if (f.type == 'Full Load')
            fullLoadFeedbackList.add(f);
          else if (f.type == 'Part Load')
            partLoadFeedbackList.add(f);
          else if (f.type == 'Gallery')
            galleryFeedbackList.add(f);
          else
            buySellFeedbackList.add(f);
        }
      } else {
      //  _notify('Failed to fetch feedback', background: Colors.red);
      }
    } catch (e) {
    //  _notify('Error fetching feedback', background: Colors.red);
    } finally {
      isFeedbackLoading = false;
      isFirstFeedbackLoading = false;
      notifyListeners();
    }
  }

  // -----------------------
  // Get discussion list
  // -----------------------
  Future<void> getDiscussionList(String userName, {int page = 0, int size = 50}) async {
    try {
      discussionList.clear();
      ApiHelper apiHelper = ApiHelper();
      var result = await apiHelper.ApiGetData('${ApiConstant.GET_DISCUSSION}/getByUserName?userName=$userName&page=$page&size=$size');
      DiscussionData discussion = DiscussionData.fromJson(result);
      discussionList.addAll(discussion.content ?? []);
    } catch (e) {
     // _notify('Error fetching discussions', background: Colors.red);
    } finally {
      notifyListeners();
    }
  }

  // -----------------------
  // Flags setters
  // -----------------------
  Future<void> setFullLoadFlag(bool value) async {
    fullLoadFlag = value;
    notifyListeners();
  }

  Future<void> setPartLoadFlag(bool value) async {
    partLoadFlag = value;
    notifyListeners();
  }

  Future<void> setJobFlag(bool value) async {
    jobFlag = value;
    notifyListeners();
  }

  Future<void> setBuySellFlag(bool value) async {
    buySellFlag = value;
    notifyListeners();
  }

  Future<void> setGalleryFlag(bool value) async {
    galleryFlag = value;
    notifyListeners();
  }

  Future<void> setPoolPurchaseFlag(bool value) async {
    poolPurchaseFlag = value;
    notifyListeners();
  }
}
