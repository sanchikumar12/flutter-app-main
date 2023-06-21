import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocapp/const/route_constants.dart';
import 'package:grocapp/models/order_model.dart';
import 'package:grocapp/screens/payment/db_write_widget.dart';
import 'package:grocapp/widgets/loader.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'order.dart';

class PaymentScreen extends StatefulWidget {
  final OrderModel order;
  final String paymentURL;

  PaymentScreen({this.order, this.paymentURL});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  WebViewController _webController;
  bool _loadingPayment = true;
  PePaytmStatus _responseStatus = PePaytmStatus.PAYMENT_LOADING;
  Map<String, dynamic> responseJSON;

  String _loadHTML() {
    return "<html> <body onload='document.f.submit();'> <form id='f' name='f' method='post' action='${widget.paymentURL}'> <input type='hidden' name='orderID' value='ORDER_${widget.order.orderId}'/> <input  type='hidden' name='custID' value='CUST${widget.order.user}' /> <input  type='hidden' name='amount' value='${widget.order.amount}' /> <input type='hidden' name='custEmail' value='${widget.order.email}' /> <input type='hidden' name='custPhone' value='${widget.order.phoneNumber}' /> </form> </body> </html>";
  }

  void getData() {
    _webController.evaluateJavascript("document.body.innerText").then((data) {
      var decodedJSON = jsonDecode(data);
      responseJSON = jsonDecode(decodedJSON);
      final checksumResult = responseJSON["status"];
      final paytmResponse = responseJSON["data"];
      if (paytmResponse["BANKTXNID"] == null ||
          paytmResponse["BANKTXNID"].length == 0) {
        Navigator.pop(context);
      } else {
        if (paytmResponse["STATUS"] == "TXN_SUCCESS") {
          if (checksumResult == 0) {
            _responseStatus = PePaytmStatus.PAYMENT_SUCCESSFUL;
            widget.order.orderStatus = "Processing";
            widget.order.statusCode = 1;
          } else {
            _responseStatus = PePaytmStatus.PAYMENT_CHECKSUM_FAILED;
            widget.order.orderStatus = "Failed";
            widget.order.statusCode = 0;
          }
        } else if (paytmResponse["STATUS"] == "TXN_FAILURE") {
          _responseStatus = PePaytmStatus.PAYMENT_FAILED;
          widget.order.orderStatus = "Failed";
          widget.order.statusCode = 0;
        }
        this.setState(() {});
      }
    });
  }

  Widget getResponseScreen() {
    //add the paytm payment response
    widget.order.payment["details"] = responseJSON;

    return PaymentDoneScreen(_responseStatus, widget.order);
  }

  @override
  void dispose() {
    _webController = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: WebView(
                debuggingEnabled: false,
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (controller) {
                  _webController = controller;
                  _webController.loadUrl(
                      new Uri.dataFromString(_loadHTML(), mimeType: 'text/html')
                          .toString());
                },
                onPageFinished: (page) {
                  if (page.contains("/process")) {
                    if (_loadingPayment) {
                      this.setState(() {
                        _loadingPayment = false;
                      });
                    }
                  }
                  if (page.contains("/paymentReceipt")) {
                    getData();
                  }
                },
              ),
            ),
            (_loadingPayment) ? loader() : Center(),
            (_responseStatus != PePaytmStatus.PAYMENT_LOADING)
                ? Center(
                    child: getResponseScreen(),
                  )
                : Center()
          ],
        ),
      ),
    );
  }
}

class PaymentDoneScreen extends StatelessWidget {
  String dialogTitle;
  String dialogContent;
  DialogType dialogType;
  final PePaytmStatus pePaytmStatus;
  final OrderModel order;
  PaymentDoneScreen(this.pePaytmStatus, this.order);

  void _pushData(context) async {
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
    print('Deleting cart items : ${futures.length}');
    await Future.wait(futures);

    Navigator.pop(context); // Itself
    Navigator.pop(context); // cart summary
    Navigator.pop(context); // cart 2
    AwesomeDialog(
      context: context,
      dialogType: dialogType,
      animType: AnimType.BOTTOMSLIDE,
      title: dialogTitle,
      desc: dialogContent,
      autoHide: Duration(seconds: 5),
    )..show();
    Future.delayed(const Duration(milliseconds: 5500), () {
      Navigator.pushNamed(
        context,
        ProfileOrderDetailsRoute,
        arguments: [order, '', true],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    String header, body;
    switch (pePaytmStatus) {
      case PePaytmStatus.PAYMENT_SUCCESSFUL:
        {
          header = "Payment Successful";
          body = "Please wait while we redirect you to Frapen";
          dialogTitle = "Order Placed !!";
          dialogContent =
              "Thank You for your Purchase. Your order has been successfully placed";
          dialogType = DialogType.SUCCES;
        }
        break;
      case PePaytmStatus.PAYMENT_CHECKSUM_FAILED:
        {
          header = "Oh Snap!";
          body =
              "Problem Verifying Payment, If you balance is deducted please contact our customer support and get your payment verified!";
          dialogTitle = "Payment Error";
          dialogContent =
              "Sorry for the inconvenience but there was problem verifying payment. Any money deducted would be refunded back.";
          dialogType = DialogType.WARNING;
        }
        break;
      case PePaytmStatus.PAYMENT_FAILED:
        {
          header = "OOPS!";
          body = "Payment was not successful, Please try again Later!";
          dialogTitle = "Payment Failed";
          dialogContent =
              "Sorry for the inconvenience but your Payment has failed. Any money deducted would be refunded back.";
          dialogType = DialogType.ERROR;
        }
        break;
      default:
        {
          header = "Payment Successful";
          body = "Please wait while we redirect you to Frapen";
          dialogTitle = "Order Placed !!";
          dialogContent =
              "Thank You for your Purchase. Your order has been successfully placed";
          dialogType = DialogType.SUCCES;
        }
        break;
    }
    _pushData(context);
    return dbWrite(context, header, body);
  }
}
