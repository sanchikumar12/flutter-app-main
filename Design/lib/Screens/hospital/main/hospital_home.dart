import 'package:design/AppConstant/app_color.dart';
import 'package:design/AppConstant/images.dart';
import 'package:design/Screens/widgets/appbar.dart';
import 'package:design/Screens/widgets/image.dart';
import 'package:design/Screens/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class HospitalHome extends StatefulWidget {
  const HospitalHome({Key? key}) : super(key: key);

  @override
  State<HospitalHome> createState() => _HospitalHomeState();
}

class _HospitalHomeState extends State<HospitalHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColor.backgroundColorDoctor,
        body: Column(
          children: [
            const Appbar(color: AppColor.secondary),
            Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 19),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 13, left: 6, bottom: 8),
                          child: CommonText.semiBold("Hello, Dr. John Doe", size: 18, color: AppColor.textTitle),
                        ),
                        Container(
                          height: 147,
                          padding: const EdgeInsets.only(left: 26, right: 11, top: 29, bottom: 19),
                          decoration: BoxDecoration(color: AppColor.skin, borderRadius: BorderRadius.circular(10)),
                          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const CommonText.extraBold("10% off", size: 20, color: AppColor.textDark),
                                const Gap(6),
                                const CommonText.medium("Generic Meds X-Labs ", size: 16, color: AppColor.textDark),
                                const Gap(9),
                                Container(
                                  height: 32,
                                  width: 114,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(color: AppColor.black, borderRadius: BorderRadius.circular(100)),
                                  child: const CommonText.semiBold("Contact", size: 15, color: AppColor.white),
                                ),
                              ],
                            ),
                            const Padding(
                              padding: EdgeInsets.only(bottom: 20),
                              child: Image(image: AssetImage(AppImages.medicine),width: 102,height: 91,),
                            ),
                          ]),
                        ),
                        const Gap(26),
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                // Navigator.of(context).push(MaterialPageRoute(builder: (context) => const OnCallScreen()));
                                //Navigator.of(context).push(MaterialPageRoute(builder: (context) => const OnCallScreen()));
                              },
                              child: Container(
                                height: 155,
                                width: 155,
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(color: AppColor.lightSky, borderRadius: BorderRadius.circular(10)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    CircleImageFromAsset(AppImages.timeCall, size: 53),
                                    Padding(
                                      padding: EdgeInsets.symmetric(vertical: 7),
                                      child: CommonText.semiBold("50", size: 28, color: AppColor.black),
                                    ),
                                    CommonText.medium("On Call Jobs", size: 15, color: AppColor.textInSkyBox),
                                  ],
                                ),
                              ),
                            ),
                            const Gap(11),
                            Expanded(
                              child: Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      // Navigator.of(context).push(MaterialPageRoute(builder: (context) => const FullTimeScreen()));
                                    },
                                    child: Container(
                                      height: 73,
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(color: AppColor.lightPurple, borderRadius: BorderRadius.circular(10)),
                                      child: Row(
                                        children: [
                                          const CircleImageFromAsset(AppImages.job, size: 53),
                                          const Gap(7),
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: const [
                                              CommonText.semiBold("15", size: 28, color: AppColor.black),
                                              Gap(2),
                                              CommonText.medium("Full time", size: 15, color: AppColor.textInVeryPaleRedBox),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const Gap(9),
                                  InkWell(
                                    onTap: () {
                                      // Navigator.of(context).push(MaterialPageRoute(builder: (context) => const WorkInProgressScreen()));
                                    },
                                    child: Container(
                                      height: 73,
                                      decoration: BoxDecoration(color: AppColor.veryPaleRed, borderRadius: BorderRadius.circular(10)),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          SquareImageFromAsset(AppImages.workInProgress, size: 51),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 25, left: 6, bottom: 8),
                          child: CommonText.semiBold("Recent jobs", size: 23, color: AppColor.textDark),
                        ),
                        for (int i = 0; i < 3; i++)
                          Container(
                            height: 106,
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 9),
                            margin: const EdgeInsets.only(bottom: 15),
                            decoration: BoxDecoration(
                              color: AppColor.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: const [
                                BoxShadow(
                                  offset: Offset(0, 0),
                                  blurRadius: 1,
                                  color: AppColor.greyLight1,
                                ),
                              ],
                            ),
                            child: Column(
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
                                const Gap(8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
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
                                          child: const CommonText.semiBold("On Call", size: 12, color: AppColor.textPrimary),
                                        ),
                                      ],
                                    ),
                                    InkWell(
                                      onTap: () {
                                        // Navigator.of(context).push(MaterialPageRoute(builder: (context) => const OnCallAppliedScreen()));
                                      },
                                      child: Container(
                                        height: 28,
                                        width: 79,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(color: AppColor.lightYellow, borderRadius: BorderRadius.circular(100)),
                                        child: const CommonText.semiBold("Apply", size: 12, color: AppColor.textPrimary),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                )),
            Container(
              height: 75,
              color: AppColor.secondary,
              alignment: Alignment.center,
              child: const CommonText.bold("Post a Job", size: 20, color: AppColor.white),
            ),          ],
        ));
  }
}
