import 'package:cloud_firestore/cloud_firestore.dart';

class Category {
  int rank;
  String name, imgUrl;
  bool active;
  List<String> subCategories;
  bool isExpanded;// only for shelf-page expansion
  Category(this.name, this.imgUrl, this.active,
      [this.subCategories, this.rank]);
  static List<Category> getListFromSnap(DocumentSnapshot snap) {
    List<Category> r = [];

    snap.data.forEach((key, value) {
      if (value['active'] == false) return;
      Category cat = Category(key, value['imgUrl'], value['active'], []);
      value.forEach((key1, value1) {
        if (key1 != 'rank' && key1 != 'imgUrl' && key1 != 'active')
          cat.subCategories.add(key1);
        if (key1 == 'rank') cat.rank = value1;
      });
      r.add(cat);
    });
    r.sort((a, b) => a.rank.compareTo(b.rank));
    return r;
  }
}
