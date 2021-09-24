import 'package:chiggy_wiggy/api_service.dart';
import 'package:chiggy_wiggy/config.dart';
import 'package:chiggy_wiggy/models/order.dart';
import 'package:flutter/cupertino.dart';

class OrderProvider with ChangeNotifier {
  APIService _apiService;
  List<OrderModel> _orderList;
  List<OrderModel> get allOrder => _orderList;
  double get totalRecord => _orderList.length.toDouble();
  OrderProvider() {
    resetStreams();
  }

  void resetStreams() {
    _apiService = APIService();
  }

  fetchOrders() async {
    List<OrderModel> orderList = await _apiService.getOrder();
    if (_orderList == null) {
      _orderList = new List<OrderModel>.empty(growable: true);
    }
    if (orderList.length > 0) {
      _orderList = [];
      _orderList.addAll(
          orderList.where((element) => element.customerId == Config.userID));
      // _orderList.addAll(orderList);
    }
    notifyListeners();
  }
}
