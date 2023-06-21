import 'dart:io';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:design/AppConstant/app_color.dart';
import 'package:design/AppConstant/images.dart';
import 'package:design/Screens/doctor/auth/profile/profile2.dart';
import 'package:design/Screens/widgets/appbar.dart';
import 'package:design/Screens/widgets/image.dart';
import 'package:design/Screens/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';

class Profile1 extends StatefulWidget {
  const Profile1({Key? key}) : super(key: key);

  @override
  State<Profile1> createState() => _Profile1State();
}

class _Profile1State extends State<Profile1> {
  //FilePickerResult? result;
  //File? profileImageFile;
  String _selectedDate = '';

  var profilePic;
  XFile? image;
  final ImagePicker _picker = ImagePicker();
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Gap(28),
                  Align(
                      alignment: Alignment.center,
                      child: InkWell(
                        onTap: () async {
                          image = await _picker.pickImage(
                              source: ImageSource.gallery);
                          setState(() {
                            profilePic = image!.path;
                          });
                        },
                        child:profilePic==null? Container(
                          height: 130,
                          width: 130,
                          decoration: const BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
                          child: SquareImageFromAsset(AppImages.profile, size: 130),
                        ):Container(
                          height: 130,
                          width: 130,
                          decoration:  const BoxDecoration(color: Colors.blue, shape: BoxShape.circle,),
                          child: CircleAvatar(child: Image.file(File(profilePic),fit: BoxFit.cover,))
                        ),
                      )),
                  const Gap(47),
                  const CommonText.medium("Full Name", size: 18, color: AppColor.greyText),
                  Padding(
                    padding: const EdgeInsets.only(left: 4, right: 50),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Name',
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColor.greyText),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColor.greyText),
                        ),
                      ),
                    ),
                  ),
                  const Gap(35),
                  const CommonText.medium("Mobile No.", size: 18, color: AppColor.greyText),
                  Padding(
                    padding: const EdgeInsets.only(left: 4, right: 50),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'No.',
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColor.greyText),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColor.greyText),
                        ),
                      ),
                    ),
                  ),
                  const Gap(40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const CommonText.medium("DOB", size: 18, color: AppColor.greyText),
                            TextFormField(
                              decoration: const InputDecoration(),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: SizedBox(
                          height: 50,
                          child: DateTimePicker(
                            dateHintText: "Select Date1",
                            fieldHintText: "Select Date2",
                            fieldLabelText: "Select Date3",
                            textAlign: TextAlign.start,
                            textInputAction: TextInputAction.none,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              labelText: _selectedDate.isNotEmpty
                                  ? _selectedDate
                                  : "Select Date",labelStyle: TextStyle(
                                color: Colors.black,
                                fontSize: _selectedDate.isEmpty?15:18),),

                            style: const TextStyle(
                                color: Colors.black,
                            ),
                            initialValue: _selectedDate,
                            //controller: date,
                            firstDate: DateTime(2000),
                            initialDate: DateTime.now().subtract(Duration(days: 1)),//snapshot.data!.data.withdrawalFromDate,//DateTime.now(),
                            lastDate: DateTime(2101),

                            onChanged: (val) {
                              //date = val as DateTime;
                              print("================================+${val}");
                              setState(() {
                                _selectedDate="";
                                _selectedDate = val;
                              });
                            },
                            validator: (val) {
                              print(val);
                              //date = val! as DateTime;

                              _selectedDate = val!;

                            },
                            onSaved: (val) {
                              print(val);
                              _selectedDate = val!;

                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const CommonText.medium("Gender", size: 18, color: AppColor.greyText),
                            TextFormField(
                              decoration: const InputDecoration(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Gap(56),
                  Center(
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const Profile2()));
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
                  const Gap(41),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
