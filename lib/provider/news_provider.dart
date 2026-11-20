import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:tkd_app/util/colors.dart';
import 'package:tkd_app/view/screens/gallery/image_picker_helper.dart';

import '../locator.dart';
import '../model/allNewsResponse.dart';
import '../model/api_response.dart';
import '../model/auth_api.dart';
import '../model/gallary_model.dart';
import '../model/request/addNewsRequest.dart';
import '../network/api_call.dart';
import '../util/app_constants.dart';
import '../widgets/toast.dart';
import 'auth_provider.dart';

/// Refactored and improved NewsProvider
/// - Proper pagination (starts at 0)
/// - Safe loading flags (loading, loadingMore)
/// - Detects last page when API returns empty content
/// - Clean toggle between All News and My News
/// - Delete now removes locally + reloads page 0 of currently active tab
/// - Add (createPost) also reloads page 0 for consistency
class NewsProvider extends ChangeNotifier {
  NewsProvider() : super() {
    // Don't aggressively call network here in constructor in case caller wants
    // to control when to load. But to keep previous behavior, load first page.
    _resetAndLoad();
  }

  // Pagination counters (starts at 0)
  int _allPage = 0;
  int _myPage = 0;

  // Flags to prevent duplicate loads
  bool _isLoading = false; // general loading
  bool _isLoadingMore = false; // loading next page

  // Detect we've reached last page (no more pages)
  bool _isAllLastPage = false;
  bool _isMyLastPage = false;

  // Lists
  List<Content> allNewsTemp = []; // backup for search
  List<Content> allNews = [];

  // search & form controllers
  TextEditingController searchController = TextEditingController();
  TextEditingController topicController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController linkController = TextEditingController();

  // images collected from image picker uploads
  List<String> images = [];

  // tab toggle: false => All News, true => My News
  bool _myNews = false;
  bool get myNews => _myNews;

  // Public state getters
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  bool get isAllLastPage => _isAllLastPage;
  bool get isMyLastPage => _isMyLastPage;

  // Auth provider (locator)
  final authProvider = locator<AuthProvider>();

  // Example: expose a scroll controllers if you want provider to handle scroll listeners
  ScrollController scrollControllerVertical = ScrollController();
  ScrollController scrollControllerHorizantal = ScrollController();

  // ----------------------- Initialization helpers -----------------------
  void _resetAndLoad() {
    // start fresh
    _allPage = 0;
    _myPage = 0;
    _isAllLastPage = false;
    _isMyLastPage = false;
    allNews.clear();
    allNewsTemp.clear();

    // load first page of the currently active tab (defaults to All News)
    if (_myNews) {
      getMyNewsData(page: 0);
    } else {
      getAllData(page: 0);
    }
  }

  // ----------------------- Image upload -----------------------
  uploadImage(BuildContext context) async {
    String? image = await ImagePickerHelper().pickAndUploadImage(context);
    if (image != null) {
      images.add(image);
      debugPrint("Image uploaded successfully: ${images.last}");
      notifyListeners();
    } else {
      debugPrint("Image upload failed or was cancelled.");
    }
  }

  // ----------------------- Pagination helpers -----------------------
  /// Call this from UI scroll when you want to load next page.
  Future<void> loadMore() async {
    if (_myNews) {
      if (_isMyLastPage || _isLoadingMore) return;
      await getMyNewsData(page: _myPage, loadMore: true);
    } else {
      if (_isAllLastPage || _isLoadingMore) return;
      await getAllData(page: _allPage, loadMore: true);
    }
  }

  // ----------------------- Get All News -----------------------
  /// Get all news. page starts at 0.
  Future<void> getAllData({required int page, bool loadMore = false}) async {
    // prevent overlapping requests
    if (loadMore) {
      if (_isLoadingMore || _isAllLastPage) return;
      _isLoadingMore = true;
    } else {
      if (_isLoading) return;
      _isLoading = true;
    }

    notifyListeners();

    try {
      String myUrl = ApiConstant.GET_NEWS_LIST(page);
      debugPrint("GET ALL NEWS: $myUrl");

      var req = await http.get(Uri.parse(myUrl));

      if (req.statusCode == 200) {
        GetAllNewsResponse newsResponse =
        GetAllNewsResponse.fromJson(jsonDecode(req.body));

        final fetched = newsResponse.content ?? <Content>[];

        // if first page, reset lists
        if (page == 0 && !loadMore) {
          allNews.clear();
          allNewsTemp.clear();
        }

        if (fetched.isEmpty) {
          // no more pages
          _isAllLastPage = true;
        } else {
          // add results
          allNews.addAll(fetched);
          allNewsTemp.addAll(fetched);
          // increment page for next call
          _allPage = page + 1;
        }
      } else {
        debugPrint('getAllData error: ${req.statusCode}');
      }
    } catch (e) {
      debugPrint('getAllData exception: $e');
    } finally {
      _isLoading = false;
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  // ----------------------- Get My News -----------------------
  /// Get my news for the currently logged in user. page starts at 0.
  Future<void> getMyNewsData({required int page, bool loadMore = false}) async {
    // prevent overlapping requests
    if (loadMore) {
      if (_isLoadingMore || _isMyLastPage) return;
      _isLoadingMore = true;
    } else {
      if (_isLoading) return;
      _isLoading = true;
    }

    notifyListeners();

    try {
      User user = await authProvider.getLoginData();
      String myUrl = ApiConstant.MY_NEWS(user.id, page);
      debugPrint("GET MY NEWS: $myUrl");
      var req = await http.get(Uri.parse(myUrl));

      if (req.statusCode == 200) {
        GetAllNewsResponse newsResponse =
        GetAllNewsResponse.fromJson(jsonDecode(req.body));

        final fetched = newsResponse.content ?? <Content>[];

        if (page == 0 && !loadMore) {
          allNews.clear();
        }

        if (fetched.isEmpty) {
          _isMyLastPage = true;
        } else {
          allNews.addAll(fetched);
          _myPage = page + 1;
        }
      } else {
        debugPrint('getMyNewsData error: ${req.statusCode}');
      }
    } catch (e) {
      debugPrint('getMyNewsData exception: $e');
    } finally {
      _isLoading = false;
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  // ----------------------- Toggle tab -----------------------
  /// Toggle between All News (false) and My News (true)
  void toggleMyNews(bool value) {
    if (_myNews == value) return; // no change

    _myNews = value;

    // reset pagination and lists for the newly selected tab
    if (_myNews) {
      _myPage = 0;
      _isMyLastPage = false;
      allNews.clear();
      getMyNewsData(page: 0);
    } else {
      _allPage = 0;
      _isAllLastPage = false;
      allNews.clear();
      allNewsTemp.clear();
      getAllData(page: 0);
    }

    notifyListeners();
  }

  // ----------------------- Search -----------------------
  /// Simple search — when search length > 2 we call API, otherwise restore temp list
  Future<void> getBySearchData() async {
    final query = searchController.text.trim();
    if (query.length > 2) {
      _isLoading = true;
      notifyListeners();
      try {
        String myUrl = ApiConstant.SEARCH_NEWS(query);
        var req = await http.get(Uri.parse(myUrl));
        if (req.statusCode == 200) {
          GetAllNewsResponse newsResponse =
          GetAllNewsResponse.fromJson(jsonDecode(req.body));
          allNews.clear();
          allNews.addAll(newsResponse.content ?? <Content>[]);
        }
      } catch (e) {
        debugPrint('search exception: $e');
      } finally {
        _isLoading = false;
        notifyListeners();
      }
    } else {
      // restore
      allNews.clear();
      allNews.addAll(allNewsTemp);
      notifyListeners();
    }
  }

  // ----------------------- Create Post -----------------------
  Future<void> createPost(BuildContext context) async {
    try {
      User user = await authProvider.getLoginData();
      AddNewsRequest postLoad = AddNewsRequest();
      postLoad.companyName = user.companyName ?? '';
      postLoad.description = descriptionController.text;
      postLoad.date = '';
      postLoad.firstName = user.firstName ?? '';
      postLoad.image = images.isNotEmpty ? images[0] : '';
      postLoad.lastName = user.lastName;
      postLoad.mobileNumber = user.mobileNumber;
      postLoad.profilePicture = user.profilePicture;
      postLoad.topicName = topicController.text;
      postLoad.userId = user.id;
      postLoad.image2 = images.isNotEmpty ? images[0] : '';
      postLoad.image3 = images.isNotEmpty ? images[0] : '';
      postLoad.image4 = images.isNotEmpty ? images[0] : '';
      postLoad.image5 = images.isNotEmpty ? images[0] : '';
      postLoad.imageType = "png";
      postLoad.isApproved = 1;
      postLoad.youtubeLink = linkController.text;

      var body = json.encode(postLoad);
      print(ApiConstant.ADD_NEWS);
      print("Request::::"+body.toString());
      final response = await http.post(Uri.parse(ApiConstant.ADD_NEWS),
          headers: {"Content-Type": "application/json"}, body: body);
      print("Response::::"+response.body);
      print("Response::::"+response.statusCode.toString());
      if (response.statusCode == 200) {
        // on success, reload first page of current tab for consistent state
        ToastMessage.show(context, "News added successfully!");
        _reloadFirstPageOfCurrentTab();
        // close any dialogs/popups should be handled by caller
        Navigator.pop(context);
        Navigator.pop(context);
      } else {
        ToastMessage.show(context, "Please try again");
      }
    } catch (e) {
      debugPrint('createPost exception: $e');
      ToastMessage.show(context, "Please try again");
    }
  }

  // ----------------------- Delete Post -----------------------
  Future<void> deletePost(Content content, BuildContext context) async {
    try {
      String myUrl = '${ApiConstant.DELETE_NEWS(content.id)}';
      debugPrint('DELETE: $myUrl');

      var apiResponse = await ApiHelper().ApiDeleteData(myUrl);

      if (apiResponse.statusCode == 200) {
        // Remove locally immediately so UI updates fast
        allNews.removeWhere((item) => item.id == content.id);
        allNewsTemp.removeWhere((item) => item.id == content.id);

        ToastMessage.show(context, "Post deleted successfully");

        // Reset pagination and reload first page of current tab (you confirmed yes)
        _reloadFirstPageOfCurrentTab();
      } else {
        ToastMessage.show(context, "Please try again");
      }
    } catch (e) {
      debugPrint('delete exception: $e');
      ToastMessage.show(context, "Please try again");
    }
  }

  // ----------------------- Utilities -----------------------
  void _reloadFirstPageOfCurrentTab() {
    if (_myNews) {
      _myPage = 0;
      _isMyLastPage = false;
      allNews.clear();
      getMyNewsData(page: 0);
    } else {
      _allPage = 0;
      _isAllLastPage = false;
      allNews.clear();
      allNewsTemp.clear();
      getAllData(page: 0);
    }
    notifyListeners();
  }

  // simple validator used previously
  bool enbleButton = false;

  void enble() {
    if (topicController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty) {
      enbleButton = true;
    } else {
      enbleButton = false;
    }
    notifyListeners();
  }

  // For completeness: placeholder for pickAndUploadImage
  Future<String?> pickAndUploadImage(BuildContext context) async {
    // Implemented by uploadImage() above which uses ImagePickerHelper
    return null;
  }
}
