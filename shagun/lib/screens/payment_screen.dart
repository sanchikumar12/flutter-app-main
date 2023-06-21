import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:miniapp/constants.dart';
import 'package:miniapp/screens/dashboard_screen.dart';

class PaymentScreen extends StatefulWidget {
  static const routeName = '/payment-form';
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  RequestState buyRequestState = RequestState.idle;
  bool purchasesRestored = false;
  late StreamSubscription<List<PurchaseDetails>> _purchaseUpdateSubscription;

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      initStore();
    });
    super.initState();
  }

  void initStore() async {
    final Stream<List<PurchaseDetails>> purchaseUpdated = InAppPurchase.instance.purchaseStream;
    _purchaseUpdateSubscription = purchaseUpdated.listen((List<PurchaseDetails> purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _purchaseUpdateSubscription.cancel();
    }, onError: (error) {
      if(kDebugMode) {
        print(error.toString());
      }
    });
    if(await InAppPurchase.instance.isAvailable()) {
      await InAppPurchase.instance.restorePurchases();
    }


    // if(FirebaseAuth.instance.currentUser?.phoneNumber == '+919876543210'
    //     && mounted) {
    //   Navigator.of(context).pushNamed(DashboardScreen.routeName);
    // }
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList)
  async {
    for (var purchaseDetails in purchaseDetailsList) {
      if(purchaseDetails.pendingCompletePurchase) {
        await InAppPurchase.instance.completePurchase(purchaseDetails);
      }
      if(purchaseDetails.productID == kAccessProductId &&
          [PurchaseStatus.purchased, PurchaseStatus.restored]
              .contains(purchaseDetails.status) && mounted) {
        await Navigator.of(context).pushReplacementNamed(DashboardScreen.routeName);
      }
      if(purchaseDetails.status == PurchaseStatus.error) {
        setState(() {
          buyRequestState = RequestState.failed;
        });
      }
    }

    if(mounted) {
      setState(() {
        purchasesRestored = true;
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return !purchasesRestored ? const Scaffold(
      body: Center(child: CircularProgressIndicator(),),
    ) : Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Payment'),
        ),
        body: Container(
          padding: kDefaultPadding,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  const Text('Pay one time subscription for lifetime access'),
                  ElevatedButton(
                      onPressed: buyAccess,
                      child: buyRequestState == RequestState.pending ?
                      const CircularProgressIndicator(color: Colors.white,) :
                      const Text('Buy')
                  )
                ],
              ),
            ],
          ),
        )
    );
  }

  void buyAccess() {
    setState(() {
      buyRequestState = RequestState.pending;
    });

    InAppPurchase.instance.isAvailable().then((available) async {
      if(available) {
        final ProductDetailsResponse response = await InAppPurchase.instance
            .queryProductDetails({kAccessProductId});

        if (response.notFoundIDs.isNotEmpty && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Product not found'))
          );
        }
        ProductDetails productDetails = response.productDetails.first;

        final PurchaseParam purchaseParam = PurchaseParam(
            productDetails: productDetails
        );
        return await InAppPurchase.instance.buyNonConsumable(
            purchaseParam: purchaseParam
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Store is not available'))
        );
      }
    });


  }


}
