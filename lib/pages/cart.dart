import 'dart:async';
import 'package:chiggy_wiggy/helper.dart';
import 'package:chiggy_wiggy/models/cart_response_model.dart';
import 'package:chiggy_wiggy/pages/varify_address.dart';
import 'package:chiggy_wiggy/provider/cart_provider.dart';
import 'package:chiggy_wiggy/provider/loader_provider.dart';
import 'package:chiggy_wiggy/utils/progressHUD.dart';
import 'package:chiggy_wiggy/utils/top_nav.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Cart extends StatefulWidget {
  final bool showBackButton;
  Cart(this.showBackButton);

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  bool isLoading = false;

  @override
  void initState() {
    var cartItemList = Provider.of<CartProvider>(context, listen: false);
    cartItemList.resetStream();
    cartItemList.fetchCartItems();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LoaderProvider>(builder: (context, loaderModel, child) {
      return Scaffold(
        backgroundColor: Colors.white
            .withOpacity(1)
            .withRed(254)
            .withBlue(245)
            .withGreen(230),
        body: ProgressHUD(
          child: buildCartUI(context),
          inAsyncCall: loaderModel.isApiCallProcess,
          opacity: 0.3,
          valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),
        ),
      );
    });
  }

  Widget cartProductCard(CartItem cartItem) {
    int qty = cartItem.qty;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                getBoldText(cartItem.productName, 18, Colors.black),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    Provider.of<LoaderProvider>(context, listen: false)
                        .setLoadingStatus(true);
                    // Provider.of<CartProvider>(context, listen: false)
                    //     .removeItem(cartItem.productId);

                    var cartProvider =
                        Provider.of<CartProvider>(context, listen: false);
                    cartProvider.updateQty(cartItem.productId, 0);

                    cartProvider.updateCart((val) {
                      Provider.of<LoaderProvider>(context, listen: false)
                          .setLoadingStatus(false);
                    });
                  },
                ),
              ],
            ),
            // SizedBox(
            //   height: 8,
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                getBoldText("₹ " + cartItem.productSalePrice, 18, Colors.red),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        if (cartItem.qty == 0) {
                        } else {
                          Provider.of<LoaderProvider>(context, listen: false)
                              .setLoadingStatus(true);
                          Provider.of<CartProvider>(context, listen: false)
                              .updateQty(cartItem.productId, cartItem.qty - 1);

                          var cartProvider =
                              Provider.of<CartProvider>(context, listen: false);

                          cartProvider.updateCart((val) {
                            Provider.of<LoaderProvider>(context, listen: false)
                                .setLoadingStatus(false);
                          });
                        }
                      },
                      icon: Icon(Icons.remove),
                    ),
                    Text(
                      qty.toString(),
                      style: GoogleFonts.varelaRound(
                        textStyle: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.red),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Provider.of<LoaderProvider>(context, listen: false)
                            .setLoadingStatus(true);
                        Provider.of<CartProvider>(context, listen: false)
                            .updateQty(cartItem.productId, cartItem.qty + 1);

                        var cartProvider =
                            Provider.of<CartProvider>(context, listen: false);

                        cartProvider.updateCart((val) {
                          Provider.of<LoaderProvider>(context, listen: false)
                              .setLoadingStatus(false);
                        });
                      },
                      icon: Icon(Icons.add),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget buildCartUI(BuildContext context) {
    return Consumer<CartProvider>(builder: (context, cartModel, child) {
      if (cartModel.cartItems != null) {
        return cartModel.cartItems.length > 0
            ? SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        getTopNav(context, 'Cart', getThemeColor(), Container(),
                            widget.showBackButton),
                        ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            itemCount: cartModel.cartItems.length,
                            itemBuilder: (context, index) {
                              return cartProductCard(
                                  cartModel.cartItems[index]);
                            }),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            getNormalText('Total', 15, Colors.black),
                            getBoldText('₹ ' + cartModel.totalAmount.toString(),
                                18, Colors.black),
                          ],
                        ),
                        FlatButton(
                            color: Colors.red,
                            shape: StadiumBorder(),
                            padding: EdgeInsets.all(8),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => VarifyAddress()));
                            },
                            child: getNormalText('Checkout', 15, Colors.white))
                      ],
                    ),
                  ],
                ),
              )
            : Column(
                children: [
                  getTopNav(
                    context,
                    'Cart',
                    getThemeColor(),
                    Container(),
                    widget.showBackButton,
                  ),
                  Center(
                    child: CircularProgressIndicator(),
                  ),
                ],
              );
      }

      return Column(
        children: [
          getTopNav(
            context,
            'Cart',
            getThemeColor(),
            Container(),
            widget.showBackButton,
          ),
          Center(
            child: Text('Cart is empty'),
          ),
        ],
      );
    });
  }
}
