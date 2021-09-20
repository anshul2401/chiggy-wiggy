import 'package:chiggy_wiggy/models/customer_details.dart';

class OrderModel {
  int customerId;
  String paymentMethod;
  String paymentMethodTitle;
  bool setPaid;
  String transectionId;
  List<LineItems> lineItems;
  int orderId;
  String orderNumber;
  String status;
  DateTime orderDate;
  Shipping shipping;
  OrderModel({
    this.customerId,
    this.paymentMethod,
    this.paymentMethodTitle,
    this.setPaid,
    this.transectionId,
    this.lineItems,
    this.orderId,
    this.orderNumber,
    this.status,
    this.orderDate,
    this.shipping,
  });

  OrderModel.fromJson(Map<String, dynamic> json) {
    customerId = json['customer_id'];
    orderId = json['id'];
    status = json['status'];
    orderNumber = json['order_key'];
    orderDate = DateTime.parse(json['date_created']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['customer_id'] = customerId;
    data['payment_method'] = paymentMethod;
    data['payment_method_title'] = paymentMethodTitle;
    data['set_paid'] = setPaid;
    data['transection_id'] = transectionId;
    data['shipping'] = shipping.toJson();
    if (lineItems != null) {
      data['line_items'] = lineItems.map((e) => e.toJson()).toList();
    }
    return data;
  }
}

class LineItems {
  int productId;
  int quantity;
  LineItems({this.productId, this.quantity});
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['product_id'] = productId;
    data['quantity'] = quantity;
    return data;
  }
}
