import 'package:flutter/material.dart';
import 'package:grocapp/const/text_style.dart';
import 'package:grocapp/models/user.dart';

Widget addressCart(bool showEdit, UserAddress address) {
  return Container(
      color: showEdit ? Colors.transparent : Colors.white,
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10, bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '${address.name},',
                    textScaleFactor: 1.2,
                    textAlign: TextAlign.justify,
                    style: orderDetilsContentText,
                  ),
                  Text(
                    '${address.lane1},',
                    textScaleFactor: 1.2,
                    style: orderDetilsContentText,
                  ),
                  Text(
                    '${address.lane2},',
                    textScaleFactor: 1.2,
                    softWrap: true,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: orderDetilsContentText,
                  ),
                  Text(
                    '${address.town} - ${address.pincode}',
                    textScaleFactor: 1.2,
                    style: orderDetilsContentText,
                  ),
                  Text(
                    '${address.phone}',
                    textScaleFactor: 1.2,
                    style: orderDetilsContentText,
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 10,
            ),
            showEdit == true
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Icon(Icons.edit),
                    ],
                  )
                : SizedBox()
          ],
        ),
      ));
}
