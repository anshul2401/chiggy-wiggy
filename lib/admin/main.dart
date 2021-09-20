import 'package:chiggy_wiggy/admin/pages/categories_page.dart';
import 'package:chiggy_wiggy/admin/pages/products/product_listing.dart';
import 'package:chiggy_wiggy/admin/provider/category_provider.dart';
import 'package:chiggy_wiggy/admin/provider/products_provider.dart';
import 'package:chiggy_wiggy/admin/provider/searchbar_provider.dart';
import 'package:chiggy_wiggy/helper.dart';
import 'package:chiggy_wiggy/provider/loader_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
          create: (context) => CategoryProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => SearchBarProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => LoaderProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ProductProvider(),
        )
      ],
      child: GetMaterialApp(
        home: SplashScreen(
          // navigateAfterFuture: APIService().getCuew2stomerIdByMobile('5'),
          seconds: 1,
          navigateAfterSeconds: new AdminHomePage(),
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

class AdminHomePage extends StatefulWidget {
  const AdminHomePage();

  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  int _index = 0;
  List<Widget> _wodgetList = [
    CategoryList(),
    ProductList(),
    CategoryList(),
    CategoryList()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.storefront_outlined,
              ),
              label: 'Orders'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.shopping_cart_outlined,
              ),
              label: 'Category'),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.shopping_bag_outlined,
            ),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.person_outline,
              ),
              label: 'Account'),
        ],
        selectedItemColor: getThemeColor(),
        currentIndex: _index,
        unselectedItemColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _index = index;
          });
        },
      ),
      body: _wodgetList[_index],
    );
  }
}
