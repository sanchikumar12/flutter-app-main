import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:interview/controller/home_controller.dart';
import 'package:interview/resources/colors.dart';
import 'package:interview/screen/login.dart';
import 'package:interview/widget/text.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    HomeController.to.callApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Grid Items"),
        centerTitle: true,
        backgroundColor: AppColor.blue,
        actions: [
          IconButton(onPressed: () async {
            SharedPreferences preferences = await SharedPreferences.getInstance();
            await preferences.clear();
            Get.off(() => (const LoginScreen()));
          }, icon: const Icon(Icons.logout,color: AppColor.white,))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 13, right: 13, top: 13),
        child: SingleChildScrollView(
          child: Obx(() => HomeController.to.item.isEmpty
              ?  Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: context.height /2.5),
                    child: const CircularProgressIndicator(
                    color: Colors.blue,
                ),
                  ))
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: GridView.builder(
                    itemCount: HomeController.to.item.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 17, mainAxisSpacing: 17, childAspectRatio: 0.85),
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              width: double.infinity,
                              height: 100,
                              decoration: const BoxDecoration(
                                color: AppColor.white,
                                boxShadow: [
                                  BoxShadow(
                                    offset: Offset(2, 2),
                                    blurRadius: 6,
                                    color: AppColor.grey,
                                  ),
                                ],
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                              ),
                              child: CachedNetworkImage(
                                imageUrl: HomeController.to.item[index].image.toString(),
                                placeholder: (context, url) => const SizedBox(
                                    width: double.infinity,
                                    child: CupertinoActivityIndicator(
                                      color: AppColor.grey,
                                    )),
                                imageBuilder: (context, imageProvider) => Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(image: imageProvider, fit: BoxFit.contain),
                                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                                  ),
                                  child: Align(
                                    alignment: Alignment.bottomRight,
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 10, bottom: 10),
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            if (HomeController.to.cartItem.contains(HomeController.to.item[index].id)) {
                                              HomeController.to.cartItem.remove(HomeController.to.item[index].id);
                                            } else {
                                              HomeController.to.cartItem.add(HomeController.to.item[index].id);
                                            }
                                          });
                                        },
                                        child: Container(
                                          height: 30,
                                          width: 30,
                                          decoration: const BoxDecoration(color: AppColor.blue, shape: BoxShape.circle),
                                          child: HomeController.to.cartItem.contains(HomeController.to.item[index].id)
                                              ? const Icon(
                                                  Icons.remove,
                                                  color: AppColor.white,
                                                  size: 17,
                                                )
                                              : const Icon(
                                                  Icons.add,
                                                  color: AppColor.white,
                                                  size: 17,
                                                ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0, top: 15),
                            child: CommonText.medium(HomeController.to.item[index].title.toString(), color: AppColor.black, size: 14, maxLines: 2, overflow: TextOverflow.ellipsis),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0, top: 5),
                            child: CommonText.semiBold("\$${HomeController.to.item[index].price.toString()}", color: AppColor.black, size: 16, maxLines: 1, overflow: TextOverflow.ellipsis),
                          ),
                        ],
                      );
                    },
                  ),
                )),
        ),
      ),
    );
  }
}
