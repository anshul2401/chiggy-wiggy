import 'package:chiggy_wiggy/helper.dart';
import 'package:chiggy_wiggy/models/order.dart';
import 'package:chiggy_wiggy/pages/order_details.dart';
import 'package:chiggy_wiggy/provider/order_provider.dart';
import 'package:chiggy_wiggy/utils/top_nav.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderPage extends StatefulWidget {
  final bool getBackButton;
  OrderPage(this.getBackButton);

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  @override
  void initState() {
    var orderProvider = Provider.of<OrderProvider>(context, listen: false);
    orderProvider.fetchOrders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderProvider>(builder: (context, orderModel, child) {
      if (orderModel.allOrder != null) {
        return orderModel.allOrder.length > 0
            ? Scaffold(
                body: SingleChildScrollView(
                  child: Column(
                    children: [
                      getTopNav(context, 'Order', getThemeColor(), Container(),
                          this.widget.getBackButton),
                      getStatusRow(orderModel.allOrder),
                    ],
                  ),
                ),
              )
            : Scaffold(
                body: Column(
                  children: [
                    getTopNav(context, 'Order', getThemeColor(), Container(),
                        this.widget.getBackButton),
                    Center(
                      child: CircularProgressIndicator(),
                    ),
                  ],
                ),
              );
      }
      return Scaffold(
        body: Column(
          children: [
            getTopNav(
              context,
              'Order',
              getThemeColor(),
              Container(),
              this.widget.getBackButton,
            ),
            Center(
              child: getBoldText('No Orders', 20, getThemeColor()),
            ),
          ],
        ),
      );
    });
  }

  Widget getStatusRow(List<OrderModel> order) {
    return ListView.builder(
      itemCount: order.length,
      physics: ScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        print(order[index].customerId);
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
                            builder: (context) => OrderDetails(
                              orderModel: order[index],
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
