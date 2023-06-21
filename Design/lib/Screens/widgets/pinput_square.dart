import 'package:design/AppConstant/app_color.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class PinPutSquare extends StatefulWidget {
  final TextEditingController otpController;

  //final Function onComplete;

  const PinPutSquare({Key? key, required this.otpController
      /*required this.onComplete*/
      })
      : super(key: key);

  @override
  _PinPutSquareState createState() => _PinPutSquareState();
}

class _PinPutSquareState extends State<PinPutSquare> {
  final defaultPinTheme =  PinTheme(
    width: 28,
    height: 35,
    margin: const EdgeInsets.only(right: 10),
    textStyle: const TextStyle(fontSize: 20, color: AppColor.black),
    decoration: BoxDecoration(
      color: AppColor.greyLight3,
      borderRadius: BorderRadius.circular(3),

    ),
  );

  final focusedPinTheme =  PinTheme(
    width: 28,
    height: 35,
    margin: const EdgeInsets.only(right: 10),
    textStyle: const TextStyle(fontSize: 20, color: AppColor.black),
    decoration: BoxDecoration(
      color: AppColor.greyLight3,
      borderRadius: BorderRadius.circular(3),
    ),
  );

  final submittedPinTheme =  PinTheme(
    width: 28,
    height: 35,
    margin: const EdgeInsets.only(right: 10),
    textStyle: const TextStyle(fontSize: 20, color: AppColor.black),
    decoration: BoxDecoration(
      color: AppColor.greyLight3,
      borderRadius: BorderRadius.circular(3),
    ),
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Pinput(
        androidSmsAutofillMethod: /*Platform.isIOS ?*/ AndroidSmsAutofillMethod.smsUserConsentApi /*: AndroidSmsAutofillMethod.none*/,
        controller: widget.otpController,
        defaultPinTheme: defaultPinTheme,
        focusedPinTheme: focusedPinTheme,
        submittedPinTheme: submittedPinTheme,
        pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
        showCursor: true,
        length: 4,
        cursor: const Padding(
          padding: EdgeInsets.all(12),
          child: VerticalDivider(thickness: 1, color: AppColor.greyText),
        ),

        /* onCompleted: (pin) {
          widget.onComplete();
        },*/
      ),
    );
  }
}
