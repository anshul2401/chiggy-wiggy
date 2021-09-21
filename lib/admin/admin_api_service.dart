import 'dart:convert';
import 'dart:io';

import 'package:chiggy_wiggy/admin/model/category_model.dart';
import 'package:chiggy_wiggy/admin/model/customer_model.dart';
import 'package:chiggy_wiggy/admin/model/order_model.dart';
import 'package:chiggy_wiggy/admin/model/product_model.dart';
import 'package:chiggy_wiggy/config.dart';
import 'package:chiggy_wiggy/admin/model/order_detail_model.dart';
import 'package:http/http.dart' as http;

class APIService {
  static var client = http.Client();

  Future<List<CategoryModel>> getCategories(
      {String strSearch,
      String sortBy,
      String sortOrder = "asc",
      bool parentCategory = true}) async {
    Map<String, String> requestHeaders = {'Content-Type': 'application/json'};
    Map<String, String> queryString = {
      'consumer_key': Config.key,
      'consumer_secret': Config.secret
    };
    if (strSearch != null) {
      queryString['search'] = strSearch;
    }
    if (parentCategory) {
      queryString['parent'] = '0';
    }
    if (sortBy != null) {
      queryString['orderby'] = sortBy;
    }
    if (sortOrder != null) {
      queryString['order'] = sortOrder;
    }
    var url = Uri.https(
      Config.baseUrl,
      '/wp-json/wc/v3/products/categories',
      queryString,
    );
    var response = await http.Client().get(
      url,
      headers: requestHeaders,
    );
    if (response.statusCode == 200) {
      return categoriesFromJson(json.decode(response.body));
    } else {
      return null;
    }
  }

  Future<CategoryModel> createCategory(CategoryModel model) async {
    var authToken =
        base64.encode(utf8.encode(Config.key + ':' + Config.secret));
    Map<String, String> requestHeader = {
      'Content-Type': 'application/json',
      'authorization': 'Basic $authToken',
    };
    var url = Uri.https(
      Config.baseUrl,
      '/wp-json/wc/v3/products/categories',
    );
    var response = await client.post(
      url,
      headers: requestHeader,
      body: jsonEncode(
        model.toJson(),
      ),
    );
    if (response.statusCode == 201) {
      return categoryFromJson(response.body);
    } else {
      print(response.statusCode);
      print(response.body);
      return null;
    }
  }

  Future<CategoryModel> updateCategory(CategoryModel model) async {
    var authToken =
        base64.encode(utf8.encode(Config.key + ':' + Config.secret));
    Map<String, String> requestHeader = {
      'Content-Type': 'application/json',
      'authorization': 'Basic $authToken',
    };
    var url = Uri.https(
      Config.baseUrl,
      '/wp-json/wc/v3/products/categories/' + model.id.toString(),
    );
    var response = await client.put(
      url,
      headers: requestHeader,
      body: jsonEncode(
        model.toJson(),
      ),
    );
    if (response.statusCode == 200) {
      return categoryFromJson(response.body);
    } else {
      print(response.statusCode);
      print(response.body);
      return null;
    }
  }

  Future<bool> deleteCategory(CategoryModel model) async {
    var authToken =
        base64.encode(utf8.encode(Config.key + ':' + Config.secret));
    Map<String, String> requestHeader = {
      'authorization': 'Basic $authToken',
    };
    var url = Uri.https(
        Config.baseUrl,
        '/wp-json/wc/v3/products/categories/' + model.id.toString(),
        {"force": "true "});
    var response = await client.delete(
      url,
      headers: requestHeader,
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      print(response.statusCode);
      print(response.body);
      return false;
    }
  }

  Future<List<ProductModel>> getProducts(
      {int pageNumber,
      int pageSize,
      String strSearch,
      String categoryId,
      String sortBy,
      String sortOrder = 'asc'}) async {
    Map<String, String> requestHeaders = {'Content-type': 'application/json'};
    Map<String, String> queryString = {
      'consumer_key': Config.key,
      'consumer_secret': Config.secret,
    };
    if (strSearch != null) {
      queryString['search'] = strSearch;
    }
    if (sortBy != null) {
      queryString['orderby'] = sortBy;
    }
    if (sortOrder != null) {
      queryString['order'] = sortOrder;
    }
    queryString['per_page'] = pageSize.toString();
    queryString['page'] = pageNumber.toString();
    var url =
        new Uri.https(Config.baseUrl, '/wp-json/wc/v3/products', queryString);
    var response = await client.get(url, headers: requestHeaders);
    if (response.statusCode == 200) {
      return productsFromJson(json.decode(response.body));
    } else {
      print(response.statusCode);
      return null;
    }
  }

  Future<ProductModel> createProduct(ProductModel model) async {
    var authToken =
        base64.encode(utf8.encode(Config.key + ':' + Config.secret));
    Map<String, String> requestHeader = {
      'Content-Type': 'application/json',
      'authorization': 'Basic $authToken',
    };
    var url = Uri.https(
      Config.baseUrl,
      '/wp-json/wc/v3/products',
    );
    var response = await client.post(
      url,
      headers: requestHeader,
      body: jsonEncode(
        model.toJson(),
      ),
    );
    if (response.statusCode == 201) {
      return productFromJson(response.body);
    } else {
      print(response.statusCode);
      print(response.body);
      return null;
    }
  }

  Future<ProductModel> updateProduct(ProductModel model) async {
    var authToken =
        base64.encode(utf8.encode(Config.key + ':' + Config.secret));
    Map<String, String> requestHeader = {
      'Content-Type': 'application/json',
      'authorization': 'Basic $authToken',
    };
    var url = Uri.https(
      Config.baseUrl,
      '/wp-json/wc/v3/products/' + model.id.toString(),
    );
    var response = await client.put(
      url,
      headers: requestHeader,
      body: jsonEncode(
        model.toJson(),
      ),
    );
    if (response.statusCode == 200) {
      return productFromJson(response.body);
    } else {
      print(response.statusCode);
      print(response.body);
      return null;
    }
  }

  Future<String> uploadImage(filePath) async {
    var url = Uri.https(
      Config.baseUrl,
      '/wp-json/wc/v2/media',
    );
    var authToken =
        base64.encode(utf8.encode(Config.key + ':' + Config.secret));
    String fileName = filePath.split('/').last;
    var token;
    Map<String, String> requestHeaders = {
      'Authorization': 'Basic $authToken',
      'Content-Disposition': 'attachment; fileName =$fileName',
      'content-type': 'image/jpeg',
    };
    List<int> imageBytes = File(filePath).readAsBytesSync();
    var request = http.Request('POST', url);
    request.headers.addAll(requestHeaders);
    request.bodyBytes = imageBytes;
    var res = await request.send();
    if (res.statusCode == 201) {
      return await getImageUrl(res.headers['location']);
    } else {
      print('helllpooo');
      print(res);
    }
    return null;
  }

  static Future<String> getImageUrl(url) async {
    Map<String, String> requestHeader = {'Content-type': 'application/json'};
    var response = await client.get(Uri.parse(url), headers: requestHeader);
    if (response.statusCode == 200) {
      var jsonString = json.decode(response.body);
      return jsonString['source_url'];
    } else {
      return null;
    }
  }

  Future<List<CustomerModel>> getCustomer({String strSearch}) async {
    Map<String, String> requestHeaders = {
      'content-type': 'application/json',
    };
    Map<String, String> queryString = {
      'consumer_key': Config.key,
      'consumer_secret': Config.secret,
    };
    if (strSearch != null) {
      queryString['search'] = strSearch;
    }

    var url = new Uri.https(
      Config.baseUrl,
      '/wp-json/wc/v3/customers',
      queryString,
    );
    var response = await client.get(url, headers: requestHeaders);
    if (response.statusCode == 200) {
      return customerFromJson(json.decode(response.body));
    } else {
      return null;
    }
  }

  Future<List<OrderModel>> getOrder() async {
    Map<String, String> requestHeaders = {
      'content-type': 'application/json',
    };
    Map<String, String> queryString = {
      'consumer_key': Config.key,
      'consumer_secret': Config.secret,
    };

    var url = new Uri.https(
      Config.baseUrl,
      '/wp-json/wc/v3/orders',
      queryString,
    );
    var response = await client.get(url, headers: requestHeaders);
    if (response.statusCode == 200) {
      return orderFromJson(json.decode(response.body));
    } else {
      return null;
    }
  }

  Future<OrderDetailModel> getOrderDetails(String orderId) async {
    Map<String, String> requestHeaders = {
      'content-type': 'application/json',
    };
    Map<String, String> queryString = {
      'consumer_key': Config.key,
      'consumer_secret': Config.secret,
    };

    var url = new Uri.https(
      Config.baseUrl,
      '/wp-json/wc/v3/orders/${int.parse(orderId)}',
      queryString,
    );

    var response = await client.get(url, headers: requestHeaders);
    if (response.statusCode == 200) {
      print(orderDetailsFromJson(response.body));
      return orderDetailsFromJson(response.body);
    } else {
      print(response.statusCode);
      return null;
    }
  }

  Future<bool> updateOrderStatus({String orderStatus, int orderId}) async {
    print(orderId);
    var authToken =
        base64.encode(utf8.encode(Config.key + ':' + Config.secret));
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'authorization': 'Basic $authToken',
    };

    var url = new Uri.https(
      Config.baseUrl,
      '/wp-json/wc/v3/orders/$orderId',
    );
    print(url);
    var response = await client.post(
      url,
      headers: requestHeaders,
      body: jsonEncode({"status": orderStatus}),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      print(response.statusCode);
      return false;
    }
  }
}
