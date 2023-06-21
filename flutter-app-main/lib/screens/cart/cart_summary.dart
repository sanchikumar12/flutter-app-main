import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocapp/const/color_const.dart';
import 'package:grocapp/const/size.dart';
import 'package:grocapp/const/size_config.dart';
import 'package:grocapp/const/text_style.dart';
import 'package:grocapp/models/delivery.dart';
import 'package:grocapp/models/order_model.dart';
import 'package:grocapp/models/product_model.dart';
import 'package:grocapp/screens/auth/auth_provider.dart';
import 'package:grocapp/screens/cart/widgets/default_address.dart';
import 'package:grocapp/screens/payment/cod.dart';
import 'package:grocapp/screens/payment/pe_paytm.dart';
import 'package:grocapp/utils/Rand.dart';
import 'package:grocapp/utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

enum Payment { COD, PAYTM }

class CartSummary extends StatefulWidget {
  final double totalPrice;
  final double totalMrp;
  final List<CartModel> items;
  final Delivery delivery;

  const CartSummary({
    Key key,
    @required this.totalMrp,
    @required this.totalPrice,
    @required this.items,
    @required this.delivery,
  }) : super(key: key);
  @override
  _CartSummaryState createState() => _CartSummaryState();
}

class _CartSummaryState extends State<CartSummary> {
  final Map<Payment, dynamic> _paymentTypeData = {
    Payment.COD: {"title": "COD", "type": "COD", "str": "Cash On Delivery"},
    Payment.PAYTM: {
      "title": "Online",
      "type": "PAYTM Gateway",
      "str":
          "Pay using UPI, Debit/ Credit Cards, Net Banking, Paytm Wallet via PayTM Gateway"
    },
  };
  ValueNotifier _payment = ValueNotifier<Payment>(null);

  AuthProvider authProvider;
  double _finalAmount;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _finalAmount = widget.delivery.charges + widget.totalPrice;
    super.initState();
  }

  @override
  void dispose() {
    _payment.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    authProvider = Provider.of(context);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Order Summary"),
      ),
      body: ConnectivityWidgetWrapper(
        disableInteraction: true,
        message: "No Internet Connection",
        child: Container(
            color: Colors.grey[100],
            height: SizeConfig.screenHeight,
            child: Stack(
              children: <Widget>[
                _body(),
                Positioned(
                  bottom: 0,
                  child: SizedBox(
                    height: SizeConfig.screenHeight * 0.1,
                    width: SizeConfig.screenWidth,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        side: BorderSide(color: primaryColor),
                      ),
                      elevation: 10,
                      color: Colors.white,
                      onPressed: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          _checkoutPriceWidget(),
                          _proceedButton()
                        ],
                      ),
                    ),
                  ),
                )
              ],
            )),
      ),
    );
  }

  Widget _checkoutPriceWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text(
          'Payable Amount',
          style: TextStyle(color: Colors.grey, fontSize: 18),
        ),
        Text(
          '₹$_finalAmount',
          style: checkOutPriceText,
        )
      ],
    );
  }

  Widget _proceedButton() {
    return RaisedButton(
        onPressed: () {
          if (_payment.value == null) {
            _scaffoldKey.currentState.hideCurrentSnackBar();
            _scaffoldKey.currentState.showSnackBar(
              SnackBar(
                content: Text("Please select a Payment Mode"),
                behavior: SnackBarBehavior.floating,
              ),
            );
            return;
          } else {
            final order = getOrder();
            if (_payment.value == Payment.COD) {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => Cod(order)),
              );
            } else {
              PePaytm pePaytm = PePaytm(
                paymentURL:
                    'https://us-central1-grocapp-f4eb9.cloudfunctions.net/customFunctions/payment',
              );

              pePaytm.makePayment(
                context,
                order: order,
              );
            }
          }
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
                'Place Order',
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
        ));
  }

  _body() {
    return ListView(
      children: <Widget>[
        SizedBox(
          height: 8,
        ),
        _paymentTypeSelector(),
        _note(),
        Container(
          padding: EdgeInsets.only(top: 2),
          width: double.infinity,
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.blockSizeHorizontal * 3, vertical: 5),
            child: Text(
              "Address",
              style: orderSummaryTitleText,
            ),
          ),
        ),
        addressCart(false, widget.delivery.address),
        SizedBox(
          height: 8,
        ),
        basket(),
        SizedBox(
          height: 8,
        ),
        payment(),
        SizedBox(
          height: SizeConfig.screenHeight * 0.12,
        ),
      ],
    );
  }

  _note() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5),
      color: Colors.blue[50],
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 8,
          ),
          Icon(
            Icons.info_outline,
            color: Colors.blue,
          ),
          SizedBox(
            width: 8,
          ),
          Flexible(
              child: Text(
            'Please verify carefully the below details',
            style: TextStyle(color: Colors.grey),
          )),
          SizedBox(
            width: 8,
          ),
        ],
      ),
    );
  }

  basket() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.blockSizeHorizontal * 3,
      ),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 8,
          ),
          Text(
            'Basket',
            style: orderSummaryTitleText,
          ),
          SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Flexible(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Expected Delivery',
                      style: TextStyle(color: Colors.grey)),
                  SizedBox(
                    height: 5,
                  ),
                  widget.delivery.type == "Special Delivery"
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                                '${DateFormat.yMMMd().format(DateTime.fromMillisecondsSinceEpoch(widget.delivery.deliveryTime))}',
                                style: GoogleFonts.lato(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700)),
                            SizedBox(
                              height: 3,
                            ),
                            Text(
                                '${DateFormat.Hm().format(DateTime.fromMillisecondsSinceEpoch(widget.delivery.deliveryTime))}',
                                style: GoogleFonts.lato(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700)),
                          ],
                        )
                      : (widget.delivery.type == "Standard Delivery"
                          ? Text(
                              '${DateFormat.yMMMd().format(DateTime.fromMillisecondsSinceEpoch(widget.delivery.deliveryTime))}',
                              style: GoogleFonts.lato(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700),
                            )
                          : Text('To Be Updated'))
                ],
              )),
              SizedBox(
                width: 8,
              ),
              Flexible(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(
                    'Total (${widget.items.length} items)',
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    '₹ ${priceText(widget.totalPrice)}',
                    style: GoogleFonts.lato(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w700),
                  )
                ],
              ))
            ],
          ),
          SizedBox(
            height: 8,
          ),
          Divider(
            thickness: 2,
          ),
          SizedBox(
            height: 8,
          ),
          ListView.separated(
              separatorBuilder: (context, int) {
                return Divider();
              },
              shrinkWrap: true,
              physics: ScrollPhysics(),
              itemCount: widget.items.length,
              itemBuilder: (BuildContext context, int index) {
                return Row(children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Container(
                      decoration: BoxDecoration(),
                      child: CachedNetworkImage(
                        fit: BoxFit.contain,
                        imageUrl: widget.items[index].productImage,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    flex: 2,
                    child:
                        Center(child: _descriptionWidgets(widget.items[index])),
                  ),
                  SizedBox()
                ]);
              }),
          SizedBox(
            height: 8,
          )
        ],
      ),
    );
  }

  Column _descriptionWidgets(CartModel item) {
    List<Widget> widgets = [
      Text(
        item.productName,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.left,
      ),
      SizedBox(
        height: 5,
      ),
      Text(
        item.productVariety.size,
        style: TextStyle(
          color: Colors.blueGrey[300],
        ),
        textAlign: TextAlign.left,
      ),
      SizedBox(
        height: 5,
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5), color: prodSpColor),
                child: Text(
                  '₹ ${item.productVariety.sp * item.count} ',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              item.productVariety.mrp != item.productVariety.sp
                  ? Text(
                      '₹ ${item.productVariety.mrp * item.count}',
                      style: TextStyle(
                          color: prodMrpColor,
                          decoration: TextDecoration.lineThrough),
                      textAlign: TextAlign.left,
                    )
                  : SizedBox(),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          item.productVariety.mrp != item.productVariety.sp
              ? Text(
                  '₹ ${priceText(item.productVariety.discount * item.count)} Off',
                  style: TextStyle(
                    color: prodDiscountColor,
                  ),
                  textAlign: TextAlign.left,
                )
              : SizedBox(),
          SizedBox(
            height: 5,
          ),
          Text('Qty : ${item.count}'),
        ],
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: widgets,
    );
  }

  payment() {
    return Container(
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.blockSizeHorizontal * 3,
        ),
        color: Colors.white,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 8,
              ),
              Text(
                'Payment Details',
                style: orderSummaryTitleText,
              ),
              SizedBox(
                height: 12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Flexible(
                      child: Text('MRP Total',
                          style: TextStyle(color: Colors.grey))),
                  SizedBox(
                    width: 8,
                  ),
                  Flexible(
                    child: Text(
                      '₹ ${widget.totalMrp}',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                ],
              ),
              Divider(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Flexible(
                      child: Text('Discount',
                          style: TextStyle(color: Colors.grey))),
                  SizedBox(
                    width: 8,
                  ),
                  Flexible(
                    child: Text(
                      '₹ -${priceText(widget.totalMrp - widget.totalPrice)}',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                ],
              ),
              Divider(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Flexible(
                      child: Text('${widget.delivery.type}',
                          style: TextStyle(color: Colors.grey))),
                  SizedBox(
                    width: 8,
                  ),
                  Flexible(
                    child: Text(
                      '₹ +${widget.delivery.charges}',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                ],
              ),
              Divider(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Flexible(
                      child: Text('Total Amount',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 18))),
                  SizedBox(
                    width: 8,
                  ),
                  Flexible(
                    child: Text(
                      '₹ $_finalAmount',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 18),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 15,
              ),
            ]));
  }

  Widget _paymentTypeSelector() {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.blockSizeHorizontal * 3, vertical: 10),
      color: Colors.white,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Payment Mode',
              style: orderSummaryTitleText,
            ),
            SizedBox(
              height: 12,
            ),
            ValueListenableBuilder(
              valueListenable: _payment,
              builder: (context, value, child) {
                return Container(
                  color: checkoutBodyContentColor,
                  child: Column(
                    children: <Widget>[
                      AbsorbPointer(
                        absorbing: widget.delivery.type == "Special Delivery"
                            ? true
                            : false,
                        ignoringSemantics: true,
                        child: CheckboxListTile(
                          title: Text(_paymentTypeData[Payment.COD]["title"]),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(_paymentTypeData[Payment.COD]["str"]),
                              widget.delivery.type == "Special Delivery"
                                  ? Text(
                                      "Unavailable for Special Delivery",
                                      style: TextStyle(
                                          color: Colors.deepOrange[100]),
                                    )
                                  : Text(''),
                            ],
                          ),
                          activeColor: accentColor,
                          value: value == Payment.COD,
                          onChanged: (_) => _payment.value = Payment.COD,
                        ),
                      ),
                      CheckboxListTile(
                        title: Text(_paymentTypeData[Payment.PAYTM]["title"]),
                        subtitle: Text(_paymentTypeData[Payment.PAYTM]["str"]),
                        activeColor: accentColor,
                        value: value == Payment.PAYTM,
                        onChanged: (_) => _payment.value = Payment.PAYTM,
                      ),
                    ],
                  ),
                );
              },
            ),
          ]),
    );
  }

  OrderModel getOrder() {
    String orderId = Timestamp.now().millisecondsSinceEpoch.toString();
    int replaceIdLen = 3;
    orderId = orderId.substring(0, orderId.length - replaceIdLen) +
        Rand.generate(replaceIdLen);
    var order = OrderModel(
      orderId: orderId,
      orderedAt: Timestamp.now().millisecondsSinceEpoch,
      user: authProvider.user.uid,
      orderStatus: "Processing",
      orderItems: widget.items,
      payment: {
        "type": _paymentTypeData[_payment.value]["type"],
        "details": null, //populated during paytm payment
      },
      delivery: widget.delivery,
      deliveredTime: 0,
      userResponse: {
        "cancelRequested": 0,
        "returnRequested": 0,
      },
      statusCode: 1,
      phoneNumber: authProvider.user.phoneNumber,
      email: null,
      amount: _finalAmount.toString(),
    );
    return order;
  }
}
