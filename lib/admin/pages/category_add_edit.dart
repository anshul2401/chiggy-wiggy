import 'package:chiggy_wiggy/admin/enum/page_type.dart';
import 'package:chiggy_wiggy/admin/model/category_model.dart';
import 'package:chiggy_wiggy/admin/pages/base_page.dart';
import 'package:chiggy_wiggy/admin/provider/category_provider.dart';
import 'package:chiggy_wiggy/helper.dart';
import 'package:chiggy_wiggy/provider/loader_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:snippet_coder_utils/FormHelper.dart';

class CategoryAddEdit extends AdminBasePage {
  final PageType pageType;
  final CategoryModel categoryModel;
  CategoryAddEdit({this.pageType, this.categoryModel});

  @override
  _CategoryAddEditState createState() => _CategoryAddEditState();
}

class _CategoryAddEditState extends AdminBasePageState<CategoryAddEdit> {
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  CategoryModel model;
  @override
  void initState() {
    pageTitle = (this.widget.pageType == PageType.Add
        ? 'Add Category'
        : 'Edit Category');
    if (this.widget.pageType == PageType.Edit) {
      this.model = this.widget.categoryModel;
    } else {
      this.model = new CategoryModel();
    }
    super.initState();
  }

  @override
  Widget pageUI() {
    return Form(
      key: formState,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FormHelper.inputFieldWidgetWithLabel(
                context,
                Icon(Icons.ac_unit_outlined),
                'name',
                "Category Name",
                '',
                (onValidate) {
                  if (onValidate.isEmpty) {
                    return 'Category name cannot be empty';
                  }
                  return null;
                },
                (onSaved) {
                  this.model.name = onSaved;
                },
                initialValue: this.model.name,
                borderColor: getThemeColor(),
                borderFocusColor: getThemeColor(),
                showPrefixIcon: false,
                borderRadius: 10,
                paddingLeft: 0,
                paddingRight: 0,
              ),
              SizedBox(
                height: 10,
              ),
              FormHelper.inputFieldWidgetWithLabel(
                context,
                Icon(Icons.ac_unit_outlined),
                'description',
                "Category Description",
                '',
                (onValidate) {
                  if (onValidate.isEmpty) {
                    return 'Category Description cannot be empty';
                  }
                  return null;
                },
                (onSaved) {
                  this.model.description = onSaved;
                },
                initialValue: this.model.description,
                borderColor: getThemeColor(),
                borderFocusColor: getThemeColor(),
                showPrefixIcon: false,
                borderRadius: 10,
                paddingLeft: 0,
                paddingRight: 0,
                isMultiline: true,
                containerHeight: 200,
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: FormHelper.submitButton(
                  'Save',
                  () {
                    if (validateAndSave()) {
                      Provider.of<LoaderProvider>(context, listen: false)
                          .setLoadingStatus(true);
                      if (this.widget.pageType == PageType.Add) {
                        Provider.of<CategoryProvider>(context, listen: false)
                            .createCategory(model, (val) {
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
                      }
                      if (this.widget.pageType == PageType.Edit) {
                        Provider.of<CategoryProvider>(context, listen: false)
                            .updateCategory(model, (val) {
                          Provider.of<LoaderProvider>(context, listen: false)
                              .setLoadingStatus(false);
                          if (val) {
                            Get.snackbar(
                              'Admin',
                              'Category Updated',
                              animationDuration: Duration(seconds: 2),
                              snackPosition: SnackPosition.BOTTOM,
                            );
                          }
                        });
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool validateAndSave() {
    final form = formState.currentState;
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }
}
