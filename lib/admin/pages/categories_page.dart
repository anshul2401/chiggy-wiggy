import 'package:chiggy_wiggy/admin/enum/page_type.dart';
import 'package:chiggy_wiggy/admin/model/category_model.dart';
import 'package:chiggy_wiggy/admin/pages/base_page.dart';
import 'package:chiggy_wiggy/admin/pages/category_add_edit.dart';
import 'package:chiggy_wiggy/admin/provider/category_provider.dart';
import 'package:chiggy_wiggy/admin/provider/searchbar_provider.dart';
import 'package:chiggy_wiggy/admin/utils/searchbar_utils.dart';
import 'package:chiggy_wiggy/helper.dart';
import 'package:chiggy_wiggy/provider/loader_provider.dart';
import 'package:chiggy_wiggy/utils/top_nav.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:snippet_coder_utils/list_helper.dart';

class CategoryList extends AdminBasePage {
  const CategoryList();

  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends AdminBasePageState<CategoryList> {
  List<CategoryModel> categories;
  @override
  void initState() {
    pageTitle = 'Categories';
    var catP = Provider.of<CategoryProvider>(context, listen: false);
    catP.fetchCategories();
    super.initState();
  }

  @override
  Widget pageUI() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // getTopNav(
          //     context,
          //     'Categories',
          //     getThemeColor(),
          //     Padding(
          //       padding: const EdgeInsets.symmetric(horizontal: 8.0),
          //       child: Icon(
          //         Icons.logout_rounded,
          //         color: Colors.white,
          //       ),
          //     ),
          //     false),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SearchBarUtils.searchBar(
                  context,
                  'strCategory',
                  'Search Category',
                  'Add Category',
                  (val) {
                    var sortModel =
                        Provider.of<SearchBarProvider>(context, listen: false)
                            .sortModel;
                    var categoryProvider =
                        Provider.of<CategoryProvider>(context, listen: false);
                    categoryProvider.resetStream();
                    categoryProvider.fetchCategories(
                      sortBy: sortModel.sortColumnName,
                      sortOrder: sortModel.sortAscending ? 'asc' : 'desc',
                      strSearch: val,
                    );
                  },
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CategoryAddEdit(
                          pageType: PageType.Add,
                        ),
                      ),
                    );
                  },
                ),
                Divider(
                  color: Colors.grey,
                ),
                categoryListUi(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget categoryListUi() {
    return new Consumer<CategoryProvider>(
      builder: (context, model, child) {
        if (model.categoryList != null && model.categoryList.length > 0) {
          return ListUtils.buildDataTable(
              context,
              [
                'Name',
                'Description',
                '',
              ],
              [
                'name',
                'description',
                '',
              ],
              Provider.of<SearchBarProvider>(context, listen: true)
                  .sortModel
                  .sortAscending,
              Provider.of<SearchBarProvider>(context, listen: true)
                  .sortModel
                  .sortColumnIndex,
              model.categoryList, (onEditValue) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CategoryAddEdit(
                  pageType: PageType.Edit,
                  categoryModel: onEditValue,
                ),
              ),
            );
          }, (onDeleteValue) {
            Provider.of<LoaderProvider>(context, listen: false)
                .setLoadingStatus(true);

            Provider.of<CategoryProvider>(context, listen: false)
                .deleteCategory(onDeleteValue, (val) {
              Provider.of<LoaderProvider>(context, listen: false)
                  .setLoadingStatus(false);
              if (val) {
                Get.snackbar(
                  'Admin',
                  'Category Created',
                  animationDuration: Duration(seconds: 2),
                  snackPosition: SnackPosition.BOTTOM,
                );
              }
            });
          },

              // headingRowColor: getThemeColor(),
              onSort: (columnIndex, columnName, ascending) {
            Provider.of<SearchBarProvider>(context, listen: false)
                .setSort(columnIndex, columnName, ascending);
            var categoryProvider =
                Provider.of<CategoryProvider>(context, listen: false);
            categoryProvider.resetStream();
            categoryProvider.fetchCategories(
              sortBy: columnName,
              sortOrder: ascending ? 'asc' : 'desc',
            );
          });
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
