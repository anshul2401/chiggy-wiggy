import 'package:chiggy_wiggy/api_service.dart';
import 'package:chiggy_wiggy/pages/home_pagee.dart';

import 'package:chiggy_wiggy/provider/cart_provider.dart';
import 'package:chiggy_wiggy/provider/loader_provider.dart';
import 'package:chiggy_wiggy/provider/order_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:splashscreen/splashscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
          navigateAfterFuture: APIService().splashScreenFun(),

          // navigateAfterSeconds: new HomePagee(),
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
