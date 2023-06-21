import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocapp/const/color_const.dart';
import 'package:grocapp/const/route_constants.dart';
import 'package:grocapp/const/size_config.dart';
import 'package:grocapp/models/product_model.dart';
import 'package:grocapp/screens/auth/auth_provider.dart';
import 'package:grocapp/screens/cart/cart_provider.dart';
import 'package:grocapp/screens/product_list/bloc.dart';
import 'package:grocapp/screens/product_list/widgets/add_to_cart_widgets.dart';
import 'package:grocapp/screens/product_list/widgets/list_end_tile.dart';
import 'package:grocapp/screens/product_list/widgets/list_loading_tile.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shimmer/shimmer.dart';
import '../cart/helper.dart';
import 'widgets/description_widgets.dart';

class ProductList extends StatefulWidget {
  final Bloc bloc;
  ProductList(this.bloc);
  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  List<ValueNotifier<bool>> updatingCount = [];
  Map<String, ValueNotifier<Variety>> varietyNotifier = {};
  Stream<List<CartModel>> cartStream;
  @override
  void initState() {
    cartStream = context.read<CartProvider>().cartController.stream;
    if (widget.bloc.queryProvider.qAdd) widget.bloc.fetchFirstList();
    _controller.addListener(_scrollListener);
    super.initState();
  }

  ScrollController _controller = ScrollController();

  bool loadingMore = false;

  void _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !loadingMore) {
      loadingMore = true;
      widget.bloc.fetchNextMovies().then((value) => loadingMore = false);
    }
  }

  @override
  void dispose() {
    if (updatingCount.length != 0) {
      updatingCount.forEach((element) {
        element.dispose();
      });
    }
    updatingCount = [];
    varietyNotifier.forEach((key, value) {
      value.dispose();
    });
    varietyNotifier = {};
    _controller.dispose();
    super.dispose();
  }

  bool isAuth;
  AuthProvider authProvider;

  @override
  Widget build(BuildContext context) {
    authProvider = Provider.of(context);
    SizeConfig().init(context);
    return _productList();
  }

  Widget _productList() {
    Stream widgetStream = Rx.combineLatest2(
      widget.bloc.productStream,
      cartStream,
      (a, b) {
        return [a, b];
      },
    );

    return StreamBuilder(
      stream: widgetStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data[0] == null || snapshot.data[1] == null) {
            return Center(
              child: getListShimmer(),
            );
          }
          List<ProductModel> products = [];
          snapshot.data[0].forEach((element) {
            ProductModel prod = ProductModel.fromSnapshot(element);
            prod.productVariety =
                prod.productVariety.where((v) => v.stock > 0).toList();
            if (prod.productVariety.isNotEmpty) products.add(prod);
          });

          if (updatingCount.length != 0) {
            if (products.length < updatingCount.length) {
              for (int i = 0; i < products.length; i++) {
                updatingCount[i].value = false;
              }
            } else if (products.length > updatingCount.length) {
              var uclSnap = updatingCount.length;
              for (int i = 0; i < products.length; i++) {
                if (i < uclSnap) {
                  updatingCount[i].value = false;
                } else {
                  updatingCount.add(ValueNotifier<bool>(false));
                }
              }
            } else {
              for (int i = 0; i < updatingCount.length; i++) {
                updatingCount[i].value = false;
              }
            }
          } else {
            products.forEach((_) {
              updatingCount.add(ValueNotifier<bool>(false));
            });
          }
          products.forEach((element) {
            varietyNotifier.putIfAbsent(element.productId,
                () => ValueNotifier<Variety>(element.productVariety.first));
          });
          List<CartModel> cartItems = snapshot.data[1];
          return ListView.builder(
            physics: widget.bloc.finished
                ? ClampingScrollPhysics()
                : BouncingScrollPhysics(),
            shrinkWrap: true,
            controller: _controller,
            itemCount: widget.bloc.queryProvider.qAdd
                ? products.length
                : products.length + 1,
            itemBuilder: (context, int index) {
              if (index == products.length) {
                if (widget.bloc.finished) {
                  return listEndTile();
                }
                return listLoadingTile();
              }
              return _productTile(
                products[index],
                cartItems,
                varietyNotifier[products[index].productId],
                updatingCount[index],
              );
            },
          );
        } else {
          return Center(
            child: getListShimmer(),
          );
        }
      },
    );
  }

  Widget _productTile(
    ProductModel model,
    List<CartModel> cartItems,
    ValueNotifier<Variety> varietyNotifier,
    ValueNotifier<bool> updatingCount,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      width: SizeConfig.screenWidth,
      height: min(SizeConfig.screenHeight * 0.22, 160),
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        ProductDetailsRoute,
                        arguments: model,
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(),
                      child: CachedNetworkImage(
                        fit: BoxFit.fill,
                        imageUrl: model.productImage,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        model.productName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                      ),
                      _descriptionWidgets(
                        model,
                        varietyNotifier,
                        cartItems,
                        updatingCount,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 5,
            child: Divider(),
          )
        ],
      ),
    );
  }

  Widget _descriptionWidgets(
      ProductModel item,
      ValueNotifier<Variety> varietyNotifier,
      List<CartModel> cartItems,
      ValueNotifier<bool> updatingCount) {
    return ValueListenableBuilder<Variety>(
      valueListenable: varietyNotifier,
      builder: (BuildContext context, Variety variety, Widget child) {
        List<Widget> widgets = [
          DropdownButton<String>(
            value: variety.size,
            icon: Icon(Icons.arrow_drop_down),
            iconSize: 24,
            elevation: 8,
            style: TextStyle(
              color: Colors.blueGrey[600],
            ),
            underline: Container(
              height: 1.5,
              color: addButtonBorderColor,
            ),
            onChanged: (String newValue) {
              for (int i = 0; i < item.productVariety.length; i++) {
                if (item.productVariety[i].size == newValue) {
                  varietyNotifier.value = item.productVariety[i];
                  break;
                }
              }
            },
            items: item.productVariety
                .map<DropdownMenuItem<String>>((Variety value) {
              return DropdownMenuItem<String>(
                value: value.size,
                child: Text(value.size),
              );
            }).toList(),
          ),
          SizedBox(
            height: 10,
          ),
        ];
        List<Widget> colOfRow = [spMrp(variety)];

        if (variety.mrp != variety.sp) {
          colOfRow.addAll([
            SizedBox(
              height: 5,
            ),
            discount(variety.discount),
          ]);
        }

        List<Widget> row = [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: colOfRow,
          ),
          _cartButton(
            item,
            varietyNotifier,
            cartItems,
            updatingCount,
          ),
        ];

        widgets.add(
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: row,
          ),
        );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: widgets,
        );
      },
    );
  }

  Widget _cartButton(ProductModel model, ValueNotifier<Variety> varietyNotifier,
      List<CartModel> cartItems, ValueNotifier<bool> updatingCount) {
    return ValueListenableBuilder(
      valueListenable: varietyNotifier,
      builder: (BuildContext context, Variety variety, Widget child) {
        int itemIndex = -1;
        double currentStock = variety.stock;
        double stockFraction = variety.fraction;
        for (int i = 0; i < cartItems.length; i++) {
          if (model.productId == cartItems[i].productId &&
              variety.size == cartItems[i].productVariety.size) {
            itemIndex = i;
            break;
          }
        }

        return ValueListenableBuilder(
          valueListenable: updatingCount,
          builder: (BuildContext context, bool updating, Widget child) {
            if (itemIndex == -1) {
              return Container(
                alignment: Alignment.center,
                child: MaterialButton(
                  onPressed: () async {
                    if (updating) {
                      return null;
                    }
                    if (!authProvider.isAuthenticated) {
                      Scaffold.of(context).hideCurrentSnackBar();
                      Scaffold.of(context).showSnackBar(
                        SnackBar(
                          behavior: SnackBarBehavior.floating,
                          content: Text("Please login to access Cart"),
                          action: SnackBarAction(
                            label: "Tap here!",
                            onPressed: () => Navigator.pushNamed(
                              context,
                              PhoneLoginRoute,
                            ),
                          ),
                        ),
                      );
                    } else {
                      await addToCart(
                          model,
                          varietyNotifier.value,
                          authProvider.user.uid,
                          model.productId,
                          updatingCount);
                    }
                  },
                  child: addToCartButton(),
                  visualDensity: VisualDensity.standard,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    side: BorderSide(color: addButtonBorderColor),
                  ),
                  color: Colors.white,
                ),
              );
            } else {
              return Container(
                padding: EdgeInsets.all(5),
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
                                  cartItems[itemIndex].count,
                                  authProvider.user.uid,
                                  cartItems[itemIndex].cartItemId,
                                  updatingCount,
                                ),
                        child: Container(
                          child: Icon(
                            Icons.remove,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    addRemoveText(
                      cartItems[itemIndex].count.toString(),
                    ),
                    Container(
                      child: InkWell(
                        splashColor: primaryColor,
                        onTap: updating
                            ? null
                            : () async {
                                bool added = await incrementItemCount(
                                  cartItems[itemIndex].count,
                                  currentStock,
                                  stockFraction,
                                  authProvider.user.uid,
                                  cartItems[itemIndex].cartItemId,
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
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        );
      },
    );
  }

  getListShimmer() {
    return Shimmer.fromColors(
      child: ListView.separated(
        separatorBuilder: (BuildContext context, index) {
          return Divider(
            color: Colors.black,
            thickness: 5,
          );
        },
        physics: ScrollPhysics(),
        shrinkWrap: true,
        itemCount: 4,
        itemBuilder: (BuildContext context, index) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            height: SizeConfig.screenHeight * 0.22,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: Row(children: <Widget>[
                    Expanded(
                        flex: 1,
                        child: Container(
                          color: Colors.white,
                          height: SizeConfig.screenHeight * 0.1,
                        )),
                    SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      flex: 2,
                      child: Center(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Container(
                                    color: Colors.white,
                                    height: 12,
                                  ),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  Container(
                                    color: Colors.white,
                                    height: 12,
                                  ),
                                ],
                              ),
                              Container(
                                color: Colors.white,
                                width: SizeConfig.screenWidth * 0.25,
                                height: 12,
                              ),
                              Container(
                                color: Colors.white,
                                width: SizeConfig.screenWidth * 0.15,
                                height: 12,
                              )
                            ]),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Container(
                      color: Colors.white,
                      width: SizeConfig.screenWidth * 0.15,
                      height: 20,
                      alignment: Alignment.center,
                    )
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
      baseColor: Colors.grey[100],
      highlightColor: Colors.grey[300],
      period: Duration(milliseconds: 800),
    );
  }
}
