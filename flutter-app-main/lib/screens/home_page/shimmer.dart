import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget shimmerOffer(BuildContext context) {
  return Shimmer.fromColors(
    period: Duration(milliseconds: 1000),
    baseColor: Colors.green[50],
    highlightColor: Colors.greenAccent[100],
    child: Container(
      width: MediaQuery.of(context).size.width,
      height: 150,
      margin: EdgeInsets.symmetric(horizontal: 5.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
    ),
  );
}

Widget shimmerCategory(BuildContext context) {
  return Shimmer.fromColors(
    period: Duration(milliseconds: 1000),
    baseColor: Colors.grey[100],
    highlightColor: Colors.grey[300],
    child: Container(
        decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10.0),
      color: Colors.white,
    )),
  );
}
