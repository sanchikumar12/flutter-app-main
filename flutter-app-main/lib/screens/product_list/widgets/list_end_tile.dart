import 'package:flutter/widgets.dart';
import 'package:grocapp/screens/auth/widgets/hr.dart';

Widget listEndTile() {
  return Container(
      padding: EdgeInsets.symmetric(vertical: 15),
      child: Row(
        children: [
          hr(60.0, 10.0),
          Text(
            "Thats all folks!",
            style: TextStyle(
                fontWeight: FontWeight.w300, fontStyle: FontStyle.italic),
          ),
          hr(10.0, 60.0),
        ],
      ));
}
