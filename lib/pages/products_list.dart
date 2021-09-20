import 'package:chiggy_wiggy/api_service.dart';
import 'package:chiggy_wiggy/helper.dart';
import 'package:chiggy_wiggy/models/cart_request_model.dart';
import 'package:chiggy_wiggy/models/cart_response_model.dart';
import 'package:chiggy_wiggy/models/product.dart';
import 'package:chiggy_wiggy/pages/cart.dart';
import 'package:chiggy_wiggy/pages/product_details.dart';
import 'package:chiggy_wiggy/provider/cart_provider.dart';
import 'package:chiggy_wiggy/provider/loader_provider.dart';
import 'package:chiggy_wiggy/utils/progressHUD.dart';
import 'package:chiggy_wiggy/utils/top_nav.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ProductList extends StatefulWidget {
  final int categoryId;
  final String categoryName;
  const ProductList({Key key, this.categoryId, this.categoryName})
      : super(key: key);

  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  bool isApiCallProcess = false;
  APIService apiService = APIService();

  @override
  Widget build(BuildContext context) {
    return Consumer<LoaderProvider>(
      builder: (context, loaderModel, child) {
        return Scaffold(
          backgroundColor: Colors.white
              .withOpacity(1)
              .withRed(254)
              .withBlue(245)
              .withGreen(230),
          body: ProgressHUD(
            color: Colors.red.withOpacity(0.1),
            inAsyncCall: loaderModel.isApiCallProcess,
            opacity: 0,
            valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),
            child: Column(
              children: [
                getTopNav(
                  context,
                  widget.categoryName,
                  getThemeColor(),
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
                                  Provider.of<CartProvider>(context,
                                          listen: false)
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
                          : new Container(
                              padding: EdgeInsets.all(2),
                              width: 0,
                              height: 0,
                            )
                    ]),
                    padding: EdgeInsets.all(5),
                    shape: CircleBorder(),
                  ),
                  true,
                ),
                Expanded(child: _productsList('10'))
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _productsList(String catID) {
    return new FutureBuilder(
        future: apiService.getProductsByCategory(widget.categoryId.toString()),
        builder: (BuildContext context, AsyncSnapshot<List<Product>> model) {
          if (model.hasData) {
            return getProductTile(model.data.toList());
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  Widget getProductTile(List<Product> product) {
    var cartProvider = Provider.of<CartProvider>(context, listen: false);
    return Container(
      child: ListView.builder(
          padding: EdgeInsets.zero,
          scrollDirection: Axis.vertical,
          itemCount: product.length,
          itemBuilder: (context, index) {
            var data = product[index];
            CartItem cartItem = cartProvider.fetchItem(data.id);

            return Padding(
              padding: const EdgeInsets.all(3.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDetail(product: data),
                    ),
                  );
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 200,
                        width: MediaQuery.of(context).size.width,
                        child: ClipRRect(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20)),
                            child: Image.network(
                              data.images[0].src,
                              fit: BoxFit.fitWidth,
                            )),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                getBoldText(data.name, 18, Colors.black),
                                getNormalText(
                                    getWeight(data.weight), 16, Colors.grey)
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            getNormalText(
                                parseHtmlString(data.shortDescription),
                                16,
                                Colors.black),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                getBoldText(
                                    'MRP: ₹' + data.price, 18, getThemeColor()),
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        if (cartItem != null) {
                                          Provider.of<LoaderProvider>(context,
                                                  listen: false)
                                              .setLoadingStatus(true);
                                          Provider.of<CartProvider>(context,
                                                  listen: false)
                                              .updateQty(cartItem.productId,
                                                  cartItem.qty - 1);

                                          var cartProvider =
                                              Provider.of<CartProvider>(context,
                                                  listen: false);

                                          cartProvider.updateCart((val) {
                                            Provider.of<LoaderProvider>(context,
                                                    listen: false)
                                                .setLoadingStatus(false);
                                          });
                                        } else {}
                                      },
                                      icon: Icon(Icons.remove),
                                    ),
                                    Text(
                                      cartItem == null
                                          ? '0'
                                          : cartItem.qty.toString(),
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
                                          Provider.of<LoaderProvider>(context,
                                                  listen: false)
                                              .setLoadingStatus(true);
                                          Provider.of<CartProvider>(context,
                                                  listen: false)
                                              .updateQty(cartItem.productId,
                                                  cartItem.qty + 1);

                                          var cartProvider =
                                              Provider.of<CartProvider>(context,
                                                  listen: false);

                                          cartProvider.updateCart((val) {
                                            Provider.of<LoaderProvider>(context,
                                                    listen: false)
                                                .setLoadingStatus(false);
                                          });
                                        } else {
                                          CartProducts cartProducts =
                                              CartProducts();
                                          Provider.of<LoaderProvider>(context,
                                                  listen: false)
                                              .setLoadingStatus(true);

                                          var cartProvider =
                                              Provider.of<CartProvider>(context,
                                                  listen: false);
                                          cartProducts.productId = data.id;
                                          cartProducts.quantity = 1;
                                          cartProvider.addToCart(cartProducts,
                                              (val) {
                                            Provider.of<LoaderProvider>(context,
                                                    listen: false)
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
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}
