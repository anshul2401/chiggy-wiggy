import 'dart:async';

import 'package:chiggy_wiggy/admin/enum/page_type.dart';
import 'package:chiggy_wiggy/admin/model/product_model.dart';
import 'package:chiggy_wiggy/admin/pages/base_page.dart';
import 'package:chiggy_wiggy/admin/pages/products/product_add_edit.dart';
import 'package:chiggy_wiggy/admin/pages/products/product_item.dart';
import 'package:chiggy_wiggy/admin/provider/products_provider.dart';
import 'package:chiggy_wiggy/helper.dart';
import 'package:chiggy_wiggy/utils/form_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class SortBy {
  String value;
  String text;
  String sortOrder;
  SortBy({
    this.value,
    this.text,
    this.sortOrder,
  });
}

class ProductList extends AdminBasePage {
  const ProductList();

  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends AdminBasePageState<ProductList> {
  ScrollController _scrollController = ScrollController();
  int _page = 1;

  final _searchQuery = new TextEditingController();
  Timer _debouncer;
  final _sortByOption = [
    SortBy(value: 'popularity', text: 'Popularity', sortOrder: 'asc'),
    SortBy(value: 'modified', text: 'Latest', sortOrder: 'asc'),
    SortBy(value: 'price', text: 'Price: High to Low', sortOrder: 'desc'),
    SortBy(value: 'price', text: 'Price: Low to High', sortOrder: 'asc'),
  ];
  @override
  void initState() {
    this.pageTitle = 'Products';
    super.initState();
    var productList = Provider.of<ProductProvider>(context, listen: false);
    productList.resetStreams();
    productList.fetchProducts(_page);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        productList.setLoadMoreStatus(LoadMoreStatus.LOADING);
        productList.fetchProducts(++_page);
      }
    });
    _searchQuery.addListener(_onSearchChanged);
  }

  _onSearchChanged() {
    var prodList = Provider.of<ProductProvider>(context, listen: false);

    if (_debouncer?.isActive ?? false) _debouncer.cancel();

    _debouncer = Timer(const Duration(microseconds: 500), () {
      prodList.resetStreams();
      prodList.setLoadMoreStatus(LoadMoreStatus.INITIAL);
      prodList.fetchProducts(1, strSearch: _searchQuery.text);
    });
  }

  @override
  Widget pageUI() {
    return Column(
      children: [
        _productFilters(),
        _productList(),
      ],
    );
  }

  Widget _productList() {
    return Consumer<ProductProvider>(builder: (context, productModel, child) {
      if (productModel.allProduct != null &&
          productModel.allProduct.length > 0 &&
          productModel.getLoadMoreStatus() != LoadMoreStatus.INITIAL) {
        return SingleChildScrollView(
          child: Column(
            children: [
              ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                controller: _scrollController,
                children: productModel.allProduct.map((e) {
                  return ProductItem(model: e);
                }).toList(),
              ),
              Visibility(
                child: Container(
                  padding: EdgeInsets.all(5),
                  height: 35,
                  width: 35,
                  child: CircularProgressIndicator(),
                ),
                visible:
                    productModel.getLoadMoreStatus() == LoadMoreStatus.LOADING,
              ),
            ],
          ),
        );
      }
      return Center(child: CircularProgressIndicator());
    });
  }

  Widget _productFilters() {
    return Container(
      height: 51,
      margin: EdgeInsets.fromLTRB(10, 10, 10, 5),
      child: Row(
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductAddEdit(
                    pageType: PageType.Add,
                  ),
                ),
              );
            },
            child: Icon(
              Icons.add,
              size: 25,
            ),
            style: ElevatedButton.styleFrom(
              shape: CircleBorder(),
              padding: EdgeInsets.all(5),
              primary: getThemeColor(),
            ),
          ),
          Flexible(
            child: TextField(
              controller: _searchQuery,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
                fillColor: Colors.grey[200],
                filled: true,
              ),
            ),
          ),
          SizedBox(
            width: 15,
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(9),
            ),
            child: PopupMenuButton(
              onSelected: (sortBy) {
                var productList =
                    Provider.of<ProductProvider>(context, listen: false);
                productList.resetStreams();
                productList.setSortBy(sortBy);
                productList.fetchProducts(_page);
              },
              itemBuilder: (BuildContext context) {
                return _sortByOption.map((e) {
                  return PopupMenuItem(
                    value: e,
                    child: Container(
                      child: Text(e.text),
                    ),
                  );
                }).toList();
              },
            ),
          )
        ],
      ),
    );
  }
}
