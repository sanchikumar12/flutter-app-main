import 'package:flutter/material.dart';
import 'package:grocapp/const/color_const.dart';
import 'package:grocapp/screens/cart/cart.dart';
import 'package:grocapp/screens/cart/cart_provider.dart';
import 'package:grocapp/screens/cart/widgets/cart_count.dart';
import 'package:grocapp/screens/home_page/home_page.dart';
import 'package:grocapp/screens/profile/profile_page.dart';
import 'package:grocapp/screens/shelf/shelf_page.dart';
import 'package:provider/provider.dart';

class App extends StatefulWidget {
  AppState createState() {
    return AppState();
  }
}

class AppState extends State<App> {
  Stream<int> cartCountStream;
  @override
  void initState() {
    cartCountStream = context.read<CartProvider>().cartLengthController.stream;
    super.initState();
  }

  List<Widget> screens = [
    HomePage(),
    //Locations(key: PageStorageKey("Locations")),
    ShelfPage(),
    Cart(),
    ProfilePage()
    // MyOrders(user),
  ];

  int bottomNavBarIndex = 0;

  void pageChanged(int index) {
    setState(() {
      bottomNavBarIndex = index;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[bottomNavBarIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        elevation: 10,
        showUnselectedLabels: true,
        selectedItemColor: Colors.green[600],
        unselectedItemColor: Colors.blueGrey[400],
        type: BottomNavigationBarType.fixed,
        unselectedIconTheme: IconThemeData(
          color: Colors.grey[400],
          opacity: 1.0,
        ),
        selectedIconTheme: IconThemeData(
          color: accentColor,
          opacity: 1.0,
        ),
        onTap: (index) => pageChanged(index),
        currentIndex: bottomNavBarIndex,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('Home')),
          BottomNavigationBarItem(
              icon: ImageIcon(
                AssetImage("assets/img/shelf.png"),
              ),
              title: Text('Shelf')),
          BottomNavigationBarItem(
            icon: cartCount(cartCountStream),
            title: Text('Cart'),
          ),

          // BottomNavigationBarItem(icon: Icon(Icons.view_list), title: Text('My Orders')),

          BottomNavigationBarItem(
              icon: Icon(Icons.person), title: Text('Profile'))
        ],
      ),
    );
  }
}
