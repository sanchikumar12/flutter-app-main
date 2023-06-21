import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class QueryProvider {
  bool decreasing;
  String orderBy;
  String field;
  dynamic query;
  int limit;
  bool qAdd;
  QueryProvider({
    @required this.orderBy,
    @required this.field,
    @required this.query,
    this.limit = 15,
    this.decreasing = false,
  }) : qAdd = false;

  QueryProvider.forQuickAdd({
    this.limit = 10,
    this.orderBy = "freq",
    this.decreasing = true,
  }) : qAdd = true;

  Future<List<DocumentSnapshot>> fetchFirstList() async {
    if (qAdd == true) {
      return (await Firestore.instance
              .collection("products")
              .where("totalStock", isGreaterThan: 0)
              .where("active", isEqualTo: true)
              .where("qAdd", isEqualTo: true)
              .orderBy("totalStock", descending: true)
              .orderBy(orderBy, descending: decreasing)
              .limit(limit)
              .getDocuments())
          .documents;
    }
    return (await Firestore.instance
            .collection("products")
            .where("totalStock", isGreaterThan: 0)
            .where("active", isEqualTo: true)
            .where(field, isEqualTo: query)
            .orderBy("totalStock", descending: true)
            .orderBy(orderBy, descending: decreasing)
            .limit(limit)
            .getDocuments())
        .documents;
  }

  Future<List<DocumentSnapshot>> fetchNextList(
      List<DocumentSnapshot> documentList) async {
    if (qAdd == true) {
      return (await Firestore.instance
              .collection("products")
              .where("totalStock", isGreaterThan: 0)
              .where("active", isEqualTo: true)
              .where("qAdd", isEqualTo: true)
              .orderBy("totalStock", descending: true)
              .orderBy(orderBy, descending: decreasing)
              .startAfterDocument(documentList.last)
              .limit(limit)
              .getDocuments())
          .documents;
    }
    return (await Firestore.instance
            .collection("products")
            .where("totalStock", isGreaterThan: 0)
            .where("active", isEqualTo: true)
            .where(field, isEqualTo: query)
            .orderBy("totalStock", descending: true)
            .orderBy(orderBy, descending: decreasing)
            .startAfterDocument(documentList.last)
            .limit(limit)
            .getDocuments())
        .documents;
  }
}
