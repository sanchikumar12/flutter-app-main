import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocapp/const/route_constants.dart';
import 'package:grocapp/models/order_model.dart';
import 'package:grocapp/screens/payment/db_write_widget.dart';

class Cod extends StatelessWidget {
  final OrderModel order;
  Cod(this.order);
  void _pushData(context) async {
    Map<String, int> freqUpdate = {};
    order.orderItems.forEach((e) {
      if (freqUpdate[e.productId] == null) {
        freqUpdate[e.productId] = e.count;
      } else {
        freqUpdate[e.productId] += e.count;
      }
    });
    var keys = freqUpdate.keys.toList();
    for (int i = 0; i < keys.length; i++) {
      try {
        DocumentReference productRef =
            Firestore.instance.collection("products").document(keys[i]);
        productRef
            .updateData({'freq': FieldValue.increment(freqUpdate[keys[i]])});
      } catch (e) {}
    }

    // Push data to orders
    await Firestore.instance
        .collection("orders")
        .document(order.orderId)
        .setData(order.map);

    // Deleting cart items;
    QuerySnapshot snap = await Firestore.instance
        .collection("users")
        .document(order.user)
        .collection("cart")
        .getDocuments();
    List<Future> futures = [];
    snap.documents.forEach((element) {
      futures.add(element.reference.delete());
    });
    await Future.wait(futures);
    AwesomeDialog(
      context: context,
      dialogType: DialogType.SUCCES,
      animType: AnimType.BOTTOMSLIDE,
      title: 'Order Placed !!',
      desc:
          'Thank You for your Purchase. Your order has been successfully placed',
      autoHide: Duration(seconds: 5),
    )..show();
    Future.delayed(const Duration(milliseconds: 5200), () {
      Navigator.pop(context); // Itself
      Navigator.pop(context); // cart summary
      Navigator.pop(context); // cart 2
      Navigator.pushNamed(
        context,
        ProfileOrderDetailsRoute,
        arguments: [order, 'COD', true],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    _pushData(context);
    return Scaffold(
      body: dbWrite(context, "", ""),
    );
  }
}
