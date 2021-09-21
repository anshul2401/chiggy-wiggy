class OrderModel {
  int orderId;
  String orderNumber;
  String status;
  DateTime orderDate;
  OrderModel({
    this.orderId,
    this.orderNumber,
    this.status,
    this.orderDate,
  });

  OrderModel.fromJson(Map<String, dynamic> json) {
    orderId = json['id'];
    orderNumber = json['order_key'];
    status = json['status'];
    orderDate = DateTime.parse(json['date_created']);
  }
}

List<OrderModel> orderFromJson(dynamic str) =>
    List<OrderModel>.from((str).map((x) => OrderModel.fromJson(x)));
