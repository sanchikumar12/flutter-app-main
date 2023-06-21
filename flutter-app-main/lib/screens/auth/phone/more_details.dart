import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_user_stream/firebase_user_stream.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:grocapp/const/color_const.dart';
import 'package:grocapp/const/route_constants.dart';

class MoreDetails extends StatefulWidget {
  final DocumentReference docRef;
  final FirebaseUser user;
  MoreDetails(this.user, this.docRef);

  @override
  _MoreDetailsState createState() => _MoreDetailsState();
}

class _MoreDetailsState extends State<MoreDetails> {
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  FocusNode nameNode = FocusNode();
  FocusNode emailNode = FocusNode();

  ValueNotifier<bool> _nameHasError = ValueNotifier(false);
  ValueNotifier<bool> _emailHasError = ValueNotifier(false);
  @override
  initState() {
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    nameController.dispose();
    _nameHasError.dispose();
    _emailHasError.dispose();
    nameNode.dispose();
    emailNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
          child: Container(
        padding: EdgeInsets.only(top: 30),
        height: height,
        child: Column(
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          'Almost there!',
                          style: TextStyle(
                            color: Colors.teal,
                            fontSize: 30,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            StreamBuilder<bool>(
                              stream: KeyboardVisibility.onChange,
                              builder: (_, keyboardOn) {
                                print(keyboardOn);
                                if (keyboardOn == null ||
                                    keyboardOn.data == true) {
                                  return Container();
                                } else {
                                  return Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 20),
                                    child: Image.asset(
                                        'assets/img/shopping_app.png'),
                                  );
                                }
                              },
                            ),
                            Container(
                              constraints: const BoxConstraints(maxWidth: 500),
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(children: <TextSpan>[
                                  TextSpan(
                                    text:
                                        'A few more details to get you started.',
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
              ),
            ),
            Column(
              children: <Widget>[
                nameField(),
                emailField(),
                doneButton(),
              ],
            ),
          ],
        ),
      )),
    );
  }

  Widget nameField() {
    return Container(
      height: 40,
      constraints: BoxConstraints(maxWidth: 500),
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10,
      ),
      child: ValueListenableBuilder(
        valueListenable: _nameHasError,
        builder: (BuildContext context, bool hasError, Widget child) {
          return TextFormField(
            focusNode: nameNode,
            onFieldSubmitted: (value) =>
                FocusScope.of(context).requestFocus(emailNode),
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              hintText: "Your Name",
              contentPadding: EdgeInsets.all(10),
              counterText: "",
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(3),
                ),
                borderSide: BorderSide(
                  color: !hasError ? primaryColor : Colors.grey,
                  width: 1.0,
                ),
              ),
              errorText: hasError == true ? "Name is too short" : null,
            ),
            controller: nameController,
            maxLength: 30,
            maxLengthEnforced: true,
            maxLines: 1,
            keyboardType: TextInputType.text,
            onChanged: (newVal) => _nameHasError.value = (newVal.length < 4),
          );
        },
      ),
    );
  }

  Widget emailField() {
    return Container(
      height: 40,
      constraints: BoxConstraints(maxWidth: 500),
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10,
      ),
      child: ValueListenableBuilder(
          valueListenable: _emailHasError,
          builder: (_, emailHasError, __) {
            return TextFormField(
              textInputAction: TextInputAction.done,
              focusNode: emailNode,
              decoration: InputDecoration(
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey,
                  ),
                ),
                hintText: "Your Email(optional)",
                hintStyle: TextStyle(),
                contentPadding: EdgeInsets.all(10),
                counterText: "",
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(3),
                  ),
                  borderSide: BorderSide(color: primaryColor),
                ),
                errorText: emailHasError ? "Enter Valid Email" : null,
              ),
              onChanged: (value) => validateEmail(value),
              controller: emailController,
              maxLines: 1,
              keyboardType: TextInputType.emailAddress,
            );
          }),
    );
  }

  void validateEmail(String value) {
    print("called");
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value)) {
      _emailHasError.value = true;
    } else {
      _emailHasError.value = false;
    }
  }

  void doneFunction() async {
    await Future.delayed(Duration(milliseconds: 500));
    _showLoader();

    widget.docRef.setData({
      "name": nameController.text,
      "email": _emailHasError.value ? "" : emailController.text,
      "phone": widget.user.phoneNumber,
    });
    var userUpdateInfo = UserUpdateInfo();
    userUpdateInfo.displayName = nameController.text;
    await widget.user.updateProfile(userUpdateInfo);
    await FirebaseUserReloader.reloadCurrentUser();
    Navigator.popUntil(context, (route) => route.isFirst);
    Navigator.pushReplacementNamed(context, HomeRoute);
  }

  Widget doneButton() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      constraints: BoxConstraints(maxWidth: 500),
      child: ValueListenableBuilder(
          valueListenable: _nameHasError,
          builder: (_, bool nameHasError, child) {
            return RaisedButton(
              onPressed: (nameHasError || nameController.text.length < 4)
                  ? null
                  : () {
                      FocusScopeNode currentFocus = FocusScope.of(context);
                      currentFocus.unfocus();
                      doneFunction();
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
                    Text(
                      'Done',
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
          }),
    );
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
                Text("Just a second..."),
              ],
            ),
          ),
        );
      },
    );
  }
}
