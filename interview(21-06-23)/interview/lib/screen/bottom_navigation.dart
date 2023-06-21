import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:interview/resources/colors.dart';
import 'package:interview/screen/cart.dart';
import 'package:interview/screen/home.dart';

class Nav extends StatefulWidget {
  const Nav({Key? key}) : super(key: key);

  @override
  State<Nav> createState() => _NavState();
}

class _NavState extends State<Nav> {
  int currentIndex = 0;
  List pages = [const Home(), const Cart()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: pages[currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed, // This is all you need!
          currentIndex: currentIndex,
          onTap: (value) {
            setState(() => currentIndex = value);
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined, size: 30, color: AppColor.grey),
              activeIcon: Icon(
                Icons.home_outlined,
                size: 30,
                color: AppColor.blue,
              ),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart_outlined, size: 30, color: AppColor.grey),
              activeIcon: Icon(
                Icons.shopping_cart_outlined,
                size: 30,
                color: AppColor.blue,
              ),
              label: "Cart",
            ),
          ],
        ));
  }
}
