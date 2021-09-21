import 'package:chiggy_wiggy/admin/admin_api_service.dart';
import 'package:chiggy_wiggy/admin/model/order_detail_model.dart';
import 'package:chiggy_wiggy/admin/pages/base_page.dart';
import 'package:chiggy_wiggy/helper.dart';
import 'package:chiggy_wiggy/provider/loader_provider.dart';
import 'package:chiggy_wiggy/admin/provider/order_provider.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:provider/provider.dart';
import 'package:snippet_coder_utils/FormHelper.dart';

class OrderDetailsPage extends AdminBasePage {
  final String orderId;
  OrderDetailsPage({this.orderId});

  @override
  _OrderDetailsPageState createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends AdminBasePageState<OrderDetailsPage> {
  APIService apiService;
  List<dynamic> orderStatusList = [];
  String orderStatus;
  @override
  void initState() {
    apiService = new APIService();
    this.pageTitle = 'Order Detail';
    this.orderStatusList.add({'id': 'pending', 'name': 'Pending'});
    this.orderStatusList.add({'id': 'processing', 'name': 'Processing'});
    this.orderStatusList.add({'id': 'on-hold', 'name': 'On Hold'});
    this.orderStatusList.add({'id': 'completed', 'name': 'Completed'});
    this.orderStatusList.add({'id': 'refunded', 'name': 'Refunded'});
    this.orderStatusList.add({'id': 'failed', 'name': 'Failed'});
    super.initState();
  }

  @override
  pageUI() {
    return new FutureBuilder(
        future: apiService.getOrderDetails(widget.orderId),
        builder: (BuildContext context,
            AsyncSnapshot<OrderDetailModel> orderDetailModel) {
          if (orderDetailModel.hasData) {
            return ListView(
              shrinkWrap: true,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          getBoldText(
                            '#' + widget.orderId.toString(),
                            16,
                            getThemeColor(),
                          ),
                          getNormalText(
                              orderDetailModel.data.orderDate.toString(),
                              16,
                              Colors.black),
                          SizedBox(
                            height: 15,
                          ),
                          getBoldText(
                            'Address',
                            16,
                            getThemeColor(),
                          ),
                          getNormalText(orderDetailModel.data.shipping.address1,
                              16, Colors.black),
                          SizedBox(
                            height: 15,
                          ),
                          getBoldText(
                            'Landmark',
                            16,
                            getThemeColor(),
                          ),
                          getNormalText(orderDetailModel.data.shipping.address2,
                              16, Colors.black),

                          SizedBox(
                            height: 15,
                          ),
                          getBoldText(
                            'Payment method',
                            16,
                            getThemeColor(),
                          ),
                          getNormalText(
                              orderDetailModel.data.paymentMethod.toString(),
                              16,
                              Colors.black),

                          // Checkpoints(
                          //   checkpoints: [
                          //     'Processing',
                          //     'Dispatched',
                          //     'Delivered',
                          //   ],
                          //   checkpointFillColor: getThemeColor(),
                          //   checkTill: 1,
                          // ),
                          SizedBox(
                            height: 15,
                          ),
                          getBoldText(
                            'Order',
                            16,
                            getThemeColor(),
                          ),
                          Divider(
                            color: Colors.grey,
                          ),

                          listOrderItem(orderDetailModel.data),
                          Divider(
                            color: Colors.grey,
                          ),
                          getTotals('Item total',
                              orderDetailModel.data.itemTotalAmount.toString()),
                          getTotals('Shipping charges',
                              orderDetailModel.data.shippingTotal.toString()),
                          getTotals('Total',
                              orderDetailModel.data.totalAmount.toString()),
                          Divider(
                            color: Colors.grey,
                          ),
                          updateOrderStatus(orderDetailModel.data),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            );
          }
          return CircularProgressIndicator();
        });
  }

  Widget listOrderItem(OrderDetailModel model) {
    return ListView.builder(
        itemCount: model.lineItems.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return getItems(model.lineItems[index]);
        });
  }

  Widget getItems(LineItems product) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            getBoldText(product.productName, 16, Colors.black),
            getNormalText(
                'qty: ' + product.quantity.toString(), 16, Colors.grey)
          ],
        ),
        getNormalText('₹ ' + product.totalAmount.toString(), 16, Colors.black),
      ],
    );
  }

  Widget getTotals(String text, String amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getBoldText(text, 16, Colors.black),
            ],
          ),
          getNormalText('₹ ' + amount, 16, Colors.black),
        ],
      ),
    );
  }

  Widget updateOrderStatus(OrderDetailModel mode) {
    return Column(
      children: [
        FormHelper.dropDownWidgetWithLabel(
          context,
          'Update order status',
          '-- Select status --',
          this.orderStatus,
          this.orderStatusList,
          (orderStatus) {
            Provider.of<LoaderProvider>(context, listen: false)
                .setLoadingStatus(true);
            Provider.of<OrderProvider>(context, listen: false)
                .updateOrderStatus(
              int.parse(widget.orderId),
              orderStatus,
              (val) {
                if (val) {
                  Provider.of<LoaderProvider>(context, listen: false)
                      .setLoadingStatus(false);
                  FormHelper.showSimpleAlertDialog(
                    context,
                    "Success",
                    'Status updated to $orderStatus',
                    'Ok',
                    () {
                      Navigator.of(context).pop();
                    },
                  );
                } else {
                  Provider.of<LoaderProvider>(context, listen: false)
                      .setLoadingStatus(false);
                }
              },
            );
          },
          (onValidateVal) {},
          borderColor: getThemeColor(),
          borderFocusColor: getThemeColor(),
          borderRadius: 10,
          paddingBottom: 0,
          paddingLeft: 0,
          paddingRight: 0,
          paddingTop: 0,
          labelFontSize: 15,
          hintFontSize: 12,
        )
      ],
    );
  }
}
