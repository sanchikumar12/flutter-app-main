import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:interview/controller/home_controller.dart';
import 'package:interview/resources/colors.dart';
import 'package:interview/widget/text.dart';

class Cart extends StatefulWidget {
  const Cart({Key? key}) : super(key: key);

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  @override
  void initState() {
    HomeController.to.cartSubTotalGet();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cart"),
        centerTitle: true,
        backgroundColor: AppColor.blue,
      ),
      body: Stack(
        children: [
          Obx(() => HomeController.to.cartItem.isEmpty
              ? const Center(
                  child: CommonText.medium(
                  "Empty",
                  size: 22,
                ))
              : ListView.builder(
                  itemCount: HomeController.to.cartItem.length,
                  padding: const EdgeInsets.only(bottom: 80),
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: SizedBox(
                          width: 50,
                          height: 50,
                          child: CachedNetworkImage(
                              placeholder: (context, url) => const SizedBox(
                                  width: double.infinity,
                                  child: CupertinoActivityIndicator(
                                    color: AppColor.greyLight,
                                  )),
                              imageUrl: HomeController.to.item[HomeController.to.cartItem[index] - 1].image.toString())),
                      title: CommonText.medium(HomeController.to.item[HomeController.to.cartItem[index] - 1].title.toString(),
                          color: AppColor.black, size: 12, maxLines: 1, overflow: TextOverflow.ellipsis),
                      subtitle: CommonText.semiBold(HomeController.to.item[HomeController.to.cartItem[index] - 1].price.toString(),
                          color: AppColor.black, size: 14, maxLines: 1, overflow: TextOverflow.ellipsis),
                      trailing: IconButton(
                          onPressed: () {
                            HomeController.to.cartItem.remove(HomeController.to.item[HomeController.to.cartItem[index] - 1].id);
                            HomeController.to.cartSubTotalGet();
                            setState(() {});
                          },
                          icon: const Icon(
                            Icons.remove_circle_outline_outlined,
                            color: AppColor.blue,
                          )),
                    );
                  },
                )),
          if (HomeController.to.cartItem.isNotEmpty)
            Obx(
              () => Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 50,
                  width: double.infinity,
                  color: AppColor.blue,
                  alignment: Alignment.center,
                  child: CommonText.semiBold(HomeController.to.subTotal.toString(), color: AppColor.white, size: 18, overflow: TextOverflow.ellipsis),
                ),
              ),
            )
        ],
      ),
    );
  }
}
