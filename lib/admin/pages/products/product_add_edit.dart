import 'package:chiggy_wiggy/admin/enum/page_type.dart';
import 'package:chiggy_wiggy/admin/main.dart';
import 'package:chiggy_wiggy/admin/model/product_model.dart';
import 'package:chiggy_wiggy/admin/pages/base_page.dart';
import 'package:chiggy_wiggy/admin/provider/products_provider.dart';
import 'package:chiggy_wiggy/helper.dart';
import 'package:chiggy_wiggy/provider/loader_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:provider/provider.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:snippet_coder_utils/multi_images_utils.dart';

class ProductAddEdit extends AdminBasePage {
  final PageType pageType;
  final ProductModel model;
  const ProductAddEdit({this.pageType, this.model});

  @override
  _ProductAddEditState createState() => _ProductAddEditState();
}

class _ProductAddEditState extends AdminBasePageState<ProductAddEdit> {
  ProductModel productModel;
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  HtmlEditorController editorController = HtmlEditorController();
  List<Object> images;
  @override
  void initState() {
    this.pageTitle =
        this.widget.pageType == PageType.Add ? 'Add Product' : 'Edit Product';
    if (this.widget.pageType == PageType.Add) {
      this.productModel = new ProductModel();
      this.productModel.images = [];
    } else {
      this.productModel = this.widget.model;
    }
    super.initState();
  }

  @override
  Widget pageUI() {
    return Form(
      key: globalKey,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: FormHelper.inputFieldWidgetWithLabel(
                  context,
                  Icon(Icons.web),
                  'name',
                  'Product name',
                  '',
                  (onValidateValue) {
                    if (onValidateValue.isEmpty) {
                      return 'Product name is required';
                    }
                    return null;
                  },
                  (onSavedValue) {
                    this.productModel.name = onSavedValue;
                  },
                  initialValue: this.productModel.name,
                  borderColor: getThemeColor(),
                  borderFocusColor: getThemeColor(),
                  borderRadius: 10,
                  paddingLeft: 0,
                  paddingRight: 0,
                  showPrefixIcon: false,
                ),
              ),
              Row(
                children: [
                  Flexible(
                    child: FormHelper.inputFieldWidgetWithLabel(
                        context,
                        Icon(Icons.wallet_giftcard),
                        'regularPrice',
                        'Regular Price',
                        '', (onValidateValue) {
                      if (onValidateValue.isEmpty) {
                        return 'Required';
                      } else {
                        return null;
                      }
                    }, (onSavedValue) {
                      this.productModel.regularPrice = onSavedValue;
                    },
                        initialValue: this.productModel.regularPrice,
                        showPrefixIcon: false,
                        borderColor: getThemeColor(),
                        borderFocusColor: getThemeColor(),
                        borderRadius: 10,
                        paddingLeft: 0,
                        paddingRight: 0,
                        suffixIcon: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              10,
                            ),
                            color: getThemeColor(),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              getBoldText(
                                '₹',
                                20,
                                Colors.white,
                              ),
                            ],
                          ),
                        )),
                  ),
                  Flexible(
                    child: FormHelper.inputFieldWidgetWithLabel(
                        context,
                        Icon(Icons.wallet_giftcard),
                        'salePrice',
                        'Sale Price',
                        '', (onValidateValue) {
                      if (onValidateValue.isEmpty) {
                        return 'Required';
                      } else {
                        return null;
                      }
                    }, (onSavedValue) {
                      this.productModel.salePrice = onSavedValue;
                    },
                        initialValue: this.productModel.salePrice,
                        showPrefixIcon: false,
                        borderColor: getThemeColor(),
                        borderFocusColor: getThemeColor(),
                        borderRadius: 10,
                        paddingLeft: 0,
                        paddingRight: 0,
                        suffixIcon: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              10,
                            ),
                            color: getThemeColor(),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              getBoldText(
                                '₹',
                                20,
                                Colors.white,
                              ),
                            ],
                          ),
                        )),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              HtmlEditor(
                controller: editorController,
                htmlEditorOptions: HtmlEditorOptions(
                  hint: 'Product Description',
                  initialText: this.productModel.description,
                ),
                htmlToolbarOptions: HtmlToolbarOptions(
                  toolbarPosition: ToolbarPosition.aboveEditor,
                  toolbarType: ToolbarType.nativeGrid,
                  defaultToolbarButtons: [
                    FontButtons(),
                  ],
                ),
                otherOptions: OtherOptions(
                  height: 400,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: getBoldText('Product Image', 20, Colors.black),
              ),
              MultiImagePicker(
                totalImages: 6,
                onImageChanged: (images) {
                  this.images = images;
                },
                imageSource: ImagePickSource.gallery,
                initialValue:
                    this.productModel.images.map((e) => e.src).toList(),
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: FormHelper.submitButton(
                  'Save',
                  () async {
                    if (validateAndSave()) {
                      Provider.of<LoaderProvider>(context, listen: false)
                          .setLoadingStatus(true);
                      if (images.length > 0) {
                        this.productModel.images = [];
                        images.forEach((element) {
                          if (element is ImageUploadModel) {
                            if (element.imageUrl == null) {
                              this.productModel.images.add(new Images(
                                  src: element.imageFile, isUpload: true));
                            } else {
                              this.productModel.images.add(Images(
                                  src: element.imageUrl, isUpload: false));
                            }
                          }
                        });
                      }
                      this.productModel.description =
                          await this.editorController.getText();
                      if (this.widget.pageType == PageType.Add) {
                        print(this.productModel.name);
                        Provider.of<ProductProvider>(context, listen: false)
                            .createProduct(this.productModel, (val) {
                          Provider.of<LoaderProvider>(context, listen: false)
                              .setLoadingStatus(false);
                          if (val) {
                            Get.snackbar(
                              'Admin',
                              'Product added successfully',
                              duration: Duration(seconds: 5),
                              snackPosition: SnackPosition.BOTTOM,
                            );
                            // Get.offAll(() => AdminHomePage());
                          } else {
                            Get.snackbar(
                              'Admin',
                              'Error',
                              duration: Duration(seconds: 5),
                              snackPosition: SnackPosition.BOTTOM,
                            );
                          }
                        });
                      } else {
                        Provider.of<ProductProvider>(context, listen: false)
                            .updateProduct(this.productModel, (val) {
                          Provider.of<LoaderProvider>(context, listen: false)
                              .setLoadingStatus(false);
                          if (val) {
                            Get.snackbar(
                              'Admin',
                              'Product updated successfully',
                              duration: Duration(seconds: 2),
                              snackPosition: SnackPosition.BOTTOM,
                            );
                            // Get.offAll(() => AdminHomePage());
                          } else {
                            Get.snackbar(
                              'Admin',
                              'Error',
                              duration: Duration(seconds: 2),
                              snackPosition: SnackPosition.BOTTOM,
                            );
                          }
                        });
                      }
                    }
                  },
                  borderColor: getThemeColor(),
                  btnColor: getThemeColor(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  bool validateAndSave() {
    final form = globalKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }
}
