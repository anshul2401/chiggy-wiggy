import 'package:chiggy_wiggy/api_service.dart';
import 'package:chiggy_wiggy/models/customer.dart';
import 'package:chiggy_wiggy/utils/form_helper.dart';
import 'package:chiggy_wiggy/utils/progressHUD.dart';
import 'package:flutter/material.dart';

class SignupPage extends StatefulWidget {
  const SignupPage();

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  APIService apiService;
  CustomerModel model;
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  bool hidePassword = true;
  bool isApiCallProcess = false;
  @override
  void initState() {
    apiService = new APIService();
    model = new CustomerModel();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        automaticallyImplyLeading: true,
        title: Text('SignUp page'),
      ),
      body: ProgressHUD(
        inAsyncCall: isApiCallProcess,
        opacity: 0.3,
        valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),
        child: new Form(
          child: _formUI(),
          key: globalKey,
        ),
      ),
    );
  }

  Widget _formUI() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Container(
          child: Align(
            alignment: Alignment.topLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FormHelper.fieldLabel('First Name'),
                FormHelper.textInput(
                  context,
                  model.firstName,
                  (value) => {this.model.firstName = value},
                  onValidate: (value) {
                    if (value.toString().isEmpty) {
                      return 'Please enter first name';
                    } else {
                      return null;
                    }
                  },
                ),
                FormHelper.fieldLabel('Last Name'),
                FormHelper.textInput(
                  context,
                  model.lastName,
                  (value) => {this.model.lastName = value},
                  onValidate: (value) {
                    if (value.toString().isEmpty) {
                      return 'Please enter last name';
                    } else {
                      return null;
                    }
                  },
                ),
                FormHelper.fieldLabel('Email'),
                FormHelper.textInput(
                  context,
                  model.email,
                  (value) => {this.model.email = value},
                  onValidate: (value) {
                    if (value.toString().isEmpty) {
                      return 'Please enter Email';
                    } else {
                      return null;
                    }
                  },
                ),
                FormHelper.fieldLabel('Password'),
                FormHelper.textInput(
                  context,
                  model.password,
                  (value) => {this.model.password = value},
                  onValidate: (value) {
                    if (value.toString().isEmpty) {
                      return 'Please enter password';
                    } else {
                      return null;
                    }
                  },
                ),
                RaisedButton(
                    child: Text('ffff'),
                    onPressed: () {
                      apiService.getCustomerIdByMobile('5');
                    }),
                Center(
                  child: FormHelper.saveButton(
                    'Register',
                    () {
                      if (validateAndSave()) {
                        model.shipping = Shipping(
                          address1: 'address1',
                          address2: 'address2',
                          city: 'indore',
                          company: 'the urban tech',
                          country: 'india',
                          firstName: model.firstName,
                          lastName: model.lastName,
                          postcode: '45010',
                          state: 'MP',
                        );
                        print(model.toJson());
                        setState(() {
                          isApiCallProcess = true;
                        });
                        apiService.createCustomer(model).then(
                          (ret) {
                            setState(() {
                              isApiCallProcess = false;
                            });
                            print(ret.toString());
                            if (ret) {
                              FormHelper.showMessage(
                                context,
                                'Chiggy Wiggy',
                                'Registration Success',
                                'OK',
                                () {
                                  Navigator.of(context).pop();
                                },
                              );
                            } else {
                              FormHelper.showMessage(
                                context,
                                'Chiggy Wiggy',
                                'Email ID already registered',
                                'OK',
                                () {
                                  Navigator.of(context).pop();
                                },
                              );
                            }
                          },
                        );
                      }
                    },
                  ),
                )
              ],
            ),
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
    }
    return false;
  }
}
