import 'package:chiggy_wiggy/admin/admin_api_service.dart';
import 'package:chiggy_wiggy/admin/model/order_model.dart';
import 'package:flutter/cupertino.dart';

class OrderProvider with ChangeNotifier {
  APIService _apiService;
  List<OrderModel> _orderList;
  List<OrderModel> get orderList => _orderList;

  OrderProvider() {
    _apiService = new APIService();
    _orderList = null;
  }
  void resetStreams() {
    _apiService = new APIService();
    _orderList = null;
    notifyListeners();
  }

  fetchOrders() async {
    List<OrderModel> orderList = await _apiService.getOrder();
    if (_orderList == null) {
      _orderList = new List<OrderModel>.empty(growable: true);
    }
    if (orderList.length > 0) {
      _orderList = [];
      _orderList.addAll(orderList);
    }
    notifyListeners();
  }

  updateOrderStatus(
    int orderId,
    String orderStatus,
    Function onCallBack,
  ) async {
    var response = await _apiService.updateOrderStatus(
        orderId: orderId, orderStatus: orderStatus);
    if (response) {
      onCallBack(true);
    } else {
      onCallBack(false);
    }
    notifyListeners();
  }
}
