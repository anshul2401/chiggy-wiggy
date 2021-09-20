import 'package:chiggy_wiggy/models/customer_details.dart';

class OrderDetailModel {
  int orderId;
  String orderNumber;
  String paymentMethod;
  String orderStatus;
  DateTime orderDate;
  Shipping shipping;
  List<LineItem> lineItem;
  double totalAmount;
  double shippingTotal;
  double itemTotalAmount;
  OrderDetailModel({
    this.orderId,
    this.orderNumber,
    this.paymentMethod,
    this.orderStatus,
    this.orderDate,
    this.shipping,
    this.lineItem,
    this.totalAmount,
    this.shippingTotal,
    this.itemTotalAmount,
  });
  OrderDetailModel.fromJson(Map<String, dynamic> json) {
    orderId = json['id'];
    orderNumber = json['order_key'];
    paymentMethod = json['payment_method_title'];
    orderStatus = json['status'];
    orderDate = DateTime.parse(json['date_created']);
    shipping =
        json['shipping'] != null ? Shipping.fromJson(json['shipping']) : null;
    if (json['line_items'] != null) {
      lineItem = [];
      json['line_items'].forEach((v) {
        lineItem.add(LineItem.fromJson(v));
      });
    }
    itemTotalAmount = lineItem != null
        ? lineItem
            .map<double>((e) => e.totalAmount)
            .reduce((value, element) => value + element)
        : null;
    totalAmount = double.parse(json['total']);
    shippingTotal = double.parse(json['shipping_total']);
  }
}

class LineItem {
  int productId;
  String productName;
  int quantity;
  double totalAmount;
  LineItem({
    this.productId,
    this.productName,
    this.quantity,
    this.totalAmount,
  });
  LineItem.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    productName = json['name'];
    quantity = json['quantity'];
    totalAmount = double.parse(json['total']);
  }
}
