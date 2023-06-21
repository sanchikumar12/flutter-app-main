import 'package:design/AppConstant/app_color.dart';
import 'package:design/AppConstant/images.dart';
import 'package:design/Screens/doctor/main/doctor_home.dart';
import 'package:design/Screens/widgets/appbar.dart';
import 'package:design/Screens/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class Profile3 extends StatefulWidget {
  const Profile3({Key? key}) : super(key: key);

  @override
  State<Profile3> createState() => _Profile3State();
}

class _Profile3State extends State<Profile3> {
  List<String> work = [
    "Critical Care",
    "E.R",
    "Ward",
    "General Med",
    "Gync",
    "Nephro",
    "Neuro",
    "Gen Surgery",
    "Dermat",
    "Ortho",
    "Gastro",
    "Pulmo",
    "Anaesthsia",
  ];
  List selectedWork = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SecondAppbar(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 37),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Gap(37),
                  const CommonText.semiBold("Work Details", size: 25, color: AppColor.black),
                  const Gap(22),
                  const CommonText.medium("Education Level", size: 18, color: AppColor.greyText),
                  const Gap(16),
                  SizedBox(
                    width: 98,
                    child: DecoratedBox(
                      decoration: const BoxDecoration(
                        border: Border(bottom: BorderSide(color: AppColor.greyText)),
                      ),
                      child: DropdownButton<String>(
                        items: <String>['A', 'B', 'C', 'D'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: CommonText.medium(value.toString(), size: 16, color: AppColor.textDark),
                          );
                        }).toList(),
                        icon: const Image(
                          image: AssetImage(AppIcons.downArrow),
                          width: 18,
                          height: 10,
                          color: AppColor.black,
                        ),
                        isExpanded: true,
                        underline: Container(),
                        style: const TextStyle(fontSize: 20, color: Colors.blue),
                        hint: const CommonText.regular("PG", size: 16, color: AppColor.black),
                        onChanged: (value) {},

                        //value: _selectedLocation,
                      ),
                    ),
                  ),
                  const Gap(35),
                  ListView.builder(
                    itemCount: work.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, ind) {
                      int index = ind - 1;
                      return ind == 0
                          ? const Padding(
                              padding: EdgeInsets.only(bottom: 5),
                              child: CommonText.medium("Select Works", size: 18, color: AppColor.greyText),
                            )
                          : Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: InkWell(
                                onTap: () {
                                  if (selectedWork.contains(index)) {
                                    selectedWork.remove(index);
                                    setState(() {});
                                  } else {
                                    selectedWork.add(index);
                                    setState(() {});
                                  }
                                },
                                child: Row(
                                  children: [
                                    selectedWork.contains(index)
                                        ? const Icon(
                                            Icons.check_box,
                                            color: AppColor.blueText,
                                          )
                                        : const Icon(Icons.square_rounded, color: Color(0xFFD9D9D9)),
                                    const SizedBox(width: 8),
                                    CommonText.medium(work[index], size: 18, color: AppColor.textPrimary),
                                  ],
                                ),
                              ),
                            );
                    },
                  ),
                  const Gap(38),
                  Center(
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const DoctorHome()));
                      },
                      child: Container(
                        height: 53,
                        width: 150,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(color: AppColor.black, borderRadius: BorderRadius.circular(6)),
                        child: const CommonText.medium("Next", size: 22, color: AppColor.white),
                      ),
                    ),
                  ),
                  const Gap(55),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
