import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grocapp/models/product_model.dart';
import 'package:rxdart/rxdart.dart';

class CartProvider extends ChangeNotifier {
  List<CartModel> _items = [];
  StreamSubscription<FirebaseUser> userAuthSub;
  Firestore firestore = Firestore.instance;
  StreamSubscription<QuerySnapshot> cartSub;

  final cartController = BehaviorSubject<List<CartModel>>();
  final cartLengthController = BehaviorSubject<int>();
  var cartCount = 0;
  List<CartModel> get cart => _items;

  CartProvider() {
    userAuthSub = FirebaseAuth.instance.onAuthStateChanged.listen((user) {
      if (user == null) {
        _items = [];
        cartCount = 0;
        cartController.add(_items);
        cartLengthController.add(cartCount);
      } else {
        cartSub = firestore
            .collection("users")
            .document(user.uid)
            .collection("cart")
            .snapshots()
            .listen((snapshot) {
          _items = [];
          snapshot.documents.forEach((element) {
            _items.add(CartModel.forCart(element.data));
          });
          cartCount = _items.length;
          cartController.add(_items);
          cartLengthController.add(cartCount);
        });
      }
    });
  }

  @override
  void dispose() {
    if (userAuthSub != null) {
      userAuthSub.cancel();
      userAuthSub = null;
    }
    if (cartSub != null) {
      cartSub.cancel();
      cartSub = null;
    }
    cartController.close();
    cartLengthController.close();
    super.dispose();
  }
}
