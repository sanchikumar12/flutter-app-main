import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:grocapp/const/color_const.dart';
import 'package:grocapp/const/route_constants.dart';
import 'package:grocapp/screens/auth/phone/otp_page.dart';

class PhoneLogin extends StatefulWidget {
  PhoneLogin();

  @override
  _PhoneLoginState createState() => _PhoneLoginState();
}

class _PhoneLoginState extends State<PhoneLogin> {
  TextEditingController phoneController = TextEditingController();

  ValueNotifier<bool> _phoneNoHasError = ValueNotifier(false);

  @override
  initState() {
    super.initState();
  }

  @override
  void dispose() {
    phoneController.dispose();
    _phoneNoHasError.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
          child: Container(
        height: height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Expanded(
                child: SingleChildScrollView(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          StreamBuilder<bool>(
                            stream: KeyboardVisibility.onChange,
                            builder: (_, keyboardOn) {
                              print(keyboardOn);
                              // if (keyboardOn == null ||
                              //     keyboardOn.data == true) {
                              //   return Container();
                              // } else {
                              return Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 20),
                                child: Image.asset(
                                  'assets/img/logo_in.png',
                                  height: height * 0.2,
                                  width: height * 0.2,
                                ),
                              );
                              // }
                            },
                          ),
                          phoneField(),
                          nextButton(),
                          Container(
                            constraints: const BoxConstraints(maxWidth: 500),
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(children: <TextSpan>[
                                TextSpan(
                                  text: 'We will send you an ',
                                  style: TextStyle(color: Colors.black),
                                ),
                                TextSpan(
                                  text: 'One Time Password ',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                                TextSpan(
                                  text: 'on this mobile number',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ]),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )),
            MaterialButton(
              onPressed: () {
                Navigator.of(context).pushNamed(HomeRoute);
              },
              child: Text(
                'Skip LogIn',
                style: TextStyle(
                    color: Colors.teal,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    fontStyle: FontStyle.italic),
              ),
            ),
          ],
        ),
      )),
    );
  }

  Widget phoneField() {
    return Container(
      height: 40,
      constraints: BoxConstraints(maxWidth: 500),
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10,
      ),
      child: ValueListenableBuilder(
        valueListenable: _phoneNoHasError,
        builder: (BuildContext context, bool hasError, Widget child) {
          return TextFormField(
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              // prefixIcon: Icon(Icons.phone),
              prefix: Text('+91'),
              hintText: "Your Phone Number",
              hintStyle: TextStyle(),
              contentPadding: EdgeInsets.all(10),
              counterText: "",
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(3),
                ),
                borderSide: BorderSide(
                  color: !hasError ? primaryColor : Colors.grey,
                ),
              ),
              errorText:
                  hasError == true ? "Phone No. Must be 10 digits" : null,
            ),
            inputFormatters: <TextInputFormatter>[
              WhitelistingTextInputFormatter.digitsOnly,
            ],
            controller: phoneController,
            maxLength: 10,
            maxLengthEnforced: true,
            maxLines: 1,
            keyboardType: TextInputType.phone,
            onChanged: (newVal) =>
                _phoneNoHasError.value = (newVal.length < 10),
          );
        },
      ),
    );
  }

  Widget nextButton() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      constraints: BoxConstraints(maxWidth: 500),
      child: ValueListenableBuilder(
        valueListenable: _phoneNoHasError,
        builder: (_, bool phoneHasError, child) {
          return RaisedButton(
            onPressed: (phoneHasError || phoneController.text.length < 10)
                ? null
                : () {
                    FocusScopeNode currentFocus = FocusScope.of(context);
                    currentFocus.unfocus();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => OtpPage(
                          "+91" + phoneController.text,
                        ),
                      ),
                    );
                  },
            color: primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(3),
              ),
            ),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Icon(Icons.phone),
                  Text(
                    'Sign In With Phone',
                  ),
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(15),
                      ),
// color: accentColor,
                    ),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
