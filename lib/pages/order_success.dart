import 'package:chiggy_wiggy/helper.dart';
import 'package:chiggy_wiggy/pages/base_page.dart';
import 'package:chiggy_wiggy/pages/home_pagee.dart';
import 'package:chiggy_wiggy/provider/cart_provider.dart';
import 'package:chiggy_wiggy/provider/loader_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderSuccess extends BasePage {
  const OrderSuccess();

  @override
  _OrderSuccessState createState() => _OrderSuccessState();
}

class _OrderSuccessState extends BasePageState<OrderSuccess> {
  @override
  void initState() {
    var orderProvider = Provider.of<CartProvider>(context, listen: false);
    orderProvider.createOrder();

    super.initState();
  }

  @override
  bool showBackButton() {
    return false;
  }

  @override
  Widget pageUI() {
    return Consumer<CartProvider>(builder: (context, orderModel, child) {
      if (orderModel.isOrderCreated) {
        orderModel.cartItems.forEach((element) {
          orderModel.updateQty(element.productId, 0);
        });
        orderModel.updateCart(null);
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 100.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Icon(
                  Icons.check_circle,
                  color: Colors.lightGreen,
                  size: 100,
                ),
                getBoldText('Order Success', 30, Colors.black),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 50),
                  child: RaisedButton(
                    onPressed: ()
                     {
                      Navigator.pushReplacement<void, void>(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) => HomePagee(),
                        ),
                      );
                    },
                    child: getNormalText('Done', 18, Colors.white),
                    shape: StadiumBorder(),
                    color: getThemeColor(),
                  ),
                )
              ],
            ),
          ),
        );
      }
      return CircularProgressIndicator();
    });
  }
}
