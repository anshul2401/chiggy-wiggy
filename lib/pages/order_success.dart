import 'dart:convert';
import 'package:chiggy_wiggy/config.dart';
import 'package:chiggy_wiggy/helper.dart';
import 'package:chiggy_wiggy/pages/base_page.dart';
import 'package:chiggy_wiggy/pages/home_pagee.dart';
import 'package:chiggy_wiggy/provider/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';

class OrderSuccess extends BasePage {
  const OrderSuccess();

  @override
  _OrderSuccessState createState() => _OrderSuccessState();
}

class _OrderSuccessState extends BasePageState<OrderSuccess> {
  int orderid;
  @override
  void initState() {
    var orderProvider = Provider.of<CartProvider>(context, listen: false);
    orderProvider.createOrder();
    orderid = orderProvider.orderId;

    super.initState();
  }

  @override
  bool showBackButton() {
    return false;
  }

  Future<Response> sendNotification(List<String> tokenIdList, String contents,
      String heading, int orderId) async {
    return await post(
      Uri.parse('https://onesignal.com/api/v1/notifications'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "app_id": Config
            .oneSignalAppId, //kAppId is the App Id that one get from the OneSignal When the application is registered.

        "include_player_ids":
            tokenIdList, //tokenIdList Is the List of All the Token Id to to Whom notification must be sent.

        // android_accent_color reprsent the color of the heading text in the notifiction
        "android_accent_color": "FF9976D2",

        "small_icon": "ic_stat_onesignal_default",

        "large_icon":
            "https://www.filepicker.io/api/file/zPloHSmnQsix82nlj9Aj?filename=name.jpg",

        "headings": {"en": heading},

        "contents": {"en": contents},

        "data": {"orderid": orderId.toString()},
      }),
    );
  }

  Future<void> initPlatformState() async {
    OneSignal.shared.init(
      Config.oneSignalAppId,
    );
    // OneSignal.shared.setInFocusDisplayType(
    //   OSNotificationDisplayType.notification,
    // );
    // OneSignal.shared.setNotificationOpenedHandler((openedResult) {
    //   var data = openedResult.notification.payload.additionalData;
    //   print(data['orderid']);
    //   Navigator.push(context,
    //       MaterialPageRoute(builder: (context) => Result(data['orderid'])));
    // });
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
                    onPressed: () {
                      sendNotification(['b0634531-dee7-42bc-abbe-6e89aac1d1d4'],
                          'Ding Dong Order!', 'Order Arrived', orderid);
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
