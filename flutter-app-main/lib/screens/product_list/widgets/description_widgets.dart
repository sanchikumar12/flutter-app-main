import 'package:flutter/material.dart';
import 'package:grocapp/const/color_const.dart';
import 'package:grocapp/models/product_model.dart';
import 'package:grocapp/utils/utils.dart';

Widget spMrp(Variety variety) {
  return Row(
    children: <Widget>[
      Container(
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5), color: prodSpColor),
        child: Text(
          '₹ ${variety.sp} ',
          style: TextStyle(
            color: Colors.white,
          ),
          textAlign: TextAlign.left,
        ),
      ),
      SizedBox(
        width: 8,
      ),
      variety.mrp != variety.sp
          ? Text(
              '₹ ${variety.mrp}',
              style: TextStyle(
                color: prodMrpColor,
                decoration: TextDecoration.lineThrough,
              ),
              textAlign: TextAlign.left,
            )
          : SizedBox(),
    ],
  );
}

Widget discount(double discount) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5), color: Colors.white),
    child: Text(
      '₹ ${priceText(discount)} Off',
      style: TextStyle(
        color: prodDiscountColor,
      ),
      textAlign: TextAlign.left,
    ),
  );
}
