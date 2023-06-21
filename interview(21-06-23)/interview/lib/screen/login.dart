import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:interview/resources/colors.dart';
import 'package:interview/screen/bottom_navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widget/text.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SafeArea(
        child: Scaffold(
      body: Stack(
        children: [
          Positioned(
            left: -20,
            right: -20,
            child: Container(
              height: MediaQuery.of(context).size.height / 2,
              width: MediaQuery.of(context).size.width * 2,
              decoration: BoxDecoration(
                color: AppColor.blue,
                borderRadius: const BorderRadius.only(bottomLeft: Radius.elliptical(60, 30), bottomRight: Radius.elliptical(60, 30)),
                boxShadow: [BoxShadow(color: AppColor.grey.withOpacity(0.8), spreadRadius: 3, blurRadius: 5)],
                // )
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 50),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.symmetric(horizontal: 26),
                    decoration: BoxDecoration(
                      boxShadow: [BoxShadow(color: AppColor.blue.withOpacity(0.3), spreadRadius: 1, offset: const Offset(0, 1), blurRadius: 10)],
                      color: AppColor.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                        const SizedBox(height: 50),
                        const CommonText.medium("Login", color: AppColor.black, size: 22, overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 50),
                        TextField(
                            keyboardType: TextInputType.name,
                            controller: usernameController,
                            decoration: InputDecoration(
                              filled: true,
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 11),
                              fillColor: AppColor.white,
                              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColor.black30)),
                              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColor.black30)),
                              labelText: 'Username',
                              hintStyle: const TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: 16,
                                color: AppColor.black,
                              ),
                            )),
                        const SizedBox(height: 50),
                        TextField(
                            controller: passwordController,
                            decoration: InputDecoration(
                              filled: true,
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 11),
                              fillColor: AppColor.white,
                              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: AppColor.black30)),
                              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: AppColor.black30)),
                              labelText: 'Password',
                              hintStyle: const TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: 16,
                                color: AppColor.black,
                              ),
                            )),
                        const SizedBox(height: 50),
                        InkWell(
                          onTap: () async {
                            if(usernameController.text.toString()=="admin"&&passwordController.text.toString()=="123456")
                            {
                              final prefs = await SharedPreferences.getInstance();
                              await prefs.setString('userName', usernameController.text.toString());
                              await prefs.setString('password', passwordController.text.toString());
                              Get.off(() => (const Nav()));
                            }
                            else{
                              ScaffoldMessenger.of(context)
                                ..clearSnackBars()
                                 ..showSnackBar(
                                  const SnackBar(backgroundColor: AppColor.red,
                                    content: CommonText.semiBold("Please check username and password and try again",color: AppColor.white,)
                                  ),
                                );
                            }

                          },
                          child: Container(
                            height: 40,
                            width: 150,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppColor.black,
                                width: 0.5,
                              ),
                              color: AppColor.blue,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10),
                              ),
                              boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.8), spreadRadius: 0.5, blurRadius: 0.5)],
                              // )
                            ),
                            child: const Center(
                              child: Text(
                                "LOGIN",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20,
                                  color: AppColor.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 50),
                      ]),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
