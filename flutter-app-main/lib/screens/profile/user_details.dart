import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_user_stream/firebase_user_stream.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grocapp/const/login_state.dart';
import 'package:grocapp/const/route_constants.dart';
import 'package:grocapp/models/user.dart';
import 'package:grocapp/screens/auth/auth_provider.dart';
import 'package:provider/provider.dart';

class UserDetails extends StatefulWidget {
  final int flow;
  const UserDetails({Key key, @required this.flow}) : super(key: key);
  @override
  _UserDetailsState createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  AuthProvider authProvider;
  FocusNode _nameFocus = FocusNode();
  FocusNode _emailFocus = FocusNode();
  FocusNode _addressFocus = FocusNode();

  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  //TextEditingController _addressController = TextEditingController();

  ValueNotifier<int> loginState = ValueNotifier(LoginState.waiting);
  ValueNotifier<bool> updatingData = ValueNotifier(false);
  //ValueNotifier<String> selectedCity = ValueNotifier("");

  UserBasic _fetchedData, _newData;

  double _width, _height;

  FirebaseUser currentUser;

  var _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    init();
    super.initState();
  }

  void init() async {
    currentUser = await FirebaseAuth.instance.currentUser();

    if (widget.flow == 1) {
      _fetchedData = UserBasic('', '', currentUser.phoneNumber);
      _newData = UserBasic('', '', currentUser.phoneNumber);
    } else {
      await _fetchFormData();
    }
    loginState.value = LoginState.loggedIn;
  }

  Future<void> _fetchFormData() async {
    DocumentSnapshot snapshot = await Firestore.instance
        .collection("users")
        .document(currentUser.uid)
        .get();
    _fetchedData = UserBasic(
        snapshot.data["name"] ?? '',
        snapshot.data["email"] ?? '',
        snapshot.data["phone"] ?? currentUser.phoneNumber);

    _newData = UserBasic(
        snapshot.data["name"], snapshot.data["email"], snapshot.data["phone"]);

    //selectedCity.value = _fetchedData.city;
    _nameController.text = _fetchedData.name;
    _emailController.text = _fetchedData.email;
    //_addressController.text = _fetchedData.address;
  }

  @override
  void dispose() {
    _nameFocus.dispose();
    _emailFocus.dispose();
    _addressFocus.dispose();

    _nameController.dispose();
    _emailController.dispose();
    // _addressFocus.dispose();

    //selectedCity.dispose();
    updatingData.dispose();
    loginState.dispose();

    super.dispose();
  }

  final formKey = GlobalKey<FormState>();

  Widget loader() {
    return Center(child: CircularProgressIndicator());
  }

  Widget getForm(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: _width * 0.10,
          right: _width * 0.10,
        ),
        child: Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              SizedBox(height: 20),
              nameField(context),
              SizedBox(height: 20),
              email(context),
              SizedBox(height: 20),
              // citySelector(context),
              // SizedBox(height: 20),
              // addressField(context),
            ],
          ),
        ),
      ),
    );
  }

  TextFormField nameField(BuildContext context) {
    return TextFormField(
      controller: _nameController,
      inputFormatters: [LengthLimitingTextInputFormatter(30)],
      keyboardType: TextInputType.text,
      style: TextStyle(color: Colors.deepPurple),
      textInputAction: TextInputAction.next,
      focusNode: _nameFocus,
      onFieldSubmitted: (value) {
        FocusScope.of(context).requestFocus(_emailFocus);
      },
      decoration: InputDecoration(
        hintText: "Your Name",
        labelText: "Name",
        // border: OutlineInputBorder(
        //   borderRadius: BorderRadius.circular(3),
        //   borderSide: BorderSide(),
        // ),
      ),
      validator: (value) {
        if (value.length > 2) {
          return null;
        } else {
          return 'Please Enter Valid Name';
        }
      },
      onSaved: (value) {
        _newData.name = value;
      },
    );
  }

  TextFormField email(BuildContext context) {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.done,
      style: TextStyle(color: Colors.deepPurple),
      focusNode: _emailFocus,
      onFieldSubmitted: (value) {
        FocusScope.of(context).requestFocus(_emailFocus);
      },
      decoration: InputDecoration(
        hintText: "abc@pqr.xyz",
        labelText: "Email Address",
      ),
      onSaved: (value) {
        _newData.email = value;
      },
      validator: validateEmail,
    );
  }

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      return null;
  }

  @override
  Widget build(BuildContext context) {
    authProvider = Provider.of(context);
    _width = MediaQuery.of(context).size.width;
    _height = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () async {
        if (updatingData.value) {
          _scaffoldKey.currentState.hideCurrentSnackBar();
          _scaffoldKey.currentState.showSnackBar(
            SnackBar(
              content:
                  Text("Please wait a moment before we update your request."),
            ),
          );
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Text("Profile"),
          centerTitle: true,
        ),
        body: ValueListenableBuilder(
          valueListenable: loginState,
          builder: (BuildContext context, int currentState, Widget child) {
            if (currentState == LoginState.loggedIn) {
              return getForm(context);
            } else {
              return loader();
            }
          },
        ),
        floatingActionButton: _updateButton(context),
      ),
    );
  }

  Widget _updateButton(context) {
    return ValueListenableBuilder(
      valueListenable: updatingData,
      builder: (BuildContext context, bool updating, Widget child) {
        return FloatingActionButton.extended(
          icon: Icon(updating ? Icons.autorenew : Icons.save),
          onPressed: updating
              ? null
              : () async {
                  //gets rid of the keyboard
                  FocusScopeNode currentFocus = FocusScope.of(context);
                  currentFocus.unfocus();

                  if (formKey.currentState.validate()) {
                    formKey.currentState.save();
                    String feedback;
                    print(_fetchedData == _newData);
                    if (_fetchedData != _newData) {
                      updatingData.value = true;
                      feedback = await pushData();
                      _fetchedData = UserBasic(
                          _newData.name, _newData.email, _newData.phone);
                      updatingData.value = false;
                    } else {
                      feedback = "Nothing to update";
                    }
                    Scaffold.of(context).showSnackBar(
                      SnackBar(
                        content: Text(feedback),
                      ),
                    );
                    if (feedback == "Profile Updated successfully" &&
                        widget.flow == 1) {
                      Navigator.pushReplacementNamed(context, HomeRoute);
                    }

                    // Navigator.of(context).pop();
                  }
                },
          label: Text(updating ? "Updating.." : "Update"),
        );
      },
    );
  }

  Future<String> pushData() async {
    DocumentReference data =
        Firestore.instance.collection("users").document(currentUser.uid);

    try {
      if (widget.flow == 1) {
        await data.setData(_newData.map);
      } else {
        await data.updateData(_newData.map);
      }
      var userUpdateInfo = UserUpdateInfo();
      userUpdateInfo.displayName = _newData.name;
      await authProvider.user.updateProfile(userUpdateInfo);
      await FirebaseUserReloader.reloadCurrentUser();
    } catch (e) {
      print(e);
      return "Something went wrong";
    }
    return "Profile Updated successfully";
  }
}
