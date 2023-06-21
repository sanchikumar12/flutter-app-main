import 'package:design/AppConstant/app_color.dart';
import 'package:design/AppConstant/images.dart';
import 'package:design/Screens/doctor/auth/signIn/signin_screen.dart';
import 'package:design/Screens/hospital/auth/signIn/signIn_hospital.dart';
import 'package:design/Screens/widgets/appbar.dart';
import 'package:design/Screens/widgets/image.dart';
import 'package:design/Screens/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class AutoUserSelection extends StatefulWidget {
  const AutoUserSelection({Key? key}) : super(key: key);

  @override
  State<AutoUserSelection> createState() => _AutoUserSelectionState();
}

class _AutoUserSelectionState extends State<AutoUserSelection> {

  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColorDoctor,
      body: Column(
        children: [
          const SecondAppbar(),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SignInScreen()));                    },
                    child: SquareImageFromAsset(AppImages.doctor, fit: BoxFit.fill,size: 88)),
                const Gap(9),
                const CommonText.semiBold("I’m a Doctor", size: 15, color: AppColor.black),
              ],
            ),
          ),Expanded(
            child: Container(
              alignment: Alignment.center,
              decoration: const BoxDecoration(color: AppColor.pinkShade),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SignInHospital()));
                  },child: SquareImageFromAsset(AppImages.hospital, fit: BoxFit.fill,size: 88)),
                  const Gap(9),
                  const CommonText.semiBold("We’r a Hospital", size: 15, color: AppColor.black),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
