import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocapp/models/user.dart';
import 'package:grocapp/screens/auth/auth_provider.dart';
import 'package:grocapp/screens/profile/address/add_address.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:grocapp/utils/Dialog.dart';

class MyAddress extends StatefulWidget {
  final String title;
  MyAddress(this.title);
  @override
  _MyAddressState createState() => _MyAddressState();
}

class _MyAddressState extends State<MyAddress> {
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  AuthProvider authProvider;
  bool _show = true;
  int selected;
  List<UserAddress> address;

  @override
  Widget build(BuildContext context) {
    authProvider = Provider.of(context);

    return Scaffold(
        //resizeToAvoidBottomPadding: false, // this avoids the overflow error

        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
          centerTitle: true,
        ),
        body: StreamBuilder(
          stream: Firestore.instance
              .collection('users')
              .document(authProvider.user.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            } else {
              if (snapshot.data['address'] == null ||
                  snapshot.data['address'].length == 0) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'You have no locations saved yet',
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Tap on the location button below to add',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                );
              }
            }
            address = [];
            for (int i = 0; i < snapshot.data['address'].length; i++) {
              address.add(UserAddress.fromMap(snapshot.data['address'][i]));
            }
            selected = snapshot.data['defAddr'];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(children: <Widget>[
                ListView.builder(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    scrollDirection: Axis.vertical,
                    physics: ScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: snapshot.data['address'].length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        child: Card(
                          elevation: 3,
                          color: Colors.grey[200],
                          shape: selected == index
                              ? new RoundedRectangleBorder(
                                  side: new BorderSide(
                                      color: Colors.blue, width: 2.0),
                                  borderRadius: BorderRadius.circular(5.0))
                              : new RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        address[index].name,
                                        textScaleFactor: 1.2,
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      Text(
                                        address[index].lane1,
                                        textScaleFactor: 1.2,
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      Text(
                                        address[index].lane2,
                                        textScaleFactor: 1.2,
                                        maxLines: 2,
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      Text(
                                        address[index].town,
                                        textScaleFactor: 1.2,
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      Text(
                                        address[index].pincode,
                                        textScaleFactor: 1.2,
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      Text(
                                        address[index].phone,
                                        textScaleFactor: 1.2,
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Container(
                                  color: Colors.green[50],
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Radio(
                                        value: index,
                                        activeColor: Colors.blue,
                                        groupValue: selected,
                                        onChanged: _handleRadioValueChange,
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      InkWell(
                                          onTap: () {
                                            showBarModalBottomSheet(
                                              expand: false,
                                              isDismissible: true,
                                              context: context,
                                              builder:
                                                  (context, scrollController) =>
                                                      Material(
                                                child: AddAddress(
                                                    address, index, 1),
                                              ),
                                            );
                                          },
                                          child: Icon(Icons.edit,
                                              color: Colors.blueGrey)),
                                      SizedBox(
                                        height: 25,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          showAlertDialog(
                                              context, address[index], index);
                                        },
                                        child: Icon(
                                          Icons.delete_outline,
                                          color: Colors.redAccent,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 15,
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                SizedBox(
                  height: 60,
                )
              ]),
            );
          },
        ),
        floatingActionButton: MyFloatingButton(authProvider, address));
  }

  void _handleRadioValueChange(value) {
    ProgressDialog.showLoadingDialog(context, _keyLoader);
    setState(() {
      selected = value;
      Firestore.instance
          .collection('users')
          .document(authProvider.user.uid)
          .updateData({
        'defAddr': value,
      }).whenComplete(() =>
              Navigator.of(_keyLoader.currentContext, rootNavigator: true)
                  .pop());
    });
  }

  showAlertDialog(BuildContext context, UserAddress address, int index) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop(); // dismiss dialog
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Continue"),
      onPressed: () {
        Navigator.of(context).pop(); // dismiss dialog

        Firestore.instance
            .collection('users')
            .document(authProvider.user.uid)
            .updateData({
          'address': FieldValue.arrayRemove([address.toMap()])
        });
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Confirm Remove"),
      content: Text("Are you sure you want to remove the saved address?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

class MyFloatingButton extends StatefulWidget {
  final AuthProvider authProvider;
  final List<UserAddress> address;
  MyFloatingButton(this.authProvider, this.address);
  @override
  _MyFloatingButtonState createState() => _MyFloatingButtonState();
}

class _MyFloatingButtonState extends State<MyFloatingButton> {
  bool _show = true;
  @override
  Widget build(BuildContext context) {
    return _show
        ? FloatingActionButton(
            backgroundColor: Colors.white,
            tooltip: 'Add Address',
            child: Icon(
              Icons.add_location,
              color: Colors.blue[700],
              size: 30,
            ),
            onPressed: () {
              showBarModalBottomSheet(
                expand: false,
                isDismissible: true,
                context: context,
                builder: (context, scrollController) => Material(
                  child: AddAddress(widget.address, 0, 0),
                ),
              );
            },
          )
        : Container();
  }

  void _showButton(bool value) {
    setState(() {
      _show = value;
    });
  }
}
