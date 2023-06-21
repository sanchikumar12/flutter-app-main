import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:grocapp/const/color_const.dart';
import 'package:grocapp/const/route_constants.dart';
import 'package:grocapp/const/size.dart';
import 'package:grocapp/const/size_config.dart';
import 'package:grocapp/const/text_style.dart';
import 'package:grocapp/models/delivery.dart';
import 'package:grocapp/models/delivery_types.dart';
import 'package:grocapp/models/product_model.dart';
import 'package:grocapp/models/user.dart';
import 'package:grocapp/screens/cart/widgets/default_address.dart';
import 'package:grocapp/screens/auth/auth_provider.dart';
import 'package:grocapp/screens/cart/widgets/min_order_msg.dart';
import 'package:grocapp/screens/config/delivery_type_config.dart';
import 'package:grocapp/screens/config/minimum_order_config.dart';
import 'package:grocapp/widgets/loader.dart';

import 'package:provider/provider.dart';

import 'beautiful_date.dart';

// enum DeliveryType { NONE, STANDARD, EXPRESS, SPECIAL }

class Cart2 extends StatefulWidget {
  final double totalPrice;
  final double totalMrp;
  final List<CartModel> items;
  const Cart2(
      {Key key,
      @required this.totalMrp,
      @required this.totalPrice,
      @required this.items})
      : super(key: key);

  @override
  Cart2State createState() => Cart2State();
}

class Cart2State extends State<Cart2> {
  UserAddress _userAddress;
  AuthProvider authProvider;
  DeliveryTypeProvider deliveryTypeConf;
  MinimumOrderProvider minOrderConf;
  bool extraCharge;

  Firestore firestore = Firestore.instance;
  ValueNotifier<DeliveryTypes> _delivery =
      ValueNotifier<DeliveryTypes>(DeliveryTypes.none());
  ValueNotifier<bool> dateRebuild = ValueNotifier(false);
  DateTime deliveryTime;

  @override
  void dispose() {
    _delivery.dispose();
    super.dispose();
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    authProvider = Provider.of<AuthProvider>(context);
    minOrderConf = Provider.of<MinimumOrderProvider>(context);
    deliveryTypeConf = Provider.of<DeliveryTypeProvider>(context);
    extraCharge = widget.totalPrice < minOrderConf.minimumOrder;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Checkout"),
      ),
      body: ConnectivityWidgetWrapper(
        disableInteraction: true,
        message: "No Internet Connection",
        child: Container(
            color: Colors.white,
            height: SizeConfig.screenHeight,
            child: Column(
              children: <Widget>[
                _body(),
                minimumOrderMessage(
                    asterisk: true,
                    minOrder: minOrderConf.minimumOrder,
                    totalPrice: widget.totalPrice),
                SizedBox(
                  height: SizeConfig.screenHeight * 0.1,
                  width: SizeConfig.screenWidth,
                  child: Material(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      side: BorderSide(color: primaryColor),
                    ),
                    elevation: 10,
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        _checkoutPriceWidget(),
                        SizedBox(),
                        _proceedButton()
                      ],
                    ),
                  ),
                )
              ],
            )),
      ),
    );
  }

  Widget _checkoutPriceWidget() {
    return ValueListenableBuilder<DeliveryTypes>(
        valueListenable: _delivery,
        builder: (context, value, child) {
          double totalPayPrice = widget.totalPrice;

          List<Widget> col = [];

          // price breakdown text
          if (_delivery.value.type != DeliveryTypes.NONE) {
            List<Widget> row2 = [];
            col.add(Row(children: row2));

            var totalPriceDesc = _descText("₹${widget.totalPrice}");
            row2.add(totalPriceDesc);

            if (value.charge > 0) {
              totalPayPrice += value.charge;
              row2.add(
                  _descText(" + ₹${value.charge} (${value.type} delivery)"));
            }
            if (extraCharge) {
              totalPayPrice += minOrderConf.extraCharge;
              if (row2.length <= 1) {
                row2.add(
                    _descText(" + ₹${minOrderConf.extraCharge} (delivery)"));
              } else {
                col.add(_descText("+ ₹${minOrderConf.extraCharge} (delivery)"));
              }
            }
          }

          List<Widget> row1 = [
            Text(
              '₹$totalPayPrice',
              style: checkOutPriceText,
            ),
          ];

          col.insert(0, Row(children: row1));

          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: col,
          );
        });
  }

  Text _descText(String s) {
    return Text(
      s,
      style: TextStyle(color: Colors.black45),
    );
  }

  void showSnack(String message) {
    _scaffoldKey.currentState.hideCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(message),
      ),
    );
  }

  Widget _proceedButton() {
    return RaisedButton(
      onPressed: () {
        if (_delivery.value.type == DeliveryTypes.NONE) {
          return showSnack("Please Select a Delivery Type");
        }
        if (_delivery.value.type == DeliveryTypes.SPECIAL) {
          if (deliveryTime == null) {
            return showSnack(
                "Please select the time of delivery for Special Delivery");
          }
        }
        if (_userAddress == null) {
          return showSnack("You haven't selected a delivery address");
        }
        DateTime time = DateTime.now().add(Duration(days: 1));

        int _deliveryTime = DateTime(
          time.year,
          time.month,
          time.day,
          11,
          00,
        ).millisecondsSinceEpoch;
        if (_delivery.value.type == "Special") {
          _deliveryTime = deliveryTime.millisecondsSinceEpoch;
        }

        Navigator.of(context).pushNamed(
          CartSummaryRoute,
          arguments: [
            widget.totalMrp,
            widget.totalPrice,
            widget.items,
            Delivery(
              charges: _delivery.value.charge +
                  (extraCharge ? minOrderConf.extraCharge : 0),
              address: _userAddress,
              type: _delivery.value.type + " delivery",
              deliveryTime: _deliveryTime,
            ),
          ],
        );
      },
      color: accentColor,
      splashColor: Colors.white30,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusDirectional.circular(8),
        // side: BorderSide(color: ),
      ),
      child: FittedBox(
        fit: BoxFit.fitWidth,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              'Checkout',
              style: TextStyle(fontSize: subscribeSize, color: Colors.white),
            ),
            SizedBox(
              width: 5,
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
              size: subscribeSize,
            )
          ],
        ),
      ),
    );
  }

  Widget _body() {
    return Expanded(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            top: SizeConfig.blockSizeVertical * 1,
            // left: SizeConfig.blockSizeHorizontal * 3,
            // right: SizeConfig.blockSizeHorizontal * 3,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 8,
              ),
              Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.blockSizeHorizontal * 3,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Delivery Type",
                      style: orderSummaryTitleText,
                    ),
                    _deliveryTypeSelector()
                  ],
                ),
              ),
              Container(
                height: 10,
                color: Colors.grey[200],
              ),
              Container(
                color: Colors.white,
                padding: EdgeInsets.only(
                    left: SizeConfig.blockSizeHorizontal * 3,
                    right: SizeConfig.blockSizeHorizontal * 3,
                    bottom: SizeConfig.blockSizeHorizontal * 3,
                    top: SizeConfig.blockSizeHorizontal * 3),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Address",
                      style: orderSummaryTitleText,
                    ),
                    _addressSelector(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // Standard, Express, Special
  Widget _deliveryTypeSelector() {
    return ValueListenableBuilder<DeliveryTypes>(
      valueListenable: _delivery,
      builder: (context, value, child) {
        List<Widget> deliveryTypeList = [];

        if (deliveryTypeConf.isLoading) {
          return loader();
        }

        deliveryTypeConf.deliveryTypes.forEach((e) {
          if (e.enabled) {
            deliveryTypeList.add(_deliveryTypeListItem(value == e, e));
          }
        });

        if (deliveryTypeList.isEmpty) {
          deliveryTypeList.add(Container(
              child: Text(
            "Sorry, currently we're not accepting orders.",
            style: detDescText,
          )));
        }

        return Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          color: checkoutBodyContentColor,
          child: Column(children: deliveryTypeList),
        );
      },
    );
  }

  Widget _deliveryTypeListItem(bool checked, DeliveryTypes deliveryType) {
    List<Widget> subtitle = [Text(deliveryType.message)];
    if (deliveryType.type == DeliveryTypes.SPECIAL && checked) {
      subtitle.add(_deliveryTimePicker());
    }
    return Container(
      color: Colors.white,
      child: CheckboxListTile(
        secondary: Container(
          height: 45,
          width: 45,
          decoration: new BoxDecoration(
            color: Colors.deepOrange[300],
            shape: BoxShape.circle,
          ),
          child: Center(
              child: Text(
            '₹ ${(deliveryType.charge + (extraCharge ? minOrderConf.extraCharge : 0)).floor()}',
            overflow: TextOverflow.fade,
            style: TextStyle(color: Colors.white),
          )),
        ),
        title: Text(deliveryType.type),
        isThreeLine: true,
        subtitle: Column(children: subtitle),
        activeColor: accentColor,
        value: checked,
        onChanged: (_) {
          if (_) _delivery.value = deliveryType;
        },
      ),
    );
  }

  Widget _addressSelector() {
    return StreamBuilder(
      stream: Firestore.instance
          .collection('users')
          .document(authProvider.user.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data['address'] == null ||
              snapshot.data['address'].length == 0) {
            return ListTile(
              title: Center(
                  child: Text("You haven't selected/added any locations.")),
              subtitle: Center(child: Text('Tap here to add location')),
              onTap: () => Navigator.pushNamed(context, ProfileAddressRoute,
                  arguments: "Select Address"),
            );
          }

          _userAddress = UserAddress.fromMap(
              snapshot.data['address'][snapshot.data['defAddr']]);
          return Material(
            color: Colors.white,
            child: InkWell(
                onTap: () => Navigator.pushNamed(context, ProfileAddressRoute,
                    arguments: "Select Address"),
                child: addressCart(true, _userAddress)),
          );
        } else {
          return Center(
            child: loader(),
          );
        }
      },
    );
  }

  Widget _deliveryTimePicker() {
    return Row(
      children: <Widget>[
        Icon(Icons.access_time),
        MaterialButton(
          onPressed: () {
            getTime();
          },
          child: ValueListenableBuilder(
            valueListenable: dateRebuild,
            builder: (context, date, child) {
              if (deliveryTime == null) {
                return Text('Select Delivery Time');
              }
              return Text(
                beautifulDateOnly(deliveryTime),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              );
            },
          ),
        )
      ],
    );
  }

  void getTime() {
    // earliest possible order
    var now = DateTime.now();
    var epo = now.add(Duration(hours: 12));

    // go next day
    if (now.hour >= 12) {
      epo = DateTime(now.year, now.month, now.day + 1, 12);
    }

    DatePicker.showDateTimePicker(
      context,
      showTitleActions: true,
      minTime: epo,
      theme: DatePickerTheme(
        backgroundColor: Colors.grey[200],
      ),
      maxTime: epo.add(
        Duration(days: 7),
      ),
      onConfirm: (date) {
        if (date.day != epo.day) {
          date = date.add(Duration(hours: 6));
        }
        if (date.hour < 6) {
          return showSnack("We can't deliver between Midnight and 6AM");
        }
        deliveryTime = date;
        dateRebuild.value = !dateRebuild.value;
      },
      onCancel: () => deliveryTime = null,
      currentTime: epo,
      locale: LocaleType.en,
    );
  }
}
