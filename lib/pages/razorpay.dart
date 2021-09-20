import 'package:chiggy_wiggy/models/order.dart';
import 'package:chiggy_wiggy/pages/order_success.dart';
import 'package:chiggy_wiggy/provider/cart_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorpayService {
  Razorpay _razorpay;
  BuildContext _buildContext;
  initPaymentGateway(BuildContext buildContext) {
    this._buildContext = buildContext;
    _razorpay = new Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, paymentSuccessful);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, paymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, externalWallet);
  }

  void paymentError(PaymentFailureResponse response) {
    // Navigator.push(
    //     context, MaterialPageRoute(builder: (context) => BookingFailed()));
  }

  void paymentSuccessful(PaymentSuccessResponse response) {
    var orderProvider = Provider.of<CartProvider>(_buildContext, listen: false);
    OrderModel orderModel = OrderModel();
    orderModel.paymentMethod = 'razorpay';
    orderModel.paymentMethodTitle = 'Razorpay';
    orderModel.setPaid = true;
    orderModel.transectionId = response.paymentId.toString();
    orderProvider.processOrder(orderModel);
    // print('thisi');
    Navigator.pushReplacement(_buildContext,
        MaterialPageRoute(builder: (context) {
      return OrderSuccess();
    }));
  }

  void externalWallet(ExternalWalletResponse response) {
    print(response.walletName);
  }

  void openCheckout(BuildContext context) {
    var cartItems = Provider.of<CartProvider>(context, listen: false);
    cartItems.fetchCartItems();

    var options = {
      "key": "rzp_test_ftqgz8hdue0pLi",
      "amount": cartItems.totalAmount * 100,
      "name": "Chiggy Wiggy",
      "description": "A step Away",
      "prefill": {
        "contact": '123456789',
        "email": 'anshulchouhan@gmail.com',
      },
      "external": {
        "wallets": ["paytm"]
      }
    };
    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e);
    }
  }
}
