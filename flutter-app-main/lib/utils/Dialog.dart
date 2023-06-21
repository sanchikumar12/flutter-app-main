import 'package:flutter/material.dart';
import 'package:grocapp/widgets/loader.dart';

class ProgressDialog {
  static Future<void> showLoadingDialog(
      BuildContext context, GlobalKey key) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new WillPopScope(
              onWillPop: () async => false,
              child: SimpleDialog(
                  key: key,
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  children: <Widget>[loader()]));
        });
  }
}
