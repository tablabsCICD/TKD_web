import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tkd_app/model/shared_post_model.dart';
import 'package:tkd_app/model/version.dart';
import 'package:tkd_app/provider/auth_provider.dart';
import 'package:tkd_app/provider/dashboard_provider.dart';
import 'package:tkd_app/provider/org_provider.dart';
import 'package:tkd_app/util/app_constants.dart';
import 'package:tkd_app/util/custom_text_style.dart';
import 'package:tkd_app/view/screens/auth/login_screen.dart';
import 'package:tkd_app/view/screens/deeplink/deeplinkscreen.dart';
import 'package:tkd_app/view/screens/menu_page.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:app_links/app_links.dart';
import 'locator.dart';
import 'model/auth_api.dart';
import 'model/organization_model.dart';
import 'network/api_call.dart';
import 'view/screens/company/company_menu_page.dart';

class EntryScreen extends StatefulWidget {
  @override
  EntryState createState() => EntryState();
}

class EntryState extends State<EntryScreen> {
  bool visitingFlag = true;
  List<User> userDetailList = [];
  final authProvider = locator<AuthProvider>();
  final dashboardProvider = locator<DashboardProvider>();
  final orgProvider = locator<OrgProvider>();
  bool companyLogin = false, userLogin = true;
  List<Organization> orgList = [];
  bool isDebug = true;
  StreamSubscription<Uri>? _linkSub;
  final AppLinks _appLinks = AppLinks();

  @override
  void initState() {
    super.initState();
    // TODO: implement initState

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (kIsWeb) {
        // Directly call the initUniLinks for web
        initUniLinks();
      } else if (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS) {
        if (isDebug) {
          versionControllApi();
        } else {
          initUniLinks();
        }
      } else {
        loginOrHome();
      }
    });
  }

  versionControllApi() async {
    ApiHelper api = ApiHelper();
    var result = await api.ApiGetData(ApiConstant.GET_CURRENT_VERSION);
    Version version = Version.fromJson(result);
    print('the version is ${version.version}');
    if (version.version! == ApiConstant.APP_VERSION) {
      await initUniLinks();
    } else {
      upDateDailog();
    }
  }

  loginOrHome() async {
    visitingFlag = (await authProvider.getVisitingFlag())!;
    bool companyVisitingFlag = (await orgProvider.getCompanyVisitingFlag())!;
    if (visitingFlag == true) {
      int? empid = await authProvider.getEmpId();

      if (empid != null) {
        userDetailList = await authProvider.getUserDetails(empid);
        ApiConstant.USER_OBJECT = authProvider.userDetailList[0];
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (builder) => MenuPage(
                    userDetailList: userDetailList, selectedTab: "Board")));
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (builder) => Login_Screen()));
      }
    } else if (companyVisitingFlag == true) {
      int? OrgId = await orgProvider.getCompanyOrgId();
      List<Organization> organization =
          await orgProvider.getCompanyDetails(OrgId!);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (builder) => CompanyMenuPage(organization[0])));
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (builder) => Login_Screen()));
    }
  }

  SharedPostModel? truckLoad;
  loginOrDetails(String postId, String type) async {
    visitingFlag = (await authProvider.getVisitingFlag())!;
    if (visitingFlag == true) {
      int? empid = await authProvider.getEmpId();
      print("EmpId:::" + empid.toString());
      if (empid != null) {
        userDetailList = await authProvider.getUserDetails(empid);
        ApiConstant.USER_OBJECT = authProvider.userDetailList[0];
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (builder) => DeepLink(id: postId, type: type)));
      } else {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (builder) =>
                Login_Screen(fromLink: true, postId: postId, linkType: type)));
      }
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (builder) =>
              Login_Screen(fromLink: true, postId: postId, linkType: type)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  void upDateDailog() {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text(
          'TKDost Update',
          style: appbarTextStyle,
        ),
        content: const Text(
          'New application update is available on play store please update the app.',
          style: titleTextStyle,
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              redirectionUrl();
            },
            child: const Text(
              'Update',
              style: titleTextStyle,
            ),
          ),
        ],
      ),
    );
  }

  void redirectionUrl() {
    launchUrlString(
        "https://play.google.com/store/apps/details?id=com.pdk.tkd");
  }

  Future<void> initUniLinks() async {
    if (kIsWeb) {
      final payload = _parseDeepLink(Uri.base);
      if (payload == null) {
        loginOrHome();
        return;
      }
      await loginOrDetails(payload.id, payload.type);
    } else {
      try {
        final initialUri = await _appLinks.getInitialLink();
        final payload = initialUri == null ? null : _parseDeepLink(initialUri);
        if (payload == null) {
          loginOrHome();
        } else {
          await loginOrDetails(payload.id, payload.type);
        }
      } on PlatformException {
        loginOrHome();
      }

      _linkSub?.cancel();
      _linkSub = _appLinks.uriLinkStream.listen((Uri uri) async {
        if (!mounted) return;
        final payload = _parseDeepLink(uri);
        if (payload == null) return;
        await loginOrDetails(payload.id, payload.type);
      }, onError: (e) {
        debugPrint("Deep link stream error: $e");
      });
    }
  }

  _DeepLinkPayload? _parseDeepLink(Uri uri) {
    String? id = uri.queryParameters['id'];
    if (id == null || id.isEmpty) {
      final segments = uri.pathSegments.where((e) => e.isNotEmpty).toList();
      if (segments.isNotEmpty) {
        final maybeId = segments.last;
        if (RegExp(r'^\d+$').hasMatch(maybeId)) {
          id = maybeId;
        }
      }
      if (id == null || id.isEmpty) return null;
    }

    String type = uri.queryParameters['type']?.toLowerCase() ?? 'post';
    final segments = uri.pathSegments.map((e) => e.toLowerCase()).toList();
    final tkdIndex = segments.indexOf('tkd');
    if (tkdIndex != -1 && tkdIndex + 1 < segments.length) {
      type = segments[tkdIndex + 1];
    } else if (segments.isNotEmpty) {
      for (final seg in segments) {
        if (seg == 'post' || seg == 'quote' || seg == 'tracking') {
          type = seg;
          break;
        }
      }
    }

    if (type != 'post' && type != 'quote' && type != 'tracking') {
      type = 'post';
    }

    debugPrint("DeepLink parsed => uri: $uri, type: $type, id: $id");

    return _DeepLinkPayload(id: id, type: type);
  }

  @override
  void dispose() {
    _linkSub?.cancel();
    super.dispose();
  }
}

class _DeepLinkPayload {
  final String id;
  final String type;
  const _DeepLinkPayload({required this.id, required this.type});
}
