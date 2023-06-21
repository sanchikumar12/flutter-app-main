import 'package:design/AppConstant/app_color.dart';
import 'package:design/AppConstant/images.dart';
import 'package:design/Screens/hospital/main/hospital_home.dart';
import 'package:design/Screens/widgets/appbar.dart';
import 'package:design/Screens/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ProfileHospital extends StatefulWidget {
  const ProfileHospital({Key? key}) : super(key: key);

  @override
  State<ProfileHospital> createState() => _ProfileHospitalState();
}

class _ProfileHospitalState extends State<ProfileHospital> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SecondAppbar(color: AppColor.secondary),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:  [
                  const Gap(82),
                  const CommonText.medium("Entity", size: 18, color: AppColor.greyText),
                  SizedBox(
                    width: 106,
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
                        icon:  const Image(
                          image: AssetImage(AppIcons.downArrow),
                          width: 18,
                          height: 10,
                          color: AppColor.black,
                        ),
                        isExpanded: true,
                        underline: Container(),
                        style: const TextStyle(fontSize: 20, color: Colors.blue),
                        hint: const CommonText.regular("Hospital", size: 16, color: AppColor.textPrimary),
                        onChanged: (value) {},

                        //value: _selectedLocation,
                      ),
                    ),
                  ),
                  const Gap(19),
                  const CommonText.medium("Hospital/ Clinic name", size: 18, color: AppColor.greyText),
                  Padding(
                    padding: const EdgeInsets.only( right: 50),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Name',
                        hintStyle: TextStyle(color: AppColor.textPrimary,fontWeight: FontWeight.w400),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColor.greyText),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColor.greyText),
                        ),
                      ),
                    ),
                  ),
                  const Gap(20),
                  const CommonText.medium("Contact No.", size: 18, color: AppColor.greyText),
                  Padding(
                    padding: const EdgeInsets.only( right: 50),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'NO.',
                        hintStyle: TextStyle(color: AppColor.textPrimary,fontWeight: FontWeight.w400),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColor.greyText),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColor.greyText),
                        ),
                      ),
                    ),
                  ),
                  const Gap(11),
                  const CommonText.medium("City", size: 18, color: AppColor.greyText),
                  SizedBox(
                    width: 132,
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
                        icon:  const Image(
                          image: AssetImage(AppIcons.downArrow),
                          width: 18,
                          height: 10,
                          color: AppColor.black,
                        ),
                        isExpanded: true,
                        underline: Container(),
                        style: const TextStyle(fontSize: 20, color: Colors.blue),
                        hint: const CommonText.regular("Hyderabad", size: 16, color: AppColor.textPrimary),
                        onChanged: (value) {},

                        //value: _selectedLocation,
                      ),
                    ),
                  ),
                  const Gap(11),
                  const CommonText.medium("Location", size: 18, color: AppColor.greyText),
                  Padding(
                    padding: const EdgeInsets.only( right: 20),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Locat',
                        hintStyle: TextStyle(color: AppColor.textPrimary,fontWeight: FontWeight.w400),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColor.greyText),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColor.greyText),
                        ),
                      ),
                    ),
                  ),
                  const Gap(56),
                  Center(
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const HospitalHome()));
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
                  const Gap(62),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
