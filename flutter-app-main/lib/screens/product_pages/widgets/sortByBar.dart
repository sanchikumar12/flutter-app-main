import 'package:flutter/material.dart';
import 'package:grocapp/const/enums.dart';

final Color inactive = Colors.grey[200];

Widget sortByBar(ValueNotifier<sortBy> current) {
  return ValueListenableBuilder(
    valueListenable: current,
    builder: (_, value, __) {
      return Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            FlatButton(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              onPressed: () {},
              splashColor: inactive,
              focusColor: inactive,
              hoverColor: inactive,
              highlightColor: inactive,
              child: Text("Sort By :"),
            ),
            FlatButton(
              shape: rounded(),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              color: value == sortBy.popularity ? Colors.white : null,
              onPressed: () => current.value = sortBy.popularity,
              child: Text("Popularity"),
            ),
            FlatButton(
              shape: rounded(),
              color: value == sortBy.newest ? Colors.white : null,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              onPressed: () => current.value = sortBy.newest,
              child: Text("Newest"),
            ),
            FlatButton(
              shape: rounded(),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              color: value == sortBy.priceIncreasing ? Colors.white : null,
              onPressed: () => current.value = sortBy.priceIncreasing,
              child: Text("Price: Low to High"),
            ),
            FlatButton(
              shape: rounded(),
              color: value == sortBy.priceDecreasing ? Colors.white : null,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              onPressed: () => current.value = sortBy.priceDecreasing,
              child: Text("Price: High to Low"),
            ),
          ],
        ),
      );
    },
  );
}

RoundedRectangleBorder rounded() {
  return RoundedRectangleBorder(
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(12),
      topRight: Radius.circular(12),
    ),
  );
}
