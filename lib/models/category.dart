class Category {
  int categoryId;
  String categoryName;
  String categoryDisc;
  int parent;
  Image image;
  Category({
    this.categoryId,
    this.categoryName,
    this.categoryDisc,
    this.parent,
    this.image,
  });

  Category.fromJson(Map<String, dynamic> json) {
    categoryId = json['id'];
    categoryName = json['name'];
    categoryDisc = json['description'];
    parent = json['parent'];
    image = json['image'] != null
        ? new Image.fromJson(json['image'])
        : Image(url: '');
  }
}

class Image {
  String url;
  Image({this.url});
  Image.fromJson(Map<String, dynamic> json) {
    url = json['src'];
  }
}
