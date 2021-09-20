import 'dart:convert';

class CategoryModel {
  int id;
  String name;
  int parent;
  String description;
  String image;
  CategoryModel({
    this.id,
    this.name,
    this.parent,
    this.description,
    this.image,
  });
  CategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    parent = json['parent'];
    description = json['description'];
    image = json['image.src'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['parent'] = this.parent;
    data['description'] = this.description;
    data['image'] = this.image;
    return data;
  }
}

List<CategoryModel> categoriesFromJson(dynamic str) => List<CategoryModel>.from(
      (str).map((x) => CategoryModel.fromJson(x)),
    );

CategoryModel categoryFromJson(String str) =>
    CategoryModel.fromJson(json.decode(str));
