import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:interview/models/item.dart';



class HomeController extends GetxController {
  static HomeController get to => Get.find();

  RxList<Item> item=RxList();
  RxList cartItem=RxList();
  RxDouble subTotal=RxDouble(0.0);

  Future<void> callApi() async {
    var response = await http.get(Uri.parse("https://fakestoreapi.com/products"),headers: {'q': '{http}'});
    if (response.statusCode == 200) {
      List responseList=jsonDecode(response.body);
      responseList.forEach((v) {
        item.add(Item.fromJson(v));
      });
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  void cartSubTotalGet(){
    double total=0.0;
    for (int i=0;i<HomeController.to.cartItem.length;i++){
      total=HomeController.to.item[HomeController.to.cartItem[i] -1].price! + total;
    }
    subTotal=total.obs;
  }

}