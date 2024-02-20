import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:http/http.dart' as http;
import 'package:tkd_app/entry_screen.dart';
import 'package:tkd_app/provider/auth_provider.dart';
import 'package:tkd_app/provider/bid_provider.dart';
import 'package:tkd_app/provider/buy_sell_provider.dart';
import 'package:tkd_app/provider/comment_provider.dart';
import 'package:tkd_app/provider/dashboard_provider.dart';
import 'package:tkd_app/provider/fleet_provider.dart';
import 'package:tkd_app/provider/gallery_provider.dart';
import 'package:tkd_app/provider/group/groupChatProvider.dart';
import 'package:tkd_app/provider/group/groupListProvider.dart';
import 'package:tkd_app/provider/job_provider.dart';
import 'package:tkd_app/provider/localization_provider.dart';
import 'package:tkd_app/provider/menu_provider.dart';
import 'package:tkd_app/provider/more_provider.dart';
import 'package:tkd_app/provider/org_provider.dart';
import 'package:tkd_app/provider/plan_provider.dart';
import 'package:tkd_app/provider/pool_purchase_provider.dart';
import 'package:tkd_app/provider/repeatProvider.dart';
import 'package:tkd_app/provider/route_provider.dart';
import 'package:tkd_app/provider/transport_provider.dart';
import 'package:tkd_app/util/app_constants.dart';
import 'package:tkd_app/view/localization/app_localization.dart';
import 'model/auth_api.dart';
import 'view/screens/auth/login_screen.dart';
import 'package:tkd_app/view/screens/menu_page.dart';
import 'locator.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();
  //setupLocator();

 // await initUniLinks();
  runApp(OverlaySupport.global(
      child: MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => locator<MenuProvider>()),
        ChangeNotifierProvider(create: (_) => locator<AuthProvider>()),
        ChangeNotifierProvider(create: (_) => locator<DashboardProvider>()),
        ChangeNotifierProvider(create: (_) => locator<TransportProvider>()),
        ChangeNotifierProvider(create: (_) => locator<JobProvider>()),
        ChangeNotifierProvider(create: (_) => locator<GalleryProvider>()),
        ChangeNotifierProvider(create: (_) => locator<BuySellProvider>()),
        ChangeNotifierProvider(create: (_) => locator<PoolPurchaseProvider>()),
        ChangeNotifierProvider(create: (_) => locator<MoreProvider>()),
        ChangeNotifierProvider(create: (_) => locator<RouteProvider>()),
        ChangeNotifierProvider(create: (_) => locator<BidProvider>()),
        ChangeNotifierProvider(create: (_) => locator<OrgProvider>()),
        ChangeNotifierProvider(create: (_) => locator<FleetProvider>()),
        ChangeNotifierProvider(create: (_) => locator<LocalizationProvider>()),
        ChangeNotifierProvider(create: (_) => locator<PlanProvider>()),
        ChangeNotifierProvider(create: (_) => locator<RepeatProvider>()),
        ChangeNotifierProvider(create: (_) => locator<GroupListProvider>()),
        ChangeNotifierProvider(create: (_) => locator<GroupChatProvider>()),
        ChangeNotifierProvider(create: (_) => locator<CommentProvider>()),
      ],
      child: MyApp(),
  )));



}



class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    List<Locale> _locals = [];
    locator<RepeatProvider>().startTimer();
    AppConstants.languages.forEach((language) {
      _locals.add(Locale(language.languageCode!, language.countryCode));
    });


    return MaterialApp(
          title: 'TKDost',
          debugShowCheckedModeBanner: false,
          locale: Provider.of<LocalizationProvider>(context).locale,
          localizationsDelegates: {
            AppLocalization.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          },
          supportedLocales: _locals,
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home:EntryScreen()
      // home: UpgradeAlert(
      //   upgrader: Upgrader(showIgnore: false,showLater: false),
      //     child: EntryScreen(),
      //     ),
    );
  }

//export PATH=/Users/paragkumbhar/SDK/flutter/bin:$PATH

}

