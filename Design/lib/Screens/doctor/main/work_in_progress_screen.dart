import 'package:design/AppConstant/app_color.dart';
import 'package:design/Screens/widgets/appbar.dart';
import 'package:design/Screens/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class WorkInProgressScreen extends StatefulWidget {
  const WorkInProgressScreen({Key? key}) : super(key: key);

  @override
  State<WorkInProgressScreen> createState() => _WorkInProgressScreenState();
}

class _WorkInProgressScreenState extends State<WorkInProgressScreen> {
  String dropdownValue = "";

  @override
  void initState() {
    dropdownValue = "0";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColor.backgroundColorDoctor,
        body: Column(
          children: [
            const Appbar(),
            Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 19),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Gap(19),
                        InkWell(
                          onTap: () {
                           // Navigator.of(context).push(MaterialPageRoute(builder: (context) => const OnCallScreen()));
                          },
                          child: Container(
                            height: 62,
                            width: double.infinity,
                            decoration: BoxDecoration(color: AppColor.veryPaleRed, borderRadius: BorderRadius.circular(10)),
                            child:const Center(child: CommonText.medium("My Jobs", size: 15, color: AppColor.textInSkyBox)),
                          ),
                        ),
                        const Gap(14),
                       // for (int i = 0; i < 33; i++)
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
                                          child: const CommonText.semiBold("Full time", size: 12, color: AppColor.textPrimary),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      height: 28,
                                      width: 79,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(color: AppColor.red, borderRadius: BorderRadius.circular(100)),
                                      child: const CommonText.semiBold("Cancel", size: 12, color: AppColor.white),
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
          ],
        ));
  }
}
