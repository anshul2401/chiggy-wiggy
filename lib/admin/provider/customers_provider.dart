import 'package:chiggy_wiggy/admin/admin_api_service.dart';
import 'package:chiggy_wiggy/admin/model/customer_model.dart';

import 'package:flutter/cupertino.dart';

class CustomerProvider with ChangeNotifier {
  APIService _apiService;
  List<CustomerModel> _customerList;
  List<CustomerModel> get customerList => _customerList;

  CustomerProvider() {
    _apiService = new APIService();
    _customerList = null;
  }
  void resetStreams() {
    _apiService = new APIService();
    _customerList = null;
    notifyListeners();
  }

  fetchCustomers({String strSearch}) async {
    List<CustomerModel> customerList =
        await _apiService.getCustomer(strSearch: strSearch);
    if (_customerList == null) {
      _customerList = new List<CustomerModel>.empty(growable: true);
    }
    if (customerList.length > 0) {
      _customerList = [];
      _customerList.addAll(customerList);
    }
    notifyListeners();
  }
}
