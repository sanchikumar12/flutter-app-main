import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocapp/const/color_const.dart';
import 'package:grocapp/models/order_model.dart';
import 'package:grocapp/screens/auth/auth_provider.dart';
import 'package:grocapp/screens/profile/orders/core/firestore_model.dart';
import 'package:grocapp/screens/profile/orders/order_card.dart';
import 'package:grocapp/const/text_style.dart';

import 'package:grocapp/widgets/loader.dart';

import 'package:provider/provider.dart';

class OrderList extends StatefulWidget {
  @override
  _OrderListState createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  List<OrderModel> orders;
  AuthProvider authProvider;

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<FirestoreModel>(context);
    authProvider = Provider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('My orders'),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.grey[200],
        child: StreamBuilder(
            stream: orderProvider.fetchOrdersAsStream(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                orders = snapshot.data.documents
                    .map((doc) => OrderModel.fromMap(doc.data, doc.documentID))
                    .where((element) => element.user == authProvider.user.uid)
                    .toList();
                if (orders.length < 1) {
                  return Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.assignment,
                          size: 80,
                          color: primaryColor,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "No Orders till Now !!",
                          style: orderDetilsContentText,
                        )
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (buildContext, index) =>
                      OrderCard(orders[index]),
                );
              } else {
                return Center(child: loader());
              }
            }),
      ),
    );
  }
}
