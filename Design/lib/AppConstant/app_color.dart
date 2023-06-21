import 'package:flutter/material.dart';

abstract class AppColor {
  static const white = Color(0xFFFFFFFF);//
  static const black = Color(0xFF000000);//
  static const black30 = Color(0xFF121212);
  static const transparent = Color(0x00000000);

  static const primary = Color(0xFF209276);//
  static const secondary = Color(0xFF403CED);//
  static const backgroundColorDoctor = Color(0xFFF8F8F8);//
  static const pinkShade = Color(0xFFFFF2F2);//

  static const textDark = Color(0xFF3C3C3C);//
  static const textLight = Color(0xFF696969);//
  static const textTitle = Color(0xFF1D1D1D);//
  static const textPrimary = Color(0xFF464646);//
  static const textInSkyBox = Color(0xFF4F656A);//
  static const textInVeryPaleRedBox = Color(0xFF684F6A);//
  static const dividerColor = Color(0xFF929191);
  static const greyBg = Color(0xFFF4F4F4);
  static const greyText = Color(0xFF949494);//
  static const blueText = Color(0xFF086ECD);//
  static const redText = Color(0xFFF54949);

  static const grey = Color(0xFF898F97);
  static const greyLight1 = Color(0xFFDEDEDE);//
  static const greyLight2 = Color(0xFFF0F0F0);//
  static const greyLight3= Color(0xFFEAEAEA);//
  static const grey2 = Color(0xFFA7A7A7);//
  static const grey3 = Color(0xFF414141);//

  static const red = Color(0xFFEE3D3D);
  static const skyBlue = Color(0xFF74CAFC);
  static const orange = Color(0xFFEF711F);

  static const greenLight = Color(0xFF7FFF00);
  static const purple = Color(0xFF9253C8);
  static const blue = Color(0xFF4875FF);
  static const deselected = Color(0xFF78838E);
  static const skin = Color(0xFFF0DCB4);//
  static const lightSky = Color(0xFFA8E0EE);//
  static const lightPurple = Color(0xFFE9CDFF);//
  static const veryPaleRed = Color(0xFFFFCDCD);//
  static const green = Color(0xFF209276);//
  static const lightYellow = Color(0xFFFFE3AA);//


  static const facebookBlue = Color(0xFF1877F2);
  static const dislike = Color(0xFF626169);
  static const favourite = Color(0xFF828C5E);

  static const primaryGradient = LinearGradient(
    colors: [primary, secondary],
    begin: AlignmentDirectional.centerStart,
    end: AlignmentDirectional.centerEnd,
  );
}
