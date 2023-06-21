import 'package:flutter/material.dart';
import 'package:grocapp/const/color_const.dart';

Row minimumOrderMessage(
    {double totalPrice, double minOrder, bool asterisk = false}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Expanded(
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(top: 2, bottom: 2),
          color: accentColor,
          height: totalPrice < minOrder ? null : 0,
          child: Text(
            (asterisk ? "* " : "") +
                "Free delivery on orders of ₹ $minOrder and above",
            style: TextStyle(color: Colors.white),
          ),
        ),
      )
    ],
  );
}
