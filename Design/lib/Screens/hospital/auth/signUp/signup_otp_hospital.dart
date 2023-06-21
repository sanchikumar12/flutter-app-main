import 'package:design/AppConstant/app_color.dart';
import 'package:design/Screens/hospital/auth/profile/profile_hospital.dart';
import 'package:design/Screens/hospital/auth/signIn/signIn_hospital.dart';
import 'package:design/Screens/widgets/appbar.dart';
import 'package:design/Screens/widgets/pinput_widget.dart';
import 'package:design/Screens/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class SignUpOtpHospital extends StatefulWidget {
  const SignUpOtpHospital({Key? key}) : super(key: key);

  @override
  State<SignUpOtpHospital> createState() => _SignUpOtpHospitalState();
}

class _SignUpOtpHospitalState extends State<SignUpOtpHospital> {


  @override
  void initState() {

    super.initState();
  }
  TextEditingController? pinController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SecondAppbar(color: AppColor.secondary),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 45),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:  [
                  const Gap(38),
                  const CommonText.semiBold("Healthcare Sign up", size: 25, color: AppColor.black),
                  const Gap(38),
                  const CommonText.medium("Enter O.T.P.", size: 18, color: AppColor.greyText),
                  const Gap(10),
                  PinInputField(otpController: otpController),
                  const Gap(70),
                  Center(
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ProfileHospital()));
                      },
                      child: Container(
                        height: 53,
                        width: 150,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(color: AppColor.black, borderRadius: BorderRadius.circular(6)),
                        child: const CommonText.medium("Submit", size: 22, color: AppColor.white),
                      ),
                    ),
                  ),
                  const Gap(70),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:  [
                      const CommonText.medium("Have an account ? ", size: 16, color: Color(0xFF313131)),
                      InkWell(onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SignInHospital()));
                      },child: const CommonText.semiBold("Login", size: 16, color: AppColor.blueText)),

                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}
