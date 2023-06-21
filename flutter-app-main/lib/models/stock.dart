import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Stock {
  String barcode;
  double mrp;
  double sp;
  double stock;
  Stock({this.barcode, this.mrp, this.sp, this.stock});

  Stock.empty(String barcode)
      : barcode = barcode,
        mrp = 0,
        sp = 0,
        stock = 0;

  Stock.fromJson(Map<String, dynamic> data)
      : barcode = data['barcode'],
        mrp = data['mrp'],
        sp = data['sp'],
        stock = data['stock'];

  Stock.fromSnap(DocumentSnapshot snapshot)
      : barcode = snapshot.data['barcode'],
        mrp = snapshot.data['mrp'],
        sp = snapshot.data['sp'],
        stock = snapshot.data['stock'];

  Map<String, dynamic> toJson() => {
        'barcode': barcode,
        'mrp': mrp,
        'sp': sp,
        'stock': stock,
      };
}
