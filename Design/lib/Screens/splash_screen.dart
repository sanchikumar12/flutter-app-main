import 'package:design/AppConstant/images.dart';
import 'package:design/Screens/doctor/auth/auto_user_selection_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) =>const AutoUserSelection(),// const DoctorHome(),
          ),
          (route) => false);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        body: Center(
            child: Padding(
          padding: EdgeInsets.only(left: 65, right: 60),
          child: Image(image: AssetImage(AppImages.splashLogo), height: 88),
        )),
      ),
    );
  }
}
