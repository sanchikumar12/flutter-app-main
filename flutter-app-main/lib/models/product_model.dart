import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';

class ProductModel {
  String productId;
  String productDescription;
  String productName;
  String productImage;
  List<Variety> productVariety = new List<Variety>();
  String category;
  String subCategory;
  bool subscription;
  bool active;
  double totalStock;

  String countryOfOrigin;

  ProductModel.fromSnapshot(DocumentSnapshot snapshot)
      : productId = snapshot.documentID,
        productDescription = snapshot['productDescription'] ?? '',
        productName = snapshot['productName'] ?? '',
        productImage = snapshot['productImage'] ?? '',
        productVariety = snapshot['productVariety'].map<Variety>((item) {
          return Variety.fromMap(item);
        }).toList(),
        category = snapshot['category'] ?? '',
        subCategory = snapshot['subCategory'] ?? '',
        subscription = snapshot['subscription'] ?? '',
        countryOfOrigin = snapshot['countryOfOrigin'] ?? '',
        active = snapshot['active'] ?? '',
        totalStock = double.tryParse("${snapshot['totalStock']}") ?? 0;

  ProductModel.fromMap(Map<String, dynamic> snapshot)
      : productId = snapshot['productId'] ?? '',
        productDescription = snapshot['productDescription'] ?? '',
        productName = snapshot['productName'] ?? '',
        productImage = snapshot['productImage'] ?? '',
        productVariety = snapshot['productVariety'].map<Variety>((item) {
          return Variety.fromMap(item);
        }).toList(),
        category = snapshot['category'] ?? '',
        subCategory = snapshot['subCategory'] ?? '',
        subscription = snapshot['subscription'] ?? '',
        countryOfOrigin = snapshot['countryOfOrigin'] ?? '',
        active = snapshot['active'] ?? '',
        totalStock = double.tryParse("${snapshot['totalStock']}") ?? 0;
}

// Two varieties are unique if and only if (mrp and size) as pair is unique.
class Variety {
  double mrp;
  String size;
  double sp;
  double stock;
  double discount;
  double
      fraction; // for uneven count items - Eg. 100g of potato from stock of 10kg; size=100g, stock=10, fraction = 0.1

  Variety.fromMap(Map<String, dynamic> item) {
    mrp = double.parse("${item['mrp']}");
    size = item['size'];
    sp = double.parse("${item['sp']}");
    stock = double.tryParse("${item['stock']}") ?? 0;
    fraction = double.tryParse("${item['fraction']}") ?? 0;
    discount = mrp - sp;
  }

  Variety.forCart(Map<String, dynamic> item) : size = item['size'];

  Map<String, dynamic> get map {
    return {
      "mrp": mrp,
      "size": size,
      "sp": sp,
      "stock": stock,
      "discount": discount
    };
  }

  Variety.fromMapOrDefault(Map<String, dynamic> item) {
    mrp = double.tryParse("${item['mrp']}") ?? 0;
    size = item['size'] ?? '-';
    sp = double.tryParse("${item['sp']}") ?? 0;
    stock = double.tryParse("$item['stock']") ?? 0;
    discount = mrp - sp < 0 ? 0 : mrp - sp;
  }

  Variety.sizeOnly(String _size) : size = _size;

  bool operator ==(o) => o is Variety && o.mrp == mrp && o.size == size;
  int get hashCode => mrp.hashCode ^ size.hashCode;
}

class CartModel {
  String productId;
  String productName;
  String productImage;

  /// Always stays null, [productVariety] & [available = false(default)] should be fetched from products
  /// For fresh prices and availability
  Variety productVariety;
  bool available;

  //this field is null if item is created locally and not fetched from firebase
  String cartItemId;

  int count;

  int returnStatus; // 0 initially | 1 flagged for return | 2 is returned

  CartModel(ProductModel p, Variety pv) {
    productId = p.productId;
    productName = p.productName;
    productImage = p.productImage;
    productVariety = pv;
    count = 1;
    available = false;
    returnStatus = 0;
  }

  Map<String, dynamic> get map {
    return {
      "productId": productId,
      "productName": productName,
      "productImage": productImage,
      "productVariety": productVariety.map,
      "count": count,
      "returnStatus": 0
    };
  }

  CartModel.fromMap(Map<String, dynamic> snap)
      : productId = snap['productId'],
        productName = snap['productName'],
        productImage = snap['productImage'],
        count = snap['count'],
        productVariety = Variety.fromMap(snap['productVariety']),
        cartItemId = snap['cartItemId'],
        available = false,
        returnStatus = snap['returnStatus'] ?? 0;

  CartModel.forCart(Map<String, dynamic> snapshot)
      : productId = snapshot['productId'],
        productName = snapshot['productName'],
        productImage = snapshot['productImage'],
        count = snapshot['count'],
        productVariety = Variety.forCart(snapshot['productVariety']),
        cartItemId = snapshot['cartItemId'],
        available = false,
        returnStatus = snapshot['returnStatus'] ?? 0;

  Map<String, dynamic> get returnMap {
    return {
      "productId": productId,
      "productName": productName,
      "productImage": productImage,
      "productVariety": productVariety.map,
      "count": count,
      "returnStatus": returnStatus
    };
  }
}
