import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocapp/const/color_const.dart';
import 'package:grocapp/const/size_config.dart';
import 'package:grocapp/const/text_style.dart';
import 'package:grocapp/screens/algolia/search_page.dart';
import 'package:grocapp/screens/home_page/get_carousel.dart';
import 'package:grocapp/screens/home_page/home_category.dart';
import 'package:grocapp/screens/home_page/quick_add.dart';
import 'package:shimmer/shimmer.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            'assets/img/logo.png',
            fit: BoxFit.fill,
            height: 20,
          ),
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'Home',

          // style: GoogleFonts.nunito(
          //     fontSize: 22,
          //     letterSpacing: 1,
          //     fontWeight: FontWeight.bold,
          //     color: Colors.green),
        ),
        actions: <Widget>[
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchPage()),
              );
            },
            child: Icon(Icons.search),
          ),
          SizedBox(
            width: 15,
          )
        ],
        backgroundColor: appbarColor,
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Carousel(),
            SizedBox(
              height: 15,
            ),
            Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Text(
                'Shop By Category',
                style: orderDetilsHeadText,
              ),
            ),
            homeCategory(context),
            SizedBox(
              height: 15,
            ),
            Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Text(
                'Quick Adds',
                style: orderDetilsHeadText,
              ),
            ),
            QuickAdds(),
          ],
        ),
      ),
    );
  }
}
