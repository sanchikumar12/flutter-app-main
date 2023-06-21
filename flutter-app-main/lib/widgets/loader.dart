import 'package:flutter/material.dart';
import 'package:grocapp/const/color_const.dart';

Widget loader() {
  return Center(
    child: SizedBox(
        height: 75.0,
        width: 75.0,
        child: Card(
          child: Stack(
            children: <Widget>[
              Center(
                child: SizedBox(
                    height: 50,
                    width: 50,
                    child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(primaryColor))),
              ),
              Center(
                child: Image.asset(
                  'assets/img/logo.png',
                  height: 30,
                  width: 30,
                ),
              )
            ],
          ),
        )),
  );
}

Widget homeloader() {
  return Center(
    child: SizedBox(
        height: 185.0,
        width: 185.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Center(
              child: Image.asset(
                'assets/img/logo_in.png',
                height: 120,
                width: 120,
              ),
            ),
            Center(
              child: SizedBox(
                  height: 35,
                  width: 35,
                  child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(primaryColor))),
            ),
          ],
        )),
  );
}
