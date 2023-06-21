import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocapp/const/color_const.dart';
import 'package:grocapp/const/route_constants.dart';
import 'package:grocapp/models/category.dart';
import 'package:grocapp/screens/algolia/search_page.dart';
import 'package:grocapp/screens/product_pages/category_product_page.dart';
import 'package:grocapp/widgets/loader.dart';
import 'package:shimmer/shimmer.dart';

class ShelfPage extends StatefulWidget {
  @override
  _ShelfPageState createState() => _ShelfPageState();
}

class _ShelfPageState extends State<ShelfPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () => Navigator.pushReplacementNamed(context, HomeRoute),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              'assets/img/logo.png',
              fit: BoxFit.fill,
              height: 20,
            ),
          ),
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text('Shelf'),
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
      body: StreamBuilder<DocumentSnapshot>(
        stream: Firestore.instance
            .collection('categories')
            .document("categories")
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return loader();
          } else {
            List<Category> cats = Category.getListFromSnap(snapshot.data);
            List<ShelfItem> shelfItems = [];
            cats.forEach((element) {
              shelfItems.add(ShelfItem(cat: element, isExpanded: false));
            });
            return ListView(
                shrinkWrap: true, children: <Widget>[MyShelfItems(shelfItems)]);
          }
        },
      ),
    );
  }
}

class ShelfItem {
  ShelfItem({this.cat, this.isExpanded = false});
  Category cat;
  bool isExpanded;
}

class MyShelfItems extends StatefulWidget {
  List<ShelfItem> shelfItems;
  MyShelfItems(this.shelfItems);
  @override
  State createState() => new MyShelfItemsState();
}

class MyShelfItemsState extends State<MyShelfItems> {
  PageStorageKey _key;
  int _activeMeterIndex;
  int i = -1;

  @override
  void initState() {
    //getCols();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // _key = new PageStorageKey('${widget.did}');
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _activeMeterIndex = _activeMeterIndex == index ? -1 : index;
        });
      },
      children: widget.shelfItems.map<ExpansionPanel>((ShelfItem item) {
        return ExpansionPanel(
            canTapOnHeader: true,
            headerBuilder: (BuildContext context, bool isExpanded) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: ListTile(
                  leading: CachedNetworkImage(
                    height: 60,
                    width: 60,
                    imageUrl: item.cat.imgUrl,
                    fit: BoxFit.contain,
                    placeholder: (context, url) {
                      return Shimmer.fromColors(
                          child: Container(
                            height: 60,
                            width: 60,
                            color: Colors.white,
                          ),
                          baseColor: Colors.grey[200],
                          highlightColor: Colors.grey[50]);
                    },
                  ),
                  title: Text(item.cat.name),
                ),
              );
            },
            isExpanded: _activeMeterIndex == (widget.shelfItems.indexOf(item)),
            body: ListView(
              shrinkWrap: true,
              physics: ScrollPhysics(),
              children: getCols(item),
            ));
      }).toList(),
    );
  }

  List<ListTile> getCols(ShelfItem item) {
    List<ListTile> cols = [
      ListTile(
        leading: Container(
          height: 60,
          width: 60,
        ),
        title: Text("All Products"),
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => CategoryProductPage(item.cat.name, "category"))),
      ),
    ];
    item.cat.subCategories.forEach((element) {
      cols.add(ListTile(
        leading: Container(
          height: 60,
          width: 60,
        ),
        title: Text(element),
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => CategoryProductPage(element, "subCategory"))),
      ));
    });
    return cols;
  }
}
