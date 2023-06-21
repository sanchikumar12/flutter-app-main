import 'dart:async';
import 'package:flutter/material.dart';
import 'package:grocapp/models/order_model.dart';
import 'package:grocapp/screens/profile/orders/core/api.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocapp/screens/profile/orders/locator.dart';

class FirestoreModel extends ChangeNotifier {
  Api _api = locator<Api>();

  List<OrderModel> orders;
  

  Future<List<OrderModel>> fetchOrders() async {
    var result = await _api.getDataCollection();
    orders = result.documents
        .map((doc) => OrderModel.fromMap(doc.data, doc.documentID))
        .toList();
    return orders;
  }

  Stream<QuerySnapshot> fetchOrdersAsStream() {
    return _api.streamDataCollection();
  }

  // Future<Order> getOrderById(String id) async {
  //   var doc = await _api.getDocumentById(id);
  //   return Order.fromMap(doc.data, doc.documentID);
  // }

  // Future removeOrder(String id) async {
  //   await _api.removeDocument(id);
  //   return;
  // }

  // Future updateOrder(Order data, String id) async {
  //   await _api.updateDocument(data.toJson(), id);
  //   return;
  // }

  // Future addOrder(Order data) async {
  //   var result = await _api.addDocument(data.toJson());

  //   return;
  // }
}
