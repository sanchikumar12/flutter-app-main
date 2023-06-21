import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MinimumOrderProvider with ChangeNotifier {
  double _minimumOrder;
  double _extraCharge;
  StreamSubscription _minimumOrderSub;

  MinimumOrderProvider() {
    _minimumOrderSub = Firestore.instance
        .collection('extras')
        .document('orders')
        .snapshots()
        .listen((orders) {
      if (orders.exists) {
        _minimumOrder = double.tryParse("${orders.data['minimum']}") ?? 299;
        _extraCharge = double.tryParse("${orders.data['extraCharge']}") ?? 29;
        print(
            "MinimumOrderProvider - $_minimumOrder , ${orders.data['minimum']}, ${orders.data['extraCharge']}");
      }
      notifyListeners();
    }, onError: (e) {
      print('ConfigProvider - Orders - $e');
    });
  }

  @override
  void dispose() {
    if (_minimumOrderSub != null) {
      _minimumOrderSub.cancel();
      _minimumOrderSub = null;
    }
    super.dispose();
  }

  double get minimumOrder => _minimumOrder;

  double get extraCharge => _extraCharge;
}
