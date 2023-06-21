import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocapp/screens/product_list/query_provider.dart';
import 'package:rxdart/rxdart.dart';

class Bloc {
  QueryProvider queryProvider;

  set setQueryProvider(QueryProvider qp) {
    queryProvider = qp;
  }

  List<DocumentSnapshot> documentList;
  bool finished;

  BehaviorSubject<List<DocumentSnapshot>> productController;

  Bloc(QueryProvider qp) {
    productController = BehaviorSubject<List<DocumentSnapshot>>();
    queryProvider = qp;
    // if the query is quickAdd type, no need to call nextList
    finished = qp.qAdd;
  }

  Stream<List<DocumentSnapshot>> get productStream => productController.stream;
/*This method will automatically fetch first X elements from the document list */
  Future fetchFirstList() async {
    try {
      documentList = await queryProvider.fetchFirstList();
      if (documentList.length == 0 ||
          documentList.length < queryProvider.limit) {
        finished = true;
      }
      productController.sink.add(documentList);
    } on SocketException {
      productController.sink
          .addError(SocketException("No Internet Connection"));
    } catch (e) {
      print(e.toString());
      productController.sink.addError(e);
    }
  }

/*This will automatically fetch the next [queryProvider.limit] elements from the list*/
  Future<void> fetchNextMovies() async {
    if (finished) return;
    try {
      List<DocumentSnapshot> newDocumentList =
          await queryProvider.fetchNextList(documentList);
      if (newDocumentList.length == 0 ||
          newDocumentList.length < queryProvider.limit) {
        finished = true;
      }
      documentList.addAll(newDocumentList);
      productController.sink.add(documentList);
      try {} catch (e) {
        print(e.toString());
      }
    } on SocketException {
      productController.sink
          .addError(SocketException("No Internet Connection"));
      finished = true;
    } catch (e) {
      print(e.toString());
    }
    return;
  }

  void dispose() {
    productController.close();
  }
}
