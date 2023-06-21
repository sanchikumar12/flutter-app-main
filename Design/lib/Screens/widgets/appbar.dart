import 'package:design/AppConstant/app_color.dart';
import 'package:design/AppConstant/images.dart';
import 'package:design/Screens/widgets/image.dart';
import 'package:design/Screens/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class Appbar extends StatelessWidget {
  final Color color;
  const Appbar({Key? key,  this.color=AppColor.primary}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      padding: const EdgeInsets.only(left: 24, right: 24, bottom: 8),
      decoration:  BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(25), bottomRight: Radius.circular(25)),
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.end, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: const [
        Image(image: AssetImage(AppImages.appbarLogo), height: 50, width: 180),
        Padding(
          padding: EdgeInsets.only(bottom: 22),
          child: Image(image: AssetImage(AppIcons.menu), height: 12, width: 27),
        ),
      ]),
    );
  }
}



class SecondAppbar extends StatelessWidget {
  final Color color;
  const SecondAppbar({Key? key,  this.color=AppColor.primary}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 279,
      width: double.infinity,
      padding: const EdgeInsets.only(bottom: 44),
      decoration:  BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(60), bottomRight: Radius.circular(60)),
      ),
      child:  Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: const [
          Image(image: AssetImage(AppImages.appbarLogo2), height: 88),
        ],
      ),
    );
  }
}
