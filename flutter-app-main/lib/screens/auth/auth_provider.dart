import 'dart:async';

import 'package:firebase_user_stream/firebase_user_stream.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider with ChangeNotifier {
  FirebaseAuth auth = FirebaseUserReloader.auth;
  FirebaseUser user;
  StreamSubscription userAuthSub;

  _getCurrentUser() async {
    user = await auth.currentUser();
  }

  AuthProvider() {
    _getCurrentUser();
    userAuthSub =
        FirebaseUserReloader.onAuthStateChangedOrReloaded.listen((newUser) {
      print('AuthProvider - FirebaseAuth - onAuthStateChanged - $newUser');
      user = newUser;
      notifyListeners();
    }, onError: (e) {
      print('AuthProvider - FirebaseAuth - onAuthStateChanged - $e');
    });
  }

  @override
  void dispose() {
    if (userAuthSub != null) {
      userAuthSub.cancel();
      userAuthSub = null;
    }
    super.dispose();
  }

  bool get isAuthenticated {
    return user != null;
  }

  void signOut() {
    if (isAuthenticated == true) auth.signOut();
  }
}
