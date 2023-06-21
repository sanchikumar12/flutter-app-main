import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocapp/models/product_model.dart';

Future<void> addToCart(
  ProductModel item,
  Variety v,
  String uid,
  String productCode,
  ValueNotifier<bool> notifier,
) async {
  notifier.value = true;

  if (v.stock != 0) {
    CartModel cartItem = CartModel(item, v);

    DocumentReference docRef = Firestore.instance
        .collection('users')
        .document(uid)
        .collection("cart")
        .document();

    Map<String, dynamic> docMap = cartItem.map;

    docMap["cartItemId"] = docRef.documentID;

    await Firestore.instance
        .collection('users')
        .document(uid)
        .collection("cart")
        .document(docRef.documentID)
        .setData(docMap);
  } else {
    itemNotAddedToast();
  }
  notifier.value = false;
}

Future<void> removeFromCart(String cartItemId, String uid) {
  return Firestore.instance
      .collection('users')
      .document(uid)
      .collection("cart")
      .document(cartItemId)
      .delete();
}

Future<bool> incrementItemCount(
    int currentCount,
    double currentStock,
    double stockFraction,
    String uid,
    String cartItemId,
    ValueNotifier<bool> notifier) async {
  bool addedToCart;
  notifier.value = true;

  if ((currentCount + 1) * stockFraction <= currentStock) {
    final DocumentReference docRef = Firestore.instance
        .collection('users')
        .document(uid)
        .collection("cart")
        .document(cartItemId);

    await docRef.updateData({
      'count': currentCount + 1,
    });
    addedToCart = true;
  } else {
    addedToCart = false;
  }

  notifier.value = false;
  return addedToCart;
}

Future<void> decrementItemCount(int currentCount, String uid, String cartItemId,
    ValueNotifier<bool> notifier) async {
  notifier.value = true;

  final DocumentReference docRef = Firestore.instance
      .collection('users')
      .document(uid)
      .collection("cart")
      .document(cartItemId);

  if (currentCount == 1) {
    docRef.delete();
  } else {
    docRef.updateData({
      'count': currentCount - 1,
    });
  }

  notifier.value = false;
}

Future<List<ProductModel>> getProducts(
    List<CartModel> cartItems, FirebaseUser user) async {
  List<Future<DocumentSnapshot>> future = [];
  cartItems.forEach((cartItem) {
    future.add(Firestore.instance
        .collection("products")
        .document(cartItem.productId)
        .get());
  });

  List<DocumentSnapshot> snap = await Future.wait(future);
  List<ProductModel> products = [];
  snap.forEach((e) {
    if (e.exists) {
      products.add(ProductModel.fromSnapshot(e));
    }
  });
  return products;
}

void itemNotAddedToast() async {
  try {
    await Fluttertoast.cancel();
  } catch (e) {}
  Fluttertoast.showToast(
      msg: 'Cannot add more items of this product',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.grey[100],
      textColor: Colors.red);
}
