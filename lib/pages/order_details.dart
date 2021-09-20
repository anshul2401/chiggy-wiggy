import 'package:chiggy_wiggy/api_service.dart';
import 'package:chiggy_wiggy/helper.dart';
import 'package:chiggy_wiggy/models/order.dart';
import 'package:chiggy_wiggy/models/order_detail_model.dart';
import 'package:chiggy_wiggy/pages/base_page.dart';
import 'package:chiggy_wiggy/utils/checkpoint.dart';
import 'package:chiggy_wiggy/utils/top_nav.dart';
import 'package:flutter/material.dart';

class OrderDetails extends StatefulWidget {
  final OrderModel orderModel;

  const OrderDetails({this.orderModel});

  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  APIService apiService;
  @override
  void initState() {
    apiService = new APIService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new FutureBuilder(
        future: apiService.getOrderDetail(widget.orderModel.orderId),
        builder: (BuildContext context,
            AsyncSnapshot<OrderDetailModel> orderDetailModel) {
          if (orderDetailModel.hasData) {
            return Scaffold(
              body: ListView(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      getTopNav(context, 'Order details', getThemeColor(),
                          Container(), true),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            getBoldText(
                              '#' + widget.orderModel.orderId.toString(),
                              16,
                              getThemeColor(),
                            ),
                            getBoldText(widget.orderModel.orderDate.toString(),
                                16, Colors.black),
                            SizedBox(
                              height: 15,
                            ),
                            getBoldText(
                              'Delivered to',
                              16,
                              getThemeColor(),
                            ),
                            getBoldText('address', 16, Colors.black),
                            SizedBox(
                              height: 15,
                            ),
                            getBoldText(
                              'Payment method',
                              16,
                              getThemeColor(),
                            ),
                            getBoldText(
                                widget.orderModel.paymentMethod.toString(),
                                16,
                                Colors.black),
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Divider(
                                color: Colors.grey,
                              ),
                            ),
                            Checkpoints(
                              checkpoints: [
                                'Processing',
                                'Dispatched',
                                'Delivered',
                              ],
                              checkpointFillColor: getThemeColor(),
                              checkTill: 1,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Divider(
                                color: Colors.grey,
                              ),
                            ),
                            listOrderItem(orderDetailModel.data)
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }
          return CircularProgressIndicator();
        });
  }

  Widget listOrderItem(OrderDetailModel model) {
    return ListView.builder(
        itemCount: model.lineItem.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return getItems(model.lineItem[index]);
        });
  }

  Widget getItems(LineItem product) {
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
}
