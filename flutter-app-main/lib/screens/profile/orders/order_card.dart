import 'package:flutter/material.dart';
import 'package:grocapp/const/color_const.dart';
import 'package:grocapp/const/route_constants.dart';
import 'package:grocapp/const/text_style.dart';
import 'package:grocapp/models/order_model.dart';
import 'package:grocapp/screens/profile/orders/order_details.dart';
import 'package:intl/intl.dart';

class OrderCard extends StatelessWidget {
  @override
  void initState() {}

  OrderModel orderDetails;
  int tCount = 0;

  OrderCard(OrderModel orderDetails) {
    this.orderDetails = orderDetails;
    getCount();
  }
  DateTime tempDate;
  @override
  Widget build(BuildContext context) {
    var tStamp =
        new DateTime.fromMillisecondsSinceEpoch(orderDetails.orderedAt);
    var date = DateFormat.yMMMd().format(tStamp);
    var time = DateFormat.Hm().format(tStamp);
    String pMode = '';
    if (orderDetails.payment['type'] == 'COD') {
      pMode = 'COD';
    } else {
      if (orderDetails.payment['details']['data'].containsKey('PAYMENTMODE')) {
        switch (orderDetails.payment['details']['data']['PAYMENTMODE']) {
          case 'PPI':
            pMode = 'PayTm Wallet';
            break;
          case 'UPI':
            pMode = 'UPI';
            break;
          case 'CC':
            pMode = 'Credit Card';
            break;
          case 'DC':
            pMode = 'Debit Card';
            break;
          case 'NB':
            pMode = 'Net Banking';
            break;
        }
      }
    }

    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, ProfileOrderDetailsRoute,
          arguments: [orderDetails, pMode, false].toList()),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 2),
        child: Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
              side: BorderSide(color: Colors.grey[200])),
          color: Colors.white,
          elevation: 3,
          child: Container(
            // color: Colors.white,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(
                        5.0) //                 <--- border radius here
                    ),
                color: Colors.white),
            padding: EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Order ID',
                            style: orderListHeadText,
                          ),
                          Text(
                            orderDetails.orderId + '',
                            style: orderListContentText,
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          side: BorderSide(color: primaryColor)),
                      color: Colors.white,
                      onPressed: () => Navigator.pushNamed(
                          context, ProfileOrderDetailsRoute,
                          arguments: [orderDetails, pMode, false].toList()),
                      child: Text(
                        'Order Details',
                        style: orderListContentText,
                      ),
                    )
                  ],
                ),
                Divider(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Flexible(
                      flex: 3,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Flexible(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 2),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: primaryColor),
                              ),
                              child: Text(
                                '₹ ${orderDetails.amount}',
                                style: TextStyle(
                                    color: accentColor,
                                    fontWeight: FontWeight.w700),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                          Flexible(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 2),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: Colors.indigo),
                              ),
                              child: Text(
                                '${tCount} Items',
                                style: TextStyle(
                                  color: Colors.indigo,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    //Spacer(flex: 1,),

                    //Spacer(flex: 1,),
                    Flexible(
                      flex: 2,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: statusColor[orderDetails.statusCode]),
                        child: Text(
                          '${orderDetails.orderStatus}',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(pMode),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[Text('$date'), Text('$time')],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void getCount() {
    orderDetails.orderItems.forEach((element) {
      tCount += element.count;
    });
  }
}
