import 'package:carousel_slider/carousel_slider.dart';
import 'package:chiggy_wiggy/helper.dart';
import 'package:chiggy_wiggy/models/cart_request_model.dart';
import 'package:chiggy_wiggy/models/cart_response_model.dart';
import 'package:chiggy_wiggy/models/product.dart';
import 'package:chiggy_wiggy/pages/product_details.dart';
import 'package:chiggy_wiggy/provider/cart_provider.dart';
import 'package:chiggy_wiggy/provider/loader_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CardCarousal extends StatelessWidget {
  final List<Product> product;
  CardCarousal({this.product});
  @override
  Widget build(BuildContext context) {
    var cartProvider = Provider.of<CartProvider>(context, listen: false);
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      child: CarouselSlider.builder(
        itemCount: product.length,
        options: CarouselOptions(
          viewportFraction: 0.95,
          aspectRatio: 1.0,
          enlargeCenterPage: true,
          autoPlay: true,
        ),
        itemBuilder: (ctx, index, realIdx) {
          CartItem cartItem = cartProvider.fetchItem(product[index].id);
          return GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ProductDetail(product: product[index])));
            },
            child: Card(
              // elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundImage:
                              NetworkImage(product[index].images[0].src),
                          backgroundColor: Colors.transparent,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              product[index].name,
                              style: GoogleFonts.varelaRound(
                                textStyle: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Text(
                              getWeight(product[index].weight),
                              style: GoogleFonts.varelaRound(
                                textStyle: TextStyle(),
                              ),
                            ),
                            Text(
                              "₹" + product[index].price,
                              style: GoogleFonts.varelaRound(
                                textStyle: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    // FlatButton(
                    //   onPressed: () {},
                    //   child: getNormalText('ADD', 14, Colors.white),
                    //   color: getThemeColor(),
                    //   shape: StadiumBorder(),
                    // )
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            if (cartItem != null) {
                              // Provider.of<LoaderProvider>(context,
                              //         listen: false)
                              //     .setLoadingStatus(true);
                              // Provider.of<CartProvider>(context, listen: false)
                              //     .updateQty(
                              //         cartItem.productId, cartItem.qty - 1);

                              // var cartProvider = Provider.of<CartProvider>(
                              //     context,
                              //     listen: false);

                              // cartProvider.updateCart((val) {
                              //   Provider.of<LoaderProvider>(context,
                              //           listen: false)
                              //       .setLoadingStatus(false);
                              // });
                            } else {}
                          },
                          icon: Icon(
                            Icons.remove,
                          ),
                          color: Colors.black,
                        ),
                        Text(
                          cartItem == null ? '0' : cartItem.qty.toString(),
                          style: GoogleFonts.varelaRound(
                            textStyle: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.red),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            if (cartItem != null) {
                              // Provider.of<LoaderProvider>(context,
                              //         listen: false)
                              //     .setLoadingStatus(true);
                              // Provider.of<CartProvider>(context, listen: false)
                              //     .updateQty(
                              //         cartItem.productId, cartItem.qty + 1);

                              // var cartProvider = Provider.of<CartProvider>(
                              //     context,
                              //     listen: false);

                              // cartProvider.updateCart((val) {
                              //   Provider.of<LoaderProvider>(context,
                              //           listen: false)
                              //       .setLoadingStatus(false);
                              // });
                            } else {
                              // CartProducts cartProducts = CartProducts();
                              // Provider.of<LoaderProvider>(context,
                              //         listen: false)
                              //     .setLoadingStatus(true);

                              // var cartProvider = Provider.of<CartProvider>(
                              //     context,
                              //     listen: false);
                              // cartProducts.productId = product[index].id;
                              // cartProducts.quantity = 1;
                              // cartProvider.addToCart(cartProducts, (val) {
                              //   Provider.of<LoaderProvider>(context,
                              //           listen: false)
                              //       .setLoadingStatus(false);
                              // });
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
        },
      ),
    );
  }
}
