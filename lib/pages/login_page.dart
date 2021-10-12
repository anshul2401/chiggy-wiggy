import 'package:chiggy_wiggy/api_service.dart';
import 'package:chiggy_wiggy/config.dart';
import 'package:chiggy_wiggy/helper.dart';
import 'package:chiggy_wiggy/main.dart';
import 'package:chiggy_wiggy/models/customer.dart';
import 'package:chiggy_wiggy/pages/home_pagee.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

enum MobileVerificationState {
  SHOW_MOBILE_FORM_STATE,
  SHOW_OTP_FORM_STATE,
}

class LoginPage extends StatefulWidget {
  const LoginPage();

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  MobileVerificationState currentState =
      MobileVerificationState.SHOW_MOBILE_FORM_STATE;
  final otpController = TextEditingController();
  final phoneController = TextEditingController();
  bool showLoading = false;

  FirebaseAuth _auth = FirebaseAuth.instance;

  String verificationId;

  APIService _apiService;

  CustomerModel model;

  @override
  void initState() {
    model = new CustomerModel();
    _apiService = APIService();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Image.asset(
                'assets/images/img_6532.jpg',
                fit: BoxFit.fill,
              ),
            ),
            showLoading
                ? Center(child: CircularProgressIndicator())
                : currentState == MobileVerificationState.SHOW_MOBILE_FORM_STATE
                    ? getLoginWidget(context)
                    : getOtpWidget(context),
          ],
        ),
      ),
    );
  }

  Widget getOtpWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.white70,
        ),
        height: 210,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: getBoldText(
                'Enter OTP',
                18,
                getThemeColor(),
              ),
            ),
            getNormalText(
              'OTP has been sent to your mobile number',
              13,
              Colors.black,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(
                      //     horizontal: 10,
                      //   ),
                      //   child: TextField(
                      //     controller: phoneController,
                      //     decoration: InputDecoration(
                      //       // hintText: "Phone Number",
                      //       labelText: 'Phone Number',
                      //       labelStyle: TextStyle(
                      //         color: Colors.black,
                      //         fontSize: 10,
                      //       ),

                      //     ),
                      //   ),
                      // ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                        ),
                        child: TextField(
                          controller: otpController,
                          decoration: InputDecoration(
                            // hintText: "Phone Number",
                            labelText: 'Enter OTP',
                            labelStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ),
                      FlatButton(
                        onPressed: () async {
                          PhoneAuthCredential phoneAuthCredential =
                              PhoneAuthProvider.credential(
                                  verificationId: verificationId,
                                  smsCode: otpController.text);

                          signInWithPhoneAuthCredential(phoneAuthCredential);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: getBoldText(
                            'VERIFY',
                            16,
                            Colors.white,
                          ),
                        ),
                        color: getThemeColor(),
                        shape: StadiumBorder(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getLoginWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.white70,
        ),
        height: 210,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: getBoldText(
                'Sign In/ Sign Up',
                18,
                getThemeColor(),
              ),
            ),
            getNormalText(
              'This is mendetory in order to checkout',
              13,
              Colors.black,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                        ),
                        child: TextField(
                          controller: phoneController,
                          decoration: InputDecoration(
                            // hintText: "Phone Number",
                            labelText: 'Mobile number',
                            labelStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 10,
                            ),
                            prefixText: '+91',

                            // hintStyle: TextStyle(fontSize: 10),
                          ),
                        ),
                      ),
                      FlatButton(
                        onPressed: () async {
                          setState(() {
                            showLoading = true;
                          });
                          phoneController.text = '+91' + phoneController.text;

                          await _auth.verifyPhoneNumber(
                            phoneNumber: phoneController.text,
                            verificationCompleted: (phoneAuthCredential) async {
                              setState(
                                () {
                                  showLoading = false;
                                },
                              );
                              //signInWithPhoneAuthCredential(phoneAuthCredential);
                            },
                            verificationFailed: (verificationFailed) async {
                              setState(() {
                                showLoading = false;
                              });
                              _scaffoldKey.currentState.showSnackBar(SnackBar(
                                  content: Text(verificationFailed.message)));
                            },
                            codeSent: (verificationId, resendingToken) async {
                              setState(() {
                                showLoading = false;
                                currentState =
                                    MobileVerificationState.SHOW_OTP_FORM_STATE;
                                this.verificationId = verificationId;
                              });
                            },
                            codeAutoRetrievalTimeout: (verificationId) async {},
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: getBoldText(
                            'PROCCED VIA OTP',
                            16,
                            Colors.white,
                          ),
                        ),
                        color: getThemeColor(),
                        shape: StadiumBorder(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
        addUser(customer.id.toString(), phoneController.text, 'Customer');
        setState(() {
          showLoading = false;
        });
        // OneSignal.shared.init(
        //   onSignalAppId,
        // );
        // await OneSignal.shared.getDeviceState().then((value) {
        //   print(value.userId);
        //   APIService.updateOneSignal(value.userId).then((value) => {
        //         print(value),
        //       });
        // });
        // OneSignal.shared.
        // OneSignal.shared.setInFocusDisplayType(
        //   OSNotificationDisplayType.notification,
        // );

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePagee()));
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        showLoading = false;
      });

      _scaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  Future<void> addUser(String woocomuserId, String mobile, String role) async {
    OneSignal.shared.init(
      Config.oneSignalAppId,
    );
    var status = await OneSignal.shared.getPermissionSubscriptionState();

    var playerId = status.subscriptionStatus.userId;

    return users
        .add({
          'woocom_userid': woocomuserId,
          'mobile': mobile,
          'role': role,
          'device': playerId,
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }
}
