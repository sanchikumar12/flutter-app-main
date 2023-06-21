import 'package:flutter/material.dart';
import 'package:grocapp/screens/auth/auth.dart';

import 'package:grocapp/screens/auth/phone/otp_page.dart';
import 'package:grocapp/screens/auth/phone/phone_auth.dart';
import 'package:grocapp/screens/cart/cart.dart';
import 'package:grocapp/screens/cart/cart2.dart';
import 'package:grocapp/screens/cart/cart_summary.dart';
import 'package:grocapp/screens/product_details/product_details.dart';
import 'package:grocapp/screens/product_list/product_list.dart';

import 'package:grocapp/screens/onboard/onboard.dart';
// import 'package:grocapp/screens/product_page/product_list_page.dart';
import 'package:grocapp/screens/profile/address/address.dart';
import 'package:grocapp/screens/profile/address/faq.dart';
import 'package:grocapp/screens/profile/orders/order_details.dart';
import 'package:grocapp/screens/profile/orders/order_list.dart';
import 'package:grocapp/screens/profile/user_details.dart';
import 'package:grocapp/screens/return/cancel_items.dart';
import 'package:grocapp/screens/return/return_items.dart';

import 'package:grocapp/services/App.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case 'onboard':
        return MaterialPageRoute(builder: (_) => OnBoarding());

      //Authentication
      case '/':
        return MaterialPageRoute(builder: (_) => Auth());

      case '/phone':
        return MaterialPageRoute(builder: (_) {
          assert(settings.arguments == null);
          return PhoneLogin();
        });

      //Home Page Chain
      case '/home':
        return MaterialPageRoute(builder: (_) => App());

      case '/home/productList/productDetails':
        return MaterialPageRoute(
            builder: (_) => ProductDetails(
                  product: settings.arguments,
                ));

      //Cart Checkout
      case '/cart':
        return MaterialPageRoute(builder: (_) => Cart());

      case '/cart/cart2':
        List arguments = settings.arguments;
        return MaterialPageRoute(
            builder: (_) => Cart2(
                  totalMrp: arguments[0],
                  totalPrice: arguments[1],
                  items: arguments[2],
                ));

      case '/cart/cart2/summary':
        List arguments = settings.arguments;

        return MaterialPageRoute(
            builder: (_) => CartSummary(
                  totalMrp: arguments[0],
                  totalPrice: arguments[1],
                  items: arguments[2],
                  delivery: arguments[3],
                ));

      //Profile Page Chain
      case '/profile/editBasic':
        return MaterialPageRoute(
            builder: (_) => UserDetails(
                  flow: settings.arguments,
                ));
      case '/profile/address':
        return MaterialPageRoute(builder: (_) => MyAddress(settings.arguments));
      case '/profile/orderList':
        return MaterialPageRoute(builder: (_) => OrderList());
      case '/profile/orderDetails':
        List arguments = settings.arguments;

        return MaterialPageRoute(
            builder: (_) => OrderDetails(
                  order: arguments[0],
                  pMode: arguments[1],
                  successDialog: arguments[2]
                ));

      case '/profile/orderDetails/cancel':
        return MaterialPageRoute(
            builder: (_) => CancelItems(
                  order: settings.arguments,
                ));
      case '/profile/orderDetails/return':
        return MaterialPageRoute(
            builder: (_) => ReturnItems(
                  order: settings.arguments,
                ));

      case '/profile/faq':
        return MaterialPageRoute(builder: (_) => FAQ());

      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                      child: Text('No route defined for ${settings.name}')),
                ));
    }
  }
}
