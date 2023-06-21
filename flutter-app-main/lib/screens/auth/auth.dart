import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocapp/const/route_constants.dart';
import 'package:grocapp/const/size_config.dart';
import 'package:grocapp/const/text_style.dart';
import 'package:grocapp/widgets/loader.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';

import 'phone/more_details.dart';

class Auth extends StatefulWidget {
  const Auth({Key key}) : super(key: key);
  @override
  _AuthState createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  int video = 1;
  bool versioncheck = true;
  bool updaterequired = false;
  bool maintenance = false;
  bool _loggedIn = false;
  bool _loading = true;
  bool _needMoreDetails = false;
  FirebaseUser firebaseUser;
  DocumentReference docRef;

  void _checkLogin() async {
    firebaseUser = await FirebaseAuth.instance.currentUser();
    _loggedIn = firebaseUser != null;
    if (_loggedIn) {
      docRef =
          Firestore.instance.collection('users').document(firebaseUser.uid);
      var snapshot = await docRef.get();
      if (!snapshot.exists || !snapshot.data.containsKey("name")) {
        _needMoreDetails = true;
      }
    }
    setState(() {
      _loading = false;
    });
  }

  @override
  void initState() {
    _checkVersion();
    //  _checkLogin();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Widget build(BuildContext context) {
    SizeConfig().init(context);

    if (versioncheck == true) {
      return Scaffold(body: homeloader());
    }
    if (updaterequired == true) {
      return Scaffold(
        body: SafeArea(
          child: Center(
            child: Card(
              elevation: 8,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: IntrinsicHeight(
                  child: Column(
                    children: <Widget>[
                      Center(
                        child: Text(
                          'Update Required',
                          style: orderDetilsHeadText,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: Text(
                          'Please Update to the Latest Version of the app',
                          style: orderDetilsContentText,
                          textAlign: TextAlign.justify,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            MaterialButton(
                              onPressed: () {SystemNavigator.pop();},
                              child: Text(
                                'Close',
                                style: GoogleFonts.nunito(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.red),
                              ),
                            ),
                            MaterialButton(
                              onPressed: () {
                                _launchStore(
                                    'https://play.google.com/store/apps/details?id=com.freshpantry.frapen');
                              },
                              child: Text(
                                'Update',
                                style: GoogleFonts.nunito(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.blue),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    if (maintenance == true) {
      return Scaffold(
        body: SafeArea(
          child: Center(
            child: Card(
              elevation: 8,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: IntrinsicHeight(
                  child: Column(
                    children: <Widget>[
                      Center(
                        child: Text(
                          'Under Maintenance',
                          style: orderDetilsHeadText,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: Text(
                          'App is currently under maintenace. Please have patience and we will be back soon....',
                          style: orderDetilsContentText,
                          textAlign: TextAlign.justify,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            MaterialButton(
                              onPressed: () {SystemNavigator.pop();},
                              child: Text(
                                'Close',
                                style: GoogleFonts.nunito(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
    if (_loading) {
      return Scaffold(body: homeloader());
    }

    if (_loggedIn) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (_needMoreDetails) {
          Navigator.popUntil(context, (route) => route.isFirst);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => MoreDetails(firebaseUser, docRef),
              ));
        } else {
          Navigator.popUntil(context, (route) => route.isFirst);
          Navigator.pushReplacementNamed(
            context,
            HomeRoute,
          );
        }
      });
      return Scaffold(body: homeloader());
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        Navigator.pushReplacementNamed(
          context,
          PhoneLoginRoute,
        );
      });
      return Scaffold(body: homeloader());
    }
  }

  void _checkVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;

    var document = Firestore.instance.collection('extras').document('about');
    await document.get().then((value) {
      if (value.data['maintenance'] == true) {
        maintenance = true;
      }
      if (value.data['version']['id'] != version &&
          value.data['version']['update'] == true) {
        setState(() {
          versioncheck = false;
          updaterequired = true;
        });
      } else {
        setState(() {
          versioncheck = false;
          _checkLogin();
        });
      }
    });
  }

  _launchStore(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
