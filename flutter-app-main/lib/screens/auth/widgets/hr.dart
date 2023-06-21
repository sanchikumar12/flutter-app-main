import 'package:flutter/material.dart';

Widget hr(double left, double right) {
  return Expanded(
    child: Container(
      margin: EdgeInsets.only(left: left, right: right),
      child: Divider(
        color: Colors.black,
        height: 1,
      ),
    ),
  );
}
