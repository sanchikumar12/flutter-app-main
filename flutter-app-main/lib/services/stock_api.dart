import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocapp/models/stock.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StockApi {
  SharedPreferences _cache;
  bool isReady = false;
  CollectionReference _db = Firestore.instance.collection("stock");
  int ttl = 180; // in minutes
  final String separator = ":::";

  void _init() async {
    _cache = await SharedPreferences.getInstance();
    isReady = true;
  }

  StockApi() {
    _init();
  }

  bool _isCacheStale(int ts) {
    return DateTime.now()
            .difference(DateTime.fromMillisecondsSinceEpoch(ts))
            .inMinutes >
        ttl;
  }

  Stock _getStockFromCache(String barcode) {
    try {
      String data = _cache.getString(barcode);
      int ts = int.tryParse(data.split(separator)[0]) ?? 0;
      if (_isCacheStale(ts)) {
        return null;
      }
      String json = data.split(separator)[1];
      return Stock.fromJson(jsonDecode(json));
    } catch (e) {}
    return null;
  }

  Future<Stock> _getFromFirestore(String barcode) async {
    DocumentSnapshot snap = await _db.document(barcode).get();
    Stock stock;
    try {
      stock = Stock.fromSnap(snap);
    } catch (e) {
      stock = Stock.empty(barcode);
    }
    return stock;
  }

  void _storeInCache(Stock stock) async {
    int ts = DateTime.now().millisecondsSinceEpoch;
    String data = "$ts" + separator + jsonEncode(stock);
    await _cache.setString(stock.barcode, data);
  }

  Future<Stock> getProduct(String barcode) async {
    Stock stock = await Future<Stock>.value(_getStockFromCache(barcode));
    if (stock == null) {
      stock = await _getFromFirestore(barcode);
      _storeInCache(stock);
    }
    return stock;
  }
}
