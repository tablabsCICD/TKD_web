
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tkd_app/provider/auth_provider.dart';
import 'package:tkd_app/provider/bid_provider.dart';
import 'package:tkd_app/provider/buy_sell_provider.dart';
import 'package:tkd_app/provider/dashboard_provider.dart';
import 'package:tkd_app/provider/fleet_provider.dart';
import 'package:tkd_app/provider/gallery_provider.dart';
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

GetIt locator = GetIt.asNewInstance();

Future<void> setupLocator() async {
  locator.registerLazySingleton(() => MenuProvider());
  locator.registerLazySingleton(() => AuthProvider());
  locator.registerLazySingleton(() => DashboardProvider());
  locator.registerLazySingleton(() => TransportProvider());
  locator.registerLazySingleton(() => JobProvider());
  locator.registerLazySingleton(() => GalleryProvider());
  locator.registerLazySingleton(() => BuySellProvider());
  locator.registerLazySingleton(() => PoolPurchaseProvider());
  locator.registerLazySingleton(() => MoreProvider());
  locator.registerLazySingleton(() => RouteProvider());
  locator.registerLazySingleton(() => BidProvider());
  locator.registerLazySingleton(() => OrgProvider());
  locator.registerLazySingleton(() => FleetProvider());
  locator.registerLazySingleton(() => PlanProvider());
  locator.registerLazySingleton(() => RepeatProvider());
  locator.registerLazySingleton(() => LocalizationProvider(sharedPreferences: locator()));

  final sharedPreferences = await SharedPreferences.getInstance();
  locator.registerLazySingleton(() => sharedPreferences);
}
