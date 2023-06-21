import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocapp/const/color_const.dart';
import 'package:grocapp/models/order_model.dart';
import 'package:grocapp/screens/return/return_items.dart';
import 'package:grocapp/utils/Dialog.dart';
import 'package:package_info/package_info.dart';

enum Reason { r1, r2, r3, r4, r5 }

class CancelItems extends StatefulWidget {
  final OrderModel order;
  const CancelItems({
    Key key,
    @required this.order,
  });
  @override
  _CancelItemsState createState() => _CancelItemsState();
}

class _CancelItemsState extends State<CancelItems> {
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  _CancelItemsState() {
    getPackage();
  }

  final Map<Reason, dynamic> cancelReason = {
    Reason.r1: {"reason": "Going somewhere, won’t be able to receive"},
    Reason.r2: {
      "reason": "No more Required",
    },
    Reason.r3: {
      "reason": "Got a better deal somewhere",
    },
    Reason.r4: {
      "reason": "Mistakenly placed the Order",
    },
    Reason.r5: {
      "reason": "Others",
    },
  };

  ValueNotifier _cancel = ValueNotifier<Reason>(Reason.r1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cancel Order'),
        centerTitle: true,
      ),
      body: ValueListenableBuilder(
          valueListenable: _cancel,
          builder: (context, value, child) {
            return Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                color: checkoutBodyContentColor,
                child: ListView(
                  children: <Widget>[
                    getTiles(_cancel, value),
                    SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: RaisedButton(
                          padding: EdgeInsets.symmetric(vertical: 5),
                          color: Colors.white,
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              side: BorderSide(color: Colors.grey[200])),
                          onPressed: () {
                            showAlertDialog(context, widget.order,
                                cancelReason[value]["reason"]);
                          },
                          child: Text('Cancel Order',
                              style: GoogleFonts.nunito(
                                  color: Colors.red,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600))),
                    )
                  ],
                ));
          }),
    );
  }

  Column getTiles(ValueNotifier<dynamic> _cancel, Reason notifvalue) {
    List<Widget> col = [];
    // col.add(Text('ok'));

    cancelReason.forEach((key, value) {
      col.add(CheckboxListTile(
        title: Text(value["reason"]),
        // subtitle: Text(
        //   "No cost Delivery",
        // ),
        activeColor: accentColor,
        value: notifvalue == key,
        onChanged: (_) => _cancel.value = key,
      ));
    });
    return Column(
      children: col,
    );
  }

  showAlertDialog(BuildContext context, OrderModel order, String reasonText) {
    Map<String, dynamic> newResponse = new Map<String, dynamic>();
    newResponse = order.userResponse;
    newResponse["cancelRequested"] = 1;
    newResponse["cancelReason"] = reasonText;
    // set up the buttons
    Widget cancelButton = FlatButton(
      textColor: Colors.red,
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop(); // dismiss dialog
      },
    );
    Widget continueButton = FlatButton(
      textColor: accentColor,
      child: Text("Continue"),
      onPressed: () {
        Navigator.of(context).pop(); // dismiss dialog
        ProgressDialog.showLoadingDialog(context, _keyLoader);

        DocumentReference documentReference =
            Firestore.instance.collection('orders').document(order.orderId);
        Firestore.instance.runTransaction((transaction) async {
          await transaction.update(documentReference, {
            'userResponse': newResponse,
          }).catchError((e) {});
        }).catchError((e) {
          return false;
        }).whenComplete(() {
          Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
          Navigator.pop(context, '1');
        });
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Confirm Cancellation"),
      content: Text("Are you sure you want to cancel your order?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void getPackage() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    print(version);
  }
}
