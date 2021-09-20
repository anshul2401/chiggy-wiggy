import 'dart:convert';

class ProductModel {
  int id;
  String name;
  String type;
  bool featured;
  String description;
  String shortDescription;
  String sku;
  String price;
  String regularPrice;
  String salePrice;
  int parentId;
  List<Categories> categories;
  List<Images> images;
  ProductModel({
    this.id,
    this.name,
    this.type,
    this.featured,
    this.description,
    this.shortDescription,
    this.sku,
    this.price,
    this.regularPrice,
    this.salePrice,
    this.parentId,
    this.categories,
    this.images,
  });
  ProductModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    type = json['type'];
    featured = json['featured'];
    description = json['description'];
    shortDescription = json['short_description'];
    sku = json['sku'];
    price = json['price'];
    regularPrice = json['regular_price'];
    salePrice = json['sale_price'];
    parentId = json['parent_id'];
    if (json['categories'] != null) {
      categories = new List<Categories>.empty(growable: true);
      json['categories'].forEach((v) {
        categories.add(new Categories.fromJson(v));
      });
    }
    if (json['images'] != null) {
      images = new List<Images>.empty(growable: true);
      json['images'].forEach((v) {
        images.add(new Images.fromJson(v));
      });
    }
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['type'] = this.type;
    data['featured'] = this.featured;
    data['description'] = this.description;
    data['short_description'] = this.shortDescription;
    data['sku'] = this.sku;
    data['price'] = this.price;
    data['regular_price'] = this.regularPrice;
    data['sale_price'] = this.salePrice;
    data['parent_id'] = this.parentId;
    if (this.categories != null) {
      data['categories'] = this.categories.map((e) => e.toJson()).toList();
    }
    if (this.images != null) {
      data['images'] = this.images.map((e) => e.toJson()).toList();
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name '] = this.name;
    return data;
  }
}

class Images {
  int id;
  String src;
  Images({this.id, this.src});
  Images.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    src = json['src'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['src'] = this.src;
    return data;
  }
}

List<ProductModel> productsFromJson(dynamic str) => List<ProductModel>.from(
      (str).map((x) => ProductModel.fromJson(x)),
    );

ProductModel productFromJson(String str) =>
    ProductModel.fromJson(json.decode(str));
