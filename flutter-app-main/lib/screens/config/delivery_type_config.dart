import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocapp/models/delivery_types.dart';

class DeliveryTypeProvider with ChangeNotifier {
  List<DeliveryTypes> _deliveryTypes = [];
  bool _isLoading = true;
  StreamSubscription _deliveryTypeSub;

  DeliveryTypeProvider() {
    _deliveryTypeSub = Firestore.instance
        .collection('extras')
        .document('delivery')
        .snapshots()
        .listen((snap) {
      Map<String, dynamic> types = snap.data;
      List<DeliveryTypes> _latestDeliveryTypes = [];
      types.forEach((key, value) {
        try {
          DeliveryTypes type = DeliveryTypes.fromMap(key, value);
          _latestDeliveryTypes.add(type);
        } catch (e) {
          print("ConfigProvider - DeliveryTypes - $e");
        }
        _deliveryTypes = _latestDeliveryTypes;
        _isLoading = false;
      });
      notifyListeners();
    });
  }

  @override
  void dispose() {
    if (_deliveryTypeSub != null) {
      _deliveryTypeSub.cancel();
      _deliveryTypeSub = null;
    }
    super.dispose();
  }

  bool get isLoading => _isLoading;

  List<DeliveryTypes> get deliveryTypes {
    return _deliveryTypes;
  }
}
