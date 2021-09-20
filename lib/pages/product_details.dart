import 'package:chiggy_wiggy/api_service.dart';
import 'package:chiggy_wiggy/helper.dart';
import 'package:chiggy_wiggy/models/cart_request_model.dart';
import 'package:chiggy_wiggy/models/cart_response_model.dart';
import 'package:chiggy_wiggy/models/product.dart';
import 'package:chiggy_wiggy/pages/cart.dart';
import 'package:chiggy_wiggy/provider/cart_provider.dart';
import 'package:chiggy_wiggy/provider/loader_provider.dart';
import 'package:chiggy_wiggy/utils/progressHUD.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ProductDetail extends StatefulWidget {
  final Product product;
  const ProductDetail({this.product});

  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  int quantity = 0;

  CartProducts cartProducts = CartProducts();

  @override
  Widget build(BuildContext context) {
    bool isApiCallProcess = false;
    APIService apiService = APIService();
    var cartProvider = Provider.of<CartProvider>(context);
    CartItem cartItem = cartProvider.fetchItem(widget.product.id);
    return Consumer<LoaderProvider>(builder: (context, loaderModel, child) {
      return Scaffold(
        body: ProgressHUD(
            inAsyncCall: loaderModel.isApiCallProcess,
            opacity: 0.3,
            valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),
            child: buildUi()),
        bottomNavigationBar: BottomAppBar(
          elevation: 10,
          child: Container(
            height: 65,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                getBoldText(
                    'MRP: ₹' + widget.product.price, 20, getThemeColor()),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        if (cartItem != null) {
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
                        } else {}
                      },
                      icon: Icon(Icons.remove),
                    ),
                    Text(
                      cartItem == null ? '0' : cartItem.qty.toString(),
                      style: GoogleFonts.varelaRound(
                        textStyle: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: getThemeColor()),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        if (cartItem != null) {
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
                        } else {
                          CartProducts cartProducts = CartProducts();
                          Provider.of<LoaderProvider>(context, listen: false)
                              .setLoadingStatus(true);

                          var cartProvider =
                              Provider.of<CartProvider>(context, listen: false);
                          cartProducts.productId = widget.product.id;
                          cartProducts.quantity = 1;
                          cartProvider.addToCart(cartProducts, (val) {
                            Provider.of<LoaderProvider>(context, listen: false)
                                .setLoadingStatus(false);
                          });
                        }
                      },
                      icon: Icon(Icons.add),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget buildUi() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          getTopImage(context, widget.product.images[0].src),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.product.name,
                  style: GoogleFonts.varelaRound(
                    textStyle: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    getDetailRow(
                        'assets/images/chicken-leg.png', 'No. of pieces 5-6'),
                    getDetailRow('assets/images/weighing-machine.png',
                        'Net Weight ${getWeight(widget.product.weight)}'),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'DISCRIPTION',
                  style: GoogleFonts.varelaRound(
                    textStyle: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  parseHtmlString(widget.product.description),
                  style: GoogleFonts.varelaRound(
                    textStyle: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'WHAT\'S IN YOUR BOX',
                  style: GoogleFonts.varelaRound(
                    textStyle: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                getWhatsInBoxRow(
                    'assets/images/meat.png', 'Fresh organic meat'),
                SizedBox(
                  height: 5,
                ),
                getWhatsInBoxRow(
                    'assets/images/hygiene-mask.png', 'Hygienic packaging'),
                SizedBox(
                  height: 5,
                ),
                getWhatsInBoxRow(
                    'assets/images/vegetarian.png', '100% vegetarian feed'),
                SizedBox(
                  height: 5,
                ),
                getWhatsInBoxRow(
                    'assets/images/butcher.png', 'Artisanal butchery'),
                // FlatButton(
                //   onPressed: () {
                //     Provider.of<LoaderProvider>(context, listen: false)
                //         .setLoadingStatus(true);

                //     var cartProvider =
                //         Provider.of<CartProvider>(context, listen: false);
                //     cartProducts.productId = widget.product.id;
                //     cartProvider.addToCart(cartProducts, (val) {
                //       Provider.of<LoaderProvider>(context, listen: false)
                //           .setLoadingStatus(false);
                //     });
                //   },
                //   child: Text('Add to cart'),
                // )
              ],
            ),
          )
        ],
      ),
    );
  }
}

Stack getTopImage(BuildContext context, String imgURL) {
  return Stack(
    alignment: AlignmentDirectional.bottomCenter,
    children: [
      Stack(
        alignment: AlignmentDirectional.centerStart,
        children: [
          Container(
            height: 200,
            width: MediaQuery.of(context).size.width,
            child: Image.network(
              imgURL,
              fit: BoxFit.fitWidth,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MaterialButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                color: Colors.white,
                textColor: Colors.black,
                child: Icon(
                  Icons.arrow_back_ios_new,
                  size: 18,
                ),
                padding: EdgeInsets.all(5),
                shape: CircleBorder(),
              ),
              MaterialButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Cart(true)));
                },
                color: Colors.white,
                textColor: Colors.black,
                child: Stack(alignment: Alignment.topRight, children: [
                  Icon(
                    Icons.shopping_cart_rounded,
                    size: 18,
                  ),
                  Provider.of<CartProvider>(context, listen: false)
                              .cartItems
                              .length !=
                          0
                      ? new Positioned(
                          top: 0,
                          right: 0,
                          child: new Container(
                            padding: EdgeInsets.all(2),
                            decoration: new BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            constraints: BoxConstraints(
                              minWidth: 10,
                              minHeight: 10,
                            ),
                            child: Text(
                              Provider.of<CartProvider>(context, listen: false)
                                  .cartItems
                                  .length
                                  .toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 6,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      : new Container()
                ]),
                padding: EdgeInsets.all(10),
                shape: CircleBorder(),
              ),
            ],
          ),
        ],
      ),
      Container(
        height: 30,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(40),
            topLeft: Radius.circular(40),
          ),
        ),
      ),
    ],
  );
}

Row getDetailRow(String imageURL, String text) {
  return Row(
    children: [
      Container(
        height: 20,
        width: 20,
        child: Image.asset(imageURL),
      ),
      SizedBox(
        width: 2,
      ),
      Text(
        text,
        style: GoogleFonts.varelaRound(
          textStyle: TextStyle(
            fontSize: 12,
          ),
        ),
      ),
    ],
  );
}

Row getWhatsInBoxRow(String imageURL, String text) {
  return Row(
    children: [
      Padding(
        padding: const EdgeInsets.only(right: 20),
        child: Container(
          height: 25,
          width: 25,
          child: Image.asset(imageURL),
        ),
      ),
      Text(
        text,
        style: GoogleFonts.varelaRound(
          textStyle: TextStyle(
            fontSize: 15,
          ),
        ),
      ),
    ],
  );
}
