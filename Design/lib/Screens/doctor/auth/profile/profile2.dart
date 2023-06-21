import 'package:design/AppConstant/app_color.dart';
import 'package:design/AppConstant/images.dart';
import 'package:design/Screens/doctor/auth/profile/profile3.dart';
import 'package:design/Screens/widgets/appbar.dart';
import 'package:design/Screens/widgets/image.dart';
import 'package:design/Screens/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class Profile2 extends StatefulWidget {
  const Profile2({Key? key}) : super(key: key);

  @override
  State<Profile2> createState() => _Profile2State();
}

class _Profile2State extends State<Profile2> {


  @override
  void initState() {

    super.initState();
  }
  TextEditingController? pinController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColorDoctor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SecondAppbar(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 37),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:  [
                  const Gap(37),
                  const CommonText.semiBold("KYC Details", size: 25, color: AppColor.black),
                  const Gap(18),
                  const CommonText.medium("Upload Aaddhar", size: 18, color: AppColor.greyText),
                  const Gap(16),
                  Row(
                    children: [
                      Column(
                        children: [
                          InkWell(
                            onTap: () async{

                            },
                            child: Container(
                              height: 77,
                              width: 133,
                              decoration: BoxDecoration(
                                color: AppColor.greyText.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child:  Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SquareImageFromAsset(AppIcons.camera,size: 33),
                                ],
                              ),
                            ),
                          ),
                          const Gap(8),
                          const CommonText.medium("Front", size: 18, color: AppColor.blueText),
                        ],
                      ),
                      const SizedBox(width: 18),
                      Column(
                        children: [
                          InkWell(
                            onTap: () async{
                            },
                            child: Container(
                              height: 77,
                              width: 133,
                              decoration: BoxDecoration(
                                color: AppColor.greyText.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child:  Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SquareImageFromAsset(AppIcons.camera,size: 33),
                                ],
                              ),
                            ),
                          ),
                          const Gap(8),
                          const CommonText.medium("Back", size: 18, color: AppColor.blueText),
                        ],
                      ),

                    ],
                  ),
                  const Gap(24),
                  const CommonText.medium("Upload License/ Provisional ", size: 18, color: AppColor.greyText),
                  const Gap(15),
                  InkWell(
                    onTap: () {

                    },
                    child: Container(
                      height: 44,
                      width: 123,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                        border: Border.all(color:AppColor.greyText),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          CommonText.medium("Upload ", size: 18, color: Color(0xFFD0D0D0)),
                          Gap(7),
                          Icon(Icons.file_upload_outlined,color:AppColor.blueText),
                        ],
                      ),
                    ),
                  ),
                  const Gap(58),
                  Center(
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const Profile3()));
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
                  const Gap(58),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}
