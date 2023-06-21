import 'package:flutter/material.dart';

const kDefaultPadding = EdgeInsets.all(20);

enum RequestState {
  idle,
  pending,
  complete,
  failed
}

const String kAccessProductId = 'shagun_one_time_fee_51';

 bool isLogin=false;