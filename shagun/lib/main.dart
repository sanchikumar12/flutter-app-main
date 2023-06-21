import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:miniapp/screens/dashboard_screen.dart';
import 'package:miniapp/screens/payment_screen.dart';
import 'package:miniapp/screens/phone_number_verification.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  late StreamSubscription<User?> _sub;
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    _sub = FirebaseAuth.instance.userChanges().listen((event) async {
      _navigatorKey.currentState?.pushReplacementNamed(
        event != null ? PaymentScreen.routeName :
        PhoneNumberVerification.routeName,
      );
    });

    super.initState();
    Future.delayed(const Duration(seconds: 3), () => FlutterNativeSplash.remove());
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shagun',
      theme: ThemeData(
          colorScheme: const ColorScheme.light().copyWith(
            primary: const Color(0xFF873d1a),
          ),
          scaffoldBackgroundColor: const Color(0xFFFFFFFF)//ACDDDE
        //primarySwatch: MaterialColor,
      ),
      initialRoute: FirebaseAuth.instance.currentUser == null ?
      PhoneNumberVerification.routeName :
      PaymentScreen.routeName,
      routes: {
        PhoneNumberVerification.routeName: (context) =>
        const PhoneNumberVerification(),
        PaymentScreen.routeName: (context) => const PaymentScreen(),
        DashboardScreen.routeName: (context) => const DashboardScreen()
      },
    );
  }
}

