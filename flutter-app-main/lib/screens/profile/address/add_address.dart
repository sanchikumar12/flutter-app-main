import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grocapp/const/color_const.dart';
import 'package:grocapp/const/string_const.dart';
import 'package:grocapp/models/user.dart';
import 'package:grocapp/screens/auth/auth_provider.dart';
import 'package:grocapp/utils/Dialog.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';
import 'package:provider/provider.dart';

class AddAddress extends StatefulWidget {
  List<UserAddress> address;
  final int index;
  final int type;
  AddAddress(this.address, this.index, this.type);
  @override
  _AddAddressState createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  FocusNode _nameFocus = FocusNode();
  FocusNode _lane1Focus = FocusNode();
  FocusNode _lane2Focus = FocusNode();
  FocusNode _townFocus = FocusNode();
  FocusNode _pincodeFocus = FocusNode();
  FocusNode _phoneFocus = FocusNode();

  TextEditingController _nameController = TextEditingController();
  TextEditingController _lane1Controller = TextEditingController();
  TextEditingController _lane2Controller = TextEditingController();

  TextEditingController _townController = TextEditingController();

  TextEditingController _pincodeController = TextEditingController();

  TextEditingController _phoneController = TextEditingController();

  ValueNotifier<bool> updatingData = ValueNotifier(false);
  ValueNotifier<String> selectedCity = ValueNotifier("");

  UserAddress userAddress = new UserAddress('', '', '', '', '', '');

  //UserBasic _fetchedData, _newData;

  @override
  void initState() {
    if (widget.type == 1) {
      _nameController.text = widget.address[widget.index].name;
      _lane1Controller.text = widget.address[widget.index].lane1;

      _lane2Controller.text = widget.address[widget.index].lane2;

      _townController.text = widget.address[widget.index].town;

      _pincodeController.text = widget.address[widget.index].pincode;

      _phoneController.text = widget.address[widget.index].phone.substring(3);
    }
    super.initState();
  }

  @override
  void dispose() {
    _nameFocus.dispose();
    _lane1Focus.dispose();
    _lane2Focus.dispose();
    _townFocus.dispose();
    _pincodeFocus.dispose();
    _phoneFocus.dispose();

    _nameController.dispose();
    _lane1Controller.dispose();
    _lane2Controller.dispose();
    _townController.dispose();
    _pincodeController.dispose();
    _phoneController.dispose();

    selectedCity.dispose();
    updatingData.dispose();

    super.dispose();
  }

  AuthProvider authProvider;

  final ScrollController _scrollController = ScrollController();

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    authProvider = Provider.of(context);

    //userAddress.town = 'Burla';
    return Material(
      child: KeyboardAvoider(
        autoScroll: true,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Container(
              child: Form(
                key: formKey,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 10),

                    Center(
                      child: Text(
                        widget.type == 0 ? 'Add New Address' : 'Edit Address',
                        style: TextStyle(
                            color: Colors.blue[700],
                            fontSize: 18,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    SizedBox(height: 10),

                    nameField(context),
                    SizedBox(height: 20),
                    lane1Field(context),
                    SizedBox(height: 20),
                    lane2Field(context),
                    SizedBox(height: 20),
                    citySelector(context),
                    SizedBox(height: 20),
                    pincodeField(context),
                    SizedBox(height: 20),
                    phoneField(context),
                    SizedBox(height: 30),
                    Center(
                      child: _updateButton(context),
                    ),
                    SizedBox(height: 30),
                    Center(
                      child: _cancelButton(context),
                    ),

                    // citySelector(context),
                    // SizedBox(height: 20),
                    // addressField(context),
                  ],
                ),
              ),
            ),
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
      style: TextStyle(color: Colors.black),
      textInputAction: TextInputAction.next,
      focusNode: _nameFocus,
      onFieldSubmitted: (value) {
        FocusScope.of(context).requestFocus(_lane1Focus);
      },
      decoration: new InputDecoration(
          prefixIcon: Icon(Icons.person_outline),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: accentColor, width: 2.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 2.0),
          ),
          hintText: 'Abhay Sharma',
          labelText: 'Name'),
      validator: (value) {
        if (value.length >= 2) {
          return null;
        } else {
          return 'Please Enter Valid Name';
        }
      },
      onSaved: (value) {
        userAddress.name = value;
      },
    );
  }

  TextFormField lane1Field(BuildContext context) {
    return TextFormField(
      controller: _lane1Controller,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      style: TextStyle(color: Colors.black),
      focusNode: _lane1Focus,
      onFieldSubmitted: (value) {
        FocusScope.of(context).requestFocus(_lane2Focus);
      },
      inputFormatters: [],
      decoration: new InputDecoration(
          prefixIcon: Icon(Icons.store_mall_directory),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: accentColor, width: 2.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 2.0),
          ),
          hintText: 'C-101',
          labelText: 'Flat / House Number'),
      onSaved: (value) {
        userAddress.lane1 = value;
      },
      validator: (value) {
        if (value.length >= 2) {
          return null;
        } else {
          return 'Please Enter Valid Flat / House Number';
        }
      },
    );
  }

  TextFormField lane2Field(BuildContext context) {
    return TextFormField(
      controller: _lane2Controller,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      style: TextStyle(color: Colors.black),
      focusNode: _lane2Focus,
      onFieldSubmitted: (value) {
        FocusScope.of(context).requestFocus(_townFocus);
      },
      inputFormatters: [],
      decoration: new InputDecoration(
          prefixIcon: Icon(Icons.near_me),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: accentColor, width: 2.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 2.0),
          ),
          hintText: 'Near Hanuman Mandir',
          labelText: 'Street / Landmark'),
      onSaved: (value) {
        userAddress.lane2 = value;
      },
      validator: (value) {
        if (value.length >= 4) {
          return null;
        } else {
          return 'Please Enter Valid Street / Landmark';
        }
      },
    );
  }

  Widget citySelector(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: selectedCity,
        builder: (BuildContext context, String city, Widget child) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 3),
            decoration: new BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(2.0)),
                border: new Border.all(color: Colors.grey, width: 2)),
            child: DropdownButton<String>(
              isExpanded: true,
              value: city == ""
                  ? (widget.address == null
                      ? "Sambalpur"
                      : widget.address[widget.index].town)
                  : city,
              elevation: 16,
              style: TextStyle(color: Colors.black),
              underline: Container(
                height: 1,
                color: Colors.black,
              ),
              hint: Text('Select City'),
              focusNode: _townFocus,
              onChanged: (String newValue) {
                userAddress.town = newValue;
                selectedCity.value = newValue;
                FocusScope.of(context).requestFocus(_pincodeFocus);
              },
              items: cities.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          );
        });
  }

  TextFormField pincodeField(BuildContext context) {
    return TextFormField(
      controller: _pincodeController,
      keyboardType: TextInputType.number,
      maxLength: 6,
      textInputAction: TextInputAction.next,
      style: TextStyle(color: Colors.black),
      focusNode: _pincodeFocus,
      onFieldSubmitted: (value) {
        FocusScope.of(context).requestFocus(_phoneFocus);
      },
      inputFormatters: [],
      decoration: new InputDecoration(
          prefixIcon: Icon(Icons.pin_drop),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: accentColor, width: 2.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 2.0),
          ),
          hintText: '768018',
          labelText: 'Pincode'),
      onSaved: (value) {
        userAddress.pincode = value;
      },
      validator: (value) {
        if (value.length == 6) {
          return null;
        } else {
          return 'Please Enter Valid Pincode';
        }
      },
    );
  }

  TextFormField phoneField(BuildContext context) {
    return TextFormField(
      controller: _phoneController,
      keyboardType: TextInputType.phone,
      maxLength: 10,
      textInputAction: TextInputAction.done,
      style: TextStyle(color: Colors.black),
      focusNode: _phoneFocus,
      onFieldSubmitted: (value) {
        //FocusScope.of(context).requestFocus(_lane2Focus);
      },
      inputFormatters: [],
      decoration: new InputDecoration(
          prefixIcon: Icon(Icons.phone),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: accentColor, width: 2.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 2.0),
          ),
          hintText: '1234567890',
          labelText: 'Phone Number'),
      onSaved: (value) {
        userAddress.phone = '+91' + value;
      },
      validator: (value) {
        if (value.length == 10) {
          return null;
        } else {
          return 'Please Enter Valid Phone Number';
        }
      },
    );
  }

  Widget _updateButton(context) {
    return ValueListenableBuilder(
        valueListenable: updatingData,
        builder: (BuildContext context, bool updating, Widget child) {
          return FloatingActionButton(
            backgroundColor: Colors.white,
            child: Icon(
                updating ? CircularProgressIndicator() : Icons.add_location,
                color: Colors.blue[700]),
            onPressed: updating
                ? null
                : () async {
                    //gets rid of the keyboard
                    FocusScopeNode currentFocus = FocusScope.of(context);
                    currentFocus.unfocus();
                    String feedback;

                    if (formKey.currentState.validate()) {
                      if (userAddress.town.length < 2) {
                        userAddress.town = 'Sambalpur';
                      }
                      ProgressDialog.showLoadingDialog(context, _keyLoader);

                      formKey.currentState.save();
                      if (widget.address != null) {
                        widget.address[widget.index] = userAddress;
                      }
                      feedback = await pushData(widget.address, userAddress,
                          widget.index, widget.type);

                      Future.delayed(Duration(milliseconds: 1000), () {
                        Navigator.of(_keyLoader.currentContext,
                                rootNavigator: false)
                            .pop();
                        Navigator.pop(context);
                      });

                      updatingData.value = false;
                    } else {
                      feedback = "Nothing to update";
                    }
                  },
            // label: Text(
            //   widget.type == 0 ? '' : '',
            //   style: TextStyle(color: Colors.blue[700]),
            // ),
          );
        });
  }

  Future<String> pushData(List<UserAddress> address, UserAddress userAddress,
      int index, int type) async {
    if (type == 0) {
      // if (address.length == 0) {
      // Firestore.instance
      //     .collection('users')
      //     .document(authProvider.user.uid)
      //     .setData({
      //   'address': FieldValue.arrayUnion([userAddress.toMap()])
      // });
      Map<String, dynamic> map = {
        'address': FieldValue.arrayUnion([userAddress.toMap()])
      };
      if (address == null || address.length == 0) map['defAddr'] = 0;

      Firestore.instance
          .collection('users')
          .document(authProvider.user.uid)
          .updateData(map);
    } else {
      List<Map<String, dynamic>> user = List<Map<String, dynamic>>();
      address.forEach((element) {
        user.add(element.toMap());
      });
      Firestore.instance
          .collection('users')
          .document(authProvider.user.uid)
          .updateData({'address': user});
    }
    try {
      // await data.updateData(_newData.map);
    } catch (e) {
      print(e);
      return "Something went wrong";
    }
    return "Profile Updated successfully";
  }

  _cancelButton(BuildContext context) {
    return Container(
      height: 45,
      width: 45,
      child: InkWell(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Center(
          child: Icon(
            Icons.cancel,
            size: 40,
            color: Colors.deepOrange[300],
          ),
        ),
      ),
    );
  }
}
