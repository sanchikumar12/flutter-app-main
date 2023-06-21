import 'package:flutter/material.dart';
import 'package:grocapp/widgets/loader.dart';

Widget dbWrite(context, header, body) {
  return WillPopScope(
    onWillPop: () async => false,
    child: Container(
      color: Colors.white,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  header,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 25),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                body,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                height: 20,
              ),
              loader(),
              SizedBox(
                height: 20,
              ),
              Text(
                "Do not close the app\nor\nhit the back button",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, color: Colors.black38),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
