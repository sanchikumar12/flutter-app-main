import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocapp/screens/product_pages/category_product_page.dart';

import 'shimmer.dart';

class Carousel extends StatefulWidget {
  @override
  _CarouselState createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  String image = 'offers';
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        padding: EdgeInsets.only(bottom: 10),
        child: StreamBuilder<DocumentSnapshot>(
            stream: Firestore.instance
                .collection('banners')
                .document('offers')
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: shimmerOffer(context));
              } else {
                List<Map<String, dynamic>> items = [];

                snapshot.data['offer'].forEach((element) {
                  items.add({
                    'bannerUrl': element['bannerUrl'],
                    'category': element['category'],
                    'subCategory': element['subCategory']
                  });
                });

                return CarouselSlider(
                  items: items.map((i) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(horizontal: 5.0),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                          ),
                          child: InkWell(
                            onTap: () {
                              if (i['category'] != 'none' && i['category'] != null) {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (_) => CategoryProductPage(
                                        i['category'], "category")));
                              } else if (i['subCategory'] != 'none' && i['subCategory'] != null) {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (_) => CategoryProductPage(
                                        i['subCategory'], "subCategory")));
                              }
                            },
                            child: CachedNetworkImage(
                              imageUrl: i['bannerUrl'],
                              imageBuilder: (context, imageProvider) {
                                return Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8.0)),
                                        image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.fill)));
                              },
                              fit: BoxFit.fill,
                              placeholder: (context, url) {
                                return shimmerOffer(context);
                              },
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                  options: CarouselOptions(
                    height: 150,
                    initialPage: 0,
                    enableInfiniteScroll: true,
                    reverse: false,
                    autoPlay: true,
                    autoPlayInterval: Duration(seconds: 3),
                    autoPlayAnimationDuration: Duration(milliseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
                  ),
                );
              }
            }));
  }
}
