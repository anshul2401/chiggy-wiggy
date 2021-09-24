import 'package:chiggy_wiggy/main.dart';
import 'package:chiggy_wiggy/config.dart';
import 'package:chiggy_wiggy/models/customer.dart';
import 'package:chiggy_wiggy/api_service.dart';
import 'package:chiggy_wiggy/authentication/home_page.dart';
import 'package:chiggy_wiggy/pages/home_pagee.dart';
import 'package:chiggy_wiggy/pages/signup_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";

enum MobileVerificationState {
  SHOW_MOBILE_FORM_STATE,
  SHOW_OTP_FORM_STATE,
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  MobileVerificationState currentState =
      MobileVerificationState.SHOW_MOBILE_FORM_STATE;

  final phoneController = TextEditingController();
  final otpController = TextEditingController();

  FirebaseAuth _auth = FirebaseAuth.instance;

  String verificationId;

  bool showLoading = false;

  APIService _apiService;

  CustomerModel model;

  @override
  void initState() {
    model = new CustomerModel();
    _apiService = APIService();
    super.initState();
  }

  void signInWithPhoneAuthCredential(
      PhoneAuthCredential phoneAuthCredential) async {
    setState(() {
      showLoading = true;
    });

    try {
      final authCredential =
          await _auth.signInWithCredential(phoneAuthCredential);

      if (authCredential?.user != null) {
        print(phoneController.text.substring(1));
        model.email = phoneController.text.substring(1) + '@gmail.com';
        model.firstName = '';
        model.lastName = '';
        model.password = '';
        model.username = phoneController.text.substring(1);
        model.shipping = Shipping(
          address1: '',
          address2: '',
          city: '',
          company: '',
          country: 'India',
          firstName: '',
          lastName: '',
          postcode: '',
          state: '',
        );

        CustomerModel customer = await _apiService.createCustomer(model);
        Config.userID = customer.id;
        setState(() {
          showLoading = false;
        });
        print(customer.id);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MyApp()));
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        showLoading = false;
      });

      _scaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  getMobileFormWidget(context) {
    return Column(
      children: [
        Spacer(),
        TextField(
          controller: phoneController,
          decoration: InputDecoration(
            hintText: "Phone Number",
          ),
        ),
        SizedBox(
          height: 16,
        ),
        FlatButton(
          onPressed: () async {
            setState(() {
              showLoading = true;
            });

            await _auth.verifyPhoneNumber(
              phoneNumber: phoneController.text,
              verificationCompleted: (phoneAuthCredential) async {
                setState(() {
                  showLoading = false;
                });
                //signInWithPhoneAuthCredential(phoneAuthCredential);
              },
              verificationFailed: (verificationFailed) async {
                setState(() {
                  showLoading = false;
                });
                _scaffoldKey.currentState.showSnackBar(
                    SnackBar(content: Text(verificationFailed.message)));
              },
              codeSent: (verificationId, resendingToken) async {
                setState(() {
                  showLoading = false;
                  currentState = MobileVerificationState.SHOW_OTP_FORM_STATE;
                  this.verificationId = verificationId;
                });
              },
              codeAutoRetrievalTimeout: (verificationId) async {},
            );
          },
          child: Text("SEND"),
          color: Colors.blue,
          textColor: Colors.white,
        ),
        Spacer(),
        FlatButton(
          onPressed: () async {
            setState(() {
              showLoading = true;
            });
            model.email = '1934034@mai.com';
            model.firstName = 'anshul';
            model.lastName = 'lastname';
            model.password = 'password';
            model.username = '9401334455342';
            model.role = '';
            model.shipping = Shipping(
              address1: 'a',
              address2: 's',
              city: 'indore',
              company: 'c',
              country: 'in',
              firstName: 'mna',
              lastName: 'aa',
              postcode: '45600',
              state: 'mp',
            );
            // _apiService.createCustomer(model).then((ret != -1?true: false) {
            //   print(ret);
            //   setState(() {
            //     showLoading = false;
            //   });
            // });
            var uid = await _apiService.createCustomer(model);
            setState(() {
              showLoading = false;
            });
            print(uid.id);
          },
          child: Text(
            'Create',
          ),
        ),
      ],
    );
  }

  getOtpFormWidget(context) {
    return Column(
      children: [
        Spacer(),
        TextField(
          controller: otpController,
          decoration: InputDecoration(
            hintText: "Enter OTP",
          ),
        ),
        SizedBox(
          height: 16,
        ),
        FlatButton(
          onPressed: () async {
            PhoneAuthCredential phoneAuthCredential =
                PhoneAuthProvider.credential(
                    verificationId: verificationId,
                    smsCode: otpController.text);

            signInWithPhoneAuthCredential(phoneAuthCredential);
          },
          child: Text("VERIFY"),
          color: Colors.blue,
          textColor: Colors.white,
        ),
        Spacer(),
      ],
    );
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body: Container(
          child: showLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : currentState == MobileVerificationState.SHOW_MOBILE_FORM_STATE
                  ? getMobileFormWidget(context)
                  : getOtpFormWidget(context),
          padding: const EdgeInsets.all(16),
        ));
  }
}
