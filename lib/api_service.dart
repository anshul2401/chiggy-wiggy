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
import 'package:http/http.dart' as http;

class APIService {
  static var client = http.Client();

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
    CartResponseModel cartResponseModel;
    try {
      String url = Config.url +
          Config.cartURL +
          "?user_id=${Config.userID}&consumer_key=${Config.key}&consumer_secret=${Config.secret}";

      var response = await Dio().get(url,
          options: new Options(headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          }));
      if (response.statusCode == 200) {
        print(response.data);
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
          "/" +
          Config.userID.toString() +
          "?consumer_key=${Config.key}&consumer_secret=${Config.secret}";
      var response = await Dio().get(url,
          options: new Options(headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          }));
      if (response.statusCode == 200) {
        responseModel = CustomerDetailModel.fromJson(response.data);
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

  Future<List<dynamic>> createOrder(OrderModel model) async {
    model.customerId = Config.userID;
    bool isOrderCreated = false;
    List ass = [];
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
        print(response.data['id']);

        // sendNotification(['b0634531-dee7-42bc-abbe-6e89aac1d1d4'],
        //     'Ding Dong Order!', 'Order Arrived');
        ass.add(response.data['id']);
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
    ass.add(isOrderCreated);
    return ass;
    // return isOrderCreated;
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
        print((response.data as List)
            .firstWhere((element) => element['username'] == phone));
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

  static Future<bool> updateOneSignal(String playerId) async {
    var authToken =
        base64.encode(utf8.encode(Config.key + ':' + Config.secret));
    Map<String, String> requestHeader = {
      "Content-Type": "application/json",
      "authorization": "Basic $authToken",
    };
    String userid = Config.userID.toString();
    var url = Uri.https(
      Config.baseUrl,
      "wp-json/wc/v3/customers/$userid",
    );
    var response = await client.post(url,
        headers: requestHeader,
        body: jsonEncode({
          "meta_data": [
            {
              "key": "one_signal_id",
              "value": playerId,
            }
          ]
        }));
    if (response.statusCode == 200) {
      return true;
    } else {
      print(response.body);
      return false;
    }
  }

  Future<http.Response> sendNotification(List<String> tokenIdList,
      String contents, String heading, String orderid) async {
    return await http.post(
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

        "data": {"orderid": orderid},
      }),
    );
  }
}
