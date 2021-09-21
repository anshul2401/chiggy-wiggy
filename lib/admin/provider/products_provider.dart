import 'package:chiggy_wiggy/admin/admin_api_service.dart';
import 'package:chiggy_wiggy/admin/model/product_model.dart';
import 'package:chiggy_wiggy/admin/pages/products/product_listing.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';

enum LoadMoreStatus { INITIAL, LOADING, STABLE }

class ProductProvider with ChangeNotifier {
  APIService _apiService;
  List<ProductModel> _productList;
  int pageSize = 10;
  List<ProductModel> get allProduct => _productList;
  double get totalRecords => _productList.length.toDouble();
  LoadMoreStatus _loadMoreStatus = LoadMoreStatus.STABLE;

  getLoadMoreStatus() => _loadMoreStatus;
  SortBy _sortBy;
  ProductProvider() {
    resetStreams();
    _sortBy = SortBy(sortOrder: 'asc', text: 'Latest', value: 'modified');
  }
  void resetStreams() {
    _apiService = new APIService();
    setLoadMoreStatus(LoadMoreStatus.INITIAL);
    _productList = null;
  }

  setLoadMoreStatus(LoadMoreStatus l) {
    _loadMoreStatus = l;
  }

  fetchProducts(
    pageNumner, {
    String strSearch,
    String categoryId,
    String sortBy,
    String sortOrder = 'asc',
  }) async {
    List<ProductModel> itemModel = await _apiService.getProducts(
        strSearch: strSearch,
        pageNumber: pageNumner,
        pageSize: pageSize,
        categoryId: categoryId,
        sortBy: this._sortBy.value,
        sortOrder: this._sortBy.sortOrder);
    if (_productList == null) {
      _productList = List<ProductModel>.empty(growable: true);
    }
    if (itemModel.length > 0) {
      _productList.addAll(itemModel);
    }
    setLoadMoreStatus(LoadMoreStatus.STABLE);
    notifyListeners();
  }

  setSortBy(SortBy sortBy) {
    _sortBy = sortBy;
    notifyListeners();
  }

  createProduct(ProductModel model, Function onCallBack) async {
    List<Images> productImages = List<Images>.empty(growable: true);
    if (model.images.length > 0) {
      await Future.forEach(model.images, (Images image) async {
        String imageUrl = await _apiService.uploadImage(image.src);
        if (imageUrl != null) {
          productImages.add(Images(src: imageUrl));
        }
      });
    }
    if (model.images.length > 0) {
      model.images = productImages;
    }
    ProductModel _productModel = await _apiService.createProduct(model);
    if (_productModel != null) {
      _productList.add(_productModel);
      onCallBack(true);
    } else {
      onCallBack(false);
    }
    notifyListeners();
  }

  updateProduct(ProductModel model, Function onCallBack) async {
    List<Images> productImages = List<Images>.empty(growable: true);
    if (model.images.length > 0) {
      await Future.forEach(model.images, (Images image) async {
        if (image.isUpload) {
          String imageUrl = await _apiService.uploadImage(image.src);
          if (imageUrl != null) {
            productImages.add(Images(src: imageUrl));
          }
        } else {
          productImages.add(Images(src: image.src));
        }
      });
    }
    if (model.images.length > 0) {
      model.images = productImages;
    }
    ProductModel _productModel = await _apiService.updateProduct(model);
    if (_productModel != null) {
      _productList.remove(model);
      _productList.add(_productModel);
      onCallBack(true);
    } else {
      onCallBack(false);
    }
    notifyListeners();
  }

  // deleteProduct(ProductModel model, Function onCallBack) async {
  //   bool isDeleted = await _apiService.deleteProduct(model);
  //   if (isDeleted) {
  //     _categoryList.remove(model);

  //     onCallBack(true);
  //   } else {
  //     onCallBack(false);
  //   }
  //   notifyListeners();
  // }
}
