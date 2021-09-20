class CartResponseModel {
  bool status;
  List<CartItem> data;
  CartResponseModel({this.data, this.status});
  CartResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data.add(new CartItem.fromJson(v));
      });
    }
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['status'] = this.status;
    if (this.data != []) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CartItem {
  int productId;
  String productName;
  String productRegularPrice;
  String productSalePrice;
  String thumbnail;
  int qty;
  double lineSubtotal;
  double lineTotal;
  CartItem(
      {this.productId,
      this.productName,
      this.productRegularPrice,
      this.productSalePrice,
      this.thumbnail,
      this.lineSubtotal,
      this.lineTotal,
      this.qty});
  CartItem.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    productName = json['product_name'];
    productRegularPrice = json['product_regular_price'];
    productSalePrice = json['product_sale_price'];
    thumbnail = json['thumbnail'];
    lineSubtotal = double.parse(json['line_subtotal'].toString());
    lineTotal = double.parse(json['line_total'].toString());
    qty = json['qty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['product_id'] = this.productId;
    data['product_name'] = this.productName;
    data['product_regular_price'] = this.productRegularPrice;
    data['product_sale_price'] = this.productSalePrice;
    data['thumbnail'] = this.thumbnail;
    data['line_subtotal'] = this.lineSubtotal;
    data['line_total'] = this.lineTotal;
    data['qty'] = this.qty;
    return data;
  }
}
