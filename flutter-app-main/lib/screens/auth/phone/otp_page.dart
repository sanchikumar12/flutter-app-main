import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_user_stream/firebase_user_stream.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grocapp/const/color_const.dart';
import 'package:grocapp/const/route_constants.dart';
import 'package:grocapp/const/size_config.dart';
import 'package:grocapp/screens/auth/phone/more_details.dart';
import 'package:grocapp/screens/auth/widgets/countdown.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class Otp {
  static const int showNothing = 0;
  static const int showTimer = 1;
  static const int showRetryButton = 2;
}

class OtpPage extends StatefulWidget {
  final String mobile;
  OtpPage(this.mobile);

  @override
  _OtpPageState createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> with TickerProviderStateMixin {
  static const int otpTimeout = 30;

  ValueNotifier<int> _showRetryButton = ValueNotifier(Otp.showNothing);
  TextEditingController otpController = TextEditingController();
  AnimationController _controller;
  ValueNotifier<String> _otpError = ValueNotifier("");

  String verificationId = '';
  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: otpTimeout),
    );
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _showRetryButton.value = Otp.showRetryButton;
      }
    });
    verifyPhone(context);
    super.initState();
  }

  @override
  void dispose() {
    _showRetryButton.dispose();
    otpController.dispose();
    _controller.dispose();
    _otpError.dispose();
    super.dispose();
  }

  void logIn(AuthCredential credential) async {
    try {
      await FirebaseAuth.instance
          .signInWithCredential(credential)
          .then((currentUser) async {
        if (currentUser != null) {
          if (otpController.text.length == 0) {
            String otp = autoFillAutoOtp(credential);
            otpController.text = otp;
          }
          success(currentUser);
          //await createUserDb(firebaseUser);

        } else {
          _otpError.value = "Something went wrong";
        }
      });
    } on PlatformException catch (error) {
      Navigator.of(context, rootNavigator: true).pop();
      if (error.message.contains(
          "The sms verification code used to create the phone auth credential is invalid")) {
        _otpError.value = "Incorrect OTP";
      } else if (error.message.contains("The sms code has expired")) {
        _otpError.value = "This sms code has expired";
      }
    }
  }

  void success(AuthResult currentUser) async {
    var docRef =
        Firestore.instance.collection('users').document(currentUser.user.uid);
    var snapshot = await docRef.get();
    FocusScopeNode currentFocus = FocusScope.of(context);
    currentFocus.unfocus();
    Navigator.popUntil(context, (route) => route.isFirst);
    if (!snapshot.exists) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MoreDetails(currentUser.user, docRef),
          ));
    } else {
      if (snapshot.data.containsKey("name")) {
        Navigator.pushReplacementNamed(
          context,
          HomeRoute,
        );
      } else {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MoreDetails(currentUser.user, docRef),
            ));
      }
    }
  }

  Future<void> verifyPhone(BuildContext context) async {
    try {
      final PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verId) {
        this.verificationId = verId;
      };

      final PhoneCodeSent smsCodeSent = (String verId, [int forceCodeResend]) {
        this.verificationId = verId;
        _showRetryButton.value = Otp.showTimer;
        _controller.forward(from: 0);
      };

      final PhoneVerificationCompleted verifiedSuccess =
          (AuthCredential credential) async {
        logIn(credential);
      };

      final PhoneVerificationFailed veriFailed = (AuthException exception) {
        print(exception.message);
        print(exception.code);
        _otpError.value = "Verification Failed";
      };

      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: widget.mobile,
        codeAutoRetrievalTimeout: autoRetrieve,
        codeSent: smsCodeSent,
        timeout: const Duration(seconds: otpTimeout),
        verificationCompleted: verifiedSuccess,
        verificationFailed: veriFailed,
      );
    } catch (e) {
      _otpError.value = ":(, Verification via Phone failed.";
    }
  }

  void failed(BuildContext context) {}

  @override
  Widget build(context) {
    SizeConfig().init(context);
    return Scaffold(
      body: SafeArea(
          child: Container(
        height: SizeConfig.screenHeight,
        child: Column(
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(top: 70),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          'Mobile Verification',
                          style: TextStyle(
                            color: Colors.teal,
                            fontSize: 30,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      StreamBuilder<bool>(
                        stream: KeyboardVisibility.onChange,
                        builder: (_, keyboardOn) {
                          if (keyboardOn == null || keyboardOn.data == true) {
                            return Container();
                          } else {
                            return Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 20),
                              child: Image.asset('assets/img/mobile.png'),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Column(
              children: <Widget>[
                waitingMessage(),
                otpField(),
                nextButton(),
              ],
            ),
          ],
        ),
      )),
    );
  }

  void otpMatch() {
    _showLoader();
    AuthCredential credential = PhoneAuthProvider.getCredential(
      verificationId: this.verificationId,
      smsCode: otpController.text,
    );
    logIn(credential);
  }

  String autoFillAutoOtp(AuthCredential credential) {
    try {
      String credentialString = credential.toString();

      var regex = RegExp(r"\d{6}");
      var res = regex.firstMatch(credentialString);
      if (res == null) {
        return "";
      }
      return res.group(0);
    } catch (e) {
      return "";
    }
  }

  Future<void> _showLoader() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            content: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircularProgressIndicator(),
                SizedBox(
                  width: 40,
                ),
                Text("Verifying"),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget waitingMessage() {
    return Column(
      children: <Widget>[
        Container(
          constraints: const BoxConstraints(maxWidth: 500),
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(children: <TextSpan>[
              TextSpan(
                text: 'Waiting to automatically detect an SMS sent to ',
                style: TextStyle(color: Colors.black),
              ),
              TextSpan(
                text: widget.mobile,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ]),
          ),
        ),
        Container(
          height: SizeConfig.blockSizeVertical * 10,
          padding: EdgeInsets.all(10),
          child: ValueListenableBuilder(
            valueListenable: _showRetryButton,
            builder: (BuildContext context, int snapshot, Widget child) {
              if (snapshot == Otp.showRetryButton) {
                return RaisedButton(
                  onPressed: () => verifyPhone(context),
                  child: Text("Resend OTP"),
                );
              } else if (snapshot == Otp.showTimer) {
                return Countdown(
                  animation: new StepTween(
                    begin: otpTimeout,
                    end: 0,
                  ).animate(_controller),
                );
              }
              return Container(
                child: Padding(
                  padding: EdgeInsets.all(0),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget otpField() {
    return Container(
      height: 40,
      constraints: BoxConstraints(maxWidth: 500),
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10,
      ),
      child: ValueListenableBuilder(
        valueListenable: _otpError,
        builder: (BuildContext context, String error, Widget child) {
          return TextField(
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(10),
              counterText: "",
              hintText: "Enter 6-digit code",
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(3),
                ),
                borderSide: BorderSide(
                  color: primaryColor,
                  width: 1.0,
                ),
              ),
              errorText: error.length == 0 ? null : error,
            ),
            inputFormatters: <TextInputFormatter>[
              WhitelistingTextInputFormatter.digitsOnly,
            ],
            controller: otpController,
            maxLength: 6,
            maxLengthEnforced: true,
            maxLines: 1,
            keyboardType: TextInputType.number,
            onChanged: (newVal) {
              if (newVal.length < 6) {
                _otpError.value = "Please enter the 6 digit OTP";
              } else {
                _otpError.value = "";
              }
            },
          );
        },
      ),
    );
  }

  Widget nextButton() {
    return ValueListenableBuilder(
      valueListenable: _otpError,
      builder: (BuildContext context, String error, Widget child) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          constraints: BoxConstraints(maxWidth: 500),
          child: RaisedButton(
            onPressed: (error.length != 0 || otpController.text.length != 6)
                ? null
                : otpMatch,
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
                  Text(
                    'Next',
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
          ),
        );
      },
    );
  }
}
