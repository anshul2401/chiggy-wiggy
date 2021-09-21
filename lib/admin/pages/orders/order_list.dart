import 'package:chiggy_wiggy/admin/model/order_model.dart';
import 'package:chiggy_wiggy/admin/pages/base_page.dart';
import 'package:chiggy_wiggy/admin/pages/orders/order_details.dart';
import 'package:chiggy_wiggy/admin/provider/order_provider.dart';
import 'package:chiggy_wiggy/helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderList extends AdminBasePage {
  const OrderList();

  @override
  _OrderListState createState() => _OrderListState();
}

class _OrderListState extends AdminBasePageState<OrderList> {
  @override
  void initState() {
    this.pageTitle = 'Orders';
    var orderProvider = Provider.of<OrderProvider>(context, listen: false);
    orderProvider.fetchOrders();
    super.initState();
  }

  @override
  Widget pageUI() {
    return Consumer<OrderProvider>(builder: (context, orderModel, child) {
      if (orderModel.orderList != null) {
        return orderModel.orderList.length > 0
            ? SingleChildScrollView(
                // child: Column(
                //   children: [
                child: getStatusRow(orderModel.orderList),
                //   ],
                // ),
              )
            : Center(
                child: getNormalText(
                  'No orders',
                  18,
                  Colors.black,
                ),
              );
      }
      return CircularProgressIndicator();
    });
  }

  Widget getStatusRow(List<OrderModel> order) {
    return ListView.builder(
      itemCount: order.length,
      physics: ScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        var data = order[index];
        return Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Column(
              children: [
                orderStatus(data.status),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                  child: Divider(
                    color: Colors.grey,
                    thickness: 1,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.adjust_outlined,
                          color: getThemeColor(),
                        ),
                        getBoldText('Order ID:', 16, Colors.black),
                      ],
                    ),
                    getNormalText(data.orderNumber, 14, Colors.black),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.date_range,
                          color: getThemeColor(),
                        ),
                        getBoldText('Order Date:', 16, Colors.black),
                      ],
                    ),
                    getNormalText(data.orderDate.toString(), 14, Colors.black),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FlatButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OrderDetailsPage(
                              orderId: order[index].orderId.toString(),
                            ),
                          ),
                        );
                      },
                      child: getNormalText('Order details', 14, Colors.white),
                      color: getThemeColor(),
                      shape: StadiumBorder(),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget orderStatus(String status) {
    Icon icon;
    Color color;
    if (status == 'pending' || status == 'processing' || status == 'on-hold') {
      icon = Icon(
        Icons.timer,
        color: Colors.orange,
      );
      color = Colors.orange;
    } else if (status == 'completed') {
      icon = Icon(
        Icons.check,
        color: Colors.green,
      );
      color = Colors.green;
    } else if (status == 'cancelled' ||
        status == 'refunded' ||
        status == 'failed') {
      icon = Icon(
        Icons.clear,
        color: Colors.red,
      );
      color = Colors.red;
    } else {
      icon = Icon(
        Icons.clear,
        color: Colors.red,
      );
      color = Colors.red;
    }
    return Row(
      children: [
        icon,
        getBoldText(status, 18, color),
      ],
    );
  }
}
