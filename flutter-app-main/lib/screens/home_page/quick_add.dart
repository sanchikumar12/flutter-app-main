import 'package:flutter/material.dart';
import 'package:grocapp/screens/product_list/product_list.dart';
import 'package:grocapp/screens/product_list/query_provider.dart';
import 'package:grocapp/screens/product_list/bloc.dart';

class QuickAdds extends StatefulWidget {
  @override
  _QuickAddsState createState() => _QuickAddsState();
}

class _QuickAddsState extends State<QuickAdds> {
  @override
  Widget build(BuildContext context) {
    return ProductList(
      Bloc(QueryProvider.forQuickAdd()),
    );
  }
}
