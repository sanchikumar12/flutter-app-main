import 'package:flutter/material.dart';
import 'package:grocapp/const/color_const.dart';
import 'package:grocapp/const/route_constants.dart';
import 'package:grocapp/const/size_config.dart';
import 'package:grocapp/const/text_style.dart';
import 'package:provider/provider.dart';

import 'package:flutter_onboard/flutter_onboard.dart';

class OnBoarding extends StatefulWidget {
  @override
  _OnBoardingState createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  static final String asset1 = 'assets/img/onboard_1.png';
  static final String asset2 = 'assets/img/onboard_2.png';
  static final String asset3 = 'assets/img/onboard_3.png';

  final List<OnBoardModel> onBoardData = [
    OnBoardModel(
      title: "Welcome to Frapen",
      description: "The Source of Online Fresh Pantry",
      imgUrl: asset1,
    ),
    OnBoardModel(
        title: "Secured Payments",
        description: "Pay Online/COD according to convenience",
        imgUrl: asset2),
    OnBoardModel(
      title: "Safe Delivery",
      description: "Your items reach your door-step safely",
      imgUrl: asset3,
    ),
  ];
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Provider<OnBoardState>(
        create: (_) => OnBoardState(),
        child: Scaffold(
          body: OnBoard(
            imageHeight: SizeConfig.screenHeight * 0.5,
            imageWidth: SizeConfig.screenWidth - 50,
            onBoardData: onBoardData,
            curve: Curves.easeOutBack,
            pageController: _pageController,
            onSkip: () {
              Navigator.pushReplacementNamed(
                context,
                AuthRoute,
              );
            },
            onDone: () {
              Navigator.pushReplacementNamed(
                context,
                AuthRoute,
              );
            },
            titleStyles: onBoardTitleText,
            pageIndicatorStyle: PageIndicatorStyle(
              width: 150,
              inactiveColor: Colors.grey,
              activeColor: accentColor,
              inactiveSize: Size(8, 8),
              activeSize: Size(15, 12),
            ),
            descriptionStyles: onBoardDetailsText,
            nextButton: Consumer<OnBoardState>(
              builder:
                  (BuildContext context, OnBoardState state, Widget child) {
                return InkWell(
                  onTap: () => _onNextTap(state),
                  child: !state.isLastPage
                      ? Container()
                      // Container(
                      //     width: 50,
                      //     height: 50,
                      //     child: Icon(Icons.arrow_forward),
                      //     decoration: BoxDecoration(
                      //       borderRadius: BorderRadius.circular(25.0),
                      //       color: Colors.white,
                      //       boxShadow: [
                      //         BoxShadow(
                      //           color: Colors.grey,
                      //           offset: Offset(0.0, 1.0), //(x,y)
                      //           blurRadius: 6.0,
                      //         ),
                      //       ],
                      //     ),
                      //   )
                      : Container(
                          width: 230,
                          height: 50,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            gradient: LinearGradient(
                              colors: [primaryColor, accentColor],
                            ),
                          ),
                          child: Text(
                            "Get Started",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                );
              },
            ),
          ),
        ));
  }

  void _onNextTap(OnBoardState onBoardState) {
    if (!onBoardState.isLastPage) {
      _pageController.animateToPage(
        onBoardState.page + 1,
        duration: Duration(milliseconds: 250),
        curve: Curves.easeInOutSine,
      );
    } else {
      Navigator.pushReplacementNamed(
        context,
        AuthRoute,
      );
    }
  }
}
