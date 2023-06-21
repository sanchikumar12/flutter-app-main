import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:grocapp/const/color_const.dart';

Widget cartCount(Stream<int> cartCountStream) {
  return StreamBuilder<int>(
    stream: cartCountStream,
    builder: (context, snapshot) {
      var count = (!snapshot.hasData) ? 0 : snapshot.data;
      return Badge(
        animationDuration: Duration(milliseconds: 500),
        showBadge: count != 0,
        badgeContent: Text(
          "$count",
          style: TextStyle(color: Colors.black),
        ),
        badgeColor: primaryColor,
        animationType: BadgeAnimationType.fade,
        child: Icon(Icons.shopping_cart),
      );
    },
  );
}
