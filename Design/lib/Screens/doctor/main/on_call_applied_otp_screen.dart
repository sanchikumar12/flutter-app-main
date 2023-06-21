import 'package:design/AppConstant/app_color.dart';
import 'package:design/AppConstant/images.dart';
import 'package:design/Screens/doctor/main/on_call_applied_unlocked_screen.dart';
import 'package:design/Screens/widgets/appbar.dart';
import 'package:design/Screens/widgets/image.dart';
import 'package:design/Screens/widgets/pinput_square.dart';
import 'package:design/Screens/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class OnCallAppliedOtpScreen extends StatefulWidget {
  const OnCallAppliedOtpScreen({Key? key}) : super(key: key);

  @override
  State<OnCallAppliedOtpScreen> createState() => _OnCallAppliedOtpScreenState();
}

class _OnCallAppliedOtpScreenState extends State<OnCallAppliedOtpScreen> {
  TextEditingController otpController2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColor.backgroundColorDoctor,
        body: Column(
          children: [
            const Appbar(),
            Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:   [
                        const Gap(27),
                        const CommonText.semiBold("Job Details", size: 25, color: AppColor.textTitle),
                        const Gap(18),
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      height: 47,
                                      width: 47,
                                      alignment: Alignment.center,
                                      decoration: const BoxDecoration(color: AppColor.green, shape: BoxShape.circle),
                                      child: const CommonText.semiBold("H", size: 28, color: AppColor.white),
                                    ),
                                    const Gap(20),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: const [
                                        CommonText.extraBold("Gen Med", size: 18, color: AppColor.textDark),
                                        Gap(3),
                                        CommonText.semiBold("₹ 3000/ Day", size: 12, color: AppColor.textLight)
                                      ],
                                    ),
                                  ],
                                ),
                                Container(
                                  height: 47,
                                  width: 85,
                                  decoration: BoxDecoration(color: AppColor.greyLight2, borderRadius: BorderRadius.circular(10)),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      CommonText.semiBold("24-Aug", size: 12, color: AppColor.textPrimary),
                                      Gap(4),
                                      CommonText.semiBold("9 AM - 9 PM", size: 9, color: AppColor.textPrimary),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const Gap(20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 28,
                                  width: 79,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(color: AppColor.greyLight2, borderRadius: BorderRadius.circular(100)),
                                  child: const CommonText.semiBold("PG-CON", size: 12, color: AppColor.textPrimary),
                                ),
                                const Gap(7),
                                Container(
                                  height: 28,
                                  width: 79,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(color: AppColor.greyLight2, borderRadius: BorderRadius.circular(100)),
                                  child: const CommonText.semiBold("Full time", size: 12, color: AppColor.textPrimary),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Gap(20),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 30),
                          child: Divider(color: Color(0xFFC5C5C5)),
                        ),
                        const Gap(21),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children:  [
                            SquareImageFromAsset(AppImages.lock,size: 67),
                            const Gap(13),
                            const CommonText.medium("Unlock to view Hospital Name, \nLocation & Contact", size: 14, color: AppColor.grey2),
                          ],
                        ),
                        const Gap(40),
                        Center(child: PinPutSquare(otpController: otpController2)),
                        const Gap(35),
                        Center(
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const OnCallAppliedUnlockedScreen()));

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
                        const Gap(28),
                        const Center(child: CommonText.semiBold("Resend OTP", size: 14, color: AppColor.blueText)),
                        const Gap(27),
                        const Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: CommonText.semiBold("Important Note", size: 16, color: AppColor.redText),
                        ),
                        const Gap(10),
                        const Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: CommonText.medium("In case of cancellation the applied job \nuser will be charged with ₹150-200 as \ninconvience fee", size: 14, color: AppColor.grey3),
                        ),
                        const Gap(67),
                      ],
                    ),
                  ),
                )),
          ],
        ));
  }
}
