import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocapp/const/color_const.dart';

TextStyle onBoardTitleText = GoogleFonts.nunito(
    fontSize: 22, fontWeight: FontWeight.w700, color: Colors.black);
TextStyle onBoardDetailsText = GoogleFonts.nunito(
    fontSize: 18, fontWeight: FontWeight.w500, color: Colors.grey);

//Product Details

TextStyle detNameText = GoogleFonts.robotoSlab(fontSize: 22);

TextStyle detSpText = GoogleFonts.roboto(
    fontSize: 30, color: accentColor, fontWeight: FontWeight.w500);

TextStyle detMrpText = GoogleFonts.notoSans(
    decoration: TextDecoration.lineThrough,
    fontSize: 15,
    color: Colors.grey,
    fontWeight: FontWeight.w300);

TextStyle detOffText = GoogleFonts.notoSans(
    fontSize: 15, color: Colors.blue, fontWeight: FontWeight.w400);

TextStyle detDescText =
    GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.w600);

TextStyle detDescSubText =
    GoogleFonts.nunito(fontSize: 15, fontWeight: FontWeight.w400);

TextStyle detBenfText =
    GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.w600);

TextStyle detBenSubText =
    GoogleFonts.nunito(fontSize: 15, fontWeight: FontWeight.w400);

TextStyle detAddCartText = GoogleFonts.lato(
    fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white);

//Profile

TextStyle profileList = GoogleFonts.nunito(
    fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black);
TextStyle profileListSub = GoogleFonts.nunito(
    fontSize: 12, fontWeight: FontWeight.w400, color: Colors.grey);

//User Details
TextStyle titleText = GoogleFonts.lato(
    fontSize: 15, fontWeight: FontWeight.w600, color: accentColor);
TextStyle valueText =
    GoogleFonts.lato(fontWeight: FontWeight.w600, color: Colors.black);

//Cart
TextStyle checkOutPriceText = GoogleFonts.roboto(
    fontSize: 20, color: Colors.indigo, fontWeight: FontWeight.w700);

TextStyle orderSummaryTitleText =
    GoogleFonts.nunito(fontSize: 20, fontWeight: FontWeight.w700);

//My Orders
TextStyle orderListHeadText = GoogleFonts.nunito(
    fontSize: 16, fontWeight: FontWeight.w700, color: Colors.black);
TextStyle orderListContentText = GoogleFonts.nunito(
    fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black);

//Order Details
TextStyle orderDetilsHeadText = GoogleFonts.nunito(
    fontSize: 18, fontWeight: FontWeight.w700, color: Colors.black);
TextStyle orderDetilsContentText = GoogleFonts.nunito(
    fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black);

final kTitleStyle = TextStyle(
  color: Colors.black,
  fontFamily: 'CM Sans Serif',
  fontSize: 26.0,
  height: 1.5,
);

final kSubtitleStyle = TextStyle(
  color: Colors.grey,
  fontSize: 18.0,
  height: 1.2,
);

TextStyle faqHeadText = GoogleFonts.nunito(
    fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black);
