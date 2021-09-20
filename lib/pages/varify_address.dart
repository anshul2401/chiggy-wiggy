import 'package:chiggy_wiggy/api_service.dart';
import 'package:chiggy_wiggy/helper.dart';
import 'package:chiggy_wiggy/models/customer.dart' as cust;
import 'package:chiggy_wiggy/models/customer_details.dart';
import 'package:chiggy_wiggy/models/order.dart';
import 'package:chiggy_wiggy/pages/base_page.dart';
import 'package:chiggy_wiggy/pages/order_success.dart';
import 'package:chiggy_wiggy/pages/razorpay.dart';
import 'package:chiggy_wiggy/provider/cart_provider.dart';
import 'package:chiggy_wiggy/utils/checkpoint.dart';
import 'package:chiggy_wiggy/utils/form_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VarifyAddress extends BasePage {
  const VarifyAddress();

  @override
  _VarifyAddressState createState() => _VarifyAddressState();
}

class _VarifyAddressState extends BasePageState<VarifyAddress> {
  @override
  void initState() {
    var cartProvider = Provider.of<CartProvider>(context, listen: false);
    cartProvider.fetchShippingDetails();
    super.initState();
  }

  // @override
  // void dispose() {
  //   _form.currentState.dispose();
  //   super.dispose();
  // }

  final _form = GlobalKey<FormState>();
  String address;
  String name;
  String landmark;
  String pincode;
  String email;
  @override
  Widget pageUI() {
    return Consumer<CartProvider>(
      builder: (context, customerModel, child) {
        if (customerModel.customerDetailModel.id != null) {
          return _formUi(customerModel.customerDetailModel);
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget _formUi(CustomerDetailModel model) {
    return Form(
      key: _form,
      child: Column(
        children: [
          Checkpoints(
            checkTill: 0,
            checkpoints: ['Details', 'Payment', 'Order'],
            checkpointFillColor: getThemeColor(),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 2),
            child: TextFormField(
              decoration: const InputDecoration(
                icon: Icon(Icons.person),
                labelText: 'Name *',
              ),
              autocorrect: false,
              onSaved: (newValue) {
                name = newValue;
              },
              initialValue: model.firstName + model.lastName,
              validator: (value) {
                if (value.isEmpty) {
                  return "This field is required";
                }
                return null;
              },
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 2),
            child: TextFormField(
              decoration: const InputDecoration(
                icon: Icon(Icons.email_rounded),
                labelText: 'Email *',
              ),
              autocorrect: false,
              onSaved: (newValue) {
                email = newValue;
              },
              initialValue: model.billing.email,
              validator: (value) {
                if (value.isEmpty) {
                  return "This field is required";
                }
                return null;
              },
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 2),
            child: TextFormField(
              decoration: const InputDecoration(
                icon: Icon(Icons.home),
                labelText: 'Address *',
              ),
              autocorrect: false,
              onSaved: (newValue) {
                address = newValue;
              },
              initialValue: model.shipping.address1,
              validator: (value) {
                if (value.isEmpty) {
                  return "This field is required";
                }
                return null;
              },
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 2),
            child: TextFormField(
              decoration: const InputDecoration(
                icon: Icon(Icons.place_outlined),
                labelText: 'Landmark ',
              ),
              autocorrect: false,
              onSaved: (newValue) {
                landmark = newValue;
              },
              initialValue: model.shipping.address2,
            ),
          ),
          // Container(
          //   padding: EdgeInsets.symmetric(horizontal: 20, vertical: 2),
          //   child: TextFormField(
          //     decoration: const InputDecoration(
          //       icon: Icon(Icons.phone_android),
          //       labelText: 'Mobile *',
          //     ),
          //     autocorrect: false,
          //     onSaved: (newValue) {
          //       mobile = newValue;
          //     },
          //     initialValue: model.billing.phone,
          //     validator: (value) {
          //       if (value.isEmpty) {
          //         return "This field is required";
          //       }
          //       return null;
          //     },
          //   ),
          // ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 2),
            child: TextFormField(
              decoration: const InputDecoration(
                icon: Icon(Icons.pin),
                labelText: 'Pincode *',
              ),
              autocorrect: false,
              onSaved: (newValue) {
                pincode = newValue;
              },
              initialValue: model.shipping.postcode,
              validator: (value) {
                if (value.isEmpty) {
                  return "This field is required";
                }
                return null;
              },
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              FlatButton(
                  onPressed: () {
                    final isValidate = _form.currentState.validate();
                    if (!isValidate) {
                      return null;
                    }

                    _form.currentState.save();
                    APIService _apiService = APIService();
                    _apiService.updateCustomer(
                      cust.CustomerModel(
                        email: email,
                        firstName: name,
                        lastName: '',
                        shipping: cust.Shipping(
                          address1: address,
                          address2: landmark,
                          city: 'Indore',
                          company: '',
                          country: 'INDIA',
                          firstName: name,
                          lastName: '',
                          postcode: pincode,
                          state: 'MP',
                        ),
                      ),
                    );
                  },
                  child: Text('update')),
              FlatButton(
                onPressed: () {
                  RazorpayService razorpayService = new RazorpayService();

                  razorpayService.initPaymentGateway(context);
                  razorpayService.openCheckout(context);
                },
                child: getNormalText('Procced to pay', 14, Colors.white),
                shape: StadiumBorder(),
                color: Colors.red,
              ),
              FlatButton(
                onPressed: () {
                  var orderProvider =
                      Provider.of<CartProvider>(context, listen: false);
                  OrderModel orderModel = OrderModel();
                  orderModel.paymentMethod = 'cod';
                  orderModel.paymentMethodTitle = 'COD';
                  orderModel.setPaid = false;
                  // orderModel.transectionId = 'anshul';
                  orderProvider.processOrder(orderModel);

                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) {
                    return OrderSuccess();
                  }));
                },
                child: getNormalText('Cash on dilevery', 14, Colors.white),
                shape: StadiumBorder(),
                color: Colors.red,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
