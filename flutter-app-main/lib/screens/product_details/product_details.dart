import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocapp/const/color_const.dart';
import 'package:grocapp/const/route_constants.dart';
import 'package:grocapp/const/size.dart';
import 'package:grocapp/const/size_config.dart';
import 'package:grocapp/const/text_style.dart';
import 'package:grocapp/models/product_model.dart';
import 'package:grocapp/screens/auth/auth_provider.dart';
import 'package:grocapp/screens/cart/cart_provider.dart';
import 'package:grocapp/screens/cart/helper.dart';
import 'package:grocapp/screens/cart/widgets/cart_count.dart';
import 'package:provider/provider.dart';

class ProductDetails extends StatefulWidget {
  final ProductModel product;
  const ProductDetails({Key key, @required this.product}) : super(key: key);

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  AuthProvider authProvider;
  ValueNotifier<int> _varietySelector = ValueNotifier<int>(0);
  ValueNotifier<bool> _updatingCount = ValueNotifier<bool>(false);
  Stream<int> cartCountStream;

  @override
  void initState() {
    cartCountStream = context.read<CartProvider>().cartLengthController.stream;
    super.initState();
  }

  @override
  void dispose() {
    _varietySelector.dispose();
    _updatingCount.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    authProvider = Provider.of(context);
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              flex: 5,
              child: Text(
                widget.product.productName,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            IconButton(
              icon: cartCount(cartCountStream),
              onPressed: () => Navigator.pushNamed(context, CartRoute),
            )
          ],
        ),
      ),
      body: SafeArea(
        child: Stack(children: <Widget>[
          Container(
            child: ListView(
              children: <Widget>[
                Container(
                  height: SizeConfig.screenHeight * 0.5,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    // borderRadius: BorderRadius.only(
                    //   bottomLeft: Radius.circular(25),
                    //   bottomRight: Radius.circular(25),
                    // ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      //Product Image
                      Center(
                        child: CachedNetworkImage(
                          height: SizeConfig.screenHeight * 0.22,
                          imageUrl: widget.product.productImage,
                          fit: BoxFit.contain,
                          placeholder: (context, url) {
                            return CircularProgressIndicator();
                          },
                        ),
                      ),

                      //Product Name
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 25),
                        child: Text(
                          widget.product.productName,
                          style: detNameText,
                        ),
                      ),

                      //Product Prices & Subscription
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 25),
                        child: ValueListenableBuilder(
                          builder:
                              (BuildContext context, int value, Widget child) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      '₹ ${widget.product.productVariety[_varietySelector.value].sp}',
                                      style: detSpText,
                                    ),
                                    // RaisedButton(
                                    //     onPressed: () {
                                    //       // Navigator.push(
                                    //       //   context,
                                    //       //   MaterialPageRoute(
                                    //       //       builder: (context) =>
                                    //       //           PaymentScreen(
                                    //       //             amount: "1.00",
                                    //       //           )),
                                    //       // );
                                    //     },
                                    //     color: Colors.lightBlue,
                                    //     splashColor: Colors.white30,
                                    //     shape: RoundedRectangleBorder(
                                    //       borderRadius:
                                    //           BorderRadiusDirectional.circular(
                                    //               8),
                                    //       side: BorderSide(
                                    //           color: Colors.lightBlueAccent),
                                    //     ),
                                    //     child: FittedBox(
                                    //       fit: BoxFit.fitWidth,
                                    //       child: Row(
                                    //         mainAxisAlignment:
                                    //             MainAxisAlignment.spaceBetween,
                                    //         children: <Widget>[
                                    //           Text(
                                    //             'Subscribe',
                                    //             style: TextStyle(
                                    //                 fontSize: subscribeSize,
                                    //                 color: Colors.white),
                                    //           ),
                                    //           SizedBox(
                                    //             width: 5,
                                    //           ),
                                    //           Icon(
                                    //             Icons.arrow_forward_ios,
                                    //             color: Colors.white,
                                    //             size: subscribeSize,
                                    //           )
                                    //         ],
                                    //       ),
                                    //     ))
                                  ],
                                ),

                                //Discount
                                widget
                                            .product
                                            .productVariety[
                                                _varietySelector.value]
                                            .discount >
                                        0.0
                                    ? Row(
                                        children: <Widget>[
                                          Text(
                                              '₹ ${widget.product.productVariety[_varietySelector.value].mrp}',
                                              style: detMrpText),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Text(
                                            '₹ ${widget.product.productVariety[_varietySelector.value].discount} Off',
                                            style: detOffText,
                                          ),
                                        ],
                                      )
                                    : SizedBox(),
                              ],
                            );
                          },
                          valueListenable: _varietySelector,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),

                //Varieties
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  color: Colors.white,
                  //padding: EdgeInsets.symmetric(horizontal: 25),
                  child: GridView.count(
                    shrinkWrap: true, physics: ClampingScrollPhysics(),

                    crossAxisSpacing: 8,
                    // Create a grid with 2 columns. If you change the scrollDirection to
                    // horizontal, this produces 2 rows.
                    crossAxisCount: 3,
                    // Generate 100 widgets that display their index in the List.
                    children: List.generate(
                        widget.product.productVariety.length, (index) {
                      return Center(
                        child: ValueListenableBuilder(
                          builder:
                              (BuildContext context, int value, Widget child) {
                            bool varietyOutOfStock =
                                widget.product.productVariety[index].stock == 0;
                            return MaterialButton(
                              splashColor: Colors.white60,
                              color: _varietySelector.value == index
                                  ? primaryColor
                                  : Colors.white,
                              onPressed: () {
                                _varietySelector.value = index;
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                side: BorderSide(
                                  color: varietyOutOfStock
                                      ? Colors.grey
                                      : primaryColor,
                                ),
                              ),
                              child: FittedBox(
                                fit: BoxFit.fitWidth,
                                child: Text(
                                  widget.product.productVariety[index].size,
                                  style: TextStyle(
                                      color: varietyOutOfStock
                                          ? Colors.grey
                                          : null),
                                ),
                              ),
                            );
                          },
                          valueListenable: _varietySelector,
                        ),
                      );
                    }),
                  ),
                ),

                SizedBox(
                  height: 5,
                ),

                //Description
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Description', style: detDescText),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        widget.product.productDescription,
                        textAlign: TextAlign.justify,
                        style: detDescSubText,
                      )
                    ],
                  ),
                ),

                SizedBox(
                  height: 5,
                ),

//Benefits
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Benefits', style: detBenfText),
                      SizedBox(
                        height: 8,
                      ),
                      FittedBox(
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.done,
                              size: doneIconSize,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              'Fresh Products',
                              style: detBenSubText,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      FittedBox(
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.done,
                              size: doneIconSize,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              'On Time Delivery',
                              style: detBenSubText,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      FittedBox(
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.done,
                              size: doneIconSize,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              'Hassle Free Experience',
                              style: detBenSubText,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                widget.product.countryOfOrigin != null &&
                        widget.product.countryOfOrigin != ""
                    ? Container(
                        color: Colors.white,
                        padding:
                            EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                        child: Text(
                          ' Country Of Origin - ${widget.product.countryOfOrigin}',
                          style: detBenSubText,
                        ),
                      )
                    : SizedBox(),
                SizedBox(
                  height: 80,
                )
              ],
            ),
          ),

          //Add To Cart Button
          Positioned(
            bottom: 20,
            left: SizeConfig.screenWidth * 0.1,
            child: SizedBox(
              height: 50,
              width: SizeConfig.screenWidth * 0.8,
              child: _cartButton(),
            ),
          )
        ]),
      ),
    );
  }

  Stream _getCartStream() {
    if (authProvider.isAuthenticated) {
      return Firestore.instance
          .collection("users")
          .document(authProvider.user.uid)
          .collection("cart")
          .snapshots();
    } else {
      return Stream.value(0);
    }
  }

  Widget _cartButton() {
    return StreamBuilder(
      stream: _getCartStream(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container(
            height: 0,
            width: 0,
            color: Colors.transparent,
          );
        }

        return ValueListenableBuilder(
          valueListenable: _varietySelector,
          builder: (BuildContext context, int varietyIndex, Widget child) {
            List<CartModel> cartItems = [];
            if (authProvider.isAuthenticated) {
              snapshot.data.documents.forEach((element) {
                cartItems.add(CartModel.forCart(element.data));
              });
            }
            int cartItemIndex = -1;
            double currentStock =
                widget.product.productVariety[varietyIndex].stock;
            double stockFraction =
                widget.product.productVariety[varietyIndex].fraction;
            for (int i = 0; i < cartItems.length; i++) {
              if (widget.product.productId == cartItems[i].productId &&
                  widget.product.productVariety[varietyIndex].size ==
                      cartItems[i].productVariety.size) {
                cartItemIndex = i;
                break;
              }
            }
            if (cartItemIndex == -1) {
              return ValueListenableBuilder(
                valueListenable: _updatingCount,
                builder: (BuildContext context, bool updating, Widget child) {
                  if (widget.product.productVariety[varietyIndex].stock == 0)
                    return _outOfStockBtn();
                  return _addToCartBtn(updating, varietyIndex);
                },
              );
            } else {
              return ValueListenableBuilder(
                valueListenable: _updatingCount,
                builder: (BuildContext context, bool updating, Widget child) {
                  return Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: accentColor.withOpacity(0.92),
                        border: Border.all(color: accentColor),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 2,
                            child: Container(
                              child: InkWell(
                                splashColor: Colors.black45,
                                onTap: updating
                                    ? null
                                    : () => decrementItemCount(
                                          cartItems[cartItemIndex].count,
                                          authProvider.user.uid,
                                          cartItems[cartItemIndex].cartItemId,
                                          _updatingCount,
                                        ),
                                child: Container(
                                  child: Icon(
                                    Icons.remove,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              child: InkWell(
                                child: Center(
                                  child: Text(
                                    cartItems[cartItemIndex].count.toString(),
                                    style: GoogleFonts.nunito(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 18),
                                  ),
                                  //padding: EdgeInsets.only(left: 10, right: 10),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                              child: InkWell(
                                splashColor: primaryColor,
                                onTap: updating
                                    ? null
                                    : () async {
                                        bool added = await incrementItemCount(
                                          cartItems[cartItemIndex].count,
                                          currentStock,
                                          stockFraction,
                                          authProvider.user.uid,
                                          cartItems[cartItemIndex].cartItemId,
                                          _updatingCount,
                                        );
                                        if (!added) {
                                          itemNotAddedToast();
                                        }
                                      },
                                child: Container(
                                  child: Icon(
                                    Icons.add,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ));
                },
              );
            }
          },
        );
      },
    );
  }

  Container _addToCartBtn(bool updating, int varietyIndex) {
    return Container(
      alignment: Alignment.center,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusDirectional.circular(8),
          side: BorderSide(color: accentColor),
        ),
        color: accentColor.withOpacity(0.93),
        onPressed: () => _addToCartHandler(updating, varietyIndex),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Icon(
              Icons.add_shopping_cart,
              size: 25,
              color: Colors.white,
            ),
            Text('Add To Cart', style: detAddCartText),
            SizedBox(),
          ],
        ),
      ),
    );
  }

  void _addToCartHandler(bool updating, int varietyIndex) async {
    if (updating) {
      return null;
    }
    if (!authProvider.isAuthenticated) {
      Scaffold.of(context).hideCurrentSnackBar();
      Scaffold.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.white,
          behavior: SnackBarBehavior.floating,
          content: InkWell(
            onTap: () => Navigator.pushNamed(
              context,
              PhoneLoginRoute,
              arguments: true, //inAppLogin = true
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Login to access it.",
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      await addToCart(
          widget.product,
          widget.product.productVariety[varietyIndex],
          authProvider.user.uid,
          widget.product.productId,
          _updatingCount);
    }
  }

  Widget _outOfStockBtn() {
    return Container(
      alignment: Alignment.center,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusDirectional.circular(8),
          side: BorderSide(color: unavailableItem),
        ),
        color: unavailableItem,
        onPressed: null,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Icon(
              Icons.circle,
              size: 25,
              color: Colors.white,
            ),
            Text('Out of Stock', style: detAddCartText),
            SizedBox(),
          ],
        ),
      ),
    );
  }
}
