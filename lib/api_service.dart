import 'dart:convert';
import 'dart:io';
import 'package:chiggy_wiggy/config.dart';
import 'package:chiggy_wiggy/models/cart_request_model.dart';
import 'package:chiggy_wiggy/models/cart_response_model.dart';
import 'package:chiggy_wiggy/models/category.dart';
import 'package:chiggy_wiggy/models/customer.dart';
import 'package:chiggy_wiggy/models/customer_details.dart';
import 'package:chiggy_wiggy/models/order.dart';
import 'package:chiggy_wiggy/models/order_detail_model.dart';
import 'package:chiggy_wiggy/models/product.dart';
import 'package:chiggy_wiggy/pages/home_pagee.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

class APIService {
  Future<CustomerModel> createCustomer(CustomerModel model) async {
    var authToken = base64.encode(
      utf8.encode(Config.key + ":" + Config.secret),
    );

    bool ret = false;
    CustomerModel customerDetails;
    try {
      var response = await Dio().post(Config.url + Config.customerURL,
          data: model.toJson(),
          options: new Options(headers: {
            HttpHeaders.authorizationHeader: 'Basic $authToken',
            HttpHeaders.contentTypeHeader: "application/json"
          }));

      if (response.statusCode == 201) {
        customerDetails = CustomerModel.fromJson(response.data);
        ret = true;
      }
      return customerDetails;
    } on DioError catch (e) {
      if (e.response.statusCode == 400) {
        ret = true;
        customerDetails = await getCustomerIdByMobile(model.username);
      }
      if (e.response.statusCode == 404) {
        ret = false;
      } else {
        ret = false;
      }
    }
    return customerDetails;
  }

  Future<List<Category>> getCategories() async {
    Iterable<Category> data = [];
    try {
      String url = Config.url +
          Config.categoryURL +
          "?consumer_key= ${Config.key}&consumer_secret=${Config.secret}";
      var response = await Dio().get(url,
          options: new Options(headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          }));

      if (response.statusCode == 200) {
        data = (response.data as List).map((e) => Category.fromJson(e));
      }
    } on DioError catch (e) {
      print(e.response);
    }

    List<Category> da = data.toList();

    return da;
  }

  Future<List<Product>> getProducts(String tagName) async {
    Iterable<Product> data = [];
    try {
      String url = Config.url +
          Config.productURL +
          "?consumer_key= ${Config.key}&consumer_secret=${Config.secret}&tag=32";
      var response = await Dio().get(url,
          options: new Options(headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          }));
      if (response.statusCode == 200) {
        data = (response.data as List).map((e) => Product.fromJson(e));
      }
    } on DioError catch (e) {
      print(e.response);
    }

    List<Product> da = data.toList();

    return da;
  }

  Future<List<Product>> getProductsByCategory(String categoryID) async {
    var data;
    try {
      String url = Config.url +
          Config.productURL +
          "?consumer_key= ${Config.key}&consumer_secret=${Config.secret}&category=$categoryID";
      var response = await Dio().get(url,
          options: new Options(headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          }));
      if (response.statusCode == 200) {
        try {
          data = (response.data as List).map((e) => Product.fromJson(e));
        } catch (e) {
          print(e);
        }
      }
    } on DioError catch (e) {
      print(e.response);
    }

    List<Product> da = data.toList();

    return da;
  }

  Future<CartResponseModel> addToCart(CartRequestModel model) async {
    model.userId = Config.userID;
    CartResponseModel cartResponseModel = CartResponseModel();
    try {
      var response = await Dio().post(
        Config.url + Config.addToCartURL,
        data: model.toJson(),
        options: new Options(
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          },
        ),
      );
      if (response.statusCode == 200) {
        cartResponseModel = CartResponseModel.fromJson(response.data);
      }
    } on DioError catch (e) {
      if (e.response.statusCode == 404) {
        print(e.response.statusCode);
      } else {
        print(e.message);
        print(e.response);
      }
    }
    return cartResponseModel;
  }

  Future<CartResponseModel> getCartItems() async {
    CartResponseModel cartResponseModel =
        CartResponseModel(data: [], status: false);
    try {
      String url = Config.url +
          Config.cartURL +
          "?user_id=${Config.userID}&consumer_key=${Config.key}&consumer_secret=${Config.secret}";

      var response = await Dio().get(url,
          options: new Options(headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          }));
      if (response.statusCode == 200) {
        cartResponseModel = CartResponseModel.fromJson(response.data);
      }
    } on DioError catch (e) {
      print(e.response);
    }
    return cartResponseModel;
  }

  Future<CustomerDetailModel> customerDetails() async {
    CustomerDetailModel responseModel;
    try {
      String url = Config.url +
          Config.customerURL +
          "?user_id=${Config.userID}&consumer_key=${Config.key}&consumer_secret=${Config.secret}";

      var response = await Dio().get(url,
          options: new Options(headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          }));
      if (response.statusCode == 200) {
        print(response.data[0]);
        responseModel = CustomerDetailModel.fromJson(response.data[0]);
      }
    } on DioError catch (e) {
      print(e.response);
    }
    return responseModel;
  }

  Future<bool> updateCustomer(CustomerModel model) async {
    var authToken =
        base64.encode(utf8.encode(Config.key + ':' + Config.secret));
    bool isOrderCreated = false;
    try {
      String url = Config.url +
          Config.customerURL +
          "/" +
          Config.userID.toString() +
          "?consumer_key=${Config.key}&consumer_secret=${Config.secret}";
      print(url);
      var response = await Dio().post(url,
          data: model.toJson(),
          options: new Options(headers: {
            HttpHeaders.authorizationHeader: 'Basic $authToken',
            HttpHeaders.contentTypeHeader: 'application/json',
          }));
      if (response.statusCode == 201) {
        isOrderCreated = true;
      }
    } on DioError catch (e) {
      print(e.response);
    }
    return isOrderCreated;
  }

  Future<bool> createOrder(OrderModel model) async {
    model.customerId = Config.userID;
    bool isOrderCreated = false;
    var authToken =
        base64.encode(utf8.encode(Config.key + ':' + Config.secret));
    try {
      var response = await Dio().post(Config.url + Config.orderUrl,
          data: model.toJson(),
          options: new Options(headers: {
            HttpHeaders.authorizationHeader: 'Basic $authToken',
            HttpHeaders.contentTypeHeader: 'application/json',
          }));
      if (response.statusCode == 201) {
        isOrderCreated = true;
      }
    } on DioError catch (e) {
      if (e.response.statusCode == 404) {
        print(e.response.statusCode);
      } else {
        print(e.message);
        print(e.response);
      }
    }
    return isOrderCreated;
  }

  Future<List<OrderModel>> getOrder() async {
    List<OrderModel> data = [];

    try {
      String url = Config.url +
          Config.orderUrl +
          "?consumer_key=${Config.key}&consumer_secret=${Config.secret}";

      var response = await Dio().get(url,
          options: new Options(headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          }));
      if (response.statusCode == 200) {
        data =
            (response.data as List).map((e) => OrderModel.fromJson(e)).toList();
      }
    } on DioError catch (e) {
      print(e.response);
    }
    return data;
  }

  Future<OrderDetailModel> getOrderDetail(int orderId) async {
    OrderDetailModel responseModel = OrderDetailModel();
    try {
      String url = Config.url +
          Config.orderUrl +
          "/$orderId?consumer_key=${Config.key}&consumer_secret=${Config.secret}";

      var response = await Dio().get(url,
          options: new Options(headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          }));
      if (response.statusCode == 200) {
        responseModel = OrderDetailModel.fromJson(response.data);
      }
    } on DioError catch (e) {
      print(e.response);
    }
    return responseModel;
  }

  Future<CustomerModel> getCustomerIdByMobile(String phone) async {
    CustomerModel customer;
    try {
      String url = Config.url +
          Config.customerURL +
          "?consumer_key=${Config.key}&consumer_secret=${Config.secret}";

      var response = await Dio().get(url,
          options: new Options(headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          }));
      if (response.statusCode == 200) {
        customer = CustomerModel.fromJson((response.data as List)
            .firstWhere((element) => element['username'] == phone));
      }
    } on DioError catch (e) {
      print(e.response);
    }

    return customer;
  }

  Future<void> splashScreenFun() async {
    FirebaseAuth _auth;

    User _user;

    _auth = FirebaseAuth.instance;
    _user = _auth.currentUser;

    if (_user == null) {
      return HomePagee();
    }
    String phn = _user.phoneNumber.substring(1);

    CustomerModel customer = await getCustomerIdByMobile(phn);

    Config.userID = customer.id;

    return HomePagee();
  }
}
