import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocapp/const/color_const.dart';
import 'package:grocapp/const/route_constants.dart';
import 'package:grocapp/const/size.dart';
import 'package:grocapp/const/size_config.dart';
import 'package:grocapp/const/text_style.dart';
import 'package:grocapp/models/product_model.dart';
import 'package:grocapp/screens/algolia/search_page.dart';
import 'package:grocapp/screens/auth/auth_provider.dart';
import 'package:grocapp/screens/cart/cart_provider.dart';
import 'package:grocapp/screens/cart/widgets/min_order_msg.dart';
import 'package:grocapp/screens/config/minimum_order_config.dart';
import 'package:grocapp/utils/utils.dart';

import 'package:grocapp/widgets/loader.dart';
import 'package:provider/provider.dart';

import 'helper.dart';

class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  AuthProvider authProvider;
  MinimumOrderProvider minOrderConfig;
  ValueNotifier<bool> updatingCount = ValueNotifier(false);
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool allItemsAvailable;

  Stream<List<CartModel>> cartStream;

  @override
  void initState() {
    cartStream = context.read<CartProvider>().cartController.stream;
    super.initState();
  }

  @override
  void dispose() {
    updatingCount.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    authProvider = Provider.of<AuthProvider>(context);
    minOrderConfig = Provider.of<MinimumOrderProvider>(context);
    SizeConfig().init(context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: InkWell(
          onTap: () => Navigator.pushReplacementNamed(context, HomeRoute),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              'assets/img/logo.png',
              fit: BoxFit.fill,
              height: 20,
            ),
          ),
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text('Cart'),
        actions: <Widget>[
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchPage()),
              );
            },
            child: Icon(Icons.search),
          ),
          SizedBox(
            width: 15,
          )
        ],
        backgroundColor: appbarColor,
      ),
      body: authProvider.isAuthenticated ? _body() : _noBody(),
    );
  }

  _body() {
    return StreamBuilder<List<CartModel>>(
      stream: cartStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Center(child: loader());
        var items = snapshot.data;
        if (items.length == 0) return _emptyCartWidget();
        List<String> pId = [];
        items.forEach((item) {
          pId.add(item.productId);
        });
        return _cartWidget(items);
      },
    );
  }

  Widget _cartWidget(List<CartModel> items) {
    return FutureProvider<List<ProductModel>>(
      create: (_) {
        return getProducts(items, authProvider.user);
      },
      catchError: (BuildContext ctx, e) {
        print(e.runtimeType);
        print(StackTrace.current);
        return [];
      },
      child: Consumer<List<ProductModel>>(builder: (context, products, _) {
        if (products == null) return loader();

        allItemsAvailable = true;
        // updating cart item prices and marking unavailable items in cart
        for (int i = 0; i < items.length; i++) {
          for (int j = 0; j < products.length; j++) {
            if (items[i].productId == products[j].productId) {
              for (int k = 0; k < products[j].productVariety.length; k++) {
                var element = products[j].productVariety[k];
                if (element.size == items[i].productVariety.size) {
                  items[i].productVariety = element;
                  if (items[i].count * element.fraction <= element.stock) {
                    items[i].available = products[j].active;
                  }
                  break;
                }
              }
              break;
            }
          }
          if (!items[i].available) {
            items[i].productVariety =
                Variety.fromMapOrDefault(items[i].productVariety.map);
          }
          allItemsAvailable &= items[i].available;
        }

        double totalPrice = 0, totalDiscount = 0, totalMrp = 0;
        items.forEach((item) {
          totalPrice += item.productVariety.sp * item.count;
          totalDiscount += item.productVariety.discount * item.count;
        });

        totalMrp = totalDiscount + totalPrice;

        double height = MediaQuery.of(context).size.height;
        if (items.length == 0) return _emptyCartWidget();
        return Column(
          children: [
            _cartItemsList(items, height),
            minimumOrderMessage(
                totalPrice: totalPrice, minOrder: minOrderConfig.minimumOrder),
            SizedBox(
              height: SizeConfig.screenHeight * 0.125,
              width: SizeConfig.screenWidth,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    side: BorderSide(color: primaryColor)),
                elevation: 10,
                color: Colors.grey[100],
                onPressed: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    _checkoutPriceWidget(totalPrice, totalDiscount, totalMrp),
                    _proceedButton(totalPrice, totalMrp, items)
                  ],
                ),
              ),
            )
          ],
        );
      }),
    );
  }

  Expanded _cartItemsList(List<CartModel> items, double height) {
    return Expanded(
      child: Container(
        child: ListView.builder(
          itemCount: items.length,
          shrinkWrap: true,
          itemBuilder: (context, int index) {
            return Container(
              color: !items[index].available ? unavailableItem : null,
              padding: EdgeInsets.symmetric(horizontal: 10),
              height: height * 0.2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Row(children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Container(
                          decoration: BoxDecoration(),
                          child: CachedNetworkImage(
                            fit: BoxFit.fill,
                            imageUrl: items[index].productImage,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        flex: 2,
                        child: Center(child: _descriptionWidgets(items[index])),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      _editCartWidgets(items[index]),
                    ]),
                  ),
                  SizedBox(
                    height: 5,
                    child: Divider(),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // ************
  // *  row1    *
  // *  row2    *
  // ************
  Widget _checkoutPriceWidget(
    double totalPrice,
    double totalDiscount,
    double totalMrp,
  ) {
    bool extraCharge = totalPrice < minOrderConfig.minimumOrder;
    if (minOrderConfig.extraCharge == null) {
      extraCharge = false;
    }
    List<Widget> col = [];

    List<Widget> row1 = [
      Text(
        '₹ $totalPrice',
        style: GoogleFonts.roboto(
            fontSize: 20, color: Colors.indigo, fontWeight: FontWeight.w700),
      ),
    ];

    if (extraCharge) {
      row1.add(Text(
        ' + ₹ ${minOrderConfig.extraCharge} delivery',
        style: GoogleFonts.roboto(
            fontSize: 14, color: Colors.indigo, fontWeight: FontWeight.w700),
      ));
    }

    col.add(Row(crossAxisAlignment: CrossAxisAlignment.center, children: row1));

    if (totalDiscount != 0) {
      col.add(Text(
        '₹$totalMrp',
        style: TextStyle(
          decoration: TextDecoration.lineThrough,
          color: Colors.indigo[200],
        ),
        overflow: TextOverflow.visible,
        softWrap: true,
      ));

      List<Widget> row2 = [];
      col.addAll([
        Row(children: row2),
        SizedBox(height: 5),
      ]);

      row2.addAll([
        Text(
          'You save: ₹ ${priceText(totalDiscount)}',
          style: TextStyle(color: Colors.black45),
        ),
        SizedBox(width: 5),
        Text(
          '(${(totalDiscount / totalMrp * 100).ceil()}% Off)',
          style: TextStyle(
            color: Colors.black45,
          ),
        )
      ]);
    }

    return Flexible(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: col,
      ),
    );
  }

  Widget _emptyCartWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            'assets/img/market_out.png',
            // color: Colors.black,
            height: SizeConfig.screenWidth * 0.4,
            width: SizeConfig.screenWidth * 0.4,
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "Cart is Empty. Please Add some Products.",
            style: orderDetilsContentText,
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 10,
          ),
          RaisedButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, HomeRoute);
            },
            color: primaryColor,
            child: Text(
              'Add Products',
              style: orderDetilsHeadText,
            ),
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
                  ? Flexible(
                      child: Text(
                        '₹ ${item.productVariety.mrp * item.count}',
                        style: TextStyle(
                            color: prodMrpColor,
                            decoration: TextDecoration.lineThrough),
                        textAlign: TextAlign.left,
                      ),
                    )
                  : SizedBox(),
            ],
          ),
          SizedBox(
            height: 8,
          ),
          item.productVariety.mrp != item.productVariety.sp
              ? Text(
                  '₹ ${priceText(item.productVariety.discount * item.count)} Off',
                  style: TextStyle(
                    color: prodDiscountColor,
                  ),
                  textAlign: TextAlign.left,
                )
              : SizedBox()
        ],
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: widgets,
    );
  }

  Column _editCartWidgets(CartModel item) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        AbsorbPointer(
            absorbing: !item.available,
            child: ValueListenableBuilder(
              valueListenable: updatingCount,
              builder: (BuildContext context, bool updating, Widget child) {
                return Container(
                    margin: EdgeInsets.only(top: 20),
                    decoration: BoxDecoration(
                      border: Border.all(color: addButtonBorderColor),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          child: InkWell(
                            splashColor: Colors.black45,
                            onTap: updating
                                ? null
                                : () => decrementItemCount(
                                      item.count,
                                      authProvider.user.uid,
                                      item.cartItemId,
                                      updatingCount,
                                    ),
                            child: Container(
                              child: Icon(
                                Icons.remove,
                                color: Colors.black,
                              ),
                              padding: EdgeInsets.all(5),
                            ),
                          ),
                        ),
                        Container(
                          child: InkWell(
                            child: Container(
                              child: Text(
                                item.count.toString(),
                              ),
                              padding: EdgeInsets.only(left: 10, right: 10),
                            ),
                          ),
                        ),
                        Container(
                          child: InkWell(
                            splashColor: primaryColor,
                            onTap: updating
                                ? null
                                : () async {
                                    bool added = await incrementItemCount(
                                      item.count,
                                      item.productVariety.stock,
                                      item.productVariety.fraction,
                                      authProvider.user.uid,
                                      item.cartItemId,
                                      updatingCount,
                                    );
                                    if (!added) {
                                      itemNotAddedToast();
                                    }
                                  },
                            child: Container(
                              child: Icon(
                                Icons.add,
                                color: Colors.black,
                              ),
                              padding: EdgeInsets.all(5),
                            ),
                          ),
                        ),
                      ],
                    ));
              },
            )),
        FlatButton.icon(
          onPressed: () async {
            await removeFromCart(
              item.cartItemId,
              authProvider.user.uid,
            );
          },
          icon: Icon(
            Icons.delete,
            color: Colors.deepOrange[400],
          ),
          label: Text(
            "Remove",
            style: TextStyle(
              color: Colors.deepOrange[400],
            ),
          ),
        ),
      ],
    );
  }

  _noBody() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Please Login to use cart",
            style: profileList,
          ),
          SizedBox(
            height: 10,
          ),
          RaisedButton(
            onPressed: () {
              Navigator.pushNamed(context, PhoneLoginRoute, arguments: true);
            },
            color: primaryColor,
            child: Text(
              'Login',
              style: profileList,
            ),
          )
        ],
      ),
    );
  }

  Widget _proceedButton(
      double totalPrice, double totalMrp, List<CartModel> items) {
    return RaisedButton(
        onPressed: () {
          if (!allItemsAvailable) {
            _scaffoldKey.currentState.hideCurrentSnackBar();
            _scaffoldKey.currentState.showSnackBar(
              SnackBar(
                behavior: SnackBarBehavior.floating,
                content: Text(
                    "One or more items in Cart are unavailable\nPlease remove them to continue"),
              ),
            );
            return;
          }

          // all ok
          Navigator.of(context).pushNamed(
            DeliveryRoute,
            arguments: [totalMrp, totalPrice, items],
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
                'Proceed',
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
}
