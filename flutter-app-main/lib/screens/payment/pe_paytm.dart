library pe_paytm;

import 'package:flutter/material.dart';
import 'package:grocapp/models/order_model.dart';
import 'package:grocapp/screens/payment/payment_screen.dart';

class PePaytm {
  final String paymentURL;

  PePaytm(
      {this.paymentURL =
          "https://us-central1-grocapp-f4eb9.cloudfunctions.net/customFunctions/payment"});

  makePayment(context, {OrderModel order}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentScreen(
          order: order,
          paymentURL: paymentURL,
        ),
      ),
    );
  }
}
