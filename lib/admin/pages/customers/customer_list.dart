import 'package:chiggy_wiggy/admin/model/customer_model.dart';
import 'package:chiggy_wiggy/admin/pages/base_page.dart';
import 'package:chiggy_wiggy/admin/provider/customers_provider.dart';
import 'package:chiggy_wiggy/admin/utils/searchbar_utils.dart';
import 'package:chiggy_wiggy/helper.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomerList extends AdminBasePage {
  const CustomerList();

  @override
  _CustomerListState createState() => _CustomerListState();
}

class _CustomerListState extends AdminBasePageState<CustomerList> {
  @override
  void initState() {
    pageTitle = 'Customers';
    var customerProvider =
        Provider.of<CustomerProvider>(context, listen: false);
    customerProvider.fetchCustomers();
    super.initState();
  }

  @override
  Widget pageUI() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: SearchBarUtils.searchBar(
              context,
              'strSearchCustomer',
              'Search Customer',
              'Add customer',
              (val) {
                var customerProvider =
                    Provider.of<CustomerProvider>(context, listen: false);
                customerProvider.resetStreams();
                customerProvider.fetchCustomers(strSearch: val);
              },
              () {},
            ),
          ),
          Divider(
            color: Colors.grey,
          ),
          _customerList(),
        ],
      ),
    );
  }

  Widget _customerRow(CustomerModel model) {
    return ListTile(
      title: getNormalText(
        "${model.firstName}",
        18,
        Colors.black,
      ),
      subtitle: getNormalText(
        '${model.userName}',
        16,
        Colors.black,
      ),
      trailing: Wrap(
        children: [
          Icon(
            Icons.edit,
            color: Colors.black,
          ),
          SizedBox(
            width: 5,
          ),
          Icon(
            Icons.delete,
            color: Colors.redAccent,
          ),
          SizedBox(
            width: 5,
          ),
          Icon(
            Icons.notification_add,
            color: Colors.orange,
          ),
        ],
      ),
    );
  }

  Widget _customerList() {
    return Consumer<CustomerProvider>(
      builder: (context, model, child) {
        if (model.customerList != null) {
          return model.customerList.length > 0
              ? ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return _customerRow(model.customerList[index]);
                  },
                  separatorBuilder: (context, index) {
                    return Divider();
                  },
                  itemCount: model.customerList.length,
                )
              : Center(
                  child: getNormalText('No data found', 18, Colors.black),
                );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
