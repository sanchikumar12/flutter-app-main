import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocapp/const/color_const.dart';
import 'package:grocapp/const/route_constants.dart';
import 'package:grocapp/const/size_config.dart';
import 'package:grocapp/const/text_style.dart';
import 'package:grocapp/models/order_model.dart';
import 'package:grocapp/models/product_model.dart';
import 'package:grocapp/screens/profile/orders/core/firestore_model.dart';
import 'package:grocapp/widgets/loader.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';

class OrderDetails extends StatefulWidget {
  OrderModel order;
  int count = 0;
  String pMode;
  double tMRP = 0;
  bool successDialog;

  OrderDetails({@required this.order, this.pMode, this.successDialog}) {
    getTMRP();
  }
  @override
  _OrderDetailsState createState() => _OrderDetailsState();

  void getTMRP() {
    order.orderItems.forEach((element) {
      tMRP = tMRP + (element.productVariety.mrp * element.count).toDouble();
    });
    order.orderItems.forEach((element) {
      count += element.count;
    });
  }
}

class _OrderDetailsState extends State<OrderDetails> {
  int onceDialog = 0;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
        appBar: AppBar(
          title: Text('Order Details'),
          centerTitle: true,
        ),
        body: StreamBuilder(
            stream: Firestore.instance
                .collection('orders')
                .document(widget.order.orderId)
                .snapshots(),
            builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Center(child: loader());
              } else {
                OrderModel orderStream = OrderModel.fromSnapshot(snapshot.data);
                return Container(
                  color: Colors.grey[100],
                  padding: const EdgeInsets.all(8.0),
                  child: ListView(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    children: <Widget>[
                      Card(
                        color: primaryColor,
                        child: ExpansionTile(
                          backgroundColor: Colors.white,
                          leading: Text(
                            '${widget.count}',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.w700),
                          ),
                          title: Text(
                            "Ordered items ",
                            style: orderDetilsHeadText,
                          ),
                          children: <Widget>[
                            Container(
                              height: 200,
                              child: ListView.separated(
                                  separatorBuilder: (context, int) {
                                    return Divider();
                                  },
                                  shrinkWrap: true,
                                  physics: ScrollPhysics(),
                                  itemCount: orderStream.orderItems.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Container(
                                      color: orderStream.orderItems[index]
                                                  .returnStatus >
                                              0
                                          ? Colors.orange[50]
                                          : Colors.white,
                                      child: ListTile(
                                        leading: CachedNetworkImage(
                                          fit: BoxFit.contain,
                                          imageUrl: orderStream
                                              .orderItems[index].productImage,
                                        ),
                                        title: Text(widget.order
                                            .orderItems[index].productName),
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(widget.order.orderItems[index]
                                                    .productVariety.size +
                                                " x " +
                                                orderStream
                                                    .orderItems[index].count
                                                    .toString()),
                                            Text(
                                              orderStream.orderItems[index]
                                                          .returnStatus ==
                                                      1
                                                  ? 'Return Requested'
                                                  : (orderStream
                                                              .orderItems[index]
                                                              .returnStatus ==
                                                          2
                                                      ? 'Return Accepted'
                                                      : ''),
                                              style:
                                                  TextStyle(color: Colors.red),
                                            )
                                          ],
                                        ),
                                        trailing: Text(
                                            '₹ ${orderStream.orderItems[index].productVariety.sp}'),
                                      ),
                                    );
                                  }),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Card(
                          child: ListTile(
                              title: Text(
                                'Current Status',
                                style: orderDetilsHeadText,
                              ),
                              trailing: Text(orderStream.orderStatus,
                                  style: GoogleFonts.nunito(
                                    color: statusColor[orderStream.statusCode],
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                  )))),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                  side: BorderSide(color: Colors.grey[200])),
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(
                                          5.0) //                 <--- border radius here
                                      ),
                                  color: Colors.white,
                                ),
                                height: SizeConfig.screenHeight * 0.15,
                                child: Column(
                                  // mainAxisAlignment: MainAxisAlignment.center,
                                  // crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      'ORDER ID',
                                      style: orderDetilsHeadText,
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      '${orderStream.orderId}',
                                      textAlign: TextAlign.center,
                                      style: orderDetilsContentText,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                  side: BorderSide(color: Colors.grey[200])),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(
                                        5.0), //                 <--- border radius here
                                  ),
                                  color: Colors.white,
                                ),
                                height: SizeConfig.screenHeight * 0.15,
                                child: Column(
                                  //mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      'ORDERED ON',
                                      textAlign: TextAlign.center,
                                      style: orderDetilsHeadText,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      DateFormat.yMMMd().format(
                                          DateTime.fromMillisecondsSinceEpoch(
                                              orderStream.orderedAt)),
                                      textAlign: TextAlign.center,
                                      style: orderDetilsContentText,
                                    ),
                                    Text(
                                      DateFormat.Hm().format(
                                          DateTime.fromMillisecondsSinceEpoch(
                                              orderStream.orderedAt)),
                                      textAlign: TextAlign.center,
                                      style: orderDetilsContentText,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      getOrderSummary(widget.tMRP, orderStream),
                      SizedBox(
                        height: 10,
                      ),

                      orderStream.userResponse['returnRequested'] == 2 ||
                              orderStream.userResponse['cancelRequested'] == 2
                          ? getRefundSummary(
                              snapshot.data.data['refundSummary'])
                          : SizedBox(),

                      IntrinsicHeight(
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    side: BorderSide(color: Colors.grey[200])),
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(
                                            5.0) //                 <--- border radius here
                                        ),
                                    color: Colors.white,
                                  ),
                                  //height: SizeConfig.screenHeight * 0.15,
                                  child: Column(
                                    // mainAxisAlignment: MainAxisAlignment.center,
                                    // crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Text(
                                        'PAYMENT',
                                        style: orderDetilsHeadText,
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        '${widget.pMode == '' ? orderStream.payment['details']['data']['PAYMENTMODE'] : widget.pMode}',
                                        style: orderDetilsContentText,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    side: BorderSide(color: Colors.grey[200])),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(
                                          5.0), //                 <--- border radius here
                                    ),
                                    color: Colors.white,
                                  ),
                                  height: double.infinity,
                                  // SizeConfig.screenHeight * 0.15,
                                  child: Column(
                                    //   mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Text(
                                        orderStream.userResponse[
                                                    'cancelRequested'] ==
                                                2
                                            ? 'Cancelled'
                                            : orderStream.deliveredTime == 0
                                                ? 'Expected Delivery'
                                                : 'Delivered',
                                        style: orderDetilsHeadText,
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      orderStream.userResponse[
                                                  'cancelRequested'] ==
                                              2
                                          ? SizedBox()
                                          : orderStream.delivery.deliveryTime ==
                                                  0
                                              ? Text(
                                                  'Awaiting Confirmation',
                                                  style: orderDetilsContentText,
                                                )
                                              : Text(
                                                  orderStream.deliveredTime == 0
                                                      ? DateFormat.yMMMd()
                                                          .format(DateTime
                                                              .fromMillisecondsSinceEpoch(
                                                                  orderStream
                                                                      .delivery
                                                                      .deliveryTime))
                                                      : DateFormat.yMMMd()
                                                          .format(DateTime
                                                              .fromMillisecondsSinceEpoch(
                                                                  orderStream
                                                                      .deliveredTime)),
                                                  style: orderDetilsContentText,
                                                ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      orderStream.userResponse[
                                                  'cancelRequested'] ==
                                              2
                                          ? SizedBox()
                                          : orderStream.deliveredTime == 0
                                              ? (orderStream.delivery
                                                          .deliveryTime !=
                                                      0
                                                  ? (orderStream
                                                              .deliveredTime !=
                                                          "Standard Delivery"
                                                      ? Text(
                                                          DateFormat.Hm().format(
                                                              DateTime.fromMillisecondsSinceEpoch(
                                                                  orderStream
                                                                      .delivery
                                                                      .deliveryTime)),
                                                          style:
                                                              orderDetilsContentText,
                                                        )
                                                      : Text(''))
                                                  : Text(''))
                                              : Text(
                                                  DateFormat.Hm().format(DateTime
                                                      .fromMillisecondsSinceEpoch(
                                                          orderStream
                                                              .deliveredTime)),
                                                  style: orderDetilsContentText,
                                                ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        orderStream.delivery.type,
                                        style: GoogleFonts.roboto(
                                            color: getColorDelivery(
                                              orderStream.delivery.type,
                                            ),
                                            fontWeight: FontWeight.w700),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      getAddress(orderStream),
                      SizedBox(
                        height: 10,
                      ),
                      getReturn(orderStream, context),
                      SizedBox(
                        height: 10,
                      ),
                      //getFAQ(),
                    ],
                  ),
                );
              }
            }));
  }

  Widget getOrderSummary(double tMrp, OrderModel orderStream) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
          side: BorderSide(color: Colors.grey[200])),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(5.0), //                 <--- border radius here
          ),
          color: Colors.white,
        ),
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 12),
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(vertical: 15),
              child: Center(
                child: Text(
                  'ORDER SUMMARY',
                  style: orderDetilsHeadText,
                ),
              ),
            ),
            Divider(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Total Quantity',
                  style: orderDetilsContentText,
                ),
                Text(
                  '${widget.count}',
                  style: orderDetilsContentText,
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Total Price (Inc GST)',
                  style: orderDetilsContentText,
                ),
                Text(
                  '₹ ${widget.tMRP}',
                  style: orderDetilsContentText,
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Discount',
                  style: orderDetilsContentText,
                ),
                Text(
                  '₹ ${widget.tMRP - double.parse(orderStream.amount) + orderStream.delivery.charges}',
                  style: orderDetilsContentText,
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Shipping',
                  style: orderDetilsContentText,
                ),
                Text(
                  '₹ ${orderStream.delivery.charges}',
                  style: orderDetilsContentText,
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Total',
                  style: orderDetilsHeadText,
                ),
                Text(
                  '₹ ${(double.parse(orderStream.amount))}',
                  style: orderDetilsHeadText,
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  Widget getRefundSummary(Map<String, dynamic> refund) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
            side: BorderSide(color: Colors.grey[200])),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(5.0), //                 <--- border radius here
            ),
            color: Colors.white,
          ),
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 12),
          child: Column(children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(vertical: 15),
              child: Center(
                child: Text(
                  'REFUND SUMMARY',
                  style: orderDetilsHeadText,
                ),
              ),
            ),
            Divider(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Quantity',
                  style: orderDetilsContentText,
                ),
                Text(
                  '${refund['qty']}',
                  style: orderDetilsContentText,
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Amount',
                  style: orderDetilsContentText,
                ),
                Text(
                  '₹ ${refund['refundAmount']}',
                  style: orderDetilsContentText,
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Mode',
                  style: orderDetilsContentText,
                ),
                Text(
                  '${refund['refundMode']}',
                  style: orderDetilsContentText,
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
          ]),
        ),
      ),
    );
  }

  getAddress(OrderModel orderStream) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
          side: BorderSide(color: Colors.grey[200])),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(5.0), //                 <--- border radius here
          ),
          color: Colors.white,
        ),
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(vertical: 15),
              child: Center(
                child: Text(
                  'Delivery Address',
                  style: orderDetilsHeadText,
                ),
              ),
            ),
            Divider(
              height: 20,
            ),
            Text(
              '${orderStream.delivery.address.name}',
              style: orderDetilsHeadText,
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              '${orderStream.delivery.address.lane1}',
              style: orderDetilsContentText,
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              '${orderStream.delivery.address.lane2}',
              style: orderDetilsContentText,
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              '${orderStream.delivery.address.town}',
              style: orderDetilsContentText,
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              '${orderStream.delivery.address.pincode}',
              style: orderDetilsContentText,
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              'Phone  ${orderStream.delivery.address.phone}',
              style: orderDetilsHeadText,
            ),
            SizedBox(
              height: 5,
            ),
          ],
        ),
      ),
    );
  }

  getReturn(OrderModel orderStream, BuildContext context) {
    if (orderStream.userResponse['returnRequested'] == 2 ||
        orderStream.userResponse['cancelRequested'] == 2) {
      return SizedBox();
    }
    if (orderStream.delivery.type == "Special Delivery" ||
        orderStream.statusCode == 0) {
      return Card(
        child: ListTile(
          title: Text(
            'No Returns / Cancels Applicable',
            style: orderDetilsContentText,
          ),
          //trailing: Icon(Icons.arrow_forward_ios),
        ),
      );
    }
    if (orderStream.userResponse['cancelRequested'] == 0 &&
        orderStream.orderStatus != "Delivered") {
      return InkWell(
        onTap: () async {
          final snackBar = SnackBar(
            content: Text('Cancel Order Requested'),
            behavior: SnackBarBehavior.floating,
            action: SnackBarAction(
              label: '',
              onPressed: () {
                // Some code to undo the change.
              },
            ),
          );
          final result = await Navigator.of(context)
              .pushNamed(OrderCancelRoute, arguments: orderStream);
          if (result == '1') {
            Scaffold.of(context).showSnackBar(snackBar);
          } else {}
        },
        child: Card(
          child: ListTile(
            title: Text(
              'CANCEL ORDER',
              style: orderDetilsHeadText,
            ),
            trailing: Icon(Icons.arrow_forward_ios),
          ),
        ),
      );
    }
    if (orderStream.userResponse['cancelRequested'] == 1) {
      return Card(
        child: ListTile(
          title: Text('Cancel Order Requested',
              style: GoogleFonts.nunito(
                  fontSize: 16,
                  color: Colors.deepOrange,
                  fontWeight: FontWeight.w600)),
        ),
      );
    }
    if (orderStream.userResponse['returnRequested'] == 0 &&
        orderStream.userResponse['cancelRequested'] == 0 &&
        orderStream.orderStatus == "Delivered") {
      DateTime deliv = orderStream.deliveredTime == 0
          ? DateTime.now()
          : DateTime.fromMillisecondsSinceEpoch(orderStream.deliveredTime);
      print(DateTime.fromMillisecondsSinceEpoch(orderStream.deliveredTime));
      if (DateTime.now().difference(deliv).inMinutes < 1440) {
        return InkWell(
          onTap: () async {
            final snackBar = SnackBar(
              content: Text('Return Items Requested'),
              behavior: SnackBarBehavior.floating,
              action: SnackBarAction(
                label: '',
                onPressed: () {
                  // Some code to undo the change.
                },
              ),
            );
            final result = await Navigator.of(context)
                .pushNamed(OrderReturnRoute, arguments: orderStream);
            if (result == '1') {
              Scaffold.of(context).showSnackBar(snackBar);
            } else {}
          },
          child: Card(
            child: ListTile(
              title: Text(
                'RETURN ITEMS',
                style: orderDetilsHeadText,
              ),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
          ),
        );
      } else {
        return Card(
          child: ListTile(
            title: Text(
              'No Returns / Cancels Applicable',
              style: orderDetilsContentText,
            ),
            //trailing: Icon(Icons.arrow_forward_ios),
          ),
        );
      }
    }
    if (orderStream.userResponse['returnRequested'] == 1) {
      return Card(
        child: ListTile(
          title: Text('Return Items Requested',
              style: GoogleFonts.nunito(
                  fontSize: 16,
                  color: Colors.deepOrange,
                  fontWeight: FontWeight.w600)),
        ),
      );
    }
    return Card(
      child: ListTile(
        title: Text(
          'No Returns / Cancels Applicable',
          style: orderDetilsContentText,
        ),
        //trailing: Icon(Icons.arrow_forward_ios),
      ),
    );
  }

  getFAQ() {
    return Card(
      child: ListTile(
        title: Text(
          'FAQ',
          style: orderDetilsHeadText,
        ),
        trailing: Icon(Icons.arrow_forward_ios),
      ),
    );
  }

  getColorDelivery(String type) {
    switch (type) {
      case "Standard Delivery":
        return deliveryColor[0];
        break;
      case "Express Delivery":
        return deliveryColor[1];
        break;

      case "Special Delivery":
        return deliveryColor[2];
        break;

      default:
        return deliveryColor[3];
    }
  }
}
