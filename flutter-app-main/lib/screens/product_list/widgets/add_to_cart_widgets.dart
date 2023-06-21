import 'package:flutter/material.dart';

Widget addToCartButton() {
  return FittedBox(
    fit: BoxFit.fitWidth,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Icon(
          Icons.add_shopping_cart,
          size: 16,
        ),
        SizedBox(
          width: 5,
        ),
        Text(
          'Add',
          style: TextStyle(fontSize: 16),
        ),
      ],
    ),
  );
}

Widget addRemoveText(String text) {
  return Container(
    child: InkWell(
      child: Container(
        child: Text(text),
        padding: EdgeInsets.only(left: 10, right: 10),
      ),
    ),
  );
}
