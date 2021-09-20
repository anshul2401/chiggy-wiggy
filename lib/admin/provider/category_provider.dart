import 'package:chiggy_wiggy/admin/admin_api_service.dart';
import 'package:chiggy_wiggy/admin/model/category_model.dart';
import 'package:flutter/cupertino.dart';

class CategoryProvider with ChangeNotifier {
  APIService _apiService;
  List<CategoryModel> _categoryList;
  List<CategoryModel> get categoryList => _categoryList;
  double get totalRecord => _categoryList.length.toDouble();
  CategoryProvider() {
    _apiService = APIService();
    _categoryList = null;
  }
  resetStream() {
    _apiService = APIService();
    _categoryList = null;
    notifyListeners();
  }

  fetchCategories({
    String strSearch,
    String sortBy,
    String sortOrder,
  }) async {
    List<CategoryModel> categoryList = await _apiService.getCategories(
      strSearch: strSearch,
      sortBy: sortBy,
      sortOrder: sortOrder,
    );
    if (_categoryList == null) {
      _categoryList = new List<CategoryModel>.empty(growable: true);
    }
    if (categoryList.length > 0) {
      _categoryList = [];
      _categoryList.addAll(categoryList);
    }
    notifyListeners();
  }

  createCategory(CategoryModel model, Function onCallBack) async {
    CategoryModel _categoryModel = await _apiService.createCategory(model);
    if (_categoryModel != null) {
      _categoryList.add(_categoryModel);
      onCallBack(true);
    } else {
      onCallBack(false);
    }
    notifyListeners();
  }

  updateCategory(CategoryModel model, Function onCallBack) async {
    CategoryModel _categoryModel = await _apiService.updateCategory(model);
    if (_categoryModel != null) {
      _categoryList.remove(model);
      _categoryList.add(_categoryModel);
      onCallBack(true);
    } else {
      onCallBack(false);
    }
    notifyListeners();
  }

  deleteCategory(CategoryModel model, Function onCallBack) async {
    bool isDeleted = await _apiService.deleteCategory(model);
    if (isDeleted) {
      _categoryList.remove(model);

      onCallBack(true);
    } else {
      onCallBack(false);
    }
    notifyListeners();
  }
}
