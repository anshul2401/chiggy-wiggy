import 'dart:core';

import 'package:chiggy_wiggy/api_service.dart';
import 'package:chiggy_wiggy/models/cart_request_model.dart';
import 'package:chiggy_wiggy/models/cart_response_model.dart';
import 'package:chiggy_wiggy/models/customer_details.dart';
import 'package:chiggy_wiggy/models/order.dart';

import 'package:flutter/material.dart';

class CartProvider with ChangeNotifier {
  APIService _apiService;
  List<CartItem> _cartItems;
  CustomerDetailModel _customerDetailModel;
  CustomerDetailModel get customerDetailModel => _customerDetailModel;
  OrderModel _orderModel;
  bool _isOrderCreated = false;
  bool get isOrderCreated => _isOrderCreated;
  OrderModel get orderModel => _orderModel;
  List<CartItem> get cartItems => _cartItems;
  int orderId;
  double get totalRecords => _cartItems.length.toDouble();
  double get totalAmount => _cartItems != null
      ? _cartItems
          .map<double>((e) => e.lineSubtotal)
          .reduce((value, element) => value + element)
      : 0;

  CartProvider() {
    _apiService = new APIService();
    _cartItems = [];
  }

  resetStream() {
    _apiService = new APIService();
    _cartItems = [];
  }

  void addToCart(CartProducts product, Function onCallBack) async {
    CartRequestModel requestModel = new CartRequestModel();
    requestModel.products = [];
    if (_cartItems == null) resetStream();
    _cartItems.forEach((element) {
      requestModel.products.add(new CartProducts(
          productId: element.productId, quantity: element.qty));
    });

    var isProductExist = requestModel.products.firstWhere(
      (prod) => prod.productId == product.productId,
      orElse: () => null,
    );

    if (isProductExist != null) {
      requestModel.products.remove(isProductExist);
    }
    requestModel.products.add(product);

    await _apiService.addToCart(requestModel).then((val) {
      if (val.data != []) {
        _cartItems = [];
        _cartItems.addAll(val.data);
      }
      onCallBack(val);
      notifyListeners();
    });
  }

  fetchCartItems() async {
    if (_cartItems == null) resetStream();
    await _apiService.getCartItems().then((value) {
      if (value != null) {
        _cartItems.addAll(value.data);
      }
    });

    notifyListeners();
  }

  void updateQty(int productId, int qty) {
    var isProdExist = _cartItems.firstWhere(
        (element) => element.productId == productId,
        orElse: () => null);
    if (isProdExist != null) {
      isProdExist.qty = qty;
    }
    notifyListeners();
  }

  void updateCart(Function onCallBack) async {
    CartRequestModel requestModel = new CartRequestModel();
    requestModel.products = [];
    if (_cartItems == null) resetStream();
    _cartItems.forEach((element) {
      requestModel.products.add(new CartProducts(
          productId: element.productId, quantity: element.qty));
    });
    await _apiService.addToCart(requestModel).then((val) {
      if (val.data != []) {
        _cartItems = [];
        _cartItems.addAll(val.data);
      }

      onCallBack(val);
      notifyListeners();
    });
  }

  void removeItem(int productId) {
    var isProdExist = _cartItems.firstWhere(
        (element) => element.productId == productId,
        orElse: () => null);

    if (isProdExist != null) {
      _cartItems.remove(isProdExist);
    }
    notifyListeners();
  }

  CartItem fetchItem(int productId) {
    var isProdExist = _cartItems.firstWhere(
        (element) => element.productId == productId,
        orElse: () => null);
    notifyListeners();
    return isProdExist;
  }

  fetchShippingDetails() async {
    if (_customerDetailModel == null) {
      _customerDetailModel = new CustomerDetailModel();
    }
    _customerDetailModel = await _apiService.customerDetails();

    notifyListeners();
  }

  processOrder(OrderModel orderModel) {
    this._orderModel = orderModel;
    notifyListeners();
  }

  emptyCart() {
    _cartItems.clear();
    notifyListeners();
  }

  createOrder() async {
    if (_orderModel.shipping == null) {
      _orderModel.shipping = new Shipping();
    }
    if (this.customerDetailModel.shipping != null) {
      _orderModel.shipping = this.customerDetailModel.shipping;
    }
    if (_orderModel.lineItems == null) {
      _orderModel.lineItems = new List<LineItems>.empty(growable: true);
    }

    _cartItems.forEach((element) {
      _orderModel.lineItems.add(
          new LineItems(productId: element.productId, quantity: element.qty));
    });

    await _apiService.createOrder(orderModel).then((value) {
      if (value != null) {
        _isOrderCreated = true;
        orderId = value[0];
        notifyListeners();
      }
    });
  }
}
