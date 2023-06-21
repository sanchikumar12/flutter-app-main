import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocapp/const/size_config.dart';
import 'package:grocapp/models/category.dart';
import 'package:grocapp/screens/home_page/shimmer.dart';
import 'package:grocapp/screens/product_pages/category_product_page.dart';
import 'package:grocapp/widgets/loader.dart';

Widget homeCategory(BuildContext context) {
  return Container(
    color: Colors.white,
    height: SizeConfig.screenHeight * 0.2,
    width: MediaQuery.of(context).size.width * 0.95,
    child: StreamBuilder<DocumentSnapshot>(
        stream: Firestore.instance
            .collection('categories')
            .document("categories")
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return loader();
          } else {
            Map<String, dynamic> data = snapshot.data.data;
            List<Category> cats = [];
            data.forEach((key, value) {
              if (value['active'] == true) {
                cats.add(Category(key, value['imgUrl'], value['active'], null,
                    value['rank']));
              }
            });
            cats.sort((a, b) => a.rank.compareTo(b.rank));
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: cats.length,
              itemBuilder: (BuildContext context, int index) {
                return circleBack(
                  cats[index].name,
                  cats[index].imgUrl,
                  context,
                );
              },
            );
          }
        }),
  );
}

Widget catImg(String imgUrl) {
  return Positioned(
    left: 0,
    top: 5,
    child: new CachedNetworkImage(
      imageUrl: imgUrl,
      fit: BoxFit.contain,
      placeholder: (context, url) {
        return shimmerCategory(context);
      },
    ),
  );
}

Widget catText(String name, BuildContext context) {
  return Container(
    width: MediaQuery.of(context).size.width * 0.32,
    margin: new EdgeInsets.only(left: 35.0),
    decoration: new BoxDecoration(
      color: Colors.white,
      shape: BoxShape.rectangle,
      borderRadius: new BorderRadius.circular(5.0),
      boxShadow: <BoxShadow>[
        new BoxShadow(
          color: Colors.black12,
          blurRadius: 10.0,
          offset: new Offset(0.0, 10.0),
        ),
      ],
    ),
  );
}

Widget circleBack(String name, String image, BuildContext context) {
  return Center(
    child: InkWell(
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => CategoryProductPage(name, "category"))),
        child: Container(
          width: SizeConfig.screenHeight * 0.12,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Flexible(
                flex: 2,
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  width: SizeConfig.screenHeight * 0.1,
                  padding: EdgeInsets.all(5),
                  height: SizeConfig.screenHeight * 0.1,
                  child: CachedNetworkImage(
                    imageUrl: image,
                    fit: BoxFit.contain,
                    placeholder: (context, url) {
                      return shimmerCategory(context);
                    },
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0.0, 1.0), //(x,y)
                        blurRadius: 6.0,
                      ),
                    ],
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: Container(
                  padding: EdgeInsets.only(left: 5, right: 5),
                  child: Text(
                    name,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    style: GoogleFonts.nunito(
                      textStyle: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                          fontSize: 15),
                    ),
                  ),
                ),
              ),
            ],
          ),
        )),
  );
}
