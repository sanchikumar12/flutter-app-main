import 'package:design/AppConstant/app_color.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class PinInputField extends StatefulWidget {
  final TextEditingController otpController;

  //final Function onComplete;

  const PinInputField({
    Key? key,
    required this.otpController,
    /*required this.onComplete*/
  }) : super(key: key);

  @override
  _PinInputFieldState createState() => _PinInputFieldState();
}

class _PinInputFieldState extends State<PinInputField> {

  final defaultPinTheme = const PinTheme(
    width: 48,
    height: 45,
    margin: EdgeInsets.only(left: 8,right: 2),
    textStyle: TextStyle(fontSize: 20, color: AppColor.black),
    decoration: BoxDecoration(
      color: AppColor.transparent,
      border: Border(bottom: BorderSide(color: AppColor.greyText)),
    ),
  );

  final focusedPinTheme = const PinTheme(
    width: 48,
    height: 45,
    margin: EdgeInsets.only(left: 8,right: 2),
    textStyle: TextStyle(fontSize: 20, color: AppColor.black),
    decoration: BoxDecoration(
      color: AppColor.transparent,
      border: Border(bottom: BorderSide(color: AppColor.greyText)),
    ),
  );

  final submittedPinTheme = const PinTheme(
    width: 48,
    height: 45,
    margin: EdgeInsets.only(left: 8,right: 2),
    textStyle: TextStyle(fontSize: 20, color: AppColor.black),
    decoration: BoxDecoration(
      color: AppColor.transparent,
      border: Border(bottom: BorderSide(color: AppColor.greyText)),
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
