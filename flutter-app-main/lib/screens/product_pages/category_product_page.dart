import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocapp/const/enums.dart';
import 'package:grocapp/const/route_constants.dart';
import 'package:grocapp/const/size_config.dart';
import 'package:grocapp/screens/algolia/search_page.dart';
import 'package:grocapp/screens/cart/cart_provider.dart';
import 'package:grocapp/screens/cart/widgets/cart_count.dart';
import 'package:grocapp/screens/product_list/product_list.dart';
import 'package:grocapp/screens/product_list/query_provider.dart';
import 'package:grocapp/screens/product_list/bloc.dart';
import 'package:provider/provider.dart';

import 'widgets/sortByBar.dart';

class CategoryProductPage extends StatefulWidget {
  final String pageName, fieldName;
  CategoryProductPage(this.pageName, this.fieldName);
  @override
  _CategoryProductPageState createState() => _CategoryProductPageState();
}

class _CategoryProductPageState extends State<CategoryProductPage> {
  Stream<int> cartCountStream;
  ValueNotifier<sortBy> sortOrder = ValueNotifier(sortBy.popularity);
  @override
  initState() {
    cartCountStream = context.read<CartProvider>().cartLengthController.stream;
    super.initState();
  }

  Bloc bloc;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(widget.pageName),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SearchPage()),
                ),
              ),
              IconButton(
                icon: cartCount(cartCountStream),
                onPressed: () => Navigator.pushNamed(context, CartRoute),
              ),
              SizedBox(
                width: 5,
              )
            ],
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Container(
            color: Colors.grey[200],
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              child: sortByBar(sortOrder),
            ),
          ),
          Expanded(
            child: productList(),
          ),
        ],
      ),
    );
  }

  Widget productList() {
    return ValueListenableBuilder(
      valueListenable: sortOrder,
      builder: (_, value, __) {
        String orderBy;
        bool descending;
        if (value == sortBy.popularity) {
          orderBy = "freq";
          descending = true;
        } else if (value == sortBy.newest) {
          orderBy = "updatedAt";
          descending = true;
        } else if (value == sortBy.priceIncreasing) {
          orderBy = "startingPrice";
          descending = false;
        } else {
          orderBy = "startingPrice";
          descending = true;
        }
        var qp = QueryProvider(
          orderBy: orderBy,
          field: widget.fieldName,
          query: widget.pageName,
          limit: 10,
          decreasing: descending,
        );
        if (bloc == null) {
          bloc = Bloc(qp);
        } else {
          bloc.setQueryProvider = qp;
        }
        bloc.productController.sink.add(null); // toggle refresh
        bloc.fetchFirstList();
        return ProductList(bloc);
      },
    );
  }

  void dispose() {
    bloc.dispose();
    super.dispose();
  }
}
