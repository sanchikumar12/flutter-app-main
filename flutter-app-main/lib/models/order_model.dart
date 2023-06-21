import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocapp/models/delivery.dart';
import 'package:grocapp/models/product_model.dart';
import 'package:grocapp/models/user.dart';
import 'package:grocapp/screens/cart/cart_summary.dart';
import 'package:grocapp/screens/payment/order.dart';

class OrderModel {
  String orderId; // required for paytm gateway
  int orderedAt;
  String user;
  String orderStatus;
  List<CartModel> orderItems;
  Map<String, dynamic> payment;
  Delivery delivery; //delivered time
  int deliveredTime;
  int statusCode;
  Map<String, dynamic> userResponse; //user return/cancellation request
  String phoneNumber; // required for paytm paytm gateway
  String amount; // required for paytm gateway
  String email; // required for paytm gateway
  PaymentResponse paymentResponse;

  OrderModel({
    this.orderId, // required for paytm gateway
    this.orderedAt,
    this.user,
    this.orderStatus,
    this.orderItems,
    this.payment,
    this.delivery,
    this.deliveredTime,
    this.statusCode,
    this.userResponse,
    this.phoneNumber, // required for paytm paytm gateway
    this.email, // required for paytm gateway
    this.amount, // required for paytm gateway
  })  : assert(orderId != null),
        assert(amount != null),
        assert(user != null),
        assert(phoneNumber != null);

  Map<String, dynamic> get map {
    return {
      "orderId": orderId,
      "orderedAt": orderedAt,
      "user": user,
      "orderStatus": orderStatus,
      "orderItems": orderItems.map((e) => e.map).toList(),
      "payment": payment,
      "delivery": delivery.toMap,
      "deliveredTime": deliveredTime,
      "statusCode": statusCode,
      "userResponse": userResponse,
      "phoneNumber": phoneNumber,
      "email": email,
      "amount": amount,
    };
  }

  OrderModel.fromMap(Map snapshot, String id)
      : orderId = snapshot['orderId'] ?? '',
        orderedAt = snapshot['orderedAt'] ?? '',
        user = snapshot['user'] ?? '',
        orderStatus = snapshot['orderStatus'] ?? '',
        orderItems = snapshot['orderItems'].map<CartModel>((item) {
          return CartModel.fromMap(item);
        }).toList(),
        payment = snapshot['payment'],
        delivery = Delivery.fromMap(snapshot['delivery']),
        deliveredTime = snapshot['deliveredTime'] ?? '',
        statusCode = snapshot['statusCode'] ?? '',
        userResponse = snapshot['userResponse'] ?? '',
        phoneNumber = snapshot['phoneNumber'],
        amount = snapshot['amount'] ?? '',
        email = snapshot['email'];

  OrderModel.fromSnapshot(DocumentSnapshot snapshot)
      : orderId = snapshot['orderId'] ?? '',
        orderedAt = snapshot['orderedAt'] ?? '',
        user = snapshot['user'] ?? '',
        orderStatus = snapshot['orderStatus'] ?? '',
        orderItems = snapshot['orderItems'].map<CartModel>((item) {
          return CartModel.fromMap(item);
        }).toList(),
        payment = snapshot['payment'],
        delivery = Delivery.fromMap(snapshot['delivery']),
        deliveredTime = snapshot['deliveredTime'] ?? '',
        statusCode = snapshot['statusCode'] ?? '',
        userResponse = snapshot['userResponse'] ?? '',
        phoneNumber = snapshot['phoneNumber'],
        amount = snapshot['amount'] ?? '',
        email = snapshot['email'];
}

class PaymentResponse {
  String type;
  PaymentResponse.fromSnapshot(Map snapshot) : type = snapshot['type'];
}
