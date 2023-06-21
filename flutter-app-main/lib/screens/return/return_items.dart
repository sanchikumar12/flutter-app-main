import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocapp/const/color_const.dart';
import 'package:grocapp/const/size_config.dart';
import 'package:grocapp/const/text_style.dart';
import 'package:grocapp/models/order_model.dart';
import 'package:grocapp/models/product_model.dart';
import 'package:grocapp/utils/Dialog.dart';

class ReturnItems extends StatefulWidget {
  final OrderModel order;
  const ReturnItems({
    Key key,
    @required this.order,
  });
  @override
  _ReturnItemsState createState() => _ReturnItemsState();
}

class ReturnModel {
  String productId;
  int count;
  double sp;
  String productName;
  String size;
  ReturnModel(this.count, this.sp, this.productId, this.productName, this.size);

  bool isSelected() {
    return count != 0;
  }

  String toString() {
    return "$productId : $count\n";
  }

  Map<String, dynamic> get toMap {
    return {
      "productId": productId,
      "productName": productName,
      "count": count,
      "size": size,
      "sp": sp
    };
  }
}

class _ReturnItemsState extends State<ReturnItems> {
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  List<ReturnModel> returns = [];

  @override
  void initState() {
    returns.addAll(
      widget.order.orderItems.map(
        (e) => ReturnModel(0, e.productVariety.sp, e.productId, e.productName,
            e.productVariety.size),
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double returnPrice = 0;
    returns.forEach((element) {
      returnPrice += element.count * element.sp;
    });
    return Scaffold(
      appBar: AppBar(
        title: Text('Return Items'),
        centerTitle: true,
      ),
      body: Stack(children: <Widget>[
        Positioned(
          top: 0,
          height: SizeConfig.screenHeight - 75,
          width: SizeConfig.screenWidth - 10,
          child: Container(
            child: ListView.separated(
              separatorBuilder: (_, index) {
                return Divider();
              },
              itemCount: widget.order.orderItems.length,
              itemBuilder: (_, index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    CheckboxListTile(
                      secondary: CachedNetworkImage(
                        imageUrl: widget.order.orderItems[index].productImage,
                        height: 50,
                        width: 50,
                      ),
                      title: Text(widget.order.orderItems[index].productName),
                      subtitle: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            widget.order.orderItems[index].productVariety.size +
                                " x " +
                                widget.order.orderItems[index].count.toString(),
                          ),
                          Text(
                              '₹ ${widget.order.orderItems[index].productVariety.sp}/item'),
                        ],
                      ),
                      activeColor: accentColor,
                      value: returns[index].isSelected(),
                      onChanged: (bool selected) {
                        setState(() {
                          widget.order.orderItems[index].returnStatus =
                              selected ? 1 : 0;
                          returns[index].count = selected
                              ? widget.order.orderItems[index].count
                              : 0;
                        });
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ),
        Positioned(
            bottom: 0,
            height: 65,
            width: SizeConfig.screenWidth,
            child: Container(
                color: Colors.grey[200],
                child: returnPrice > 0.0
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Flexible(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Text(
                                'Refund Amount',
                                style: orderDetilsContentText,
                              ),
                              Text(
                                '₹ $returnPrice',
                                style: orderDetilsContentText,
                              )
                            ],
                          )),
                          Flexible(
                            child: RaisedButton(
                              color: Colors.white,
                              onPressed: () {
                                showAlertDialog(context, widget.order,
                                    returnPrice, returns);
                              },
                              child: Text('Place Return',
                                  style: GoogleFonts.nunito(
                                      color: Colors.deepOrange,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700)),
                            ),
                          )
                        ],
                      )
                    : Center(
                        child: Text(
                          'Select atleast 1 item to Return',
                          style: orderDetilsContentText,
                        ),
                      )))
      ]),
    );
  }

  showAlertDialog(BuildContext context, OrderModel order, double returnPrice,
      List<ReturnModel> returns) {
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
        List<Map<String, dynamic>> returnItems = [];
        returns.forEach((element) {
          if (element.count > 0) {
            returnItems.add(element.toMap);
          }
        });
        Map<String, dynamic> newResponse = new Map<String, dynamic>();
        newResponse = order.userResponse;
        newResponse["returnRequested"] = 1;
        newResponse["cancelRequested"] = order.userResponse['cancelRequested'];
        Navigator.of(context).pop(); // dismiss dialog
        ProgressDialog.showLoadingDialog(context, _keyLoader);
        List<Map<String, dynamic>> newitems = [];
        order.orderItems.forEach((element) {
          newitems.add(element.returnMap);
        });

        DocumentReference documentReference =
            Firestore.instance.collection('orders').document(order.orderId);
        Firestore.instance.runTransaction((transaction) async {
          await transaction.update(documentReference, {
            'userResponse': newResponse,
            'orderItems': newitems
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
      title: Text("Confirm Return"),
      content: Text(
          "Kindly make sure the items packaging or seal are not tempered or broken"),
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
}
