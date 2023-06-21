import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:grocapp/const/route_constants.dart';
import 'package:grocapp/screens/auth/auth_provider.dart';
import 'package:grocapp/screens/cart/cart_provider.dart';
import 'package:grocapp/screens/config/delivery_type_config.dart';
import 'package:grocapp/screens/config/minimum_order_config.dart';
import 'package:grocapp/screens/profile/orders/core/firestore_model.dart';
import 'package:grocapp/screens/profile/orders/locator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './services/router.dart' as router;
import 'package:flutter/services.dart' show DeviceOrientation, SystemChrome;
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'const/color_const.dart';

int initScreen;

Future<void> main() async {
  setupLocator();
  // Set `enableInDevMode` to true to see reports while in debug mode
  // This is only to be used for confirming that reports are being
  // submitted as expected. It is not intended to be used for everyday
  // development.

  // Crashlytics.instance.enableInDevMode = true;

  // Pass all uncaught errors from the framework to Crashlytics.
  FlutterError.onError = Crashlytics.instance.recordFlutterError;
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  initScreen = prefs.getInt("initScreen");
  await prefs.setInt("initScreen", 1);
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp() {
    // PushNotificationsManager push = new PushNotificationsManager();
    // push.init();
  }
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
        ChangeNotifierProvider<FirestoreModel>(
            create: (_) => locator<FirestoreModel>()),
        ChangeNotifierProvider<CartProvider>(create: (_) => CartProvider()),
        ChangeNotifierProvider<MinimumOrderProvider>(
            create: (_) => MinimumOrderProvider()),
        ChangeNotifierProvider<DeliveryTypeProvider>(
            create: (_) => DeliveryTypeProvider()),
      ],
      child: ConnectivityAppWrapper(
        app: MaterialApp(
          theme: ThemeData(
              accentColor: Color(0xFF52DA75),
              primaryColor: primaryColor,
              iconTheme: IconThemeData(color: Color(0xFF32C96C)),
              appBarTheme: AppBarTheme(color: Colors.grey[200])),
          //onGenerateRoute: Navigation.router.generator,
          debugShowCheckedModeBanner: false,
          onGenerateRoute: router.Router.generateRoute,
          initialRoute: (initScreen == 0 || initScreen == null)
              ? OnBoardRoute
              : AuthRoute,
        ),
      ),
    );
  }
}
