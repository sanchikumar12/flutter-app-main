import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:miniapp/constants.dart';
import 'package:miniapp/screens/dashboard_screen.dart';
import 'package:miniapp/screens/payment_screen.dart';
import 'package:pinput/pinput.dart';

class PhoneNumberVerification extends StatefulWidget {
  const PhoneNumberVerification({Key? key}) : super(key: key);
  static const routeName = '/phone-number-verification';

  @override
  State<PhoneNumberVerification> createState() =>
      _PhoneNumberVerificationState();
}

class _PhoneNumberVerificationState extends State<PhoneNumberVerification> {
  String phoneNumber = '';
  RequestState submitRequestState = RequestState.idle;
  FirebaseAuth auth = FirebaseAuth.instance;
  String errorString = '';
  bool codeSent = false;
  String verificationId = '';
  int? resendToken;

  @override
  void initState() {
    isLogin=true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verify phone number"),
        automaticallyImplyLeading: false,
      ),
      body: Container(
          padding: kDefaultPadding,
          child: codeSent
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      'Verification',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize:
                      16),
                    ),
                    Container(
                        margin: const EdgeInsets.only(top: 30),
                        child: const Text(
                          'Enter the code sent to the number',
                          style: TextStyle(fontSize: 16),
                        )
                    ),
                    Container(
                        margin: const EdgeInsets.only(top: 30),
                        child: Text(
                          phoneNumber,
                          style: const TextStyle(fontSize: 16),
                        )
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 30),
                      child: Pinput(
                        errorText: errorString.isEmpty ? errorString : null,
                        length: 6,
                        onCompleted: (pin) async {
                          PhoneAuthCredential credential =
                              PhoneAuthProvider.credential(
                                  verificationId: verificationId, smsCode: pin);
                          try {
                            final userCredentials =
                            await auth.signInWithCredential(credential);
                            if (userCredentials.user != null) {
                              _goAhead();
                            }
                          } catch(e) {
                            setState(() {
                              errorString = "Wrong code";
                            });
                          }

                        },
                      ),
                    ),
                    Container(
                        margin: const EdgeInsets.only(top: 30),
                        child: const Text("Didn't receive code?")
                    ),
                    Container(
                        margin: const EdgeInsets.only(top: 30),
                        child: TextButton(
                            onPressed: sendCode,
                            child: const Text('Resend')
                        )
                    )
                  ],
                )
              : Column(
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(top: 40),
                      child: IntlPhoneField(
                        decoration: const InputDecoration(
                          //decoration for Input Field
                          labelText: 'Phone Number',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(),
                          ),
                        ),
                        initialCountryCode: 'IN',
                        onChanged: (phone) {
                          phoneNumber = phone.completeNumber;
                        },
                      ),
                    ),
                    Text(
                      errorString,
                      style: const TextStyle(color: Colors.red),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      //make submit button 100% width
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                          ),
                          textStyle: const TextStyle(
                              fontSize: 18,
                              inherit: true
                          ),
                          minimumSize: const Size(150, 50), // adjust the button size here
                        ),
                        onPressed: submitPhoneNumber,
                        child: submitRequestState == RequestState.pending
                            ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                            : const Text("Submit"),
                      ),
                    )
                  ],
                )),
    );
  }

  void submitPhoneNumber() async {
    setState(() {
      submitRequestState = RequestState.pending;
      errorString = '';
    });
    sendCode();
  }

  void _goAhead() {
    Navigator.of(context).pushNamed(PaymentScreen.routeName);//DashboardScreen.routeName
  }

  void sendCode() {
    auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await auth.signInWithCredential(credential);
          _goAhead();
        },
        verificationFailed: (FirebaseAuthException e) {
          setState(() {
            submitRequestState = RequestState.failed;
            errorString = e.message ?? 'Something went wrong';
          });
        },
        codeSent: (String verificationId, int? resendToken) {
          setState(() {
            codeSent = true;
            this.verificationId = verificationId;
            this.resendToken = resendToken;
            errorString = '';
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
        forceResendingToken: resendToken);
  }
}
