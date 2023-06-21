import 'package:flutter/material.dart';

Widget listLoadingTile() {
  return ListTile(
    title: Center(
      child: CircularProgressIndicator(),
    ),
  );
}
