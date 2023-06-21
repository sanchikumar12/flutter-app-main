import 'dart:async';
import 'dart:convert';
import 'package:algolia/algolia.dart';
import 'package:flutter/material.dart';
import 'package:grocapp/const/route_constants.dart';
import 'package:grocapp/models/product_model.dart';
import 'package:grocapp/services/algolia.dart';
import 'package:grocapp/utils/Dialog.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key key}) : super(key: key);
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final GlobalKey<ScaffoldState> _searchPageState = GlobalKey<ScaffoldState>();

  final Algolia _algol = AlgoliaApplication.algolia;
  String _searchTerm;
  bool _isSearch;
  Future<List<AlgoliaObjectSnapshot>> _futureResults;
  List<AlgoliaObjectSnapshot> _results = List<AlgoliaObjectSnapshot>();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  @override
  void initState() {
    _isSearch = false;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool _load = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _searchPageState,
      //backgroundColor: primary,
      appBar: AppBar(
        title: TextField(
          autofocus: true,
          decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "Search...",
              hintStyle: TextStyle(color: Colors.black.withAlpha(50))),
          onChanged: (val) {
            setState(() {
              if (val.length > 2) {
                _load = true;
                _isSearch = true;
                _searchTerm = val;
                _searchResultOperation(val);
              } else {
                _isSearch = false;
                _load = false;
              }
            });
          },
        ),
        actions: <Widget>[
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.close),
          ),
          SizedBox(
            width: 10,
          )
        ],
      ),
      body: SafeArea(
        child: _isSearch && _results.length > 0
            ? ListView.builder(
                itemCount: _results.length,
                itemBuilder: (context, i) {
                  return ListTile(
                    onTap: () {
                      // ProgressDialog.showLoadingDialog(context, _keyLoader);

                      // Navigator.of(_keyLoader.currentContext,
                      //         rootNavigator: true)
                      //     .pop();
                      Navigator.of(context).pushNamed(
                        ProductDetailsRoute,
                        arguments: ProductModel.fromMap(_results[i].data),
                      );
                    },
                    title: Text(
                      _results[i].data['productName'],
                      style: TextStyle(color: Colors.blue),
                    ),
                    leading: CircleAvatar(
                      backgroundImage: _results[i].data['productImage'] == null
                          ? AssetImage("assets/img/shelf.jpg")
                          : NetworkImage(_results[i].data['productImage']),
                    ),
                  );
                })
            : _results.length == 0
                ? Center(
                    child: Text('No Products Found'),
                  )
                : Center(
                    child: _load == false
                        ? Text(
                            "Please Enter Product Name (2 Letters atleast)",
                            style: TextStyle(color: Colors.blue),
                          )
                        : CircularProgressIndicator(),
                  ),
      ),
    );
  }

  Future<List<AlgoliaObjectSnapshot>> _operation(String input) async {
    List<AlgoliaObjectSnapshot> results = new List<AlgoliaObjectSnapshot>();
    AlgoliaQuery query = _algol.instance
        .index("products")
        .search(input)
        .setFacetFilter("active:true");
    AlgoliaQuerySnapshot snap = await query.getObjects();
    results = snap.hits;
    return results;
  }

  _searchResultOperation(String input) {
    if (input.length > 0) {
      Duration duration = Duration(milliseconds: 500);
      Timer(duration, () {
        if (input == _searchTerm) {
          // input hasn't changed in the last 500 milliseconds..
          // you can start search
          print('Now !!! search term : ' + _searchTerm);
          if (_isSearch) {
            Future<List<AlgoliaObjectSnapshot>> searchRes =
                _operation(_searchTerm); //SEARCH OPERATION
            setState(() {
              _futureResults = searchRes;
            });
            _setResult(_futureResults);
          }
        } else {
          //wait.. Because user still writing..
          print('Not Now');
        }
      });
    }
  }

  _setResult(Future<List<AlgoliaObjectSnapshot>> objects) async {
    List<AlgoliaObjectSnapshot> snapshot = await objects;
    setState(() {
      _results = snapshot;
    });
  }
}
