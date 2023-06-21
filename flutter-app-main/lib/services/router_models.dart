import 'package:grocapp/const/route_constants.dart';

class ProductListData {
  /// Atleast one of `isSearch`, `isFieldQuery`, `isFieldQuery2` must be true
  bool isSearch, isFieldQuery, isFieldQuery2, isQuick, isAll;

  /// TODO: IMPLEMENT THIS
  /// `searchString` is to be matched with productName
  String searchString;

  /// For `isFieldQuery`
  /// example:-
  /// `field` = "category", `query` = "Bakery, cakes & Dairy"
  String field, query;

  /// used for chaining queries.
  /// For `isFieldQuery`
  /// example:-
  /// `field` = "cubCategory", `query` = "Dairy"
  String field2, query2;

  ProductListData(
      {this.isSearch = false,
      this.searchString = "",
      this.isFieldQuery = false,
      this.field = "",
      this.query = "",
      this.isFieldQuery2 = false,
      this.field2 = "",
      this.query2 = "",
      this.isQuick = false,
      this.isAll = false})
      : assert(
          !(isSearch == false &&
              isFieldQuery == false &&
              isFieldQuery2 == false &&
              isQuick == false &&
              isAll == false),
          'No List Data was provided',
        );
}
