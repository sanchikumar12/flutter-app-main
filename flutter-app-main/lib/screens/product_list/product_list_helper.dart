import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocapp/services/router_models.dart';

Stream<QuerySnapshot> getProducts(ProductListData data) {
  final Firestore firestore = Firestore.instance;

  Stream<QuerySnapshot> stream;

  if (data.isSearch) {
    //TODO: IMPLEMENT THIS.
  } else if (data.isFieldQuery && !data.isFieldQuery2) {
    stream = firestore
        .collection("products")
        .where(data.field, isEqualTo: data.query)
        .snapshots();
  } else if (data.isFieldQuery2 && data.isFieldQuery2) {
    stream = firestore
        .collection("products")
        .where(data.field, isEqualTo: data.query)
        .where(data.field2, isEqualTo: data.query2)
        .snapshots();
  } else if (data.isQuick) {
    stream = firestore
        .collection("products")
        .where('qAdd', isEqualTo: true)
        .snapshots();
  } else if (data.isAll) {
    stream = firestore.collection("products").snapshots();
  } else {
    print("!!!!!!!!! Use 'isFieldQuery' !!!!!!!!!");
    assert("Don't Do" == "This");
  }
  return stream;
}
