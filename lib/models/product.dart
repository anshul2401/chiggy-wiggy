class Product {
  int id = 0;
  String name = '';
  String description = '';
  String shortDescription = '';
  String sku = '';
  String price = '';
  String regularPrice = '';
  String stockStatus = '';
  String weight = '';
  List<Images> images = [];
  List<Categories> categories = [];
  Product({
    this.id,
    this.name,
    this.description,
    this.shortDescription,
    this.sku,
    this.price,
    this.regularPrice,
    this.stockStatus,
    this.weight,
  });
  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    shortDescription = json['short_description'];
    sku = json['sku'];
    price = json['price'];
    regularPrice = json['regular_price'];
    stockStatus = json['stock_status'];
    weight = json['weight'].toString();
    if (json['categories'] != null) {
      categories = [];
      json['categories'].forEach((v) {
        categories.add(Categories.fromJson(v));
      });
    }
    if (json['images'] != null) {
      categories = [];
      json['images'].forEach((v) {
        images.add(Images.fromJson(v));
      });
    }
  }
}

class Categories {
  int id;
  String name;
  Categories({this.id, this.name});
  Categories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}

class Images {
  String src = '';
  Images({this.src});
  Images.fromJson(Map<String, dynamic> json) {
    src = json['src'];
  }
}
