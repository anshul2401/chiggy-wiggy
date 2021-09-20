import 'package:chiggy_wiggy/api_service.dart';
import 'package:chiggy_wiggy/pages/home_pagee.dart';
import 'package:chiggy_wiggy/pages/signup_page.dart';
import 'package:chiggy_wiggy/provider/cart_provider.dart';
import 'package:chiggy_wiggy/provider/loader_provider.dart';
import 'package:chiggy_wiggy/provider/order_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:splashscreen/splashscreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => LoaderProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => CartProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => OrderProvider(),
        )
      ],
      child: MaterialApp(
        home: SplashScreen(
          navigateAfterFuture: APIService().getCustomerIdByMobile('5'),
          seconds: 3,
          navigateAfterSeconds: new HomePagee(),
          imageBackground: AssetImage('assets/images/splash.png'),
          // image: Image.asset('assets/images/logo2.jpeg'),
          backgroundColor: Colors.white,
          styleTextUnderTheLoader: new TextStyle(),
          photoSize: 200.0,
          useLoader: false,
        ),

        // home: SignupPage(),
      ),
    );
  }
}
