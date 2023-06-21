import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocapp/models/user.dart';

class Delivery {
  double charges;
  UserAddress address;
  int deliveryTime;
  String type;
  Delivery({this.charges, this.address, this.type, this.deliveryTime});

  Map<String, dynamic> get toMap {
    return {
      "charges": charges,
      "address": address.toMap(),
      "deliveryTime": deliveryTime,
      "type": type,
    };
  }

  Delivery.fromSnapshot(DocumentSnapshot snapshot)
      : charges = snapshot['charges'] ?? '',
        address = UserAddress.fromMap(snapshot['address']),
        deliveryTime = snapshot['deliveryTime'] ?? 0,
        type = snapshot['type'] ?? '';

  Delivery.fromMap(Map<String, dynamic> snapshot)
      : charges = snapshot['charges'] ?? 0.0,
        address = UserAddress.fromMap(snapshot['address']),
        deliveryTime = snapshot['deliveryTime'] ?? 0,
        type = snapshot['type'] ?? '';
}
